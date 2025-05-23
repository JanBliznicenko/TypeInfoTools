Class {
	#name : 'TITTypesCollectionSources',
	#superclass : 'Object',
	#traits : 'TComparable',
	#classTraits : 'TComparable classTrait',
	#instVars : [
		'collectors',
		'weight'
	],
	#category : 'TypeInfoTools-Core-Inference',
	#package : 'TypeInfoTools-Core',
	#tag : 'Inference'
}

{ #category : 'comparing' }
TITTypesCollectionSources >> < aComparable [
	"Answer whether the receiver is less than the argument."

	^ self weight > aComparable weight
]

{ #category : 'comparing' }
TITTypesCollectionSources >> = aComparable [
	"Compare the receiver with the argument and answer with true if the
	receiver is equal to the argument. Otherwise answer false."

	^ self collectors = aComparable collectors
]

{ #category : 'adding' }
TITTypesCollectionSources >> add: aCollector [

	collectors addIfNotPresent: aCollector.
	weight := nil
]

{ #category : 'accessing' }
TITTypesCollectionSources >> collectors [

	^ collectors
]

{ #category : 'enumerating' }
TITTypesCollectionSources >> do: aBlock [

	^ collectors do: aBlock
]

{ #category : 'testing' }
TITTypesCollectionSources >> includesCollector: aCollector [

	^ collectors includes: aCollector
]

{ #category : 'initialization' }
TITTypesCollectionSources >> initialize [

	super initialize.
	collectors := SortedCollection sortBlock: [ :a :b |
		              a weight > b weight or: [
			              a weight = b weight and: [
				              a sourceName < b sourceName ] ] ]
]

{ #category : 'printing' }
TITTypesCollectionSources >> printOn: aStream [

	^ collectors
		  do: [ :each | aStream nextPutAll: each sourceName ]
		  separatedBy: [ aStream nextPutAll: ', ' ]
]

{ #category : 'comparing' }
TITTypesCollectionSources >> threeWayCompareTo: otherSources [

	| weightComparison |
	weightComparison := (self weight threeWayCompareTo:
		                     otherSources weight) negated.
	weightComparison isZero ifFalse: [ ^ weightComparison ].
	^ self collectors ifEmpty: [ 0 ] ifNotEmpty: [ :existingCollectors |
			  existingCollectors first sourceName threeWayCompareTo:
				  otherSources collectors first sourceName ]
]

{ #category : 'accessing' }
TITTypesCollectionSources >> weight [

	^ weight ifNil: [
		  weight := collectors sumNumbers: [ :each | each weight ] ]
]
