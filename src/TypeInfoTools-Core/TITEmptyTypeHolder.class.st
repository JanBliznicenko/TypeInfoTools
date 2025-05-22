Class {
	#name : 'TITEmptyTypeHolder',
	#superclass : 'TITAbstractTypeHolder',
	#category : 'TypeInfoTools-Core-RealTime',
	#package : 'TypeInfoTools-Core',
	#tag : 'RealTime'
}

{ #category : 'testing' }
TITEmptyTypeHolder class >> acceptsClass: aClass [

	^ aClass == UndefinedObject
]

{ #category : 'copying' }
TITEmptyTypeHolder >> , anotherHolder [

	^ anotherHolder
]

{ #category : 'adding' }
TITEmptyTypeHolder >> addValue: aValue [

	aValue ifNotNil: [
		self error: self className , ' cannot hold any value' ]
]

{ #category : 'adding' }
TITEmptyTypeHolder >> copyWithTypeHolder: anotherTypeHolder [

	^ anotherTypeHolder
]

{ #category : 'as yet unclassified' }
TITEmptyTypeHolder >> threeWayCompareTo: aTypeHolder [

	^ aTypeHolder threeWayCompareToEmpty: self
]

{ #category : 'as yet unclassified' }
TITEmptyTypeHolder >> threeWayCompareToEmpty: anEmptyTypeHolder [

	^ 0
]

{ #category : 'as yet unclassified' }
TITEmptyTypeHolder >> threeWayCompareToTypeHolder: aTypeHolder [

	^ -1
]

{ #category : 'instance creation' }
TITEmptyTypeHolder >> withValue: aValue [

	^ TITTypeHolder newBestForValue: aValue
]
