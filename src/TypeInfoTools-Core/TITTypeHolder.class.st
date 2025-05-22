Class {
	#name : 'TITTypeHolder',
	#superclass : 'TITAbstractTypeHolder',
	#instVars : [
		'types'
	],
	#category : 'TypeInfoTools-Core-RealTime',
	#package : 'TypeInfoTools-Core',
	#tag : 'RealTime'
}

{ #category : 'testing' }
TITTypeHolder class >> acceptsClass: aClass [

	^ true
]

{ #category : 'instance creation' }
TITTypeHolder class >> newFrom: aTypeHolder andValue: aValue [

	^ self new
		  replaceFrom: aTypeHolder;
		  addValue: aValue;
		  yourself
]

{ #category : 'adding' }
TITTypeHolder >> addValue: aValue [

	types add: aValue class
]

{ #category : 'initialization' }
TITTypeHolder >> initialize [

	super initialize.
	types := Bag new
]

{ #category : 'inspecting' }
TITTypeHolder >> inspectionItems: aBuilder [

	<inspectorPresentationOrder: 0 title: 'Items'>
	^ types inspectionItems: aBuilder
]

{ #category : 'printing' }
TITTypeHolder >> printOn: aStream [

	super printOn: aStream.
	aStream nextPutAll: ' ('.
	types printElementsOn: aStream.
	aStream nextPut: $)
]

{ #category : 'adding' }
TITTypeHolder >> replaceFrom: anotherHolder [

	types := anotherHolder types
]

{ #category : 'accessing' }
TITTypeHolder >> types [

	^ types
]

{ #category : 'instance creation' }
TITTypeHolder >> withValue: aValue [

	(self class acceptsClass: aValue class) ifFalse: [
		^ self class superclass newFrom: self andValue: aValue ].
	self addValue: aValue.
	^ self
]
