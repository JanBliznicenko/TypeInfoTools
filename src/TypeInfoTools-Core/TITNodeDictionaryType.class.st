Class {
	#name : 'TITNodeDictionaryType',
	#superclass : 'TITNodeType',
	#instVars : [
		'keyType',
		'valueType'
	],
	#category : 'TypeInfoTools-Core-RealTime',
	#package : 'TypeInfoTools-Core',
	#tag : 'RealTime'
}

{ #category : 'testing' }
TITNodeDictionaryType class >> acceptsValue: aValue [

	| type |
	type := aValue class.
	^ type = Dictionary or: [
		  type = OrderedDictionary or: [ type = SmallDictionary ] ]
]

{ #category : 'accessing' }
TITNodeDictionaryType >> collectionType [

	^ self type
]

{ #category : 'accessing' }
TITNodeDictionaryType >> collectionType: aClass [

	self type: aClass
]

{ #category : 'accessing' }
TITNodeDictionaryType >> keyType [

	^ keyType
]

{ #category : 'accessing' }
TITNodeDictionaryType >> keyType: aClass [

	keyType := aClass
]

{ #category : 'accessing' }
TITNodeDictionaryType >> valueType [

	^ valueType
]

{ #category : 'accessing' }
TITNodeDictionaryType >> valueType: aClass [

	valueType := aClass
]
