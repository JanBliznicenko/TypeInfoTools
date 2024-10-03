Class {
	#name : 'TITTypeInfo',
	#superclass : 'Object',
	#instVars : [
		'#node => ToOneRelationSlot inverse: #typeInfo inClass: #TITTypedNode',
		'#types',
		'#collectionElementTypes'
	],
	#category : 'TypeInfoTools-Inference',
	#package : 'TypeInfoTools',
	#tag : 'Inference'
}

{ #category : 'adding' }
TITTypeInfo >> addCollectionElementTypes: aClassCollection by: aTypeCollector [

	collectionElementTypes addClasses: aClassCollection by: aTypeCollector
]

{ #category : 'adding' }
TITTypeInfo >> addTypes: aClassCollection by: aTypeCollector [

	types addClasses: aClassCollection by: aTypeCollector
]

{ #category : 'accessing' }
TITTypeInfo >> collectionElementTypes [

	^ collectionElementTypes
]

{ #category : 'initialization' }
TITTypeInfo >> initialize [

	super initialize.
	types := TITTypesCollection forTypeInfo: self.
	collectionElementTypes := TITTypesCollection forTypeInfo: self
]

{ #category : 'testing' }
TITTypeInfo >> isEmpty [

	^ self types isEmpty and: [ self collectionElementTypes isEmpty ]
]

{ #category : 'accessing' }
TITTypeInfo >> node [

	^ node
]

{ #category : 'accessing' }
TITTypeInfo >> node: anObject [

	node := anObject
]

{ #category : 'adding' }
TITTypeInfo >> prioritizedClasses: aCollection [

	types prioritizedClasses: aCollection.
	collectionElementTypes prioritizedClasses: aCollection
]

{ #category : 'adding' }
TITTypeInfo >> setOrIntersectWithPrioritizedClasses: aCollection [ 

	types setOrIntersectWithPrioritizedClasses: aCollection.
	collectionElementTypes setOrIntersectWithPrioritizedClasses: aCollection
]

{ #category : 'accessing' }
TITTypeInfo >> types [

	^ types
]
