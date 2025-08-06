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

{ #category : 'accessing' }
TITMethodReference >> executedMethodSelector [

	^  name
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
