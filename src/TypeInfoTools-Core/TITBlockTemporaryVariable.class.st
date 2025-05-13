Class {
	#name : 'TITBlockTemporaryVariable',
	#superclass : 'TITTemporaryVariable',
	#instVars : [
		'block'
	],
	#category : 'TypeInfoTools-Core-Structure',
	#package : 'TypeInfoTools-Core',
	#tag : 'Structure'
}

{ #category : 'instance creation' }
TITBlockTemporaryVariable class >> forOCVariableNode: aVariableNode [

	| blockNode |
	blockNode := aVariableNode methodOrBlockNode.
	blockNode isBlock ifFalse: [
		self error:
			'Unable to create TITBlockTemporaryVariable for non-block var' ].
	^ self new
		  name: aVariableNode name;
		  block: (TITBlock forOCBlockNode: blockNode);
		  ocProgramNode: aVariableNode;
		  yourself
]

{ #category : 'visiting' }
TITBlockTemporaryVariable >> accept: anInferenceToolAdaptor [

	^ anInferenceToolAdaptor visitBlockTemporaryVariable: self
]

{ #category : 'accessing' }
TITBlockTemporaryVariable >> block [

	^ block
]

{ #category : 'accessing' }
TITBlockTemporaryVariable >> block: aTITBlock [

	block := aTITBlock
]

{ #category : 'accessing' }
TITBlockTemporaryVariable >> classDescription [

	^ 'Block-level temporary variable'
]

{ #category : 'accessing' }
TITBlockTemporaryVariable >> method [

	^ self block method
]

{ #category : 'accessing' }
TITBlockTemporaryVariable >> parent [

	^ self block
]
