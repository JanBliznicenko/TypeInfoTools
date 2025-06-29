Class {
	#name : 'TITTypeHolder',
	#superclass : 'TITAbstractTypeHolder',
	#instVars : [
		'types'
	],
	#category : 'TypeInfoTools-Dev-RealTime',
	#package : 'TypeInfoTools-Dev',
	#tag : 'RealTime'
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

{ #category : 'converting' }
TITTypeHolder >> convertTypesToClass [

	self types: (types
			 collect: [ :each |
					 each isString
						 ifTrue: [
								 [
									 (each endsWith: ' class')
										 ifTrue: [
										 (Smalltalk at: (each allButLast: 6) asSymbol) class ]
										 ifFalse: [ Smalltalk at: each asSymbol ] ]
									 on: KeyNotFound
									 do: [ :e | nil ] ]
						 ifFalse: [ each ] ]
			 thenSelect: [ :each | each isNotNil ])
]

{ #category : 'converting' }
TITTypeHolder >> convertTypesToString [

	self types: (types collect: [ :each |
				 each isSymbol
					 ifTrue: [ each ]
					 ifFalse: [
							 each isString
								 ifTrue: [ each asSymbol ]
								 ifFalse: [ each name asSymbol ] ] ])
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
	types := IdentitySet new
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
			(commonSuper ~= Object and: [
				 commonSuper ~= ProtoObject and: [ commonSuper isNotNil ] ])
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
	merged := IdentityBag new.
	(IdentityBag withAll: types) doWithOccurrences: [ :type :occurences |
		self mergeType: type occurences: occurences into: merged ].
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

	^ (self class newBestWithClass: aValue class)
		  replaceFrom: self;
		  addValue: aValue;
		  yourself
]
