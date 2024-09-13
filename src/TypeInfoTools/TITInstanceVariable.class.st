Class {
	#name : 'TITInstanceVariable',
	#superclass : 'TITVariable',
	#instVars : [
		'#ownerClass => ToOneRelationSlot inverse: #instanceVariables inClass: #TITClass'
	],
	#category : 'TypeInfoTools-Structure',
	#package : 'TypeInfoTools',
	#tag : 'Structure'
}

{ #category : 'visiting' }
TITInstanceVariable >> accept: anInferenceToolAdaptor [

	^ anInferenceToolAdaptor visitInstanceVariable: self
]

{ #category : 'accessing' }
TITInstanceVariable >> ownerClass [

	^ ownerClass
]

{ #category : 'accessing' }
TITInstanceVariable >> ownerClass: anObject [

	ownerClass := anObject
]

{ #category : 'accessing' }
TITInstanceVariable >> parent [

	^ self ownerClass
]
