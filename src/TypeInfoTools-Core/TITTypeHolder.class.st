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
TITTypeHolder class >> newFrom: aTypeHolder [

	^ self new
		  replaceFrom: aTypeHolder;
		  yourself
]

{ #category : 'copying' }
TITTypeHolder >> , anotherHolder [

	^ anotherHolder copyWithTypeHolder: self
]

{ #category : 'adding' }
TITTypeHolder >> addValue: aValue [

	aValue ifNil: [ ^ self ].
	aValue class = Object ifTrue: [ ^ self ].
	aValue class = ProtoObject ifTrue: [ ^ self ].
	types add: (TITTypesCollection afterClassReplacement: aValue class)
]

{ #category : 'adding' }
TITTypeHolder >> copyWithTypeHolder: anotherTypeHolder [

	^ self class new
		  types: types , anotherTypeHolder types;
		  yourself
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

{ #category : 'private' }
TITTypeHolder >> mergeType: type occurences: occurences into: merged [

	| commonSuper |
	merged doWithOccurrences: [ :mergedType :mergedOccurences |
			commonSuper := type commonSuperclassSymmetricWith: mergedType.
			(commonSuper ~= Object and: [ commonSuper ~= ProtoObject ])
				ifTrue: [
						merged removeKey: mergedType ifAbsent: [ self error ].
						merged
							add: commonSuper
							withOccurrences: occurences + mergedOccurences.
						^ self ] ].
	merged add: type withOccurrences: occurences
]

{ #category : 'private' }
TITTypeHolder >> mergeTypes [

	| merged |
	merged := Bag new.
	types doWithOccurrences: [ :type :occurences |
		self mergeType: type occurences: occurences into: merged ].
	types := merged
]

{ #category : 'printing' }
TITTypeHolder >> printOn: aStream [

	| associations |
	associations := types valuesAndCounts associations.
	associations sort: [ :c1 :c2 | c1 value > c2 value ].

	super printOn: aStream.
	aStream nextPutAll: ' ('.
	associations
		do: [ :pair | aStream nextPutAll: pair key name ]
		separatedBy: [ aStream space ].
	aStream nextPut: $)
]

{ #category : 'adding' }
TITTypeHolder >> replaceFrom: anotherHolder [

	types := anotherHolder types
]

{ #category : 'comparing' }
TITTypeHolder >> threeWayCompareTo: aTypeHolder [

	^ aTypeHolder threeWayCompareToTypeHolder: self
]

{ #category : 'comparing' }
TITTypeHolder >> threeWayCompareToEmpty: anEmptyTypeHolder [

	^ 1
]

{ #category : 'comparing' }
TITTypeHolder >> threeWayCompareToTypeHolder: aTypeHolder [

	^ types size threeWayCompareTo: aTypeHolder types size
]

{ #category : 'accessing' }
TITTypeHolder >> types [

	^ types
]

{ #category : 'adding' }
TITTypeHolder >> types: aCollection [

	types := aCollection
]

{ #category : 'instance creation' }
TITTypeHolder >> withValue: aValue [

	| holder |
	holder := (self class acceptsClass: aValue class)
		          ifTrue: [ self ]
		          ifFalse: [ self class superclass newFrom: self ].
	holder addValue: aValue.
	^ holder
]
