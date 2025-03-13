Class {
	#name : 'TITNoNode',
	#superclass : 'TITStructureNode',
	#category : 'TypeInfoTools-Core-Structure',
	#package : 'TypeInfoTools-Core',
	#tag : 'Structure'
}

{ #category : 'visiting' }
TITNoNode >> accept: anInferenceToolAdaptor [
	"do nothing"

	
]

{ #category : 'accessing' }
TITNoNode >> classDescription [

	^ ''
]

{ #category : 'accessing' }
TITNoNode >> name [

	^ ''
]

{ #category : 'accessing' }
TITNoNode >> parent [

	self notify:
		'Do not ask for parent of "No" node, as you might get an infinite loop'.
	^ self
]

{ #category : 'accessing' }
TITNoNode >> shortDescription [

	^ ''
]
