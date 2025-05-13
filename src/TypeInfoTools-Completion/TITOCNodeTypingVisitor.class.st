Class {
	#name : 'TITOCNodeTypingVisitor',
	#superclass : 'OCTypingVisitor',
	#category : 'TypeInfoTools-Completion',
	#package : 'TypeInfoTools-Completion'
}

{ #category : 'visiting' }
TITOCNodeTypingVisitor >> typeOCProgramNode: aNode [

	aNode isError ifTrue: [ ^ self ].

	^ self typeTITNode: (TITTypedNodeCreationVisitor visit: aNode)
]

{ #category : 'visiting' }
TITOCNodeTypingVisitor >> typeTITNode: aTITNode [

	| type |
	aTITNode ocProgramNode ifNil: [ ^ self ].

	TITSequentialAdaptorsTypeCollector fast addTypesTo: aTITNode.

	type := aTITNode typeInfo types
		        commonSuperclassOfTopWeightClassesOrAny.

	type ifNil: [ ^ self ].

	self typeNode: aTITNode ocProgramNode with: type
]

{ #category : 'visiting' }
TITOCNodeTypingVisitor >> visitMessageNode: aNode [

	^ self typeOCProgramNode: aNode receiver
]
