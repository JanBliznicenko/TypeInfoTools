Class {
	#name : 'TITMessageSendNode',
	#superclass : 'TITTypedNode',
	#traits : 'TITTTypedNodeInMethod',
	#classTraits : 'TITTTypedNodeInMethod classTrait',
	#instVars : [
		'message',
		'receiver'
	],
	#category : 'TypeInfoTools-Core-Structure',
	#package : 'TypeInfoTools-Core',
	#tag : 'Structure'
}

{ #category : 'instance creation' }
TITMessageSendNode class >> forMessage: aMessage [

	^ self new
		  message: aMessage;
		  yourself
]

{ #category : 'visiting' }
TITMessageSendNode >> accept: anInferenceToolAdaptor [

	^ anInferenceToolAdaptor visitMessageSend: self
]

{ #category : 'accessing' }
TITMessageSendNode >> classDescription [

	^ 'Message send'
]

{ #category : 'accessing' }
TITMessageSendNode >> longDescription [

	^ String streamContents: [ :s |
		  s << self shortDescription.
		  self parent shortDescriptionJoinedBy: ' to ' to: s ]
]

{ #category : 'accessing' }
TITMessageSendNode >> message [

	^ message
]

{ #category : 'accessing' }
TITMessageSendNode >> message: anObject [

	message := anObject
]

{ #category : 'accessing' }
TITMessageSendNode >> method [

	^ self receiver method
]

{ #category : 'accessing' }
TITMessageSendNode >> name [

	^ message selector
]

{ #category : 'accessing' }
TITMessageSendNode >> parent [

	^ self receiver
]

{ #category : 'accessing' }
TITMessageSendNode >> receiver [

	^ receiver ifNil: [
		  receiver := TITTypedNodeCreationVisitor visit: message receiver ]
]

{ #category : 'accessing' }
TITMessageSendNode >> selector [

	^ message selector
]
