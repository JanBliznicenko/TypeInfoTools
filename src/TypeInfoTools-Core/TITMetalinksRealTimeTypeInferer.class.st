Class {
	#name : 'TITMetaLinksRealTimeTypeInferer',
	#superclass : 'Object',
	#instVars : [
		'package',
		'packagesPattern',
		'insertionVisitor',
		'variableTypes',
		'messageTypes',
		'parameterTypes',
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
	variableTypes := IdentityDictionary new.
	messageTypes := IdentityDictionary new.
	parameterTypes := IdentityDictionary new.
	returnTypes := IdentityDictionary new
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
TITMetaLinksRealTimeTypeInferer >> parameterTypes [

	^ parameterTypes
]

{ #category : 'accessing' }
TITMetaLinksRealTimeTypeInferer >> returnTypes [

	^ returnTypes
]

{ #category : 'as yet unclassified' }
TITMetaLinksRealTimeTypeInferer >> runExamples [

	| packages exampleMethods |
	self ensurePackagesPattern.

	packages := self packageOrganizer packages select: [ :eachPackage |
		            eachPackage name matchesRegex: packagesPattern ].
	packages ifEmpty: [
		self error: 'There is no package matching ' , packagesPattern ].


	exampleMethods := packages flatCollectAsSet: [ :eachPackage |
			                  eachPackage classes flatCollect: [ :eachClass |
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

{ #category : 'private' }
TITMetaLinksRealTimeTypeInferer >> runTests [

	| packages testClasses testResult |
	TestCase defaultTimeLimit: 1 minute.
	
	self ensurePackagesPattern.
	packages := self packageOrganizer packages select: [ :eachPackage |
		            eachPackage name matchesRegex: packagesPattern ].
	packages ifEmpty: [
		self error: 'There is no package matching ' , packagesPattern ].

	testClasses := packages flatCollectAsSet: [ :eachPackage |
			               eachPackage classes select: [ :each |
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

{ #category : 'as yet unclassified' }
TITMetaLinksRealTimeTypeInferer >> runTestsAndExamples [

	self
		runTests;
		runExamples
]

{ #category : 'visiting' }
TITMetaLinksRealTimeTypeInferer >> saveTypeOf: aValue in: aNode to: aDictionary [

	aDictionary
		at: aNode
		ifPresent: [ :currentHolder |
			aDictionary at: aNode put: (currentHolder withValue: aValue) ]
		ifAbsentPut: [ TITAbstractTypeHolder newBestForValue: aValue ]
]

{ #category : 'visiting' }
TITMetaLinksRealTimeTypeInferer >> saveTypeOf: aValue inMessage: aMessageSendNode [

	self saveTypeOf: aValue in: aMessageSendNode to: messageTypes
]

{ #category : 'visiting' }
TITMetaLinksRealTimeTypeInferer >> saveTypeOf: aValue inReturnOfMethod: aMethodNode [

	self saveTypeOf: aValue in: aMethodNode to: returnTypes
]

{ #category : 'visiting' }
TITMetaLinksRealTimeTypeInferer >> saveTypeOf: aValue inVariable: aVariableNode [

	self saveTypeOf: aValue in: aVariableNode to: variableTypes
]

{ #category : 'as yet unclassified' }
TITMetaLinksRealTimeTypeInferer >> uninstallLinks [

	insertionVisitor uninstallAll
]

{ #category : 'accessing' }
TITMetaLinksRealTimeTypeInferer >> variableTypes [

	^ variableTypes
]

{ #category : 'as yet unclassified' }
TITMetaLinksRealTimeTypeInferer >> variableTypesByNames [

	^ (((variableTypes associations collect: [ :eachPair |
		     eachPair key name -> eachPair value ]) groupedBy: [ :eachPair |
		    eachPair key ]) collect: [ :eachArray |
			   eachArray
				   inject: TITEmptyTypeHolder new
				   into: [ :acc :each | acc , each value ] ]) collect: [ :each |
		  each mergeTypes ]
]

{ #category : 'visiting' }
TITMetaLinksRealTimeTypeInferer >> visitAllBy: aVisitor [

	| definedClasses |
	definedClasses := package definedClasses.
	definedClasses , (definedClasses collect: #class) do: [ :eachClass |
		eachClass methodsDo: [ :eachMethod | aVisitor visit: eachMethod ast ] ]
]
