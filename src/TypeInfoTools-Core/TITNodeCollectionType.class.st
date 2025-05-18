Class {
	#name : 'TITNodeCollectionType',
	#superclass : 'TITNodeType',
	#instVars : [
		'elementType'
	],
	#classInstVars : [
		'atomicCollectionTypes'
	],
	#category : 'TypeInfoTools-Core-RealTime',
	#package : 'TypeInfoTools-Core',
	#tag : 'RealTime'
}

{ #category : 'testing' }
TITNodeCollectionType class >> acceptsValue: aValue [

	^ self considersAsCollection: aValue class
]

{ #category : 'accessing' }
TITNodeCollectionType class >> atomicCollectionTypes [

	^ atomicCollectionTypes ifNil: [
			  atomicCollectionTypes := {
				                           Bitmap.
				                           ByteArray.
				                           CharacterSet.
				                           CharacterSetComplement.
				                           DoubleByteArray.
				                           DoubleWordArray.
				                           FFIExternalArray.
				                           Float32Array.
				                           Float64Array.
				                           IntegerArray.
				                           Interval.
				                           ProcessList.
				                           RunArray.
				                           Semaphore.
				                           ShortIntegerArray.
				                           SparseLargeTable.
				                           String.
				                           Text.
				                           WideCharacterSet.
				                           WordArray } flatCollectAsSet: [ :each |
				                           each withAllSubclasses ] ]
]

{ #category : 'testing' }
TITNodeCollectionType class >> considersAsCollection: aClass [

	^ aClass isCollectionClass and: [
		  (self atomicCollectionTypes includes: aClass) not ]
]

{ #category : 'initialization' }
TITNodeCollectionType class >> reset [

	<script>
	atomicCollectionTypes := nil
]

{ #category : 'accessing' }
TITNodeCollectionType >> collectionType [

	^ self type
]

{ #category : 'accessing' }
TITNodeCollectionType >> collectionType: aClass [

	self type: aClass
]

{ #category : 'accessing' }
TITNodeCollectionType >> elementType [

	^ elementType
]

{ #category : 'accessing' }
TITNodeCollectionType >> elementType: aClass [

	elementType := aClass
]
