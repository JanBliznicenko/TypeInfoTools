Extension { #name : 'StComposedMessageElementPresenter' }

{ #category : '*TypeInfoTools-MessageList' }
StComposedMessageElementPresenter >> initializePresenters [

	locationLabel := self newLabel"
		addStyle: 'dim';
		yourself".
	selectorLabel := self newLabel.
	packageLabel := self newLabel"
		addStyle: 'dim';
		yourself"
]

{ #category : '*TypeInfoTools-MessageList' }
StComposedMessageElementPresenter >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	selectorLabel label: (messageList selectorOf: self model) trimmed.
	packageLabel label: (messageList packageOf: self model) name trimmed.
	locationLabel label: (messageList locationOf: self model) trimmed	
]
