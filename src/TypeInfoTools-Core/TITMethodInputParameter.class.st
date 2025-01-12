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

{ #category : 'as yet unclassified' }
TITMethodInputParameter class >> forASTVariableNode: aVariableNode [

	^ self new
		  name: aVariableNode name;
		  method: (TITMethod forASTMethodNode: aVariableNode methodNode);
		  yourself
]

{ #category : 'visiting' }
TITMethodInputParameter >> accept: anInferenceToolAdaptor [

	^ anInferenceToolAdaptor visitMethodInputParameter: self
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
