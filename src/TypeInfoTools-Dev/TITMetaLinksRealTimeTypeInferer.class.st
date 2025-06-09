Class {
	#name : 'TITMetaLinksRealTimeTypeInferer',
	#superclass : 'Object',
	#instVars : [
		'gatheredPackages',
		'executedPackages',
		'insertionVisitor',
		'variableTypes',
		'returnTypes',
		'logStream',
		'errorLogStream',
		'name'
	],
	#category : 'TypeInfoTools-Dev-RealTime',
	#package : 'TypeInfoTools-Dev',
	#tag : 'RealTime'
}

{ #category : 'private' }
TITMetaLinksRealTimeTypeInferer class >> createImagesByNames [

	| baselines sourceName sourceDirectory |
	baselines := TITDependentPackagesFinder baselinesForTyping.
	sourceName := FileLocator image basenameWithoutExtension.
	sourceDirectory := FileLocator image parent asFileReference.
	^ [ :job |
		  job max: baselines size.
		  baselines withIndexCollect: [ :eachBaseline :index |
				  | projectName targetName targetDirectory targetImage |
				  projectName := eachBaseline name asString allButFirst: 10.
				  job title: 'Creating directory for ' , projectName.
				  job value: index.
				  targetName := sourceName , '_' , projectName.
				  targetDirectory := (FileLocator image parent parent
				                      / (sourceName , '_' , projectName))
					                     asFileReference.
				  targetDirectory ensureDeleteAllChildren.
				  targetDirectory ensureCreateDirectory.
				  sourceDirectory := FileLocator image parent asFileReference.
				  sourceDirectory files
					  select: [ :each |
							  each basename endsWithAnyOf:
								  #( '.version' '.sources' '.changes' '.image' ) ]
					  thenDo: [ :each |
							  each copyTo: targetDirectory
								  /
								  (each basename copyReplaceAll: sourceName with: targetName) ].
				  targetImage := targetDirectory / (targetName , '.image').
				  projectName -> targetImage ] ] asJob run
]

{ #category : 'examples' }
TITMetaLinksRealTimeTypeInferer class >> example [

	[ self gatherBaselineNamed: 'AIEditDistances' ]
		forkAt: Processor userBackgroundPriority
		named: self name
]

{ #category : 'examples' }
TITMetaLinksRealTimeTypeInferer class >> gatherBaselineNamed: aNameOfBaseline [

	| baselineClass inferer results |
	baselineClass := Smalltalk at:
		                 ('BaselineOf' , aNameOfBaseline) asSymbol.
	inferer := self new.
	results := inferer
		           gatheredBaseline: baselineClass;
		           name: aNameOfBaseline;
		           gatherTypes.
	results inspect.
	inferer inspect
]

{ #category : 'examples' }
TITMetaLinksRealTimeTypeInferer class >> runBaselinesInSeparateProcesses [

	<script>
	| imagesByNames getImageByName exe mutex allImagesAmount threads |
	threads := 6.
	imagesByNames := self createImagesByNames.
	allImagesAmount := imagesByNames size.
	mutex := Mutex new.
	getImageByName := [ mutex critical: [ imagesByNames removeFirst ] ].
	exe := (FileLocator vmDirectory asFileReference / 'PharoConsole.exe')
		       displayString.

	1 to: threads do: [ :index |
			[
				[ mutex critical: [ imagesByNames isNotEmpty ] ] whileTrue: [
						| imageByName |
						imageByName := getImageByName value.
						self runImageByName: imageByName index: index ] ]
				forkAt: Processor userBackgroundPriority
				named: self name , '-' , index asString ]
]

{ #category : 'examples' }
TITMetaLinksRealTimeTypeInferer class >> runImageByName: imageByName index: index [

	| process exe |
	Transcript crShow: index asString , ': Processing ' , imageByName key.
	exe := (FileLocator vmDirectory asFileReference / 'PharoConsole.exe')
		       displayString.
	process := OSWSWinProcess new.
	process
		command: exe;
		workingDirectory: imageByName value parent displayString;
		arguments: {
				'--headless'.
				imageByName value displayString.
				('eval [TITMetaLinksRealTimeTypeInferer gatherBaselineNamed: '''
				 , imageByName key
				 ,
					 '''] on: Error do: [:e|]. Smalltalk snapshot: false andQuit: true') };
		run.
	[ process isRunning ] whileTrue: [ 10 seconds wait ].
	Transcript crShow: index asString , ': Finished ' , imageByName key
]

{ #category : 'adding' }
TITMetaLinksRealTimeTypeInferer >> addLinksToMethod: aMethod [

	insertionVisitor visit: aMethod ast
]

{ #category : 'execution' }
TITMetaLinksRealTimeTypeInferer >> deleteWindowsExcept: originalWindows [

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
	BlOSWindowSDL2HostSpace allInstances do: [ :each | each close ]
]

{ #category : 'logging' }
TITMetaLinksRealTimeTypeInferer >> errorLog: anObject [

	self log: anObject.
	errorLogStream nextPutAll: anObject asString
]

{ #category : 'logging' }
TITMetaLinksRealTimeTypeInferer >> errorLogCrlf: anObject [

	self errorLog: anObject asString , String crlf.
	logStream flush.
	errorLogStream flush
]

{ #category : 'logging' }
TITMetaLinksRealTimeTypeInferer >> errorLogEntry: aString [

	self errorLogTime.
	self errorLogCrlf: aString asString.
	logStream flush.
	errorLogStream flush
]

{ #category : 'logging' }
TITMetaLinksRealTimeTypeInferer >> errorLogTime [

	self errorLog: self timestamp
]

{ #category : 'execution' }
TITMetaLinksRealTimeTypeInferer >> excludesTestClass: aTestClass [

	^ aTestClass = MorphicWindowManagerTest
]

{ #category : 'accessing' }
TITMetaLinksRealTimeTypeInferer >> executedPackages [

	^ executedPackages ifNil: [
			  executedPackages := TITDependentPackagesFinder
				                      forTypingPackages: gatheredPackages ]
]

{ #category : 'accessing' }
TITMetaLinksRealTimeTypeInferer >> executedPackages: aCollectionOfPackages [

	executedPackages := aCollectionOfPackages
]

{ #category : 'logging' }
TITMetaLinksRealTimeTypeInferer >> fileNameOfOfType: aString [

	(aString , '_' , self name , '.txt') inspect.
	^ aString , '_' , self name , '.txt'
]

{ #category : 'execution' }
TITMetaLinksRealTimeTypeInferer >> gatherTypes [

	[
		self installLinks.
		self runTestsAndExamples.
		self logResults ] ensure: [ self uninstallLinks ]
]

{ #category : 'accessing' }
TITMetaLinksRealTimeTypeInferer >> gatheredBaseline: aBaselineClass [

	self gatheredPackages: aBaselineClass version loadedSystemPackages
]

{ #category : 'accessing' }
TITMetaLinksRealTimeTypeInferer >> gatheredPackage: aPackage [

	self gatheredPackages: { aPackage }
]

{ #category : 'accessing' }
TITMetaLinksRealTimeTypeInferer >> gatheredPackages: aPackagesCollection [

	self initialize.
	gatheredPackages := aPackagesCollection copyWithoutAll:
		                    TITDependentPackagesFinder
			                    excludedPackagesForTypes
]

{ #category : 'initialization' }
TITMetaLinksRealTimeTypeInferer >> initialize [

	super initialize.
	logStream := NullStream new.
	errorLogStream := NullStream new.
	self initializeTypeHolders
]

{ #category : 'initialization' }
TITMetaLinksRealTimeTypeInferer >> initializeTypeHolders [

	variableTypes := Dictionary new.
	returnTypes := Dictionary new
]

{ #category : 'adding' }
TITMetaLinksRealTimeTypeInferer >> installLinks [

	| excludedSelectors |
	insertionVisitor ifNotNil: [ insertionVisitor uninstallAll ].
	insertionVisitor := TITMetaLinksInsertionVisitor new.
	insertionVisitor typeGatherer: self.

	excludedSelectors := TraitedMetaclass selectors asSet
	                     , TraitedClass selectors.

	[ :packageJob |
		packageJob max: gatheredPackages size.

		gatheredPackages withIndexDo: [ :eachPackage :packageIndex |
				packageJob title:
					'Installing MetaLinks in package ' , eachPackage name asString
					, ' ( ' , packageIndex asString , '/'
					, gatheredPackages size asString , ' )'.
				packageJob currentValue: packageIndex.

				eachPackage definedClasses do: [ :eachClass |
						eachClass methods , eachClass class methods
							reject: [ :any | excludedSelectors includes: any selector ]
							thenDo: [ :eachMethod | insertionVisitor visit: eachMethod ast ] ] ] ]
		asJob run
]

{ #category : 'logging' }
TITMetaLinksRealTimeTypeInferer >> log: anObject [

	logStream nextPutAll: anObject asString
]

{ #category : 'logging' }
TITMetaLinksRealTimeTypeInferer >> logCrlf: anObject [

	self log: anObject asString , String crlf.
	logStream flush
]

{ #category : 'logging' }
TITMetaLinksRealTimeTypeInferer >> logEntry: aString [

	self logTime.
	self logCrlf: aString asString.
	logStream flush
]

{ #category : 'logging' }
TITMetaLinksRealTimeTypeInferer >> logFileWithContent: aNameOfContent extension: anExtension [

	^ (self name , '_' , aNameOfContent , '.' , anExtension)
		  asFileReference
]

{ #category : 'logging' }
TITMetaLinksRealTimeTypeInferer >> logResults [

	self logResults: self variableTypesByNamesAsStrings as: 'VarTypes'.
	self logResults: self returnTypesByNamesAsStrings as: 'RetTypes'
]

{ #category : 'logging' }
TITMetaLinksRealTimeTypeInferer >> logResults: contents as: aContentTypeName [

	Smalltalk image isInteractiveGraphic ifTrue: [ contents inspect ].
	(self logFileWithContent: aContentTypeName extension: 'ston')
		ensureDelete;
		writeStreamDo: [ :s | STON put: contents onStreamPretty: s ]
]

{ #category : 'logging' }
TITMetaLinksRealTimeTypeInferer >> logTime [

	self log: self timestamp
]

{ #category : 'accessing' }
TITMetaLinksRealTimeTypeInferer >> name [

	^ name ifNil: [ 'realtime' ]
]

{ #category : 'accessing' }
TITMetaLinksRealTimeTypeInferer >> name: aString [

	name := aString
]

{ #category : 'accessing' }
TITMetaLinksRealTimeTypeInferer >> returnTypes [

	^ returnTypes
]

{ #category : 'accessing' }
TITMetaLinksRealTimeTypeInferer >> returnTypesByNames [

	^ (((returnTypes associations collect: [ :eachPair |
		     eachPair key selector -> eachPair value ]) groupedBy: [
		    :eachPair | eachPair key ]) collect: [ :eachArray |
			   eachArray
				   inject: TITEmptyTypeHolder new
				   into: [ :acc :each | acc , each value ] ]) collect: [ :each |
		  each mergeTypes ]
]

{ #category : 'accessing' }
TITMetaLinksRealTimeTypeInferer >> returnTypesByNamesAsStrings [

	^ self returnTypesByNames
		  do: [ :eachClass | eachClass convertTypesToString ];
		  yourself
]

{ #category : 'execution' }
TITMetaLinksRealTimeTypeInferer >> runExamples [

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

	self deleteWindowsExcept: originalWindows.

	self logEntry:
		'Executed ' , exampleMethods size asString , ' examples'.

	Smalltalk image isInteractiveGraphic ifFalse: [ ^ self ].
	self inform: 'Executed ' , exampleMethods size asString , ' examples'
]

{ #category : 'execution' }
TITMetaLinksRealTimeTypeInferer >> runTests [

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
		'Executed ' , testClasses size asString , ' test classes'.

	Smalltalk image isInteractiveGraphic ifFalse: [ ^ self ].
	testResult hasPassed ifTrue: [ ^ self ].

	self errorLogEntry:
		'Test errors: ' , testResult errorCount asString
		, ', Test failures: ' , testResult failureCount asString.
	GrowlMorph
		showTestResult: testResult
		with: (String streamContents: [ :s |
					 executedPackages size = 1
						 ifTrue: [ s nextPutAll: executedPackages anyOne name ]
						 ifFalse: [ executedPackages size asString , ' packages' ] ])
]

{ #category : 'execution' }
TITMetaLinksRealTimeTypeInferer >> runTestsAndExamples [

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

{ #category : 'visiting' }
TITMetaLinksRealTimeTypeInferer >> saveTypeOf: aValue in: aNode to: aDictionary [

	aNode ifNil: [ self error: 'Node cannot be nil' ].
	aDictionary
		at: aNode
		ifPresent: [ :currentHolder |
				thisContext mayBeInRecursion ifTrue: [
						^ self errorLogEntry:
							  'Did not save type because of potential recursion in '
							  , ((aNode method compiledMethod printString) ifEmpty: [ aNode asString ]) ].
				aDictionary at: aNode put: (currentHolder withValue: aValue) ]
		ifAbsentPut: [ TITAbstractTypeHolder newBestForValue: aValue ]
]

{ #category : 'visiting' }
TITMetaLinksRealTimeTypeInferer >> saveTypeOf: aValue inReturnOfMethod: aMethodNode [

	self saveTypeOf: aValue in: aMethodNode to: returnTypes
]

{ #category : 'visiting' }
TITMetaLinksRealTimeTypeInferer >> saveTypeOf: aValue inVariable: aVariableNode [

	| originalVariable |
	originalVariable := aVariableNode variable definingNode ifNil: [
			                    aVariableNode variable originalVar definingNode
				                    ifNil: [ aVariableNode variable ] ].
	self saveTypeOf: aValue in: originalVariable to: variableTypes
]

{ #category : 'logging' }
TITMetaLinksRealTimeTypeInferer >> timestamp [

	^ Time now print24 , ' | '
]

{ #category : 'execution' }
TITMetaLinksRealTimeTypeInferer >> uninstallLinks [

	insertionVisitor ifNil: [ ^ self ].
	insertionVisitor uninstallAll
]

{ #category : 'accessing' }
TITMetaLinksRealTimeTypeInferer >> variableTypes [

	^ variableTypes
]

{ #category : 'accessing' }
TITMetaLinksRealTimeTypeInferer >> variableTypesByNames [

	^ (((variableTypes associations collect: [ :eachPair |
		     eachPair key name -> eachPair value ]) groupedBy: [ :eachPair |
		    eachPair key ]) collect: [ :eachArray |
			   eachArray
				   inject: TITEmptyTypeHolder new
				   into: [ :acc :each | acc , each value ] ]) collect: [ :each |
		  each mergeTypes ]
]

{ #category : 'accessing' }
TITMetaLinksRealTimeTypeInferer >> variableTypesByNamesAsStrings [

	^ self variableTypesByNames
		  do: [ :eachClass | eachClass convertTypesToString ];
		  yourself
]
