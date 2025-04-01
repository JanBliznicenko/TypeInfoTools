Trait {
	#name : 'TITTTypedNodeInMethod',
	#category : 'TypeInfoTools-Core-Structure',
	#package : 'TypeInfoTools-Core',
	#tag : 'Structure'
}

{ #category : 'accessing' }
TITTTypedNodeInMethod >> compilationBlock: aBlock [

	self method compilationBlock: aBlock
]

{ #category : 'accessing' }
TITTTypedNodeInMethod >> compiledMethod [

	^ self method compiledMethod
]

{ #category : 'accessing' }
TITTTypedNodeInMethod >> method [

	^ self shouldBeImplemented
]
