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

{ #category : 'private' }
TITTestsAndExamplesRunner class >> baselines [

	^ TITDependentPackagesFinder baselinesForTyping
]

{ #category : 'examples' }
TITTestsAndExamplesRunner class >> example [

	[ self gatherBaselineNamed: 'AIEditDistances' ]
		forkAt: Processor userBackgroundPriority
		named: self name
]

{ #category : 'examples' }
TITTestsAndExamplesRunner class >> exampleAll [

	| projectNames |
	projectNames := self projectNames.
	[
		[ :job |
			job max: projectNames size.
			projectNames withIndexDo: [ :each :i |
					job currentValue: i.
					self gatherBaselineNamed: each ] ] asJob run ]
		forkAt: Processor userBackgroundPriority
		named: self name
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
TITTestsAndExamplesRunner class >> projectNames [

	^ self baselines collect: [ :eachBaseline |
		  eachBaseline name asString allButFirst: 10 ]
]

{ #category : 'execution' }
TITTestsAndExamplesRunner >> deleteWindowsExcept: originalWindows [

	Smalltalk currentWorld systemWindows
		reject: [ :eachWindow |
				(Smalltalk image isInteractiveGraphic and: [
					 originalWindows includes: eachWindow ]) or: [
						| model |
						model := eachWindow model.
						model isNotNil and: [
								(model isKindOf: ClyFullBrowserMorph) or: [
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

{ #category : 'execution' }
TITTestsAndExamplesRunner >> excludesTestClass: aTestClass [

	^ aTestClass = MorphicWindowManagerTest
]

{ #category : 'executing' }
TITTestsAndExamplesRunner >> execute [

	self runTestsAndExamples.
	self logResults
]

{ #category : 'accessing' }
TITTestsAndExamplesRunner >> executedPackages [

	^ executedPackages ifNil: [
			  executedPackages := TITDependentPackagesFinder
				                      forTypingPackages: gatheredPackages ]
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
		                    TITDependentPackagesFinder
			                    excludedPackagesForTypes
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
TITTestsAndExamplesRunner >> logResults [

	self logResults: self variableTypesByNamesAsStrings as: 'VarTypes'.
	self logResults: self returnTypesByNamesAsStrings as: 'RetTypes'
]

{ #category : 'logging' }
TITTestsAndExamplesRunner >> logResults: contents as: aContentTypeName [

	Smalltalk image isInteractiveGraphic ifTrue: [ contents inspect ].
	(self logFileWithContent: aContentTypeName extension: 'ston')
		ensureDelete;
		writeStreamDo: [ :s | STON put: contents onStreamPretty: s ]
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
			                  (eachPackage definedClasses sorted: [ :a :b |
				                   a name < b name ]) flatCollect: [ :eachClass |
					                  (eachClass class methods select: [ :eachMethod |
							                   (ClyExampleScript canBeProvidedByMethod:
								                    eachMethod) and: [
								                   ClyExampleScript isImplementedByMethod:
									                   eachMethod ] ]) sorted: [ :a :b |
						                  a selector < b selector ] ] ].

	self logEntry:
		'Executing ' , exampleMethods size asString , ' examples'.

	exampleMethods ifEmpty: [ ^ self ].

	originalWindows := Smalltalk currentWorld systemWindows asSet.

	[ :job |
		job max: exampleMethods size.
		exampleMethods withIndexDo: [ :each :index |
				job title:
					'Executing example ' , each printString , ' (' , index asString
					, ' / ' , exampleMethods size asString , ')'.
				job value: index - 1.
				self logEntry:
					'Executing example ' , each printString , ' (' , index asString
					, ' / ' , exampleMethods size asString , ')'.
				[
					1 seconds wait.

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
				2 seconds wait ] ] asJob run.
		
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
			               (eachPackage definedClasses select: [ :each |
					                each isTestCase and: [
						                each isAbstract not and: [
							                (self excludesTestClass: each) not ] ] ])
				               sorted: [ :a :b | a name < b name ] ].

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
									runExamples ] ] ] ensure: [
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
