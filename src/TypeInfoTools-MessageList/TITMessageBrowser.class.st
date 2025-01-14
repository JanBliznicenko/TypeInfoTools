Class {
	#name : 'TITMessageBrowser',
	#superclass : 'StMessageBrowser',
	#category : 'TypeInfoTools-MessageList-Presenters',
	#package : 'TypeInfoTools-MessageList',
	#tag : 'Presenters'
}

{ #category : 'accessing' }
TITMessageBrowser class >> preferredExtent [

	^ 1000 @ 700
]

{ #category : 'initialization' }
TITMessageBrowser >> newMessageList [
	
	^ self instantiate: TITMessageListPresenter
]

{ #category : 'accessing' }
TITMessageBrowser >> typeInfo: aTypeInfo [

	messageList typeInfo: aTypeInfo
]
