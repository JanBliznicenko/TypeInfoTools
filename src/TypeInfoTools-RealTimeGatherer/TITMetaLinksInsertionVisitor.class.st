Class {
	#name : 'TITMetaLinksInsertionVisitor',
	#superclass : 'OCProgramNodeVisitor',
	#instVars : [
		'links',
		'typeGatherer'
	],
	#category : 'TypeInfoTools-RealTimeGatherer-Gathering',
	#package : 'TypeInfoTools-RealTimeGatherer',
	#tag : 'Gathering'
}

{ #category : 'initialization' }
TITMetaLinksInsertionVisitor >> initialize [

	super initialize.
	links := OrderedCollection new.
	typeGatherer := TITNoTypeGatherer new
]

{ #category : 'visiting' }
TITMetaLinksInsertionVisitor >> returnSelfCode [

	^ String cr , ' ...^self'
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

	| link |
	link := MetaLink new.
	link
		metaObject: [ :newValue :class |
				typeGatherer
					saveTypeOf: newValue
					inVariableNamed: anAssignmentNode variable name asSymbol
					receiverClass: class ];
		selector: #value:value:;
		arguments: #( newValue class );
		control: #before.
	links add: link.
	anAssignmentNode link: link.

	super visitAssignmentNode: anAssignmentNode
]

{ #category : 'visiting' }
TITMetaLinksInsertionVisitor >> visitMethodNode: aMethodNode [

	| selector link returnSelfBlock updatedNode |
	selector := aMethodNode selector.
	updatedNode := aMethodNode.
	aMethodNode lastIsReturn ifFalse: [
			| methodClass |
			methodClass := aMethodNode methodClass.
			methodClass compile: aMethodNode sourceCode , self returnSelfCode.
			updatedNode := (methodClass >> selector) ast ].

	link := MetaLink new.
	returnSelfBlock := updatedNode lastIsReturn
		                   ifTrue: [ [ :receiver |  ] ]
		                   ifFalse: [
				                   [ :receiver |
					                   typeGatherer
						                   saveTypeOf: receiver
						                   inReturnOfSelector: selector
						                   receiverClass: receiver class ] ].
	link
		metaObject: [ :receiver :arguments |
				returnSelfBlock value: receiver.
				arguments withIndexDo: [ :eachArgument :index |
							typeGatherer
								saveTypeOf: eachArgument
								inVariableNamed:
									(updatedNode arguments at: index) name asSymbol
								receiverClass: receiver class ] ];
		selector: #value:value:;
		arguments: #( receiver arguments );
		control: #before.
	links add: link.
	updatedNode link: link.

	super visitMethodNode: aMethodNode
]

{ #category : 'visiting' }
TITMetaLinksInsertionVisitor >> visitReturnNode: aReturnNode [

	| link |
	link := MetaLink new.
	link
		metaObject: [ :value :class |
				typeGatherer
					saveTypeOf: value
					inReturnOfSelector: aReturnNode methodNode selector
					receiverClass: class ];
		selector: #value:value:;
		arguments: #( value class );
		control: #before.
	links add: link.
	aReturnNode link: link.
	super visitReturnNode: aReturnNode
]
