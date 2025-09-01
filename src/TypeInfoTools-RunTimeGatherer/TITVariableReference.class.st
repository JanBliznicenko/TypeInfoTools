Class {
	#name : 'TITVariableReference',
	#superclass : 'TITClassItemReference',
	#instVars : [
		'executedMethodSelector'
	],
	#category : 'TypeInfoTools-RunTimeGatherer-Structure',
	#package : 'TypeInfoTools-RunTimeGatherer',
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

{ #category : 'comparing' }
TITVariableReference >> = anObject [
	"Answer whether the receiver and anObject represent the same object."

	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	super = anObject ifFalse: [ ^ false ].
	^ executedMethodSelector = anObject executedMethodSelector
]

{ #category : 'accessing' }
TITVariableReference >> executedMethodSelector [

	^ executedMethodSelector
]

{ #category : 'accessing' }
TITVariableReference >> executedMethodSelector: aSymbol [

	executedMethodSelector := aSymbol
]

{ #category : 'comparing' }
TITVariableReference >> hash [
	"Answer an integer value that is related to the identity of the receiver."

	^ super hash bitXor: executedMethodSelector hash
]

{ #category : 'accessing' }
TITVariableReference >> referencingClass [

	^ self executedMethodClass
]
