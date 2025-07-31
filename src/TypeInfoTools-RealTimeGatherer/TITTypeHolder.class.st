Class {
	#name : 'TITTypeHolder',
	#superclass : 'TITAbstractTypeHolder',
	#instVars : [
		'types'
	],
	#category : 'TypeInfoTools-RealTimeGatherer-Structure',
	#package : 'TypeInfoTools-RealTimeGatherer',
	#tag : 'Structure'
}

{ #category : 'testing' }
TITTypeHolder class >> acceptsClass: aClass [

	^ true
]

{ #category : 'accessing' }
TITTypeHolder class >> priority [

	^ 50
]

{ #category : 'copying' }
TITTypeHolder >> , anotherHolder [

	^ anotherHolder copyWithTypeHolder: self
]

{ #category : 'adding' }
TITTypeHolder >> addType: aClass [

	types add: aClass
]

{ #category : 'adding' }
TITTypeHolder >> addValue: aValue [

	| class |
	aValue ifNil: [ ^ self ].
	class := aValue class.
	class ifNil: [ ^ self ].
	class = Object ifTrue: [ ^ self ].
	class = ProtoObject ifTrue: [ ^ self ].
	self addType: (TITTypesCollection afterClassReplacement: class)
]

{ #category : 'adding' }
TITTypeHolder >> copyWithTypeHolder: anotherTypeHolder [

	^ self class new
		  types: types , anotherTypeHolder types;
		  yourself
]

{ #category : 'instance creation' }
TITTypeHolder >> fromSton: stonReader [

	stonReader parseMapDo: [ :instVarName :value |
			| resolved |
			resolved := value isStonReference
				            ifTrue: [
						            instVarName = #types
							            ifTrue: [ stonReader resolveReference: value ]
							            ifFalse: [ stonReader resolveReference: value ] ]
				            ifFalse: [ value ].
			self instVarNamed: instVarName asSymbol put: resolved ]
]

{ #category : 'initialization' }
TITTypeHolder >> initialize [

	super initialize.
	types := IdentitySet new
]

{ #category : 'inspecting' }
TITTypeHolder >> inspectionItems: aBuilder [

	<inspectorPresentationOrder: 0 title: 'Items'>
	^ types inspectionItems: aBuilder
]

{ #category : 'private' }
TITTypeHolder >> mergeTypes [

	| merged |
	merged := IdentityBag new.
	(IdentityBag withAll: types) doWithOccurrences: [ :type :occurences |
		merged add: type withOccurrences: occurences ].
	self types: merged
]

{ #category : 'printing' }
TITTypeHolder >> printOn: aStream [

	| associations |
	associations := types asBag valuesAndCounts associations.
	associations sort: [ :c1 :c2 | c1 value > c2 value ].

	super printOn: aStream.
	aStream nextPutAll: ' ('.
	associations
		do: [ :pair | aStream nextPutAll: pair key asString ]
		separatedBy: [ aStream space ].
	aStream nextPut: $)
]

{ #category : 'adding' }
TITTypeHolder >> replaceFrom: anotherHolder [

	self types: anotherHolder types
]

{ #category : 'private' }
TITTypeHolder >> size [

	^ types size
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

	^ self class newFrom: self withValue: aValue
]
