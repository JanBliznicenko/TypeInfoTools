Class {
	#name : 'TITNoTreeNode',
	#superclass : 'Object',
	#classInstVars : [
		'instance'
	],
	#category : 'TypeInfoTools-Core-ClassTree',
	#package : 'TypeInfoTools-Core',
	#tag : 'ClassTree'
}

{ #category : 'accessing' }
TITNoTreeNode class >> instance [

	^ instance ifNil: [ instance := self new ]
]

{ #category : 'merging' }
TITNoTreeNode >> withParentsIncludesCollectors: otherCollectors [

	^ false
]
