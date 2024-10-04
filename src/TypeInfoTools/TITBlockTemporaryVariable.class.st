Class {
	#name : 'TITBlockTemporaryVariable',
	#superclass : 'TITTemporaryVariable',
	#instVars : [
		'#block => ToOneRelationSlot inverse: #temporaryVariables inClass: #TITBlock'
	],
	#category : 'TypeInfoTools-Structure',
	#package : 'TypeInfoTools',
	#tag : 'Structure'
}

{ #category : 'visiting' }
TITBlockTemporaryVariable >> accept: anInferenceToolAdaptor [

	^ anInferenceToolAdaptor visitBlockTemporaryVariable: self
]

{ #category : 'accessing' }
TITBlockTemporaryVariable >> block [

	^ block
]

{ #category : 'accessing' }
TITBlockTemporaryVariable >> block: anObject [

	block := anObject
]

{ #category : 'accessing' }
TITBlockTemporaryVariable >> classDescription [

	^ 'Block-level temporary variable'
]

{ #category : 'accessing' }
TITBlockTemporaryVariable >> parent [

	^ self block
]
