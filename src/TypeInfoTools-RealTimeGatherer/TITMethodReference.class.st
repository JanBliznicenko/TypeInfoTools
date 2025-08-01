Class {
	#name : 'TITMethodReference',
	#superclass : 'TITClassItemReference',
	#instVars : [
		'senderClass'
	],
	#category : 'TypeInfoTools-RealTimeGatherer-Structure',
	#package : 'TypeInfoTools-RealTimeGatherer',
	#tag : 'Structure'
}

{ #category : 'instance creation' }
TITMethodReference class >> toOriginImplementorClass: anOriginImplementorClass executedMethodClass: anExecutedMethodClass receiverClass: aReceiverClass senderClass: aSenderClass name: aSymbol [

	^ self new
		  originImplementorClass: anOriginImplementorClass;
		  executedMethodClass: anExecutedMethodClass;
		  receiverClass: aReceiverClass;
		  senderClass: aSenderClass;
		  name: aSymbol;
		  yourself
]

{ #category : 'comparing' }
TITMethodReference >> = anObject [
	"Answer whether the receiver and anObject represent the same object."

	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	super = anObject ifFalse: [ ^ false ].
	^ senderClass = anObject senderClass
]

{ #category : 'accessing' }
TITMethodReference >> executedMethodSelector [

	^  name
]

{ #category : 'comparing' }
TITMethodReference >> hash [
	"Answer an integer value that is related to the identity of the receiver."

	^ super hash bitXor: senderClass hash
]

{ #category : 'accessing' }
TITMethodReference >> referencingClass [

	^ self senderClass
]

{ #category : 'accessing' }
TITMethodReference >> senderClass [

	^ senderClass
]

{ #category : 'accessing' }
TITMethodReference >> senderClass: aClass [

	senderClass := aClass
]
