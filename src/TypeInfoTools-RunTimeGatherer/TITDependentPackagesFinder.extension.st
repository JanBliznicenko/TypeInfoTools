Extension { #name : 'TITDependentPackagesFinder' }

{ #category : '*TypeInfoTools-RunTimeGatherer' }
TITDependentPackagesFinder class >> baselinesForInference [

	^ ((BaselineOf allSubclasses copyWithoutAll:
		    TITRunTimeInferenceExclusions excludedBaselinesFromInfering
		    , TITMetaLinksRunTimeTypeInferer splitBaselines) reject: [
		   :each | each version loadedSystemPackages isEmpty ])
		  asSortedCollection: [ :a :b | a name < b name ]
]

{ #category : '*TypeInfoTools-RunTimeGatherer' }
TITDependentPackagesFinder class >> forTypingPackages: aSetOfPackages [

	| finder |
	finder := self gather.
	self debugMode ifTrue: [ finder inspect ].
	^ finder query
		  includePackagesToProcess;
		  packagesToProcess: aSetOfPackages;
		  excludedPackages:
			  TITRunTimeInferenceExclusions excludedPackagesFromRunning;
		  get
]
