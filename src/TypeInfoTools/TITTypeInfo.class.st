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
TITTypeInfo >> addCollectionElementType: aClass [

	collectionElementTypes add: aClass
]

{ #category : 'adding' }
TITTypeInfo >> addCollectionElementTypes: aClassCollection [

	collectionElementTypes addAll: aClassCollection
]

{ #category : 'adding' }
TITTypeInfo >> addType: aClass [

	types add: aClass
]

{ #category : 'adding' }
TITTypeInfo >> addTypes: aClassCollection [

	types addAll: aClassCollection
]

{ #category : 'accessing' }
TITTypeInfo >> collectionElementTypes [

	^ collectionElementTypes
]

{ #category : 'accessing' }
TITTypeInfo >> collectionElementTypes: anObject [

	collectionElementTypes := anObject
]

{ #category : 'initialization' }
TITTypeInfo >> initialize [

	super initialize.
	types := TITTypesCollection new.
	collectionElementTypes := TITTypesCollection new
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

{ #category : 'accessing' }
TITTypeInfo >> types [

	^ types
]

{ #category : 'accessing' }
TITTypeInfo >> types: anObject [

	types := anObject
]
