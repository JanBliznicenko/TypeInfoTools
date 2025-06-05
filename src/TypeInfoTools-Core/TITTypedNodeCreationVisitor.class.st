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

	^ TITClass forRealClass: Array node: anArrayNode
]

{ #category : 'visiting' }
TITTypedNodeCreationVisitor >> visitBlockNode: aBlockNode [

	^ TITBlock forOCBlockNode: aBlockNode
]

{ #category : 'visiting' }
TITTypedNodeCreationVisitor >> visitCascadeNode: aCascadeNode [

	^ self visit: aCascadeNode messages last
]

{ #category : 'visiting' }
TITTypedNodeCreationVisitor >> visitInstanceVariableNode: anInstanceVariableNode [

	^ TITInstanceVariable forOCVariableNode: anInstanceVariableNode
]

{ #category : 'visiting' }
TITTypedNodeCreationVisitor >> visitLiteralArrayNode: anArrayNode [

	^ TITClass forRealClass: Array node: anArrayNode
]

{ #category : 'visiting' }
TITTypedNodeCreationVisitor >> visitLiteralValueNode: aVariableNode [

	^ TITClass
		  forRealClass: aVariableNode value class
		  node: aVariableNode
]

{ #category : 'visiting' }
TITTypedNodeCreationVisitor >> visitLocalVariableNode: aNode [

	^ TITTemporaryVariable forOCVariableNode: aNode
]

{ #category : 'visiting' }
TITTypedNodeCreationVisitor >> visitMessageNode: aMessageNode [

	^ TITMessageSendNode forOCMessageNode: aMessageNode
]

{ #category : 'visiting' }
TITTypedNodeCreationVisitor >> visitSelfNode: aSelfNode [

	^ TITClass forRealClass: aSelfNode methodNode methodClass
		  node: aSelfNode
]

{ #category : 'visiting' }
TITTypedNodeCreationVisitor >> visitVariableNode: aVariableNode [

	^ TITClass
		  forRealClass: aVariableNode variable value class
		  node: aVariableNode
]
