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

{ #category : 'as yet unclassified' }
TITVariable class >> forASTVariableNode: aVariableNode [

	aVariableNode isInstanceVariable ifTrue: [
		^ TITInstanceVariable forASTVariableNode: aVariableNode ].
	aVariableNode isClassVariable ifTrue: [
		^ TITSharedVariable forASTVariableNode: aVariableNode ].
	aVariableNode isLocalVariable ifTrue: [
		^ TITTemporaryVariable forASTVariableNode: aVariableNode ].
	self error: 'Unsupported variable type'
]

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
