Class {
	#name : 'TITTypesCollection',
	#superclass : 'Object',
	#instVars : [
		'classes',
		'byCounts',
		'prioritizedClasses'
	],
	#category : 'TypeInfoTools-Inference',
	#package : 'TypeInfoTools',
	#tag : 'Inference'
}

{ #category : 'adding' }
TITTypesCollection >> addClass: aClass [

	classes add: aClass.
	byCounts := nil
]

{ #category : 'adding' }
TITTypesCollection >> addClasses: aCollection [

	aCollection do: [ :each | self addClass: each ]
]

{ #category : 'adding' }
TITTypesCollection >> byCounts [

	byCounts ifNil: [
		| countsAndClasses |
		countsAndClasses := Dictionary new.
		classes associationsDo: [ :classAndCount |
			countsAndClasses at: classAndCount value ifAbsentPut: [
				(SortedCollection sortUsing: [ :a :b | a name < b name ]) add:
					classAndCount key ] ].
		byCounts := countsAndClasses associations sortedAs: [ :each |
			            each key ] ].
	^ byCounts
]

{ #category : 'adding' }
TITTypesCollection >> classes [

	^ classes asSet
]

{ #category : 'adding' }
TITTypesCollection >> collect: aBlock [

	^ classes valuesAndCounts collect: [ :pair | aBlock value: pair key ]
]

{ #category : 'adding' }
TITTypesCollection >> do: aBlock [

	^ classes doWithOccurrences: [ :key :value | aBlock value: key ]
]

{ #category : 'initialization' }
TITTypesCollection >> initialize [

	super initialize.
	classes := IdentityBag new
]

{ #category : 'adding' }
TITTypesCollection >> lessProbableClasses [

	Array streamContents: [ :s |
		s addAll:
			((self byCounts first value asSet difference: prioritizedClasses)
				 sorted: [ :a :b | a name < b name ]).
		self byCounts allButFirst do: [ :each |
			s addAll: (each value sorted: [ :a :b | a name < b name ]) ] ]
]

{ #category : 'adding' }
TITTypesCollection >> mostProbableClasses [

	^ self mostProbableClassesSet asSortedCollection: [ :a :b |
		  a name < b name ]
]

{ #category : 'adding' }
TITTypesCollection >> mostProbableClassesSet [

	^ self byCounts first value asSet intersection: prioritizedClasses
]

{ #category : 'adding' }
TITTypesCollection >> prioritizedClasses: aCollection [

	prioritizedClasses := aCollection asSet
]

{ #category : 'adding' }
TITTypesCollection >> select: aBlock [

	^ classes valuesAndCounts select: [ :pair | aBlock value: pair key ]
]
