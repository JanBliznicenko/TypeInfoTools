Class {
	#name : 'TITDictionaryTypeHolder',
	#superclass : 'TITTypeHolder',
	#instVars : [
		'keyType',
		'valueType'
	],
	#category : 'TypeInfoTools-Core-RealTime',
	#package : 'TypeInfoTools-Core',
	#tag : 'RealTime'
}

{ #category : 'testing' }
TITDictionaryTypeHolder class >> acceptsClass: aClass [

	^ aClass = Dictionary or: [
		  aClass = OrderedDictionary or: [ aClass = SmallDictionary ] ]
]

{ #category : 'converting' }
TITDictionaryTypeHolder >> asStringOn: aStream [

	self type printOn: aStream.
	aStream nextPut: ${.
	self keyType printOn: aStream.
	aStream nextPutAll: '->'.
	self valueType printOn: aStream.
	aStream nextPut: $}
]

{ #category : 'accessing' }
TITDictionaryTypeHolder >> collectionType [

	^ self type
]

{ #category : 'accessing' }
TITDictionaryTypeHolder >> collectionType: aClass [

	self type: aClass
]

{ #category : 'accessing' }
TITDictionaryTypeHolder >> fillFromValue: aDictionary [

	super fillFromValue: aDictionary.
	aDictionary associationsDo: [ :eachPair |
			keyType := eachPair key.
			valueType := eachPair value.
			"we do not save every one as it could be incredibly slow"
			^ self ]
]

{ #category : 'accessing' }
TITDictionaryTypeHolder >> keyType [

	^ keyType
]

{ #category : 'accessing' }
TITDictionaryTypeHolder >> keyType: aClass [

	keyType := aClass
]

{ #category : 'accessing' }
TITDictionaryTypeHolder >> valueType [

	^ valueType
]

{ #category : 'accessing' }
TITDictionaryTypeHolder >> valueType: aClass [

	valueType := aClass
]
