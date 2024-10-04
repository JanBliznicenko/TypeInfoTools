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
TITMethodReturnNode >> classDescription [

	^ 'Returned value'
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
TITMethodReturnNode >> name [

	^ '^'
]

{ #category : 'accessing' }
TITMethodReturnNode >> ownerClass [

	^ self method ownerClass
]

{ #category : 'accessing' }
TITMethodReturnNode >> parent [

	^ self method
]

{ #category : 'accessing' }
TITMethodReturnNode >> realClass [

	^ self method realClass
]

{ #category : 'accessing' }
TITMethodReturnNode >> shortDescription [

	^ self classDescription
]
