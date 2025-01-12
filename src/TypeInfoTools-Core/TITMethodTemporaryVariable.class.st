Class {
	#name : 'TITMethodTemporaryVariable',
	#superclass : 'TITTemporaryVariable',
	#instVars : [
		'method'
	],
	#category : 'TypeInfoTools-Core-Structure',
	#package : 'TypeInfoTools-Core',
	#tag : 'Structure'
}

{ #category : 'as yet unclassified' }
TITMethodTemporaryVariable class >> forASTVariableNode: aVariableNode [

	^ self new
		  name: aVariableNode name;
		  method: (TITMethod forASTMethodNode: aVariableNode methodNode);
		  yourself
]

{ #category : 'visiting' }
TITMethodTemporaryVariable >> accept: anInferenceToolAdaptor [

	^ anInferenceToolAdaptor visitMethodTemporaryVariable: self
]

{ #category : 'accessing' }
TITMethodTemporaryVariable >> classDescription [

	^ 'Temporary variable'
]

{ #category : 'accessing' }
TITMethodTemporaryVariable >> method [

	^ method
]

{ #category : 'accessing' }
TITMethodTemporaryVariable >> method: anObject [

	method := anObject
]

{ #category : 'accessing' }
TITMethodTemporaryVariable >> ownerClass [

	^ self method ownerClass
]

{ #category : 'accessing' }
TITMethodTemporaryVariable >> parent [

	^ self method
]

{ #category : 'accessing' }
TITMethodTemporaryVariable >> realClass [

	^ self method realClass
]
