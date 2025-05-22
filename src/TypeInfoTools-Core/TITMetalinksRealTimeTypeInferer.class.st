Class {
	#name : 'TITMetaLinksRealTimeTypeInferer',
	#superclass : 'Object',
	#instVars : [
		'package',
		'packagesPattern',
		'insertionVisitor',
		'variableTypes',
		'messageTypes',
		'returnTypes'
	],
	#category : 'TypeInfoTools-Core-RealTime',
	#package : 'TypeInfoTools-Core',
	#tag : 'RealTime'
}

{ #category : 'examples' }
TITMetaLinksRealTimeTypeInferer class >> example [

	| package inferer |
	
	
	package := self packageOrganizer packageNamed: 'Zinc-HTTP'.
	inferer := TITMetaLinksRealTimeTypeInferer new.

	inferer package: package.
	inferer installLinks.
	inferer runTestsAndExamples.
	inferer uninstallLinks.
	inferer variableTypesByNames inspect
]

{ #category : 'adding' }
TITMetaLinksRealTimeTypeInferer >> addLinksToMethod: aMethod [

	insertionVisitor visit: aMethod ast
]

{ #category : 'accessing' }
TITMetaLinksRealTimeTypeInferer >> ensurePackagesPattern [

	packagesPattern ifNotNil: [ ^ self ].
	packagesPattern := '.*' , (package name copyUpTo: $-) , '.*'
]

{ #category : 'initialization' }
TITMetaLinksRealTimeTypeInferer >> initialize [

	super initialize.
	self initializeTypeHolders
]

{ #category : 'initialization' }
TITMetaLinksRealTimeTypeInferer >> initializeTypeHolders [

	variableTypes := Dictionary new.
	messageTypes := Dictionary new.
	returnTypes := Dictionary new
]

{ #category : 'adding' }
TITMetaLinksRealTimeTypeInferer >> installLinks [

	| definedClasses |
	insertionVisitor ifNotNil: [ insertionVisitor uninstallAll ].
	insertionVisitor := TITMetaLinksInsertionVisitor new.
	insertionVisitor typeGatherer: self.

	definedClasses := package definedClasses.
	definedClasses , (definedClasses collect: #class) do: [ :eachClass |
			eachClass methodsDo: [ :eachMethod |
				insertionVisitor visit: eachMethod ast ] ]
]

{ #category : 'accessing' }
TITMetaLinksRealTimeTypeInferer >> messageTypes [

	^ messageTypes
]

{ #category : 'accessing' }
TITMetaLinksRealTimeTypeInferer >> package: aPackage [

	self initialize.
	package := aPackage.
	packagesPattern := nil
]

{ #category : 'accessing' }
TITMetaLinksRealTimeTypeInferer >> packagesPattern [

	^ packagesPattern ifNil: [ '.*' , (package name copyUpTo: $-) , '.*' ]
]

{ #category : 'accessing' }
TITMetaLinksRealTimeTypeInferer >> packagesPattern: aString [

	packagesPattern := aString
]

{ #category : 'accessing' }
TITMetaLinksRealTimeTypeInferer >> returnTypes [

	^ returnTypes
]

{ #category : 'execution' }
TITMetaLinksRealTimeTypeInferer >> runExamples [

	| packages exampleMethods |
	self ensurePackagesPattern.

	packages := self packageOrganizer packages select: [ :eachPackage |
		            eachPackage name matchesRegex: packagesPattern ].
	packages ifEmpty: [
		self error: 'There is no package matching ' , packagesPattern ].


	exampleMethods := packages flatCollectAsSet: [ :eachPackage |
			                  eachPackage definedClasses flatCollect: [ :eachClass |
					                  eachClass class methods select: [ :eachMethod |
						                  ClyExampleScript isImplementedByMethod:
							                  eachMethod ] ] ].

	exampleMethods do: [ :each |
			| originalWindows windowsToDelete |
			originalWindows := Smalltalk currentWorld systemWindows asSet.
			each
				valueWithReceiver: each classBinding value instanceSide
				arguments: #(  ).
			windowsToDelete := Smalltalk currentWorld systemWindows asSet
				                   difference: originalWindows.
			[
				10 seconds wait.
				windowsToDelete do: #delete ]
				forkAt: Processor userBackgroundPriority
				named: 'Example windows deletion' ].

	exampleMethods ifNotEmpty: [
		self inform:
			'Executed ' , exampleMethods size asString , ' examples' ]
]

{ #category : 'execution' }
TITMetaLinksRealTimeTypeInferer >> runTests [

	| packages testClasses testResult |
	TestCase defaultTimeLimit: 1 minute.
	
	self ensurePackagesPattern.
	packages := self packageOrganizer packages select: [ :eachPackage |
		            eachPackage name matchesRegex: packagesPattern ].
	packages ifEmpty: [
		self error: 'There is no package matching ' , packagesPattern ].

	testClasses := packages flatCollectAsSet: [ :eachPackage |
			               eachPackage definedClasses select: [ :each |
				               each isTestCase and: [ each isAbstract not ] ] ].

testResult := 	testClasses
		ifEmpty: [ TestAsserter classForTestResult new ]
		ifNotEmpty: [
		 testClasses anyOne classForTestResult new ].

	testClasses do: [ :each |
			each resetHistory.
			each suite run: testResult ].
	testResult updateResultsInHistory.

	GrowlMorph
		showTestResult: testResult
		with: (String streamContents: [ :s |
					 packages
						 do: [ :each | s nextPutAll: each name ]
						 separatedBy: [ s nextPutAll: ', ' ] ])
]

{ #category : 'execution' }
TITMetaLinksRealTimeTypeInferer >> runTestsAndExamples [

	self
		runTests;
		runExamples
]

{ #category : 'visiting' }
TITMetaLinksRealTimeTypeInferer >> saveTypeOf: aValue in: aNode to: aDictionary [

	aNode ifNil: [ self error: 'Node cannot be nil' ].
	aDictionary
		at: aNode
		ifPresent: [ :currentHolder |
			aDictionary at: aNode put: (currentHolder withValue: aValue) ]
		ifAbsentPut: [ TITAbstractTypeHolder newBestForValue: aValue ]
]

{ #category : 'visiting' }
TITMetaLinksRealTimeTypeInferer >> saveTypeOf: aValue inMessage: aMessageNode [

	self saveTypeOf: aValue in: aMessageNode to: messageTypes
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

{ #category : 'execution' }
TITMetaLinksRealTimeTypeInferer >> uninstallLinks [

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

{ #category : 'visiting' }
TITMetaLinksRealTimeTypeInferer >> visitAllBy: aVisitor [

	| definedClasses |
	definedClasses := package definedClasses.
	definedClasses , (definedClasses collect: #class) do: [ :eachClass |
		eachClass methodsDo: [ :eachMethod | aVisitor visit: eachMethod ast ] ]
]
