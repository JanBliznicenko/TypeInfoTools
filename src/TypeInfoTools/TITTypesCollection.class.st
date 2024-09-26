Class {
	#name : 'TITTypesCollection',
	#superclass : 'Object',
	#instVars : [
		'classes',
		'byCounts',
		'prioritizedClasses',
		'mostProbableClasses',
		'lessProbableClasses'
	],
	#category : 'TypeInfoTools-Inference',
	#package : 'TypeInfoTools',
	#tag : 'Inference'
}

{ #category : 'adding' }
TITTypesCollection >> addClass: aClass [

	classes add: aClass.
	self resetCaches.
]

{ #category : 'adding' }
TITTypesCollection >> addClasses: aCollection [

	aCollection do: [ :each | self addClass: each ]
]

{ #category : 'adding' }
TITTypesCollection >> allByProbability [

	^ self mostProbableClasses , self lessProbableClasses
]

{ #category : 'adding' }
TITTypesCollection >> byCounts [

	byCounts ifNil: [ self calculateByCounts ].
	^ byCounts
]

{ #category : 'adding' }
TITTypesCollection >> calculateByCounts [

	| countsAndClasses |
	countsAndClasses := Dictionary new.
	classes associationsDo: [ :classAndCount |
		countsAndClasses at: classAndCount value ifAbsentPut: [
			(SortedCollection sortUsing: [ :a :b | a name < b name ])
				add: classAndCount key;
				yourself ] ].
	^ byCounts := countsAndClasses associations sorted: [ :a :b |
		              a key > b key ]
]

{ #category : 'adding' }
TITTypesCollection >> calculateByProbability [

	| topCountPrioritized topCountOthers |
	self byCounts ifEmpty: [
		mostProbableClasses := Array new.
		lessProbableClasses := Array new.
		^ self ].
	topCountPrioritized := Array streamContents: [ :prioritizedStream |
		                       topCountOthers := Array streamContents: [
			                                         :othersStream |
			                                         self byCounts first value
				                                         do: [ :each |
					                                         ((prioritizedClasses
						                                           includes: each)
						                                          ifTrue: [
						                                          prioritizedStream ]
						                                          ifFalse: [
						                                          othersStream ])
						                                         nextPut: each ] ] ].

	topCountPrioritized
		ifEmpty: [
			mostProbableClasses := topCountOthers.
			topCountOthers := Array new ]
		ifNotEmpty: [ mostProbableClasses := topCountPrioritized ].

	lessProbableClasses := Array streamContents: [ :lessProbableStream |
		                       lessProbableStream nextPutAll: topCountOthers.
		                       self byCounts allButFirstDo: [ :each |
			                       lessProbableStream nextPutAll: each value ] ]
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
	classes := IdentityBag new.
	prioritizedClasses := Set new
]

{ #category : 'testing' }
TITTypesCollection >> isEmpty [

	^ classes isEmpty
]

{ #category : 'adding' }
TITTypesCollection >> lessProbableClasses [

	lessProbableClasses ifNil: [ self calculateByProbability ].
	^ lessProbableClasses
]

{ #category : 'adding' }
TITTypesCollection >> mostProbableClasses [

	mostProbableClasses ifNil: [ self calculateByProbability ].
	^ mostProbableClasses
]

{ #category : 'adding' }
TITTypesCollection >> prioritizedClasses: aCollection [

	prioritizedClasses := aCollection asSet.
	lessProbableClasses := nil.
	mostProbableClasses := nil
]

{ #category : 'adding' }
TITTypesCollection >> resetCaches [

	byCounts := nil.
	mostProbableClasses := nil.
	lessProbableClasses := nil
]

{ #category : 'adding' }
TITTypesCollection >> select: aBlock [

	^ classes valuesAndCounts select: [ :pair | aBlock value: pair key ]
]

{ #category : 'adding' }
TITTypesCollection >> setOrIntersectWithPrioritizedClasses: aCollection [

	self prioritizedClasses:
		((prioritizedClasses intersection: aCollection) ifEmpty: [
			 prioritizedClasses , aCollection ])
]
