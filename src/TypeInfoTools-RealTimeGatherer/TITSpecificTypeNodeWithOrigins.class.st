Class {
	#name : 'TITSpecificTypeNodeWithOrigins',
	#superclass : 'TITSubtreeNodeWithOrigins',
	#instVars : [
		'type'
	],
	#category : 'TypeInfoTools-RealTimeGatherer-Processing',
	#package : 'TypeInfoTools-RealTimeGatherer',
	#tag : 'Processing'
}

{ #category : 'instance creation' }
TITSpecificTypeNodeWithOrigins class >> newRoot [

	^ self withType: nil
]

{ #category : 'instance creation' }
TITSpecificTypeNodeWithOrigins class >> withType: aClass [

	^ self new
		  type: aClass;
		  yourself
]

{ #category : 'comparing' }
TITSpecificTypeNodeWithOrigins >> = anObject [
	"Answer whether the receiver and anObject represent the same object."

	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	^ type = anObject type
]

{ #category : 'accessing' }
TITSpecificTypeNodeWithOrigins >> atTypeHierarchy: aClassHierarchy addOrigins: aRefAndReceiverClasses [

	| directSubclass subclassNode |
	aClassHierarchy ifEmpty: [ ^ self addaRefAndReceiverClasses: aRefAndReceiverClasses ].
	directSubclass := aClassHierarchy last.
	subclassNode := childNodes
		                at: directSubclass
		                ifAbsentPut: [ self class withType: directSubclass ].
	^ subclassNode
		  atTypeHierarchy: aClassHierarchy allButLast
		  addOrigins: aRefAndReceiverClasses
]

{ #category : 'accessing' }
TITSpecificTypeNodeWithOrigins >> childNodes [

	^ childNodes values
]

{ #category : 'accessing' }
TITSpecificTypeNodeWithOrigins >> forType: aType addRefAndReceiverClasses: aRefAndReceiverClasses [

	^ self
		  atTypeHierarchy: aType withAllSuperclasses
		  addOrigins: aRefAndReceiverClasses
]

{ #category : 'comparing' }
TITSpecificTypeNodeWithOrigins >> hash [
	"Answer an integer value that is related to the identity of the receiver."

	^ type hash
]

{ #category : 'initialization' }
TITSpecificTypeNodeWithOrigins >> initialize [

	super initialize.
	childNodes := Dictionary new.
]

{ #category : 'testing' }
TITSpecificTypeNodeWithOrigins >> isAcceptableMostPreciseNode [

	^ ({
		   Object.
		   ProtoObject.
		   UndefinedObject.
		   nil } includes: type) not
]

{ #category : 'accessing' }
TITSpecificTypeNodeWithOrigins >> name [

	^ type name
]

{ #category : 'accessing' }
TITSpecificTypeNodeWithOrigins >> type [

	^ type
]

{ #category : 'accessing' }
TITSpecificTypeNodeWithOrigins >> type: anObject [

	type := anObject
]
