Class {
	#name : 'TITNodeType',
	#superclass : 'Object',
	#instVars : [
		'type'
	],
	#category : 'TypeInfoTools-Core-RealTime',
	#package : 'TypeInfoTools-Core',
	#tag : 'RealTime'
}

{ #category : 'testing' }
TITNodeType class >> acceptsValue: aValue [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
TITNodeType >> type [

	^ type
]

{ #category : 'accessing' }
TITNodeType >> type: aClass [

	type := aClass
]
