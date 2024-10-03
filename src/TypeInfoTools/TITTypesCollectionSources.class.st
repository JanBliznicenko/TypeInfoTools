Class {
	#name : 'TITTypesCollectionSources',
	#superclass : 'Object',
	#instVars : [
		'collectors',
		'weight'
	],
	#category : 'TypeInfoTools-Inference',
	#package : 'TypeInfoTools',
	#tag : 'Inference'
}

{ #category : 'adding' }
TITTypesCollectionSources >> add: aCollector [

	collectors addIfNotPresent: aCollector.
	weight := nil
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

{ #category : 'accessing' }
TITTypesCollectionSources >> weight [

	^ weight ifNil: [
		  weight := collectors sumNumbers: [ :each | each weight ] ]
]
