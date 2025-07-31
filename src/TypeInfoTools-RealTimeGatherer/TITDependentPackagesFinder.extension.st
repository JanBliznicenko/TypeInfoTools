Extension { #name : 'TITDependentPackagesFinder' }

{ #category : '*TypeInfoTools-RealTimeGatherer' }
TITDependentPackagesFinder class >> baselinesForInference [

	^ ((BaselineOf allSubclasses copyWithoutAll:
		    TITRealTimeInferenceExclusions excludedBaselinesFromInfering
		    , TITMetaLinksRealTimeTypeInferer splitBaselines) reject: [
		   :each | each version loadedSystemPackages isEmpty ])
		  asSortedCollection: [ :a :b | a name < b name ]
]

{ #category : '*TypeInfoTools-RealTimeGatherer' }
TITDependentPackagesFinder class >> forTypingPackages: aSetOfPackages [

	| finder |
	finder := self gather.
	self debugMode ifTrue: [ finder inspect ].
	^ finder query
		  includePackagesToProcess;
		  packagesToProcess: aSetOfPackages;
		  excludedPackages:
			  TITRealTimeInferenceExclusions excludedPackagesFromRunning;
		  get
]
