Class {
	#name : 'TITTypeInfo',
	#superclass : 'Object',
	#instVars : [
		'#node => ToOneRelationSlot inverse: #typeInfo inClass: #TITTypedNode',
		'#types',
		'#collectionElementTypes',
		'#collectorsIncluded'
	],
	#category : 'TypeInfoTools-Core-Inference',
	#package : 'TypeInfoTools-Core',
	#tag : 'Inference'
}

{ #category : 'adding' }
TITTypeInfo >> addAllFrom: otherTypeInfo [

	types addAllFrom: otherTypeInfo types.
	collectionElementTypes addAllFrom:
		otherTypeInfo collectionElementTypes.
	collectorsIncluded addAll: otherTypeInfo collectorsIncluded
]

{ #category : 'adding' }
TITTypeInfo >> addCollectionElementTypes: aClassCollection by: aTypeCollector [

	collectorsIncluded add: aTypeCollector.
	collectionElementTypes addClasses: aClassCollection by: aTypeCollector
]

{ #category : 'adding' }
TITTypeInfo >> addTypes: aClassCollection by: aTypeCollector [

	collectorsIncluded add: aTypeCollector.
	types addClasses: aClassCollection by: aTypeCollector
]

{ #category : 'accessing' }
TITTypeInfo >> collectionElementTypes [

	^ collectionElementTypes
]

{ #category : 'accessing' }
TITTypeInfo >> collectorsIncluded [

	^ collectorsIncluded
]

{ #category : 'testing' }
TITTypeInfo >> ifEmpty: aBlock [

	^ self isEmpty
		  ifTrue: [ aBlock value ]
		  ifFalse: [ self ]
]

{ #category : 'testing' }
TITTypeInfo >> ifNotEmpty: aBlock [

	^ self isEmpty
		  ifTrue: [ self ]
		  ifFalse: [ aBlock value ]
]

{ #category : 'initialization' }
TITTypeInfo >> initialize [

	super initialize.
	types := TITTypesCollection forTypeInfo: self.
	collectionElementTypes := TITTypesCollection forTypeInfo: self.
	collectorsIncluded := Set new.
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

{ #category : 'printing' }
TITTypeInfo >> printOn: aStream [

	super printOn: aStream.
	aStream nextPutAll: '('.
	aStream nextPutAll: types size asString.
	aStream nextPutAll: ')'
]

{ #category : 'adding' }
TITTypeInfo >> prioritizedClasses: aCollection [

	types prioritizedClasses: aCollection.
	collectionElementTypes prioritizedClasses: aCollection
]

{ #category : 'testing' }
TITTypeInfo >> processedByAnyCollector [

	^ collectorsIncluded isNotEmpty
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
