Class {
	#name : 'TITDependentPackagesFinder',
	#superclass : 'Object',
	#instVars : [
		'packages',
		'initialPackages',
		'includesInitialPackages',
		'maxAmountOfPackages',
		'baselinesByPackages',
		'dependentByPackages',
		'excludesReflectionPackages'
	],
	#category : 'TypeInfoTools-Dev-Dependencies',
	#package : 'TypeInfoTools-Dev',
	#tag : 'Dependencies'
}

{ #category : 'examples' }
TITDependentPackagesFinder class >> allByBaselines [

	| baselines |
	baselines := (BaselineOf allSubclasses reject: [ :any |
		              any version loadedSystemPackages isEmpty ])
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
					    maxAmountOfPackages:
						    each version loadedSystemPackages size * 2 + 20;
					    baseline: each;
					    collect;
					    packages) ]) asOrderedDictionary ] asJob
		  title: 'Finding dependent packages...';
		  max: baselines size;
		  run
]

{ #category : 'examples' }
TITDependentPackagesFinder class >> allByBaselinesForTyping [

	| baselines |
	baselines := self baselinesForTyping.

	^ [ :job |
		  | finder |
		  finder := self new
			            includeInitialPackages;
			            excludeReflectionPackages;
			            yourself.
		  (baselines withIndexCollect: [ :each :index |
				   job title: 'Finding dependent on ' , each name.
				   job value: index - 1.
				   each -> (finder
					    maxAmountOfPackages:
						    each version loadedSystemPackages size * 2 + 20;
					    baseline: each;
					    collect;
					    packages) ]) asOrderedDictionary ] asJob
		  title: 'Finding dependent packages...';
		  max: baselines size;
		  run
]

{ #category : 'examples' }
TITDependentPackagesFinder class >> allByPackages [

	| packages |
	packages := self packageOrganizer packages asSortedCollection.

	^ [ :job |
		  | finder |
		  finder := self new
			            includeInitialPackages;
			            maxAmountOfPackages: (self maxAmountOfPackagesFor: 1);
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
TITDependentPackagesFinder class >> baselinesForTyping [

	^ ((BaselineOf allSubclasses copyWithoutAll:
		    self excludedBaselinesForTypes) reject: [ :each |
		   each version loadedSystemPackages isEmpty ]) asSortedCollection: [
		  :a
		  :b | a name < b name ]
]

{ #category : 'examples' }
TITDependentPackagesFinder class >> dependingPackagesOn: aPackageName [

	^ self new
		  includeInitialPackages;
		  maxAmountOfPackages: (self maxAmountOfPackagesFor: 1);
		  packageName: aPackageName;
		  collect;
		  packages
]

{ #category : 'examples' }
TITDependentPackagesFinder class >> exampleAllByBaselines [

	self allByBaselines inspect
]

{ #category : 'examples' }
TITDependentPackagesFinder class >> exampleAllByBaselinesForTyping [

	self allByBaselinesForTyping inspect
]

{ #category : 'examples' }
TITDependentPackagesFinder class >> exampleAllByPackages [

	self allByPackages inspect
]

{ #category : 'examples' }
TITDependentPackagesFinder class >> exampleSingleBaseline [

	(self forBaseline: BaselineOfDrTests) inspect
]

{ #category : 'examples' }
TITDependentPackagesFinder class >> exampleSinglePackage [

	(self forPackage: 'Athens-Cairo') inspect
]

{ #category : 'examples' }
TITDependentPackagesFinder class >> excludedBaselinesForTypes [

	^ {
		  BaselineOfTypeInfoTools.
		  BaselineOfReflectivity } asSet
]

{ #category : 'examples' }
TITDependentPackagesFinder class >> excludedPackagesForTypes [

	^ (self excludedBaselinesForTypes flatCollect: [ :each |
		   each version loadedSystemPackages ])
	  , (#( 'OpalCompiler-Core' 'Kernel-CodeModel' ) collect: [ :each |
			   self packageOrganizer packageNamed: each ])
]

{ #category : 'examples' }
TITDependentPackagesFinder class >> forBaseline: aBaselineClass [

	^ self new
		  includeInitialPackages;
		  maxAmountOfPackages: (self maxAmountOfPackagesFor:
					   aBaselineClass version loadedSystemPackages size);
		  baseline: aBaselineClass;
		  collect;
		  packages
]

{ #category : 'examples' }
TITDependentPackagesFinder class >> forPackage: aPackage [

	^ self forPackages: { aPackage }
]

{ #category : 'examples' }
TITDependentPackagesFinder class >> forPackageNamed: aPackageName [

	^ self forPackage: (self packageOrganizer packageNamed: aPackageName)
]

{ #category : 'examples' }
TITDependentPackagesFinder class >> forPackages: aCollectionOfPackages [

	^ self new
		  includeInitialPackages;
		  maxAmountOfPackages:
			  (self maxAmountOfPackagesFor: aCollectionOfPackages size);
		  packages: aCollectionOfPackages;
		  collect;
		  packages
]

{ #category : 'examples' }
TITDependentPackagesFinder class >> forTypingPackages: aCollectionOfPackages [

	^ self new
		  includeInitialPackages;
		  maxAmountOfPackages:
			  (self maxAmountOfPackagesFor: aCollectionOfPackages size);
		  packages: aCollectionOfPackages;
		  excludeReflectionPackages;
		  collect;
		  packages
]

{ #category : 'examples' }
TITDependentPackagesFinder class >> maxAmountOfPackagesFor: anInteger [

	^ anInteger * 3 + 30
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

	self packages: aBaselineClass version loadedSystemPackages
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
		   daPackageFor: aPackage name) dependencies flatCollectAsSet: [
		  :each | each targetPackages ]
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
TITDependentPackagesFinder >> excludeReflectionPackages [

	excludesReflectionPackages := true
]

{ #category : 'accessing' }
TITDependentPackagesFinder >> excludesReflectionPackages [ 

	^ excludesReflectionPackages ifNil: [ false ]
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
TITDependentPackagesFinder >> packages [

	| results |
	results := self includesInitialPackages
		           ifTrue: [ packages ]
		           ifFalse: [
		           packages reject: [ :any | initialPackages includes: any ] ].
	self excludesReflectionPackages ifTrue: [
		results removeAllFoundIn: self class excludedPackagesForTypes ].
	^ results sorted
]

{ #category : 'accessing' }
TITDependentPackagesFinder >> packages: aCollectionOfPackages [

	initialPackages := aCollectionOfPackages asSet.
	packages := nil
]

{ #category : 'private - processing' }
TITDependentPackagesFinder >> packagesInBaseline: aBaseline do: aBlock [

	aBaseline version loadedSystemPackages do: aBlock
]

{ #category : 'private - processing' }
TITDependentPackagesFinder >> prepareBeforeCollect [

	packages := initialPackages copy.

	self includesInitialPackages ifTrue: [
		packages do: [ :each | self addAndReportPackage: each ] ]
]
