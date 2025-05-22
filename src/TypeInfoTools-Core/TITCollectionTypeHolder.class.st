Class {
	#name : 'TITCollectionTypeHolder',
	#superclass : 'TITTypeHolder',
	#instVars : [
		'elementTypes'
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
				                           MethodDictionary.
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

{ #category : 'copying' }
TITCollectionTypeHolder >> , anotherHolder [

	^ anotherHolder copyWithCollectionTypeHolder: self
]

{ #category : 'adding' }
TITCollectionTypeHolder >> addValue: aValue [

	super addValue: aValue.
	aValue ifEmpty: [ ^ self ].
	elementTypes := elementTypes withValue: aValue anyOne
]

{ #category : 'converting' }
TITCollectionTypeHolder >> convertTypesToString [

	super convertTypesToString.
	elementTypes convertTypesToString
]

{ #category : 'adding' }
TITCollectionTypeHolder >> copyWithCollectionHolder: anotherTypeHolder [

	^ (self copyWithTypeHolder: anotherTypeHolder)
		  elementTypes: elementTypes , anotherTypeHolder elementTypes;
		  yourself
]

{ #category : 'accessing' }
TITCollectionTypeHolder >> elementTypes [

	^ elementTypes
]

{ #category : 'accessing' }
TITCollectionTypeHolder >> elementTypes: anObject [

	elementTypes := anObject
]

{ #category : 'initialization' }
TITCollectionTypeHolder >> initialize [

	super initialize.
	elementTypes := TITEmptyTypeHolder new
]

{ #category : 'private' }
TITCollectionTypeHolder >> mergeTypes [

	super mergeTypes.
	elementTypes mergeTypes
]

{ #category : 'adding' }
TITCollectionTypeHolder >> replaceFrom: anotherHolder [

	super replaceFrom: anotherHolder.
	elementTypes replaceFrom: anotherHolder elementTypes
]
