Class {
	#name : 'TITTestsAndExamplesProcessHandler',
	#superclass : 'Object',
	#instVars : [
		'manager',
		'shouldRun',
		'vm',
		'processName',
		'runnerClass',
		'process',
		'baselineName'
	],
	#category : 'TypeInfoTools-Dev-RealTime',
	#package : 'TypeInfoTools-Dev',
	#tag : 'RealTime'
}

{ #category : 'instance creation' }
TITTestsAndExamplesProcessHandler class >> named: aString manager: aManager [

	^ self new
		  processName: aString;
		  manager: aManager;
		  yourself
]

{ #category : 'instance creation' }
TITTestsAndExamplesProcessHandler class >> named: aString manager: aManager runnerClass: aClass [

	^ (self named: aString manager: aManager)
		  runnerClass: aClass;
		  yourself
]

{ #category : 'instance creation' }
TITTestsAndExamplesProcessHandler class >> runNamed: aString manager: aManager [

	^ (self named: aString manager: aManager)
		  run;
		  yourself
]

{ #category : 'instance creation' }
TITTestsAndExamplesProcessHandler class >> runNamed: aString manager: aManager runnerClass: aClass [

	^ (self named: aString manager: aManager runnerClass: aClass)
		  run;
		  yourself
]

{ #category : 'accessing' }
TITTestsAndExamplesProcessHandler >> baselineName [

	^ baselineName
]

{ #category : 'initialization' }
TITTestsAndExamplesProcessHandler >> initialize [

	super initialize.
	shouldRun := true.
	runnerClass := TITMetaLinksRealTimeTypeInferer
]

{ #category : 'accessing' }
TITTestsAndExamplesProcessHandler >> manager [

	^ manager
]

{ #category : 'accessing' }
TITTestsAndExamplesProcessHandler >> manager: anObject [

	manager := anObject
]

{ #category : 'running' }
TITTestsAndExamplesProcessHandler >> prepareDirectoryForProjectNamed: projectName [

	| sourceName sourceDirectory targetName targetDirectory |
	sourceName := FileLocator image basenameWithoutExtension.
	sourceDirectory := FileLocator imageDirectory asFileReference.
	targetName := sourceName , '_' , projectName.
	targetDirectory := (sourceDirectory parent / targetName)
		                   asFileReference.
	targetDirectory ensureDeleteAllChildren.
	targetDirectory ensureCreateDirectory.
	sourceDirectory files
		select: [ :each |
				each basename endsWithAnyOf:
					#( '.version' '.sources' '.changes' '.image' ) ]
		thenDo: [ :each |
				each copyTo: targetDirectory
					/ (each basename copyReplaceAll: sourceName with: targetName) ].
	^ targetDirectory / (targetName , '.image')
]

{ #category : 'accessing' }
TITTestsAndExamplesProcessHandler >> process [

	^ process
]

{ #category : 'accessing' }
TITTestsAndExamplesProcessHandler >> processName [

	^ processName
]

{ #category : 'accessing' }
TITTestsAndExamplesProcessHandler >> processName: anObject [

	processName := anObject
]

{ #category : 'running' }
TITTestsAndExamplesProcessHandler >> run [

	baselineName := nil.
	[
		shouldRun and: [
			(baselineName := manager getNextBaselineName) isNotNil ] ]
		whileTrue: [ self runBaseline ]
]

{ #category : 'running' }
TITTestsAndExamplesProcessHandler >> runBaseline [

	| imageFile |
	Transcript crShow:
		processName asString , ': Preparing directory for ' , baselineName.
	imageFile := self prepareDirectoryForProjectNamed: baselineName.
	Transcript crShow:
		processName asString , ': Processing ' , baselineName.
	process := OSWSWinProcess new.
	process
		command: vm displayString;
		workingDirectory: imageFile parent displayString;
		arguments: {
				'--headless'.
				imageFile displayString.
				('eval [' , runnerClass name , ' gatherBaselineNamed: '''
				 , baselineName
				 ,
					 '''] on: Error do: [ :e |  ]. Smalltalk snapshot: false andQuit: true') };
		run.
	[ process isRunning ] whileTrue: [ 2 seconds wait ].
	Transcript crShow:
		processName asString , ': Finished ' , baselineName
]

{ #category : 'accessing' }
TITTestsAndExamplesProcessHandler >> runnerClass: anObject [

	runnerClass := anObject
]

{ #category : 'accessing' }
TITTestsAndExamplesProcessHandler >> shouldRun [

	^ shouldRun
]

{ #category : 'accessing' }
TITTestsAndExamplesProcessHandler >> shouldRun: anObject [

	shouldRun := anObject
]
