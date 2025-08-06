Class {
	#name : 'TITVariableReference',
	#superclass : 'TITClassItemReference',
	#instVars : [
		'executedMethodSelector'
	],
	#category : 'TypeInfoTools-RealTimeGatherer-Structure',
	#package : 'TypeInfoTools-RealTimeGatherer',
	#tag : 'Structure'
}

{ #category : 'instance creation' }
TITVariableReference class >> toOriginImplementorClass: anOriginImplementorClass executedMethodClass: anExecutedMethodClass executedMethodSelector: aSelector receiverClass: aReceiverClass name: aSymbol [

	^ self new
		  originImplementorClass: anOriginImplementorClass;
		  executedMethodClass: anExecutedMethodClass;
		  executedMethodSelector: aSelector;
		  receiverClass: aReceiverClass;
		  name: aSymbol;
		  yourself
]

{ #category : 'accessing' }
TITVariableReference >> executedMethodSelector [

	^ executedMethodSelector
]

{ #category : 'accessing' }
TITVariableReference >> executedMethodSelector: aSymbol [

	executedMethodSelector := aSymbol
]

{ #category : 'accessing' }
TITVariableReference >> referencingClass [

	^ self executedMethodClass
]
