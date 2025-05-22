Class {
	#name : 'TITAbstractTypeHolder',
	#superclass : 'Object',
	#category : 'TypeInfoTools-Core-RealTime',
	#package : 'TypeInfoTools-Core',
	#tag : 'RealTime'
}

{ #category : 'testing' }
TITAbstractTypeHolder class >> acceptsClass: aClass [

	^ self subclassResponsibility
]

{ #category : 'instance creation' }
TITAbstractTypeHolder class >> newBestForValue: aValue [

	| class |
	class := {
		         TITEmptyTypeHolder.
		         TITKeyValueTypeHolder.
		         TITDictionaryTypeHolder.
		         TITCollectionTypeHolder.
		         TITTypeHolder } detect: [ :any |
		         any acceptsClass: aValue class ].
	^ class newWithValue: aValue
]

{ #category : 'instance creation' }
TITAbstractTypeHolder class >> newWithValue: anObject [

	^ self new
		  addValue: anObject;
		  yourself
]

{ #category : 'adding' }
TITAbstractTypeHolder >> addValue: aValue [

	self subclassResponsibility
]

{ #category : 'instance creation' }
TITAbstractTypeHolder >> withValue: aValue [

	^ self subclassResponsibility
]
