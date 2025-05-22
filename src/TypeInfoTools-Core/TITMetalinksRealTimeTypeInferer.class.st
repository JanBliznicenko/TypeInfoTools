Class {
	#name : 'TITMetaLinksRealTimeTypeInferer',
	#superclass : 'Object',
	#instVars : [
		'package',
		'packagesPattern',
		'insertionVisitor',
		'types'
	],
	#category : 'TypeInfoTools-Core-RealTime',
	#package : 'TypeInfoTools-Core',
	#tag : 'RealTime'
}

{ #category : 'examples' }
TITMetaLinksRealTimeTypeInferer class >> example [

	| package inferer types |
	package := self packageOrganizer packageNamed: 'TITMyClass'.
	inferer := TITMetaLinksRealTimeTypeInferer new.

	inferer package: package.
	inferer installLinks.
	inferer runTestsAndExamples.
	inferer uninstallLinks.
	types := inferer gatherTypes.
	types inspect
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

{ #category : 'as yet unclassified' }
TITMetaLinksRealTimeTypeInferer >> gatherTypes [

	^ types
]

{ #category : 'initialization' }
TITMetaLinksRealTimeTypeInferer >> initialize [

	super initialize.
	types := Dictionary new
]

{ #category : 'adding' }
TITMetaLinksRealTimeTypeInferer >> installLinks [

	| definedClasses |
	insertionVisitor ifNotNil: [ insertionVisitor uninstallAll ].
	insertionVisitor := TITMetaLinksInsertionVisitor new.
	insertionVisitor typeBlock: [ :node :value |
		self saveTypeOf: value to: node ].

	definedClasses := package definedClasses.
	definedClasses , (definedClasses collect: #class) do: [ :eachClass |
			eachClass methodsDo: [ :eachMethod |
				insertionVisitor visit: eachMethod ast ] ]
]

{ #category : 'accessing' }
TITMetaLinksRealTimeTypeInferer >> package: aPackage [

	package := aPackage.
	packagesPattern := nil.
	types := Dictionary new
]

{ #category : 'accessing' }
TITMetaLinksRealTimeTypeInferer >> packagesPattern [

	^ packagesPattern ifNil: [ '.*' , (package name copyUpTo: $-) , '.*' ]
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
TITMetaLinksRealTimeTypeInferer >> saveTypeOf: aValue to: aNode [

	types
		at: aNode
		ifPresent: [ :currentHolder |
			types at: aNode put: (currentHolder withValue: aValue) ]
		ifAbsentPut: [ TITAbstractTypeHolder newBestForValue: aValue ]
]

{ #category : 'as yet unclassified' }
TITMetaLinksRealTimeTypeInferer >> uninstallLinks [

	insertionVisitor uninstallAll
]

{ #category : 'as yet unclassified' }
TITMetaLinksRealTimeTypeInferer >> visitAllBy: aVisitor [

	| definedClasses |
	definedClasses := package definedClasses.
	definedClasses , (definedClasses collect: #class) do: [ :eachClass |
		eachClass methodsDo: [ :eachMethod | aVisitor visit: eachMethod ast ] ]
]
