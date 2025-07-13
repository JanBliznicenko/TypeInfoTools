Class {
	#name : 'TITAbstractTypeHolder',
	#superclass : 'Object',
	#classInstVars : [
		'withAllSubclassesByPriority',
		'withMoreGeneralClasses'
	],
	#category : 'TypeInfoTools-Dev-RealTime',
	#package : 'TypeInfoTools-Dev',
	#tag : 'RealTime'
}

{ #category : 'testing' }
TITAbstractTypeHolder class >> acceptsClass: aClass [

	^ self subclassResponsibility
]

{ #category : 'instance creation' }
TITAbstractTypeHolder class >> newAccomodatingOwnInstanceAndClass: aClass [

	^ (self withMoreGeneralClasses detect: [ :any |
		   any acceptsClass: aClass ]) new
]

{ #category : 'instance creation' }
TITAbstractTypeHolder class >> newFrom: aHolder withValue: aValue [

	^ (self newAccomodatingOwnInstanceAndClass: aValue class)
		  replaceFrom: aHolder;
		  addValue: aValue;
		  yourself
]

{ #category : 'instance creation' }
TITAbstractTypeHolder class >> newMostPreciseForClass: aClass [

	^ (self withAllSubclassesByPriority detect: [ :any |
		   any acceptsClass: aClass ]) new
]

{ #category : 'instance creation' }
TITAbstractTypeHolder class >> newMostPreciseForValue: aValue [

	^ (self newMostPreciseForClass: aValue class)
		  addValue: aValue;
		  yourself
]

{ #category : 'accessing' }
TITAbstractTypeHolder class >> priority [

	^ -1
]

{ #category : 'instance creation' }
TITAbstractTypeHolder class >> withAllSubclassesByPriority [

	^ withAllSubclassesByPriority ifNil: [
			  withAllSubclassesByPriority := (self withAllSubclasses select: [
				                                  :any | any priority > 0 ])
				                                 sortedAs: [ :each |
				                                 each priority ] ]
]

{ #category : 'accessing' }
TITAbstractTypeHolder class >> withMoreGeneralClasses [

	| foundClasses nextSuperClass |
	withMoreGeneralClasses ifNotNil: [ ^ withMoreGeneralClasses ].
	foundClasses := OrderedCollection with: self.
	[
		nextSuperClass := foundClasses last superclass.
		nextSuperClass = TITAbstractTypeHolder ] whileFalse: [
		foundClasses add: nextSuperClass ].
	^ withMoreGeneralClasses := foundClasses
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
