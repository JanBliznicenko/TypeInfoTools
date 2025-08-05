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
TITSpecificTypeNodeWithOrigins >> = otherNode [

	^ self type = otherNode type
]

{ #category : 'querying' }
TITSpecificTypeNodeWithOrigins >> allChildOrigins [

	^ childNodes flatCollectAsSet: [ :each | each allOrigins ]
]

{ #category : 'accessing' }
TITSpecificTypeNodeWithOrigins >> atTypeHierarchy: aClassHierarchy addOrigins: aCollectionOfClasses [

	| directSubclass subclassNode |
	aClassHierarchy ifEmpty: [ ^ self addOrigins: aCollectionOfClasses ].
	directSubclass := aClassHierarchy last.
	subclassNode := childNodes
		                at: directSubclass
		                ifAbsentPut: [ self class withType: directSubclass ].
	^ subclassNode
		  atTypeHierarchy: aClassHierarchy allButLast
		  addOrigins: aCollectionOfClasses
]

{ #category : 'accessing' }
TITSpecificTypeNodeWithOrigins >> childNodes [

	^ childNodes values
]

{ #category : 'accessing' }
TITSpecificTypeNodeWithOrigins >> forType: aType addOrigins: aCollectionOfClasses [

	^ self
		  atTypeHierarchy: aType withAllSuperclasses
		  addOrigins: aCollectionOfClasses
]

{ #category : 'comparing' }
TITSpecificTypeNodeWithOrigins >> hash [

	^ self type hash
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
