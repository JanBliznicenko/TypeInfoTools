Extension { #name : 'StMessageBrowser' }

{ #category : '*TypeInfoTools-MessageList' }
StMessageBrowser class >> preferredExtent [

	self flag: 'Commented out the code below (thus disabling remembering the extent) as a hotfix for errors caused by https://github.com/pharo-spec/NewTools/pull/932'.
	
	^ "preferredExtent ifNil: [ preferredExtent := "self defaultPreferredExtent" ]"
]

{ #category : '*TypeInfoTools-MessageList' }
StMessageBrowser class >> preferredExtent: aPoint [

	self flag: 'Commented out the code below (thus disabling remembering the extent) as a hotfix for errors caused by https://github.com/pharo-spec/NewTools/pull/932'.
	"preferredExtent := aPoint"
]
