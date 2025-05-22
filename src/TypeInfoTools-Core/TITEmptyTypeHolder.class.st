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

{ #category : 'adding' }
TITEmptyTypeHolder >> addValue: aValue [

	aValue ifNotNil: [
		self error: self className , ' cannot hold any value' ]
]

{ #category : 'instance creation' }
TITEmptyTypeHolder >> withValue: aValue [

	^ TITTypeHolder newBestForValue: aValue
]
