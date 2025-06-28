Class {
	#name : 'TITAbstractTypeHolder',
	#superclass : 'Object',
	#category : 'TypeInfoTools-Dev-RealTime',
	#package : 'TypeInfoTools-Dev',
	#tag : 'RealTime'
}

{ #category : 'testing' }
TITAbstractTypeHolder class >> acceptsClass: aClass [

	^ self subclassResponsibility
]

{ #category : 'instance creation' }
TITAbstractTypeHolder class >> newBestForClasses: aCollectionOfClasses [

	^ ((self withAllSubclasses sortedAs: [ :each | each priority ])
		   detect: [ :any |
				   any priority > 0 and: [
						   aCollectionOfClasses allSatisfy: [ :eachType |
							   any acceptsClass: eachType ] ] ]) new
]

{ #category : 'instance creation' }
TITAbstractTypeHolder class >> newBestForValue: aValue [

	^ self newBestForClasses: { aValue class }
]

{ #category : 'instance creation' }
TITAbstractTypeHolder class >> newBestWithValue: aValue [

	^ (self newBestForValue: aValue)
		  addValue: aValue;
		  yourself
]

{ #category : 'accessing' }
TITAbstractTypeHolder class >> priority [

	^ -1
]

{ #category : 'copying' }
TITAbstractTypeHolder >> , anotherHolder [

	^ self subclassResponsibility
]

{ #category : 'adding' }
TITAbstractTypeHolder >> addValue: aValue [

	self subclassResponsibility
]

{ #category : 'converting' }
TITAbstractTypeHolder >> convertTypesToClass [
	"do nothing"

	
]

{ #category : 'converting' }
TITAbstractTypeHolder >> convertTypesToString [
	"do nothing"

	
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

{ #category : 'adding' }
TITAbstractTypeHolder >> replaceFrom: anotherHolder [

	self subclassResponsibility
]

{ #category : 'private' }
TITAbstractTypeHolder >> size [

	^ self subclassResponsibility
]

{ #category : 'comparing' }
TITAbstractTypeHolder >> threeWayCompareTo: aTypeHolder [

	^ self subclassResponsibility
]

{ #category : 'comparing' }
TITAbstractTypeHolder >> threeWayCompareToEmpty: anEmptyTypeHolder [

	^ self subclassResponsibility
]

{ #category : 'comparing' }
TITAbstractTypeHolder >> threeWayCompareToTypeHolder: aTypeHolder [

	^ self subclassResponsibility
]

{ #category : 'instance creation' }
TITAbstractTypeHolder >> withValue: aValue [

	^ self subclassResponsibility
]
