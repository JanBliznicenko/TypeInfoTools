Class {
	#name : 'TITTemporaryVariable',
	#superclass : 'TITVariable',
	#category : 'TypeInfoTools-Core-Structure',
	#package : 'TypeInfoTools-Core',
	#tag : 'Structure'
}

{ #category : 'instance creation' }
TITTemporaryVariable class >> forOCVariableNode: aVariableNode [

	| definingNode |
	definingNode := aVariableNode variable definingNode.

	definingNode isDefinedByBlock ifTrue: [
		^ TITBlockTemporaryVariable forOCVariableNode: definingNode ].

	definingNode isArgumentVariable ifTrue: [
		^ TITMethodInputParameter forOCVariableNode: definingNode ].

	^ TITMethodTemporaryVariable forOCVariableNode: definingNode
]

{ #category : 'testing' }
TITTemporaryVariable >> isTemporary [

	^ true
]
