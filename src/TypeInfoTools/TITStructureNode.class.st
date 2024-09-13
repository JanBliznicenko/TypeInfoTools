Class {
	#name : 'TITStructureNode',
	#superclass : 'Object',
	#category : 'TypeInfoTools-Structure',
	#package : 'TypeInfoTools',
	#tag : 'Structure'
}

{ #category : 'visiting' }
TITStructureNode >> accept: anInferenceToolAdaptor [

	self subclassResponsibility
]

{ #category : 'accessing' }
TITStructureNode >> package [

	^ self parent package
]

{ #category : 'accessing' }
TITStructureNode >> parent [

	^ self subclassResponsibility
]
