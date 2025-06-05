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
TITDependentPackagesFinder class >> allByBaselines [

	| baselines excluded |
	excluded := {
		            BaselineOfTypeMe.
		            BaselineOfTypeInfoTools.
		            BaselineOfRoelTyper.
		            BaselineOfJ2Inferer } asSet.
	baselines := (BaselineOf allSubclasses copyWithoutAll: excluded)
		             asSortedCollection: [ :a :b | a name < b name ].

	^ [ :job |
		  | finder |
		  finder := self new
			            includeInitialPackages;
			            yourself.
		  (baselines withIndexCollect: [ :each :index |
				   job title: 'Finding dependent on ' , each name.
				   job value: index - 1.
				   each -> (finder
					    maxAmountOfPackages: each version packages size * 3 + 50;
					    baseline: each;
					    collect;
					    packages) ]) asOrderedDictionary ] asJob
		  title: 'Finding dependent packages...';
		  max: baselines size;
		  run
]

{ #category : 'examples' }
TITDependentPackagesFinder class >> allByBaselinesExcept: excluded [

	| baselines  |
	baselines := (BaselineOf allSubclasses copyWithoutAll: excluded)
		             asSortedCollection: [ :a :b | a name < b name ].

	^ [ :job |
		  | finder |
		  finder := self new
			            includeInitialPackages;
			            yourself.
		  (baselines withIndexCollect: [ :each :index |
				   job title: 'Finding dependent on ' , each name.
				   job value: index - 1.
				   each -> (finder
					    maxAmountOfPackages: each version packages size * 3 + 50;
					    baseline: each;
					    collect;
					    packages) ]) asOrderedDictionary ] asJob
		  title: 'Finding dependent packages...';
		  max: baselines size;
		  run
]

{ #category : 'examples' }
TITDependentPackagesFinder class >> allByBaselinesForTypes [

	^ self allByBaselinesExcept: {
			  BaselineOfTypeMe.
			  BaselineOfTypeInfoTools.
			  BaselineOfRoelTyper.
			  BaselineOfJ2Inferer } asSet
]

{ #category : 'examples' }
TITDependentPackagesFinder class >> allByPackages [

	| packages |
	packages := self packageOrganizer packages asSortedCollection.

	^ [ :job |
		  | finder |
		  finder := self new
			            includeInitialPackages;
			            maxAmountOfPackages: 100;
			            yourself.
		  (packages withIndexCollect: [ :each :index |
				   job title: 'Finding dependent on ' , each name.
				   job value: index - 1.
				   each -> (finder
					    package: each;
					    collect;
					    packages) ]) asOrderedDictionary ] asJob
		  title: 'Finding dependent packages...';
		  max: packages size;
		  run
]

{ #category : 'examples' }
TITDependentPackagesFinder class >> dependingPackagesOn: aPackageName [

	^ self new
		  includeInitialPackages;
		  maxAmountOfPackages: 100;
		  packageName: aPackageName;
		  collect;
		  packages
]

{ #category : 'examples' }
TITDependentPackagesFinder class >> exampleAllByBaselines [

	self allByBaselines inspect
]

{ #category : 'examples' }
TITDependentPackagesFinder class >> exampleAllByBaselinesForTypes [

	self allByBaselinesForTypes inspect
]

{ #category : 'examples' }
TITDependentPackagesFinder class >> exampleAllByPackages [

	self allByPackages inspect
]

{ #category : 'examples' }
TITDependentPackagesFinder class >> exampleSingleBaseline [

	(self forBaseline: BaselineOfAthens) inspect
]

{ #category : 'examples' }
TITDependentPackagesFinder class >> exampleSinglePackage [

	(self forPackage: 'Athens-Cairo') inspect
]

{ #category : 'examples' }
TITDependentPackagesFinder class >> forBaseline: aBaselineClass [

	^ self new
		  includeInitialPackages;
		  maxAmountOfPackages: 100;
		  baseline: aBaselineClass;
		  collect;
		  packages
]

{ #category : 'examples' }
TITDependentPackagesFinder class >> forPackage: aPackageName [

	^ self new
		  includeInitialPackages;
		  maxAmountOfPackages: 100;
		  packageName: aPackageName;
		  collect;
		  packages
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
