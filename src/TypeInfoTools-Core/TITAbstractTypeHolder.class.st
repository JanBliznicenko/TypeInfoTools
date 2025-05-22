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

{ #category : 'copying' }
TITAbstractTypeHolder >> , anotherHolder [

	^ self subclassResponsibility
]

{ #category : 'adding' }
TITAbstractTypeHolder >> addValue: aValue [

	self subclassResponsibility
]

{ #category : 'adding' }
TITAbstractTypeHolder >> copyWithCollectionTypeHolder: anotherTypeHolder [

	^ self copyWithTypeHolder: anotherTypeHolder
]

{ #category : 'adding' }
TITAbstractTypeHolder >> copyWithDictionaryTypeHolder: anotherTypeHolder [

	^ self copyWithCollectionTypeHolder: anotherTypeHolder
]

{ #category : 'adding' }
TITAbstractTypeHolder >> copyWithKeyValueTypeHolder: anotherTypeHolder [

	^ self copyWithTypeHolder: anotherTypeHolder
]

{ #category : 'adding' }
TITAbstractTypeHolder >> copyWithTypeHolder: anotherTypeHolder [

	^ self subclassResponsibility
]

{ #category : 'private' }
TITAbstractTypeHolder >> mergeTypes [

	
]

{ #category : 'as yet unclassified' }
TITAbstractTypeHolder >> threeWayCompareTo: aTypeHolder [

	^ self subclassResponsibility
]

{ #category : 'as yet unclassified' }
TITAbstractTypeHolder >> threeWayCompareToEmpty: anEmptyTypeHolder [

	^ self subclassResponsibility
]

{ #category : 'as yet unclassified' }
TITAbstractTypeHolder >> threeWayCompareToTypeHolder: aTypeHolder [

	^ self subclassResponsibility
]

{ #category : 'instance creation' }
TITAbstractTypeHolder >> withValue: aValue [

	^ self subclassResponsibility
]
