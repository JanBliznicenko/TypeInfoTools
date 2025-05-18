Class {
	#name : 'TITClassTreeRootNode',
	#superclass : 'TITAbstractClassTreeNode',
	#category : 'TypeInfoTools-Core-ClassTree',
	#package : 'TypeInfoTools-Core',
	#tag : 'ClassTree'
}

{ #category : 'accessing' }
TITClassTreeRootNode >> findMaxWeightNode [

	^ (self subclassNodes ifEmpty: [ ^ self ]) allButFirst
		  inject: self subclassNodes first maxWeightNode
		  into: [ :topNode :eachChild |
				  eachChild maxWeightInTree > topNode weight
					  ifTrue: [ eachChild maxWeightNode ]
					  ifFalse: [ topNode ] ]
]

{ #category : 'accessing' }
TITClassTreeRootNode >> findMinWeightNode [

	^ (self subclassNodes ifEmpty: [ ^ self ]) allButFirst
		  inject: self subclassNodes first minWeightNode
		  into: [ :topNode :eachChild |
				  eachChild minWeightInTree < topNode weight
					  ifTrue: [ eachChild minWeightNode ]
					  ifFalse: [ topNode ] ]
]

{ #category : 'initialization' }
TITClassTreeRootNode >> initialize [

	super initialize.
	self representedClass: ProtoObject
]

{ #category : 'testing' }
TITClassTreeRootNode >> isRootNode [

	^ true
]

{ #category : 'accessing' }
TITClassTreeRootNode >> parentNode [

	^ TITNoTreeNode instance
]

{ #category : 'accessing' }
TITClassTreeRootNode >> rootNode [

	^ self
]
