Trait {
	#name : 'TITTShowTypesCommand',
	#category : 'TypeInfoTools-TreePresenter-Commands',
	#package : 'TypeInfoTools-TreePresenter',
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

	^ TITTypedNodeTreePresenter openOn: aTITNode
]
