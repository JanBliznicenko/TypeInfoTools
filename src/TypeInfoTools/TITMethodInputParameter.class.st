Class {
	#name : 'TITMethodInputParameter',
	#superclass : 'TITTemporaryVariable',
	#instVars : [
		'#method => ToOneRelationSlot inverse: #parameterVariables inClass: #TITMethod'
	],
	#category : 'TypeInfoTools-Structure',
	#package : 'TypeInfoTools',
	#tag : 'Structure'
}

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
