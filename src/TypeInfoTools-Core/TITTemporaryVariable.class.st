Class {
	#name : 'TITTemporaryVariable',
	#superclass : 'TITVariable',
	#category : 'TypeInfoTools-Core-Structure',
	#package : 'TypeInfoTools-Core',
	#tag : 'Structure'
}

{ #category : 'instance creation' }
TITTemporaryVariable class >> forOCVariableNode: aVariableNode [

	aVariableNode isDefinedByBlock ifTrue: [
		^ TITBlockTemporaryVariable forOCVariableNode: aVariableNode ].

	aVariableNode isArgumentVariable ifTrue: [
		^ TITMethodInputParameter forOCVariableNode: aVariableNode ].

	^ TITMethodTemporaryVariable forOCVariableNode: aVariableNode
]

{ #category : 'testing' }
TITTemporaryVariable >> isTemporary [

	^ true
]
