Class {
	#name : 'TITTemporaryVariable',
	#superclass : 'TITVariable',
	#traits : 'TITTTypedNodeInMethod',
	#classTraits : 'TITTTypedNodeInMethod classTrait',
	#category : 'TypeInfoTools-Core-Structure',
	#package : 'TypeInfoTools-Core',
	#tag : 'Structure'
}

{ #category : 'instance creation' }
TITTemporaryVariable class >> forOCVariableNode: aVariableNode [

	| definingNode |
	definingNode := aVariableNode variable originalVar definingNode
		                ifNil: [ aVariableNode variable definingNode ].

	definingNode isDefinedByBlock ifTrue: [
		^ TITBlockTemporaryVariable forOCVariableNode: definingNode ].

	definingNode isArgumentVariable ifTrue: [
		^ TITMethodInputParameter forOCVariableNode: definingNode ].

	^ TITMethodTemporaryVariable forOCVariableNode: definingNode
]

{ #category : 'accessing' }
TITTemporaryVariable >> compiledMethod [

	^ self method compiledMethod
]

{ #category : 'testing' }
TITTemporaryVariable >> isTemporary [

	^ true
]

{ #category : 'accessing' }
TITTemporaryVariable >> method [

	^ self subclassResponsibility
]
