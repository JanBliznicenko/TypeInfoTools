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
TITStructureNode >> classDescription [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
TITStructureNode >> longDescription [

	^ self shortDescription , ' in ' , self parent shortDescription
]

{ #category : 'accessing' }
TITStructureNode >> name [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
TITStructureNode >> package [

	^ self parent package
]

{ #category : 'accessing' }
TITStructureNode >> parent [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
TITStructureNode >> shortDescription [

	^ self classDescription , ' "' , self name , '"'
]
