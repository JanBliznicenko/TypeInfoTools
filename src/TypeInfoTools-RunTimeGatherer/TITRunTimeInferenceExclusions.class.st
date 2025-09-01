Class {
	#name : 'TITRunTimeInferenceExclusions',
	#superclass : 'Object',
	#category : 'TypeInfoTools-RunTimeGatherer-Gathering',
	#package : 'TypeInfoTools-RunTimeGatherer',
	#tag : 'Gathering'
}

{ #category : 'private - constants' }
TITRunTimeInferenceExclusions class >> excludedBaselines [

	^ Set withAll: {
			  BaselineOfTypeInfoTools.
			  BaselineOfReflectivity.
			  BaselineOfThreadedFFI.
			  BaselineOfUnifiedFFI.
			  BaselineOfAlexandrie }
]

{ #category : 'constants' }
TITRunTimeInferenceExclusions class >> excludedBaselinesFromInfering [

	^ self excludedBaselines , (Set withAll: {
			   BaselineOfEmergencyDebugger.
			   BaselineOfGeneralTests.
			   BaselineOfGhost.
			   BaselineOfKernelTests.
			   BaselineOfMocketry.
			   BaselineOfMonticelloZinc.
			   BaselineOfMonticelloZodiac.
			   BaselineOfNewToolsNewToolsDebugger.
			   BaselineOfPharoBootstrapAST.
			   BaselineOfPharoBootstrapCollections.
			   BaselineOfPharoBootstrapFFI.
			   BaselineOfPharoBootstrapJenkinsTools.
			   BaselineOfPharoBootstrapKernel.
			   BaselineOfPharoBootstrapTranscript.
			   BaselineOfPharoBootstrapRandom.
			   BaselineOfPharoBootstrapShift.
			   BaselineOfPharoBootstrapSystem.
			   BaselineOfPharoBootstrapSUnit.
			   BaselineOfPharoBootstrapZinc.
			   BaselineOfSindarin.
			   BaselineOfSpecCore.
			   BaselineOfStateSpecs.
			   BaselineOfTraits.
			   BaselineOfUI })
]

{ #category : 'constants' }
TITRunTimeInferenceExclusions class >> excludedBaselinesFromRunning [

	^ self excludedBaselines
]

{ #category : 'private - constants' }
TITRunTimeInferenceExclusions class >> excludedClassesFromRunning [

	^ self excludedPackagesFromRunning flatCollectAsSet: [ :each |
		  each definedClasses ]
]

{ #category : 'constants' }
TITRunTimeInferenceExclusions class >> excludedClassesFromRunningExamples [

	^ self excludedClassesFromRunning , (Set withAll: {
			   SpMenuItemPresenter.
			   SpMenuPresenter })
]

{ #category : 'constants' }
TITRunTimeInferenceExclusions class >> excludedClassesFromRunningTests [

	^ self excludedClassesFromRunning , (Set withAll: {
			   MorphicWindowManagerTest.
			   PhLVirtualMachineManagerTest.
			   AlbTextEditorInserterTest.
			   BlStartupShutdownTest.
			   IceGitWithoutUserNameTest })
]

{ #category : 'private - constants' }
TITRunTimeInferenceExclusions class >> excludedPackages [

	^ (self packageOrganizer packages select: [ :each |
		   each name includesSubstring: 'Deprecated' ]) asSet
]

{ #category : 'constants' }
TITRunTimeInferenceExclusions class >> excludedPackagesFromInfering [

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
TITRunTimeInferenceExclusions class >> excludedPackagesFromRunning [

	| excludedPacakagesFromEverything packagesInExcludedBaselines |
	excludedPacakagesFromEverything := self excludedPackages.
	packagesInExcludedBaselines := self excludedBaselinesFromRunning
		                               flatCollectAsSet: [ :each |
		                               each version loadedSystemPackages ].
	^ excludedPacakagesFromEverything , packagesInExcludedBaselines
]
