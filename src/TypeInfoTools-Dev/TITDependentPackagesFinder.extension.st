Extension { #name : 'TITDependentPackagesFinder' }

{ #category : '*TypeInfoTools-Dev' }
TITDependentPackagesFinder class >> baselinesForTyping [

	^ ((BaselineOf allSubclasses copyWithoutAll:
		    self excludedBaselinesForTypes) reject: [ :each |
		   each version loadedSystemPackages isEmpty ]) asSortedCollection: [
		  :a
		  :b | a name < b name ]
]

{ #category : '*TypeInfoTools-Dev' }
TITDependentPackagesFinder class >> byBaselinesForTyping [

	| baselines excludedPackages |
	baselines := self baselinesForTyping.
	excludedPackages := self excludedPackagesForTypes.

	^ [ :job |
		  | finder |
		  job value: baselines size negated.
		  finder := self gather.
		  self debugMode ifTrue: [ finder inspect ].
		  (baselines withIndexCollect: [ :each :index |
					   | packages |
					   job title: 'Finding dependent on ' , each name.
					   job value: index - 1.
					   packages := each version loadedSystemPackages.
					   each -> (finder query
							    includePackagesToProcess;
							    excludedPackages: excludedPackages;
							    packagesToProcess: packages;
							    get) ]) asOrderedDictionary ] asJob
		  title: 'Gathering dependent packages...';
		  min: baselines size negated;
		  max: baselines size;
		  run
]

{ #category : '*TypeInfoTools-Dev' }
TITDependentPackagesFinder class >> exampleByBaselinesForTyping [

	^ self byBaselinesForTyping inspect
]

{ #category : '*TypeInfoTools-Dev' }
TITDependentPackagesFinder class >> excludedBaselinesForTypes [

	^ {
		  BaselineOfTypeInfoTools.
		  BaselineOfReflectivity.
		  BaselineOfTraits } asSet
]

{ #category : '*TypeInfoTools-Dev' }
TITDependentPackagesFinder class >> excludedPackagesForTypes [

	^ (self excludedBaselinesForTypes flatCollect: [ :each |
		   each version loadedSystemPackages ])
	  , (#( 'OpalCompiler-Core' 'Kernel-CodeModel' ) collect: [ :each |
			   self packageOrganizer packageNamed: each ])
]

{ #category : '*TypeInfoTools-Dev' }
TITDependentPackagesFinder class >> forTypingPackages: aSetOfPackages [

	| finder |
	finder := self gather.
	self debugMode ifTrue: [ finder inspect ].
	^ finder query
		  excludePackagesToProcess;
		  packagesToProcess: aSetOfPackages;
		  excludedPackages: self excludedPackagesForTypes;
		  get
]
