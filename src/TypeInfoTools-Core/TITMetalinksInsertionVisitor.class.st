Class {
	#name : 'TITMetaLinksInsertionVisitor',
	#superclass : 'OCProgramNodeVisitor',
	#instVars : [
		'links',
		'typeBlock'
	],
	#category : 'TypeInfoTools-Core-RealTime',
	#package : 'TypeInfoTools-Core',
	#tag : 'RealTime'
}

{ #category : 'initialization' }
TITMetaLinksInsertionVisitor >> initialize [

	super initialize.
	links := OrderedCollection new.
	typeBlock := [ :node :value | Transcript crShow: value asString ]
]

{ #category : 'visiting' }
TITMetaLinksInsertionVisitor >> saveTypeOf: aValue to: aNode [

	typeBlock value: aNode value: aValue
]

{ #category : 'accessing' }
TITMetaLinksInsertionVisitor >> typeBlock: aBlockClosure [

	typeBlock := aBlockClosure
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
		metaObject: [ :value :newValue |
				self saveTypeOf: value to: anAssignmentNode receiver ];
		selector: #value:value:;
		arguments: #( value newValue );
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
				self saveTypeOf: returnedValue to: aMessageNode ];
		selector: #value:;
		arguments: #( value );
		control: #after.
	links add: link.
	aMessageNode link: link.

	super visitMessageNode: aMessageNode
]

{ #category : 'visiting' }
TITMetaLinksInsertionVisitor >> visitMethodNode: aMethodNode [

	| link |
	link := MetaLink new.
	link
		metaObject: [ :arguments :value |
				arguments withIndexDo: [ :eachArgument :index |
						self
							saveTypeOf: eachArgument
							to: (aMethodNode arguments at: index) ].
				self saveTypeOf: value to: aMethodNode ];
		selector: #value:value:value:;
		arguments: #( arguments value );
		control: #after.
	links add: link.
	aMethodNode link: link.

	super visitMethodNode: aMethodNode
]
