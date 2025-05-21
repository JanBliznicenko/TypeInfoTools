Class {
	#name : 'TITCollectionTypeHolder',
	#superclass : 'TITTypeHolder',
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
TITCollectionTypeHolder class >> acceptsClass: aClass [

	^ self considersAsCollection: aClass
]

{ #category : 'accessing' }
TITCollectionTypeHolder class >> atomicCollectionTypes [

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
TITCollectionTypeHolder class >> considersAsCollection: aClass [

	^ aClass isCollectionClass and: [
		  (self atomicCollectionTypes includes: aClass) not ]
]

{ #category : 'initialization' }
TITCollectionTypeHolder class >> reset [

	<script>
	atomicCollectionTypes := nil
]

{ #category : 'converting' }
TITCollectionTypeHolder >> asStringOn: aStream [

	self type printOn: aStream.
	aStream nextPut: ${.
	self elementType printOn: aStream.
	aStream nextPut: $}
]

{ #category : 'accessing' }
TITCollectionTypeHolder >> collectionType [

	^ self type
]

{ #category : 'accessing' }
TITCollectionTypeHolder >> collectionType: aClass [

	self type: aClass
]

{ #category : 'accessing' }
TITCollectionTypeHolder >> elementType [

	^ elementType
]

{ #category : 'accessing' }
TITCollectionTypeHolder >> elementType: aClass [

	elementType := aClass
]

{ #category : 'accessing' }
TITCollectionTypeHolder >> fillFromValue: aCollection [

	super fillFromValue: aCollection.
	aCollection ifEmpty: [ ^ self ].
	"we do not save every one as it could be incredibly slow"
	elementType := aCollection anyOne class
]
