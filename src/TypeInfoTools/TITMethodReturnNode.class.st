Class {
	#name : 'TITMethodReturnNode',
	#superclass : 'TITTypedNode',
	#instVars : [
		'#method => ToOneRelationSlot inverse: #returnNode inClass: #TITMethod'
	],
	#category : 'TypeInfoTools-Structure',
	#package : 'TypeInfoTools',
	#tag : 'Structure'
}

{ #category : 'visiting' }
TITMethodReturnNode >> accept: anInferenceToolAdaptor [

	^ anInferenceToolAdaptor visitMethodReturn: self
]

{ #category : 'accessing' }
TITMethodReturnNode >> method [

	^ method
]

{ #category : 'accessing' }
TITMethodReturnNode >> method: anObject [

	method := anObject
]

{ #category : 'accessing' }
TITMethodReturnNode >> ownerClass [

	^ self method ownerClass
]

{ #category : 'accessing' }
TITMethodReturnNode >> parent [

	^ self method
]
