Class {
	#name : 'TITTestsAndExamplesRunner',
	#superclass : 'Object',
	#instVars : [
		'gatheredPackages',
		'executedPackages',
		'logStream',
		'errorLogStream',
		'name'
	],
	#category : 'TypeInfoTools-Dev-RealTime',
	#package : 'TypeInfoTools-Dev',
	#tag : 'RealTime'
}

{ #category : 'constants' }
TITTestsAndExamplesRunner class >> amountOfThreads [

	^ 12
]

{ #category : 'private' }
TITTestsAndExamplesRunner class >> baselines [

	<script: 'self baselines inspect'>
	^ TITDependentPackagesFinder baselinesForInference
]

{ #category : 'examples' }
TITTestsAndExamplesRunner class >> example [

	[ self gatherBaselineNamed: self exampleBaselineName ]
		forkAt: Processor userBackgroundPriority
		named: self name
]

{ #category : 'examples' }
TITTestsAndExamplesRunner class >> exampleAll [

	| baselines |
	baselines := self baselines.
	[
		[ :job |
			job max: baselines size.
			baselines withIndexDo: [ :each :i |
					job currentValue: i.
					job title: 'Executing examples in ' , each name.
					self new
						gatheredBaseline: each;
						gatheredPackagesAsExecutedPackages;
						name: (self nameOfBaseline: each);
						execute ] ] asJob run ]
		forkAt: Processor userBackgroundPriority
		named: self name
]

{ #category : 'examples' }
TITTestsAndExamplesRunner class >> exampleBaselineName [

	<script: 'self exampleBaselineName inspect'>
	| imageNameParts imageTypeAndDate imageBaseline defaultName |
	defaultName := 'RTree'.
	imageNameParts := Smalltalk image imageFile basenameWithoutExtension
		                  splitOn: $_.
	imageNameParts size = 2 ifFalse: [ ^ defaultName ].
	imageTypeAndDate := imageNameParts first.
	imageBaseline := imageNameParts second.
	imageBaseline ifEmpty: [ ^ defaultName ].
	((imageTypeAndDate matchesRegex: '.*-\d\d-\d\d-\d\d') and: [
		 imageBaseline first isLetter and: [
			 imageBaseline isAllAlphaNumerics ] ]) ifTrue: [ ^ imageBaseline ].
	^ defaultName
]

{ #category : 'examples' }
TITTestsAndExamplesRunner class >> gatherBaselineNamed: aNameOfBaseline [

	| baselineClass inferer results |
	baselineClass := Smalltalk at:
		                 ('BaselineOf' , aNameOfBaseline) asSymbol.
	inferer := self new.
	results := inferer
		           gatheredBaseline: baselineClass;
		           name: aNameOfBaseline;
		           execute.
	results inspect.
	inferer inspect
]

{ #category : 'private' }
TITTestsAndExamplesRunner class >> nameOfBaseline: aBaselineClass [

	^ aBaselineClass name asString allButFirst: 10
]

{ #category : 'private' }
TITTestsAndExamplesRunner class >> prepareDirectoryForProjectNamed: projectName [

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

{ #category : 'private' }
TITTestsAndExamplesRunner class >> prepareVmForThread: anIndex [

	| sourceDirectory sourceDirectoryName targetDirectoryName targetDirectory originalTargetExe targetExeName targetExe |
	sourceDirectory := FileLocator vmDirectory asFileReference.
	sourceDirectoryName := sourceDirectory basename.
	targetDirectoryName := sourceDirectoryName , '_' , anIndex asString.
	targetDirectory := sourceDirectory parent / targetDirectoryName.
	originalTargetExe := targetDirectory / 'PharoConsole.exe'.
	targetExeName := 'PharoConsole_' , anIndex asString , '.exe'.
	targetExe := targetDirectory / targetExeName.
	targetExe exists ifTrue: [
			targetExe isWritable ifFalse: [ self notify: 'VM in use' ].
			^ targetExe ].
	targetDirectory ensureDeleteAllChildren.
	targetDirectory ensureCreateDirectory.
	sourceDirectory copyAllTo: targetDirectory.
	originalTargetExe renameTo: targetExeName.
	^ targetExe
]

{ #category : 'private' }
TITTestsAndExamplesRunner class >> projectNames [

	<script: 'self projectNames inspect'>
	^ self baselines collect: [ :eachBaseline |
		  self nameOfBaseline: eachBaseline ]
]

{ #category : 'execution' }
TITTestsAndExamplesRunner class >> runBaselinesInSeparateProcesses [

	<script>
	| projectNames getNextProjectName mutex |
	projectNames := self projectNames.
	mutex := Mutex new.
	getNextProjectName := [ mutex critical: [ projectNames removeFirst ] ].
	Transcript open.

	1 to: self amountOfThreads do: [ :threadIndex |
			| vm |
			vm := self prepareVmForThread: threadIndex.
			[
				[ mutex critical: [ projectNames isNotEmpty ] ] whileTrue: [
						| projectName imageFile |
						projectName := getNextProjectName value.
						imageFile := self prepareDirectoryForProjectNamed: projectName.
						self
							runProjectNamed: projectName
							image: imageFile
							vm: vm
							threadIndex: threadIndex ] ]
				forkAt: Processor userBackgroundPriority
				named: self name , '-' , threadIndex asString ]
]

{ #category : 'examples' }
TITTestsAndExamplesRunner class >> runProjectNamed: projectName image: anImageFile vm: vm threadIndex: threadIndex [

	| process |
	Transcript crShow:
		threadIndex asString , ': Processing ' , projectName.
	process := OSWSWinProcess new.
	process
		command: vm displayString;
		workingDirectory: anImageFile parent displayString;
		arguments: {
				'--headless'.
				anImageFile displayString.
				('eval [' , self name , ' gatherBaselineNamed: ''' , projectName
				 ,
					 '''] on: Error do: [ :e |  ]. Smalltalk snapshot: false andQuit: true') };
		run.
	[ process isRunning ] whileTrue: [ 5 seconds wait ].
	Transcript crShow: threadIndex asString , ': Finished ' , projectName
]

{ #category : 'execution' }
TITTestsAndExamplesRunner >> deleteWindowsExcept: originalWindows [

	Smalltalk currentWorld systemWindows
		reject: [ :eachWindow |
				(Smalltalk image isInteractiveGraphic and: [
					 originalWindows includes: eachWindow ]) or: [
						| model |
						model := eachWindow model.
						(model isKindOf: ClyFullBrowserMorph) or: [
								(model respondsTo: #presenter) and: [
										| presenter |
										presenter := eachWindow model presenter.
										(presenter isKindOf: StDebugger) or: [
												(presenter isKindOf:
													 StAbstractMessageCentricBrowserPresenter) or: [
														(presenter isKindOf: StInspectorPresenter) and: [
																(executedPackages includes:
																	 presenter model inspectedObject class package) not ] ] ] ] ] ] ]
		thenDo: [ :each | each delete ].
	Smalltalk
		at: #BlOSWindowSDL2HostSpace
		ifPresent: [ :windowClass |
		windowClass allInstancesDo: [ :each | each close ] ]
]

{ #category : 'logging' }
TITTestsAndExamplesRunner >> errorLog: anObject [

	self log: anObject.
	errorLogStream nextPutAll: anObject asString
]

{ #category : 'logging' }
TITTestsAndExamplesRunner >> errorLogCrlf: anObject [

	self errorLog: anObject asString , String crlf.
	logStream flush.
	errorLogStream flush
]

{ #category : 'logging' }
TITTestsAndExamplesRunner >> errorLogEntry: aString [

	self errorLogTime.
	self errorLogCrlf: aString asString.
	logStream flush.
	errorLogStream flush
]

{ #category : 'logging' }
TITTestsAndExamplesRunner >> errorLogTime [

	self errorLog: self timestamp
]

{ #category : 'executing' }
TITTestsAndExamplesRunner >> execute [

	self runTestsAndExamples
]

{ #category : 'accessing' }
TITTestsAndExamplesRunner >> executedPackages [

	^ executedPackages ifNil: [
			  executedPackages := (TITDependentPackagesFinder
				                       forTypingPackages: gatheredPackages)
				                      asArray sortedAs: [ :each | each name ] ]
]

{ #category : 'accessing' }
TITTestsAndExamplesRunner >> executedPackages: aCollectionOfPackages [

	executedPackages := aCollectionOfPackages
]

{ #category : 'logging' }
TITTestsAndExamplesRunner >> fileNameOfOfType: aString [

	(aString , '_' , self name , '.txt') inspect.
	^ aString , '_' , self name , '.txt'
]

{ #category : 'accessing' }
TITTestsAndExamplesRunner >> gatheredBaseline: aBaselineClass [

	self gatheredPackages: aBaselineClass version loadedSystemPackages
]

{ #category : 'accessing' }
TITTestsAndExamplesRunner >> gatheredPackage: aPackage [

	self gatheredPackages: { aPackage }
]

{ #category : 'accessing' }
TITTestsAndExamplesRunner >> gatheredPackages: aPackagesCollection [

	self initialize.
	gatheredPackages := aPackagesCollection copyWithoutAll:
		                    TITRealTimeInferenceExclusions
			                    excludedPackagesFromInfering
]

{ #category : 'accessing' }
TITTestsAndExamplesRunner >> gatheredPackagesAsExecutedPackages [

	executedPackages := gatheredPackages copy
]

{ #category : 'initialization' }
TITTestsAndExamplesRunner >> initialize [

	super initialize.
	logStream := NullStream new.
	errorLogStream := NullStream new.
]

{ #category : 'logging' }
TITTestsAndExamplesRunner >> log: anObject [

	logStream nextPutAll: anObject asString
]

{ #category : 'logging' }
TITTestsAndExamplesRunner >> logCrlf: anObject [

	self log: anObject asString , String crlf.
	logStream flush
]

{ #category : 'logging' }
TITTestsAndExamplesRunner >> logEntry: aString [

	self logTime.
	self logCrlf: aString asString.
	logStream flush
]

{ #category : 'logging' }
TITTestsAndExamplesRunner >> logFileWithContent: aNameOfContent extension: anExtension [

	^ (self name , '_' , aNameOfContent , '.' , anExtension)
		  asFileReference
]

{ #category : 'logging' }
TITTestsAndExamplesRunner >> logTime [

	self log: self timestamp
]

{ #category : 'accessing' }
TITTestsAndExamplesRunner >> name [

	^ name ifNil: [ 'realtime' ]
]

{ #category : 'accessing' }
TITTestsAndExamplesRunner >> name: aString [

	name := aString
]

{ #category : 'execution' }
TITTestsAndExamplesRunner >> runExamples [

	| exampleMethods originalWindows |
	exampleMethods := self executedPackages flatCollect: [ :eachPackage |
			                  ((eachPackage definedClasses difference:
				                    TITRealTimeInferenceExclusions
					                    excludedClassesFromRunningExamples) asArray
				                   sortedAs: [ :each | each name ]) flatCollect: [
					                  :eachClass |
					                  (eachClass class methods select: [ :eachMethod |
							                   (ClyExampleScript canBeProvidedByMethod:
								                    eachMethod) and: [
								                   ClyExampleScript isImplementedByMethod:
									                   eachMethod ] ]) asArray sortedAs: [ :each |
						                  each selector ] ] ].

	self logEntry:
		'Executing ' , exampleMethods size asString , ' examples'.

	exampleMethods ifEmpty: [ ^ self ].

	originalWindows := Smalltalk currentWorld systemWindows asSet.

	[ :job |
		job max: exampleMethods size.
		exampleMethods withIndexDo: [ :each :index |
				| finished |
				finished := false.
				job title:
					'Executing example ' , each printString , ' (' , index asString
					, ' / ' , exampleMethods size asString , ')'.
				job value: index - 1.
				self logEntry:
					'Executing example ' , each printString , ' (' , index asString
					, ' / ' , exampleMethods size asString , ')'.
				Smalltalk garbageCollect.
				[
					1 to: 5 do: [ :exponent |
					finished ifFalse: [ (3 ** exponent) seconds wait ] ].
					self deleteWindowsExcept: originalWindows ]
					forkAt: Processor userSchedulingPriority
					named: self class name , ' window deleting'.
				[
					each
						valueWithReceiver: each classBinding value instanceSide
						arguments: #(  ) ]
					on: Error
					do: [ :error |
							self errorLogEntry:
								'Failed to execute example ' , each printString
								, ' because of error: ' , error description ].
				2 second wait.
				finished := true ] ] asJob run.

	self logEntry:
		'Executed ' , exampleMethods size asString , ' examples'.

	self deleteWindowsExcept: originalWindows.

	Smalltalk image isInteractiveGraphic ifFalse: [ ^ self ].
	self inform: 'Executed ' , exampleMethods size asString , ' examples'
]

{ #category : 'execution' }
TITTestsAndExamplesRunner >> runTests [

	| testClasses testResult originalWindows |
	TestCase defaultTimeLimit: 1 minute.

	testClasses := self executedPackages flatCollect: [ :eachPackage |
			               ((eachPackage definedClasses select: [ :each |
				                 each isTestCase and: [ each isAbstract not ] ])
				                difference:
				                TITRealTimeInferenceExclusions
					                excludedClassesFromRunningTests) asArray
				               sortedAs: [ :each | each name ] ].

	self logEntry:
		'Executing ' , testClasses size asString , ' test classes'.

	testClasses ifEmpty: [ ^ self ].

	testResult := testClasses anyOne classForTestResult new.

	originalWindows := Smalltalk currentWorld systemWindows asSet.

	[ :job |
		job max: testClasses size.
		testClasses withIndexDo: [ :each :index |
				job title:
					'Executing tests in ' , each printString , ' (' , index asString
					, ' / ' , testClasses size asString , ')'.
				job value: index - 1.
				self logEntry:
					'Executing tests in ' , each printString , ' (' , index asString
					, ' / ' , testClasses size asString , ')'.
				each resetHistory.
				Smalltalk garbageCollect.
				[ each suite run: testResult ]
					on: Error
					do: [ :error |
							self errorLogEntry:
								'Failed to execute tests in ' , each name asString
								, ' because of error: ' , error description asString ] ] ]
		asJob run.

	testResult updateResultsInHistory.

	self deleteWindowsExcept: originalWindows.

	self logEntry:
		'Executed ' , testClasses size asString , ' test classes, '
		, testResult passedCount asString , ' passed'.

	Smalltalk image isInteractiveGraphic ifTrue: [
			GrowlMorph
				showTestResult: testResult
				with: (String streamContents: [ :s |
							 executedPackages size = 1
								 ifTrue: [ s nextPutAll: executedPackages anyOne name ]
								 ifFalse: [ executedPackages size asString , ' packages' ] ]) ].

	testResult hasPassed ifTrue: [ ^ self ].

	self errorLogEntry:
		'Test errors: ' , testResult errorCount asString
		, ', Test failures: ' , testResult failureCount asString
]

{ #category : 'execution' }
TITTestsAndExamplesRunner >> runTestsAndExamples [

	[
		(self logFileWithContent: 'Log' extension: 'txt')
			ensureDelete;
			writeStreamDo: [ :s |
					(self logFileWithContent: 'Errors' extension: 'txt')
						ensureDelete;
						writeStreamDo: [ :es |
								logStream := s.
								errorLogStream := es.
								self
									runTests;
									runExamples.
								self logEntry: 'Tests and examples executed' ] ] ] ensure: [
			logStream := NullStream new.
			errorLogStream := NullStream new.
			Smalltalk image isInteractiveGraphic ifTrue: [
					(self logFileWithContent: 'Errors' extension: 'txt')
						readStreamDo: [ :s |
						s contents ifNotEmpty: [ :contents | contents inspect ] ] ] ]
]

{ #category : 'logging' }
TITTestsAndExamplesRunner >> timestamp [

	^ Time now print24 , ' | '
]
