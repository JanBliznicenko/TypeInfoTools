Class {
	#name : 'TITNodeKeyValueType',
	#superclass : 'TITNodeType',
	#instVars : [
		'keyType'
	],
	#category : 'TypeInfoTools-Core-RealTime',
	#package : 'TypeInfoTools-Core',
	#tag : 'RealTime'
}

{ #category : 'accessing' }
TITNodeKeyValueType >> keyType [

	^ keyType
]

{ #category : 'accessing' }
TITNodeKeyValueType >> keyType: aClass [

	keyType := aClass
]

{ #category : 'accessing' }
TITNodeKeyValueType >> valueType [

	^ self type
]

{ #category : 'accessing' }
TITNodeKeyValueType >> valueType: aClass [

	self type: aClass
]
