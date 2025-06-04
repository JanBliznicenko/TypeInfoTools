Class {
	#name : 'TITMetaLinksInsertionVisitor',
	#superclass : 'OCProgramNodeVisitor',
	#instVars : [
		'links',
		'typeGatherer'
	],
	#category : 'TypeInfoTools-Dev-RealTime',
	#package : 'TypeInfoTools-Dev',
	#tag : 'RealTime'
}

{ #category : 'initialization' }
TITMetaLinksInsertionVisitor >> initialize [

	super initialize.
	links := OrderedCollection new
]

{ #category : 'accessing' }
TITMetaLinksInsertionVisitor >> typeGatherer: anObject [

	typeGatherer := anObject
]

{ #category : 'cleanup' }
TITMetaLinksInsertionVisitor >> uninstallAll [

	links
		do: [ :eachLink | eachLink uninstall ];
		removeAll
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
TITMetaLinksInsertionVisitor >> visitMessageNode: aMessageNode [

	"| link |
	link := MetaLink new.
	link
		metaObject: [ :returnedValue |
				typeGatherer saveTypeOf: returnedValue inMessage: aMessageNode  ];
		selector: #value:;
		arguments: #( value );
		control: #after.
	links add: link.
	aMessageNode link: link."

	super visitMessageNode: aMessageNode
]

{ #category : 'visiting' }
TITMetaLinksInsertionVisitor >> visitMethodNode: aMethodNode [

	| link returnSelfBlock |
	aMethodNode addSelfReturn.
	
	link := MetaLink new.
	returnSelfBlock := aMethodNode lastIsReturn
		                   ifTrue: [ [ :receiver |  ] ]
		                   ifFalse: [
				                   [ :receiver |
				                   typeGatherer
					                   saveTypeOf: receiver
					                   inReturnOfMethod: aMethodNode ] ].
	link
		metaObject: [ :receiver :arguments |
				returnSelfBlock value: receiver.
				arguments withIndexDo: [ :eachArgument :index |
							typeGatherer
								saveTypeOf: eachArgument
								inVariable: (aMethodNode arguments at: index) ] ];
		selector: #value:value:;
		arguments: #( receiver arguments );
		control: #before.
	links add: link.
	aMethodNode link: link.

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
