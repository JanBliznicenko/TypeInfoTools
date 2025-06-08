Class {
	#name : 'TITRealTimeInferenceExclusions',
	#superclass : 'Object',
	#category : 'TypeInfoTools-Dev-RealTime',
	#package : 'TypeInfoTools-Dev',
	#tag : 'RealTime'
}

{ #category : 'private - constants' }
TITRealTimeInferenceExclusions class >> excludedBaselines [

	^ Set withAll: {
			  BaselineOfTypeInfoTools.
			  BaselineOfReflectivity.
			  BaselineOfThreadedFFI.
			  BaselineOfUnifiedFFI.
			  BaselineOfAlexandrie }
]

{ #category : 'constants' }
TITRealTimeInferenceExclusions class >> excludedBaselinesFromInfering [

	^ self excludedBaselines , (Set withAll: {
			   BaselineOfTraits.
			   BaselineOfGhost.
			   BaselineOfStateSpecs.
			   BaselineOfMocketry.
			   BaselineOfSindarin.
			   BaselineOfEmergencyDebugger.
			   BaselineOfKernelTests.
			   BaselineOfUI.
			   BaselineOfPharoBootstrapCollections.
			   BaselineOfPharoBootstrapKernel.
			   BaselineOfPharoBootstrapTranscript.
			   BaselineOfNewToolsDebugger.
			   BaselineOfPharoBootstrapAST })
]

{ #category : 'constants' }
TITRealTimeInferenceExclusions class >> excludedBaselinesFromRunning [

	^ self excludedBaselines
]

{ #category : 'private - constants' }
TITRealTimeInferenceExclusions class >> excludedClassesFromRunning [

	^ self excludedPackagesFromRunning flatCollectAsSet: [ :each |
		  each definedClasses ]
]

{ #category : 'constants' }
TITRealTimeInferenceExclusions class >> excludedClassesFromRunningExamples [

	^ self excludedClassesFromRunning , (Set withAll: {
			   SpMenuItemPresenter.
			   SpMenuPresenter })
]

{ #category : 'constants' }
TITRealTimeInferenceExclusions class >> excludedClassesFromRunningTests [

	^ self excludedClassesFromRunning , (Set withAll: {
			   MorphicWindowManagerTest.
			   PhLVirtualMachineManagerTest.
			   AlbTextEditorInserterTest.
			   BlStartupShutdownTest })
]

{ #category : 'private - constants' }
TITRealTimeInferenceExclusions class >> excludedPackages [

	^ (self packageOrganizer packages select: [ :each |
		   each name includesSubstring: 'Deprecated' ]) asSet
]

{ #category : 'constants' }
TITRealTimeInferenceExclusions class >> excludedPackagesFromInfering [

	| excludedPacakagesFromEverything packagesInExcludedBaselines packagesBrokenByMetaLinks |
	excludedPacakagesFromEverything := self excludedPackages.
	packagesInExcludedBaselines := self excludedBaselinesFromInfering
		                               flatCollectAsSet: [ :each |
		                               each version loadedSystemPackages ].
	packagesBrokenByMetaLinks := #( 'OpalCompiler-Core'
	                                'Kernel-CodeModel' 'StateSpecs-Specs'
	                                'STON-Core' 'Debugger-Model' )
		                             collectAsSet: [ :each |
		                             self packageOrganizer packageNamed:
			                             each ].
	^ excludedPacakagesFromEverything , packagesInExcludedBaselines
	  , packagesBrokenByMetaLinks
]

{ #category : 'constants' }
TITRealTimeInferenceExclusions class >> excludedPackagesFromRunning [

	| excludedPacakagesFromEverything packagesInExcludedBaselines |
	excludedPacakagesFromEverything := self excludedPackages.
	packagesInExcludedBaselines := self excludedBaselinesFromRunning
		                               flatCollectAsSet: [ :each |
		                               each version loadedSystemPackages ].
	^ excludedPacakagesFromEverything , packagesInExcludedBaselines
]
