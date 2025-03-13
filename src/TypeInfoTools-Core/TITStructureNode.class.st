Class {
	#name : 'TITStructureNode',
	#superclass : 'Object',
	#category : 'TypeInfoTools-Core-Structure',
	#package : 'TypeInfoTools-Core',
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

	^ String streamContents: [ :s |
		  s << self shortDescription.
		  self parent shortDescriptionJoinedBy: ' in ' to: s ]
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

{ #category : 'accessing' }
TITStructureNode >> shortDescriptionJoinedBy: aString to: aStream [

	^ aStream << aString << self shortDescription uncapitalized
]
