Class {
	#name : 'TITTypedNodeCreationVisitor',
	#superclass : 'OCProgramNodeVisitor',
	#category : 'TypeInfoTools-Core-Structure',
	#package : 'TypeInfoTools-Core',
	#tag : 'Structure'
}

{ #category : 'visiting' }
TITTypedNodeCreationVisitor class >> visit: anOCNode [

	^ self new visit: anOCNode
]

{ #category : 'visiting' }
TITTypedNodeCreationVisitor >> visitArrayNode: anArrayNode [

	^ TITClass forRealClass: Array
]

{ #category : 'visiting' }
TITTypedNodeCreationVisitor >> visitInstanceVariableNode: anInstanceVariableNode [

	^ TITInstanceVariable forSystemInstanceVariable:
		  anInstanceVariableNode variable
]

{ #category : 'visiting' }
TITTypedNodeCreationVisitor >> visitLiteralValueNode: aVariableNode [

	^ TITClass forRealClass: aVariableNode value class
]

{ #category : 'visiting' }
TITTypedNodeCreationVisitor >> visitLocalVariableNode: aNode [

	^ TITTemporaryVariable forOCVariableNode: aNode
]

{ #category : 'visiting' }
TITTypedNodeCreationVisitor >> visitMessageNode: aMessageNode [

	^ TITMessageSendNode forMessage: aMessageNode
]

{ #category : 'visiting' }
TITTypedNodeCreationVisitor >> visitSelfNode: aSelfNode [

	^ TITClass forRealClass: aSelfNode methodNode methodClass
]

{ #category : 'visiting' }
TITTypedNodeCreationVisitor >> visitVariableNode: aVariableNode [

	^ TITClass forRealClass: aVariableNode variable value class
]
