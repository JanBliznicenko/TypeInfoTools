Class {
	#name : 'TITMetaLinksInsertionVisitor',
	#superclass : 'OCProgramNodeVisitor',
	#instVars : [
		'links',
		'typeGatherer'
	],
	#category : 'TypeInfoTools-RunTimeGatherer-Gathering',
	#package : 'TypeInfoTools-RunTimeGatherer',
	#tag : 'Gathering'
}

{ #category : 'visiting' }
TITMetaLinksInsertionVisitor >> executedAssignmentToClasswideVariableNamed: aSymbol value: anObject receiverClass: receiverClass executedMethodClass: executedMethodClass executedMethodSelector: aSelector originalImplementorClass: originalImplementorClass [

	typeGatherer
		saveTypeOf: anObject
		inVariableReference: (TITClasswideVariableReference
				 toOriginImplementorClass: originalImplementorClass
				 executedMethodClass: executedMethodClass
				 executedMethodSelector: aSelector
				 receiverClass: receiverClass
				 name: aSymbol)
]

{ #category : 'visiting' }
TITMetaLinksInsertionVisitor >> executedAssignmentToLocalVariableNamed: aSymbol value: anObject receiverClass: receiverClass executedMethodClass: executedMethodClass executedMethodSelector: aSelector originalImplementorClass: originalImplementorClass [

	typeGatherer
		saveTypeOf: anObject
		inVariableReference: (TITLocalVariableReference
				 toOriginImplementorClass: originalImplementorClass
				 executedMethodClass: executedMethodClass
				 executedMethodSelector: aSelector
				 receiverClass: receiverClass
				 name: aSymbol)
]

{ #category : 'visiting' }
TITMetaLinksInsertionVisitor >> executedMethodArguments: arguments names: argumentNames receiverClass: receiverClass executedMethodClass: executedMethodClass executedMethodSelector: aSelector [

	arguments withIndexDo: [ :eachArgument :index |
			self
				executedAssignmentToLocalVariableNamed: (argumentNames at: index)
				value: eachArgument
				receiverClass: receiverClass
				executedMethodClass: executedMethodClass
				executedMethodSelector: aSelector
				originalImplementorClass: executedMethodClass ]
]

{ #category : 'visiting' }
TITMetaLinksInsertionVisitor >> executedReturnFromSelector: aSymbol value: anObject receiverClass: receiverClass senderClass: aSenderClass executedMethodClass: executedMethodClass originalImplementorClass: originalImplementorClass [

	typeGatherer
		saveTypeOf: anObject
		inReturnReference: (TITMethodReference
				 toOriginImplementorClass: originalImplementorClass
				 executedMethodClass: executedMethodClass
				 receiverClass: receiverClass
				 senderClass: aSenderClass
				 name: aSymbol)
]

{ #category : 'initialization' }
TITMetaLinksInsertionVisitor >> initialize [

	super initialize.
	links := OrderedCollection new.
	typeGatherer := TITNoTypeGatherer new
]

{ #category : 'visiting' }
TITMetaLinksInsertionVisitor >> returnSelfCode [

	^ String cr , '	...^self'
]

{ #category : 'accessing' }
TITMetaLinksInsertionVisitor >> typeGatherer: anObject [

	typeGatherer := anObject
]

{ #category : 'cleanup' }
TITMetaLinksInsertionVisitor >> uninstallAll [

	links do: [ :each |
			each methods do: [ :eachMethod |
					| source |
					source := eachMethod sourceCode.
					eachMethod methodClass compile:
						((source endsWith: self returnSelfCode)
							 ifTrue: [ source allButLast: self returnSelfCode size ]
							 ifFalse: [ source ]) ] ].
	links removeAll
]

{ #category : 'visiting' }
TITMetaLinksInsertionVisitor >> visitAssignmentNode: anAssignmentNode [

	| varName link methodNode selector methodClass variableNode originalImplementorClass |
	methodNode := anAssignmentNode methodNode.
	selector := methodNode selector.
	methodClass := methodNode methodClass.
	variableNode := anAssignmentNode variable.
	varName := variableNode name asSymbol.
	originalImplementorClass := variableNode isGlobalVariable
		                            ifTrue: [ SystemEnvironment ]
		                            ifFalse: [
				                            variableNode isClassVariable
					                            ifTrue: [
					                            variableNode variable owningClass ]
					                            ifFalse: [ methodClass ] ].
	link := MetaLink new.
	link
		metaObject: [ :newValue :class |
				self
					executedAssignmentToClasswideVariableNamed: varName
					value: newValue
					receiverClass: class
					executedMethodClass: methodClass
					executedMethodSelector: selector
					originalImplementorClass: originalImplementorClass ];
		selector: #value:value:;
		arguments: #( newValue class );
		control: #before.
	links add: link.
	anAssignmentNode link: link.

	super visitAssignmentNode: anAssignmentNode
]

{ #category : 'visiting' }
TITMetaLinksInsertionVisitor >> visitMethodNode: aMethodNode [

	| link methodClass selector updatedMethodNode argumentNames |
	link := MetaLink new.
	methodClass := aMethodNode methodClass.
	selector := aMethodNode selector.
	updatedMethodNode := aMethodNode.
	aMethodNode lastIsReturn ifFalse: [
			methodClass compile: aMethodNode sourceCode , self returnSelfCode.
			updatedMethodNode := (methodClass >> selector) ast ].
	argumentNames := updatedMethodNode arguments collect: [ :each |
		                 each name asSymbol ].

	link
		metaObject: [ :receiver :arguments |
				self
					executedMethodArguments: arguments
					names: argumentNames
					receiverClass: receiver class
					executedMethodClass: methodClass
					executedMethodSelector: selector ];
		selector: #value:value:;
		arguments: #( receiver arguments );
		control: #before.

	links add: link.
	updatedMethodNode link: link.

	super visitMethodNode: updatedMethodNode
]

{ #category : 'visiting' }
TITMetaLinksInsertionVisitor >> visitReturnNode: aReturnNode [

	| link methodNode methodClass selector originalImplementorClass |
	methodNode := aReturnNode methodNode.
	selector := methodNode selector.
	methodClass := methodNode methodClass.
	originalImplementorClass := methodClass withAllSuperclasses reversed
		                            detect: [ :any |
		                            any includesSelector: selector ].
	link := MetaLink new.
	link
		metaObject: [ :value :class :context | 
				self
					executedReturnFromSelector: selector
					value: value
					receiverClass: class
					senderClass: context sender methodClass
					executedMethodClass: methodClass
					originalImplementorClass: originalImplementorClass ];
		selector: #value:value:value:;
		arguments: #( value class context );
		control: #before.
	links add: link.
	aReturnNode link: link.
	super visitReturnNode: aReturnNode
]
