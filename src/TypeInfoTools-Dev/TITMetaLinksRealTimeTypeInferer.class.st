Class {
	#name : 'TITMetaLinksRealTimeTypeInferer',
	#superclass : 'TITTestsAndExamplesRunner',
	#instVars : [
		'insertionVisitor',
		'variableTypes',
		'returnTypes'
	],
	#category : 'TypeInfoTools-Dev-RealTime',
	#package : 'TypeInfoTools-Dev',
	#tag : 'RealTime'
}

{ #category : 'examples' }
TITMetaLinksRealTimeTypeInferer class >> example [

	super example
]

{ #category : 'examples' }
TITMetaLinksRealTimeTypeInferer class >> runBaselinesInSeparateProcesses [

	<script>
	super runBaselinesInSeparateProcesses
]

{ #category : 'adding' }
TITMetaLinksRealTimeTypeInferer >> addLinksToMethod: aMethod [

	insertionVisitor visit: aMethod ast
]

{ #category : 'execution' }
TITMetaLinksRealTimeTypeInferer >> execute [

	[
		self installLinks.
		self runTestsAndExamples.
		self logResults ] ensure: [ self uninstallLinks ]
]

{ #category : 'initialization' }
TITMetaLinksRealTimeTypeInferer >> initialize [

	super initialize.
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

{ #category : 'accessing' }
TITMetaLinksRealTimeTypeInferer >> returnTypes [

	^ returnTypes
]

{ #category : 'accessing' }
TITMetaLinksRealTimeTypeInferer >> returnTypesByNames [

	^ ((returnTypes associations groupedBy: [ :eachPair |
		    eachPair key value ]) collect: [ :eachArray |
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

{ #category : 'visiting' }
TITMetaLinksRealTimeTypeInferer >> saveTypeOf: aValue in: anItem to: aDictionary [

	aDictionary
		at: anItem
		ifPresent: [ :currentHolder |
				thisContext mayBeInRecursion ifTrue: [
						^ self errorLogEntry:
							  'Did not save type because of potential recursion related to '
							  , (anItem printString ifEmpty: [ anItem asString ]) ].
				aDictionary at: anItem put: (currentHolder withValue: aValue) ]
		ifAbsentPut: [ TITAbstractTypeHolder newBestForValue: aValue ]
]

{ #category : 'visiting' }
TITMetaLinksRealTimeTypeInferer >> saveTypeOf: aValue inReturnOfMethod: aMethodNode [

	| key |
	key := aMethodNode compiledMethod methodClass -> aMethodNode selector.
	self saveTypeOf: aValue in: key to: returnTypes
]

{ #category : 'visiting' }
TITMetaLinksRealTimeTypeInferer >> saveTypeOf: aValue inVariable: aVariableNode [

	| key |
	key := aVariableNode methodNode compiledMethod methodClass
	       -> aVariableNode name.
	self saveTypeOf: aValue in: key to: variableTypes
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

	^ ((variableTypes associations groupedBy: [ :eachPair |
		    eachPair key value ]) collect: [ :eachArray |
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
