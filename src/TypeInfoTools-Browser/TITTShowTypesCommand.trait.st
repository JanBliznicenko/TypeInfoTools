Trait {
	#name : 'TITTShowTypesCommand',
	#category : 'TypeInfoTools-Browser-Commands',
	#package : 'TypeInfoTools-Browser',
	#tag : 'Commands'
}

{ #category : 'accessing' }
TITTShowTypesCommand >> defaultMenuIconName [

	^ #hierarchy
]

{ #category : 'accessing' }
TITTShowTypesCommand >> defaultMenuItemName [

	^ 'Infer Types'
]

{ #category : 'executing' }
TITTShowTypesCommand >> execute [

	^ [ :job |
	  job title: 'Running type inference'.
	  self executeInJob: job ] asJob run
]

{ #category : 'ui - dialogs' }
TITTShowTypesCommand >> informNoneFound [

	self inform: 'No types were found'
]

{ #category : 'execution' }
TITTShowTypesCommand >> showSingleItem: aTITNode [

	^ TITTypedNodePresenter openOn: aTITNode
]
