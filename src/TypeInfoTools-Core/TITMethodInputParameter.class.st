Class {
	#name : 'TITMethodInputParameter',
	#superclass : 'TITTemporaryVariable',
	#instVars : [
		'method'
	],
	#category : 'TypeInfoTools-Core-Structure',
	#package : 'TypeInfoTools-Core',
	#tag : 'Structure'
}

{ #category : 'instance creation' }
TITMethodInputParameter class >> forOCVariableNode: aVariableNode [

	^ self new
		  name: aVariableNode name;
		  method: (TITMethod forOCMethodNode: aVariableNode methodNode);
		  ocProgramNode: aVariableNode;
		  yourself
]

{ #category : 'visiting' }
TITMethodInputParameter >> accept: anInferenceToolAdaptor [

	^ anInferenceToolAdaptor visitMethodInputParameter: self
]

{ #category : 'as yet unclassified' }
TITMethodInputParameter >> assumesNameOtherMeansSameClass [

	^ true
]

{ #category : 'accessing' }
TITMethodInputParameter >> classDescription [

	^ 'Parameter'
]

{ #category : 'accessing' }
TITMethodInputParameter >> method [

	^ method
]

{ #category : 'accessing' }
TITMethodInputParameter >> method: anObject [

	method := anObject
]

{ #category : 'accessing' }
TITMethodInputParameter >> ownerClass [

	^ self method ownerClass
]

{ #category : 'accessing' }
TITMethodInputParameter >> parent [

	^ self method
]

{ #category : 'accessing' }
TITMethodInputParameter >> realClass [

	^ self method realClass
]
