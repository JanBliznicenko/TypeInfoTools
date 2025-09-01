Class {
	#name : 'TITTypeTreeRootNode',
	#superclass : 'TITAbstractTypeTreeNode',
	#category : 'TypeInfoTools-Core-ClassTree',
	#package : 'TypeInfoTools-Core',
	#tag : 'ClassTree'
}

{ #category : 'accessing' }
TITTypeTreeRootNode >> findMaxWeightNode [

	^ (self subclassNodes ifEmpty: [ ^ self ]) allButFirst
		  inject: self subclassNodes first maxWeightNode
		  into: [ :topNode :eachChild |
				  eachChild maxWeightInTree > topNode weight
					  ifTrue: [ eachChild maxWeightNode ]
					  ifFalse: [ topNode ] ]
]

{ #category : 'accessing' }
TITTypeTreeRootNode >> findMinWeightNode [

	^ (self subclassNodes ifEmpty: [ ^ self ]) allButFirst
		  inject: self subclassNodes first minWeightNode
		  into: [ :topNode :eachChild |
				  eachChild minWeightInTree < topNode weight
					  ifTrue: [ eachChild minWeightNode ]
					  ifFalse: [ topNode ] ]
]

{ #category : 'initialization' }
TITTypeTreeRootNode >> initialize [

	super initialize.
	self representedClass: nil
]

{ #category : 'testing' }
TITTypeTreeRootNode >> isRootNode [

	^ true
]

{ #category : 'merging' }
TITTypeTreeRootNode >> mergeChildrenMajority [
	"do nothing"

	
]

{ #category : 'accessing' }
TITTypeTreeRootNode >> parentNode [

	^ TITNoTreeNode instance
]

{ #category : 'accessing' }
TITTypeTreeRootNode >> rootNode [

	^ self
]
