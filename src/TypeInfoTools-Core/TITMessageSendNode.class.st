Class {
	#name : 'TITMessageSendNode',
	#superclass : 'TITTypedNode',
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
TITMessageSendNode >> message [

	^ message
]

{ #category : 'accessing' }
TITMessageSendNode >> message: anObject [

	message := anObject
]

{ #category : 'accessing' }
TITMessageSendNode >> name [

	^ message selector
]

{ #category : 'accessing' }
TITMessageSendNode >> parent [

	^ TITNoNode new
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
