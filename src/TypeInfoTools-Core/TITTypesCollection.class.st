Class {
	#name : 'TITTypesCollection',
	#superclass : 'Object',
	#instVars : [
		'typeInfo',
		'classes',
		'sortedClasses'
	],
	#category : 'TypeInfoTools-Core-Inference',
	#package : 'TypeInfoTools-Core',
	#tag : 'Inference'
}

{ #category : 'as yet unclassified' }
TITTypesCollection class >> forTypeInfo: aTypeInfo [

	^ self new
		  typeInfo: aTypeInfo;
		  yourself
]

{ #category : 'adding' }
TITTypesCollection >> addClass: aClass by: aTypeCollector [

	aClass = Object ifTrue: [ ^ self ].
	(classes at: aClass ifAbsentPut: [ TITTypesCollectionSources new ])
		add: aTypeCollector.
	self resetCache
]

{ #category : 'adding' }
TITTypesCollection >> addClasses: aCollection by: aTypeCollector [

	aCollection ifEmpty: [ ^ self ].
	aCollection do: [ :each | self addClass: each by: aTypeCollector ]
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
	classes := Dictionary new
]

{ #category : 'testing' }
TITTypesCollection >> isEmpty [

	^ self sortedClasses isEmpty
]

{ #category : 'testing' }
TITTypesCollection >> isNotEmpty [

	^ self isEmpty not
]

{ #category : 'adding' }
TITTypesCollection >> minimumWeight [

	^ 0.99
]

{ #category : 'adding' }
TITTypesCollection >> resetCache [

	sortedClasses := nil
]

{ #category : 'adding' }
TITTypesCollection >> select: aBlock [

	^ classes valuesAndCounts select: [ :pair | aBlock value: pair key ]
]

{ #category : 'adding' }
TITTypesCollection >> sortedClasses [

	sortedClasses ifNotNil: [ ^ sortedClasses ].
	(typeInfo types == self and: [
		 typeInfo collectionElementTypes sortedClasses isNotEmpty ])
		ifTrue: [
			classes associationsDo: [ :each |
				(each key isCollectionClass and: [
					 (each key includesBehavior: String) not ]) ifTrue: [
					each value add: TITCollectionElementTypesFoundMarker new ] ] ].
	^ sortedClasses := ((classes associations select: [ :eachPair |
		                     eachPair value weight >= self minimumWeight ]) sorted: [ :a :b |
		                    a value weight > b value weight ])
		                   asOrderedDictionary
]

{ #category : 'accessing' }
TITTypesCollection >> typeInfo: aTypeInfo [

	typeInfo := aTypeInfo
]
