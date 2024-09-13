Class {
	#name : 'TITVariable',
	#superclass : 'TITTypedNode',
	#instVars : [
		'name'
	],
	#category : 'TypeInfoTools-Structure',
	#package : 'TypeInfoTools',
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
