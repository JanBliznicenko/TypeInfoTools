Class {
	#name : 'TITMetaLinksInsertionVisitor',
	#superclass : 'OCProgramNodeVisitor',
	#instVars : [
		'links',
		'typeGatherer'
	],
	#category : 'TypeInfoTools-Core-RealTime',
	#package : 'TypeInfoTools-Core',
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

	| link |
	link := MetaLink new.
	link
		metaObject: [ :returnedValue |
				typeGatherer saveTypeOf: returnedValue inMessage: aMessageNode  ];
		selector: #value:;
		arguments: #( value );
		control: #after.
	links add: link.
	aMessageNode link: link.

	super visitMessageNode: aMessageNode
]

{ #category : 'visiting' }
TITMetaLinksInsertionVisitor >> visitMethodNode: aMethodNode [
	"| link |
	link := MetaLink new.
	link
		metaObject: [ :arguments :value |
				arguments withIndexDo: [ :eachArgument :index |
					typeGatherer
					saveTypeOf: eachArgument
					inVariable: (aMethodNode arguments at: index)
						 ].
				typeGatherer
					saveTypeOf: value
					inReturnOfMethod: aMethodNode ];
		selector: #value:value:;
		arguments: #( arguments value );
		control: #after.
	links add: link.
	aMethodNode link: link."

	super visitMethodNode: aMethodNode
]
