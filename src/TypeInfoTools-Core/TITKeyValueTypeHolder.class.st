Class {
	#name : 'TITKeyValueTypeHolder',
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
TITKeyValueTypeHolder class >> acceptsClass: aClass [

	^ aClass includesBehavior: Association
]

{ #category : 'converting' }
TITKeyValueTypeHolder >> asStringOn: aStream [

	self type printOn: aStream.
	aStream nextPut: $:.
	self keyType printOn: aStream.
	aStream nextPutAll: '->'.
	self valueType printOn: aStream
]

{ #category : 'accessing' }
TITKeyValueTypeHolder >> fillFromValue: anAssociationOrOtherPair [

	super fillFromValue: anAssociationOrOtherPair.

	keyType := anAssociationOrOtherPair key.
	valueType := anAssociationOrOtherPair value
]

{ #category : 'accessing' }
TITKeyValueTypeHolder >> keyType [

	^ keyType
]

{ #category : 'accessing' }
TITKeyValueTypeHolder >> keyType: aClass [

	keyType := aClass
]

{ #category : 'accessing' }
TITKeyValueTypeHolder >> valueType [

	^ valueType
]

{ #category : 'accessing' }
TITKeyValueTypeHolder >> valueType: aClass [

	valueType := aClass
]
