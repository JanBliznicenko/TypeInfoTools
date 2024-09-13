Class {
	#name : 'TITTypesCollection',
	#superclass : 'Object',
	#instVars : [
		'classes',
		'byCounts'
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

	classes do: [ :each | self addClass: each ]
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
		byCounts := countsAndClasses sortedAs: [ :each | each key ] ].
	^ byCounts
]

{ #category : 'initialization' }
TITTypesCollection >> initialize [

	super initialize.
	classes := IdentityBag new
]
