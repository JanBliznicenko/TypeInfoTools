Trait {
	#name : 'TITTShowTypesCommand',
	#category : 'TypeInfoTools-Commands',
	#package : 'TypeInfoTools',
	#tag : 'Commands'
}

{ #category : 'accessing' }
TITTShowTypesCommand >> defaultMenuIconName [

	^ #hierarchy
]

{ #category : 'accessing' }
TITTShowTypesCommand >> defaultMenuItemName [

	^ 'Infer Types v2'
]

{ #category : 'ui - dialogs' }
TITTShowTypesCommand >> informNoneFound [

	self inform: 'No types were found'
]
