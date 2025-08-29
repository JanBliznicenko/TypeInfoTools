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

	| type treeNode |
	aTITNode ocProgramNode ifNil: [ ^ self ].

	TITAdaptorsFusionTypeCollector fast addTypesTo: aTITNode.
	treeNode := aTITNode typeInfo types asClassTreeForPresenting
		            maxWeightNode ifNil: [ ^ self ].
	treeNode weight <= 0.1 ifTrue: [ ^ self ].
	type := treeNode representedClass.

	self typeNode: aTITNode ocProgramNode with: type
]

{ #category : 'visiting' }
TITOCNodeTypingVisitor >> visitMessageNode: aNode [

	^ self typeOCProgramNode: aNode receiver
]
