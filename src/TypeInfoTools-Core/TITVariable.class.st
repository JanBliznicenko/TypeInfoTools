Class {
	#name : 'TITVariable',
	#superclass : 'TITTypedNode',
	#instVars : [
		'name'
	],
	#category : 'TypeInfoTools-Core-Structure',
	#package : 'TypeInfoTools-Core',
	#tag : 'Structure'
}

{ #category : 'testing' }
TITVariable >> isTemporary [

	^ false
]

{ #category : 'accessing' }
TITVariable >> name [

	^ name
]

{ #category : 'accessing' }
TITVariable >> name: anObject [

	name := anObject
]
