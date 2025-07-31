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
		metaObject: [ :newValue |
				typeGatherer
					saveTypeOf: newValue
					inVariable: anAssignmentNode variable ];
		selector: #value:;
		arguments: #( newValue );
		control: #before.
	links add: link.
	anAssignmentNode link: link.

	super visitAssignmentNode: anAssignmentNode
]

{ #category : 'visiting' }
TITMetaLinksInsertionVisitor >> visitMethodNode: aMethodNode [

	| link returnSelfBlock updatedNode |
	updatedNode := aMethodNode.
	aMethodNode lastIsReturn ifFalse: [
			| selector class |
			selector := aMethodNode selector.
			class := aMethodNode methodClass.
			class compile: aMethodNode sourceCode , self returnSelfCode.
			updatedNode := (class >> selector) ast ].

	link := MetaLink new.
	returnSelfBlock := updatedNode lastIsReturn
		                   ifTrue: [ [ :receiver |  ] ]
		                   ifFalse: [
				                   [ :receiver |
				                   typeGatherer
					                   saveTypeOf: receiver
					                   inReturnOfMethod: updatedNode ] ].
	link
		metaObject: [ :receiver :arguments |
				returnSelfBlock value: receiver.
				arguments withIndexDo: [ :eachArgument :index |
							typeGatherer
								saveTypeOf: eachArgument
								inVariable: (updatedNode arguments at: index) ] ];
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
		metaObject: [ :value |
				typeGatherer
					saveTypeOf: value
					inReturnOfMethod: aReturnNode methodNode ];
		selector: #value:;
		arguments: #( value );
		control: #before.
	links add: link.
	aReturnNode link: link.

	super visitReturnNode: aReturnNode
]
