Class {
	#name : 'TITCompiledCodeContainedNode',
	#superclass : 'TITContainerNode',
	#instVars : [
		'blocks'
	],
	#category : 'TypeInfoTools-Structure',
	#package : 'TypeInfoTools',
	#tag : 'Structure'
}

{ #category : 'accessing' }
TITCompiledCodeContainedNode >> allBlocks [

	^ self blocks flatCollect: [ :each | each allBlocks ]
]

{ #category : 'accessing' }
TITCompiledCodeContainedNode >> compiledCode [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
TITCompiledCodeContainedNode >> containedBlocks [

	^ blocks
]

{ #category : 'accessing' }
TITCompiledCodeContainedNode >> containedBlocks: anObject [

	blocks := anObject
]

{ #category : 'initialization' }
TITCompiledCodeContainedNode >> initialize [

	self class initializeSlots: self.
	super initialize.
]
