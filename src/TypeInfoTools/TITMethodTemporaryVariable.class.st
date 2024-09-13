Class {
	#name : 'TITMethodTemporaryVariable',
	#superclass : 'TITTemporaryVariable',
	#instVars : [
		'#method => ToOneRelationSlot inverse: #temporaryVariables inClass: #TITMethod'
	],
	#category : 'TypeInfoTools-Structure',
	#package : 'TypeInfoTools',
	#tag : 'Structure'
}

{ #category : 'visiting' }
TITMethodTemporaryVariable >> accept: anInferenceToolAdaptor [

	^ anInferenceToolAdaptor visitMethodTemporaryVariable: self
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
