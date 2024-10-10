Class {
	#name : 'TITTemporaryVariable',
	#superclass : 'TITVariable',
	#category : 'TypeInfoTools-Structure',
	#package : 'TypeInfoTools',
	#tag : 'Structure'
}

{ #category : 'as yet unclassified' }
TITTemporaryVariable class >> forASTVariableNode: aVariableNode [

	aVariableNode methodOrBlockNode isBlock ifTrue: [
		^ TITBlockTemporaryVariable forASTVariableNode: aVariableNode ].

	aVariableNode isArgumentVariable ifTrue: [
		^ TITMethodInputParameter forASTVariableNode: aVariableNode ].

	^ TITMethodTemporaryVariable forASTVariableNode: aVariableNode
]

{ #category : 'testing' }
TITTemporaryVariable >> isTemporary [

	^ true
]
