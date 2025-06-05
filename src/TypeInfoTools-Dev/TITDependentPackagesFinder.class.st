Class {
	#name : 'TITDependentPackagesFinder',
	#superclass : 'Object',
	#instVars : [
		'packages',
		'initialPackages',
		'includesInitialPackages',
		'maxAmountOfPackages',
		'baselinesByPackages',
		'dependentByPackages'
	],
	#category : 'TypeInfoTools-Dev-Dependencies',
	#package : 'TypeInfoTools-Dev',
	#tag : 'Dependencies'
}

{ #category : 'examples' }
TITDependentPackagesFinder class >> exampleAll [

	| packages |
	packages := self packageOrganizer packages asSortedCollection.
	[
		[ :job |
			| finder |
			finder := self new
				          includeInitialPackages;
				          maxAmountOfPackages: 50;
				          yourself.
			(packages withIndexCollect: [ :each :index |
					 job title: 'Finding dependent on ' , each name.
					 job value: index - 1.
					 each -> (finder
						  package: each;
						  collect;
						  packages) ]) asOrderedDictionary inspect ] asJob
			title: 'Finding dependent baselines...';
			max: packages size;
			run ]
		forkAt: Processor userBackgroundPriority
		named: 'TITDependentBaselinesFinder'
]

{ #category : 'examples' }
TITDependentPackagesFinder class >> exampleSingleBaseline [

	[
		(self new
			 includeInitialPackages;
			 maxAmountOfPackages: 50;
			 baseline: BaselineOfEpicea;
			 collect;
			 packages) inspect ]
		forkAt: Processor userBackgroundPriority
		named: self name
]

{ #category : 'examples' }
TITDependentPackagesFinder class >> exampleSinglePackage [

	[
		(self new
			 includeInitialPackages;
			 maxAmountOfPackages: 50;
			 packageName: ('Athens-Cairo');
			 collect;
			 packages) inspect ]
		forkAt: Processor userBackgroundPriority
		named: 'TITDependentBaselinesFinder'
]

{ #category : 'adding' }
TITDependentPackagesFinder >> addAndReportPackage: aPackage [

	packages addIfNotPresent: aPackage ifPresentDo: [ ^ false ].
	packages size - (self includesInitialPackages
		 ifTrue: [ 0 ]
		 ifFalse: [ initialPackages size ]) >= self maxAmountOfPackages
		ifTrue: [ TITMaxAmountOfDependentPackagesReached signal ].
	^ true
]

{ #category : 'accessing' }
TITDependentPackagesFinder >> baseline: aBaselineClass [

	| packagesInBaseline |
	packagesInBaseline := Set new.
	self
		packagesInBaseline: aBaselineClass
		do: [ :eachPackage | packagesInBaseline add: eachPackage ].
	self packages: packagesInBaseline
]

{ #category : 'private - processing' }
TITDependentPackagesFinder >> baselinesByPackages [

	| newBaselinesByPackages |
	baselinesByPackages ifNotNil: [ ^ baselinesByPackages ].
	newBaselinesByPackages := Dictionary new.

	BaselineOf allSubclasses do: [ :eachBaseline |
			self packagesInBaseline: eachBaseline do: [ :eachPackage |
					(newBaselinesByPackages at: eachPackage ifAbsentPut: Set new)
						add: eachBaseline ] ].

	^ baselinesByPackages := newBaselinesByPackages
]

{ #category : 'private - processing' }
TITDependentPackagesFinder >> collect [

	self prepareBeforeCollect.

	[ self collectFromPackages: packages ]
		on: TITMaxAmountOfDependentItemsReached
		do: [ :error |  ]
]

{ #category : 'private - processing' }
TITDependentPackagesFinder >> collectFromPackages: currentPackages [

	| dependentPackages newPackages |
	dependentPackages := currentPackages flatCollectAsSet: [ :eachPackage |
		                     self dependentByPackages at: eachPackage ].
	newPackages := dependentPackages select: [ :eachPackage |
		               self addAndReportPackage: eachPackage ].
	newPackages ifEmpty: [ ^ self ].
	self collectFromPackages: newPackages
]

{ #category : 'private - processing' }
TITDependentPackagesFinder >> dependenciesViaPackageDependencyOf: aPackage [

	^ (StDependencyChecker new
		   shouldComputeMessageSendDependencies: false;
		   daPackageFor: aPackage name) dependencies
		  collect: [ :each | each target systemPackage ]
		  as: Set
]

{ #category : 'private - processing' }
TITDependentPackagesFinder >> dependenciesViaPackageNameOn: aPackage [

	| projectNames |
	projectNames := { (aPackage name copyUpTo: $-) } asSet
	                , (IceRepository registry
			                 select: [ :repo |
				                 repo name ~= 'pharo' and: [
					                 repo includesPackageNamed: aPackage name ] ]
			                 thenCollect: [ :each | each name copyUpTo: $- ])
	                ,
		                ((self baselinesByPackages
			                  at: aPackage
			                  ifAbsent: [ Set empty ]) collect: [ :each |
			                 each name allButFirst: 10 ]).
	^ self packageOrganizer packages select: [ :eachPackage |
			  projectNames anySatisfy: [ :anyNamePart |
					  eachPackage ~= aPackage and: [
						  eachPackage name
							  includesSubstring: anyNamePart
							  caseSensitive: false ] ] ]
]

{ #category : 'private - processing' }
TITDependentPackagesFinder >> dependentByPackages [

	| newDependentByPackages |
	dependentByPackages ifNotNil: [ ^ dependentByPackages ].

	newDependentByPackages := (self packageOrganizer packages collect: [
		                           :eachPackage |
		                           eachPackage
		                           ->
		                           (self dependenciesViaPackageNameOn:
			                            eachPackage) asSet ]) asDictionary.

	self packageOrganizer packages do: [ :eachPackage |
			(self dependenciesViaPackageDependencyOf: eachPackage) do: [
				:eachDependency |
				(newDependentByPackages at: eachDependency) add: eachPackage ] ].

	^ dependentByPackages := newDependentByPackages
]

{ #category : 'accessing' }
TITDependentPackagesFinder >> excludeInitialPackages [

	includesInitialPackages := false
]

{ #category : 'accessing' }
TITDependentPackagesFinder >> includeInitialPackages [

	includesInitialPackages := true
]

{ #category : 'accessing' }
TITDependentPackagesFinder >> includesInitialPackages [

	^ includesInitialPackages ifNil: [ true ]
]

{ #category : 'accessing' }
TITDependentPackagesFinder >> maxAmountOfPackages [

	^ maxAmountOfPackages ifNil: [
		  maxAmountOfPackages := self packageOrganizer packages size ]
]

{ #category : 'accessing' }
TITDependentPackagesFinder >> maxAmountOfPackages: anInteger [
	"Maximum amount of returned packages"

	maxAmountOfPackages := anInteger
]

{ #category : 'accessing' }
TITDependentPackagesFinder >> package: aPackage [

	self packages: { aPackage }
]

{ #category : 'accessing' }
TITDependentPackagesFinder >> packageName: aPackageName [

	self package: (self packageOrganizer packageNamed: aPackageName)
]

{ #category : 'accessing' }
TITDependentPackagesFinder >> packages [

	| results |
	results := self includesInitialPackages
		           ifTrue: [ packages ]
		           ifFalse: [
		           packages reject: [ :any | initialPackages includes: any ] ].
	^ results sorted
]

{ #category : 'accessing' }
TITDependentPackagesFinder >> packages: aCollectionOfPackages [

	initialPackages := aCollectionOfPackages asSet.
	packages := nil
]

{ #category : 'private - processing' }
TITDependentPackagesFinder >> packagesInBaseline: aBaseline do: aBlock [

	aBaseline version packages do: [ :eachPackageSpec |
			self packageOrganizer
				packageNamed: eachPackageSpec name
				ifPresent: aBlock ]
]

{ #category : 'private - processing' }
TITDependentPackagesFinder >> prepareBeforeCollect [

	packages := initialPackages copy.

	self includesInitialPackages ifTrue: [
		packages do: [ :each | self addAndReportPackage: each ] ]
]
