Class {
	#name : 'TITTypesCollection',
	#superclass : 'Object',
	#instVars : [
		'typeInfo',
		'sortedClasses',
		'classesWithCollectors'
	],
	#category : 'TypeInfoTools-Core-Inference',
	#package : 'TypeInfoTools-Core',
	#tag : 'Inference'
}

{ #category : 'instance creation' }
TITTypesCollection class >> forTypeInfo: aTypeInfo [

	^ self new
		  typeInfo: aTypeInfo;
		  yourself
]

{ #category : 'adding' }
TITTypesCollection >> addAllFrom: otherTypesCollection [

	otherTypesCollection classesWithCollectors keysAndValuesDo: [
		:class
		:collectors |
		collectors do: [ :collector | self addClass: class by: collector ] ]
]

{ #category : 'adding' }
TITTypesCollection >> addClass: aClass by: aTypeCollector [

	aClass = Object ifTrue: [ ^ self ].
	(classesWithCollectors at: aClass ifAbsentPut: [ TITTypesCollectionSources new ])
		add: aTypeCollector.
	self resetCache
]

{ #category : 'adding' }
TITTypesCollection >> addClasses: aCollection by: aTypeCollector [

	aCollection ifEmpty: [ ^ self ].
	aCollection do: [ :each | self addClass: each by: aTypeCollector ]
]

{ #category : 'adding' }
TITTypesCollection >> classesWithCollectors [

	^ classesWithCollectors
]

{ #category : 'accessing' }
TITTypesCollection >> classesWithCollectors: anObject [

	classesWithCollectors := anObject
]

{ #category : 'adding' }
TITTypesCollection >> collect: aBlock [

	^ classesWithCollectors valuesAndCounts collect: [ :pair | aBlock value: pair key ]
]

{ #category : 'adding' }
TITTypesCollection >> do: aBlock [

	^ classesWithCollectors doWithOccurrences: [ :key :value | aBlock value: key ]
]

{ #category : 'initialization' }
TITTypesCollection >> initialize [

	super initialize.
	classesWithCollectors := Dictionary new
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

{ #category : 'printing' }
TITTypesCollection >> printOn: aStream [

	super printOn: aStream.
	aStream nextPutAll: '('.
	aStream nextPutAll: self size asString.
	aStream nextPutAll: ')'
]

{ #category : 'adding' }
TITTypesCollection >> resetCache [

	sortedClasses := nil
]

{ #category : 'adding' }
TITTypesCollection >> select: aBlock [

	^ classesWithCollectors valuesAndCounts select: [ :pair | aBlock value: pair key ]
]

{ #category : 'adding' }
TITTypesCollection >> size [

	^ classesWithCollectors size
]

{ #category : 'adding' }
TITTypesCollection >> sortedClasses [

	sortedClasses ifNotNil: [ ^ sortedClasses ].
	(typeInfo types == self and: [
		 typeInfo collectionElementTypes sortedClasses isNotEmpty ])
		ifTrue: [
			classesWithCollectors associationsDo: [ :each |
				(each key isCollectionClass and: [
					 (each key includesBehavior: String) not ]) ifTrue: [
					each value add: TITCollectionElementTypesFoundMarker new ] ] ].
	^ sortedClasses := ((classesWithCollectors associations select: [
		                     :eachPair |
		                     eachPair value weight >= self minimumWeight ])
		                    sorted: [ :a :b |
		                    a value weight > b value weight ])
		                   asOrderedDictionary
]

{ #category : 'accessing' }
TITTypesCollection >> typeInfo: aTypeInfo [

	typeInfo := aTypeInfo
]
