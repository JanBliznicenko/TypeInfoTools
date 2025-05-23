Class {
	#name : 'TITTypesCollection',
	#superclass : 'Object',
	#instVars : [
		'typeInfo',
		'sortedClasses',
		'classesWithCollectors'
	],
	#classInstVars : [
		'classReplacements'
	],
	#category : 'TypeInfoTools-Core-Inference',
	#package : 'TypeInfoTools-Core',
	#tag : 'Inference'
}

{ #category : 'accessing' }
TITTypesCollection class >> afterClassReplacement: aClass [

	^ self classReplacements at: aClass ifAbsent: [ aClass ]
]

{ #category : 'accessing' }
TITTypesCollection class >> classReplacements [

	^ classReplacements ifNil: [
			  classReplacements := {
				                       (True -> Boolean).
				                       (False -> Boolean).
				                       (ByteString -> String).
				                       (WideString -> String).
				                       (ByteSymbol -> Symbol).
				                       (WideSymbol -> Symbol).
				                       (BoxedFloat64 -> Float).
				                       (SmallFloat64 -> Float).
				                       (LargeInteger -> Integer).
				                       (LargeNegativeInteger -> Integer).
				                       (LargePositiveInteger -> Integer).
				                       (SmallInteger -> Integer) } asDictionary ]
]

{ #category : 'instance creation' }
TITTypesCollection class >> forTypeInfo: aTypeInfo [

	^ self new
		  typeInfo: aTypeInfo;
		  yourself
]

{ #category : 'accessing' }
TITTypesCollection class >> reset [

	super reset.
	classReplacements := nil
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

	aClass = ProtoObject ifTrue: [ ^ self ].
	aClass = Object ifTrue: [ ^ self ].
	aClass isTrait ifTrue: [ ^ self ].
	(classesWithCollectors
		 at: aClass
		 ifAbsentPut: [ TITTypesCollectionSources new ]) add: aTypeCollector.
	self resetCache
]

{ #category : 'adding' }
TITTypesCollection >> addClasses: aCollection by: aTypeCollector [

	aCollection ifEmpty: [ ^ self ].
	aCollection do: [ :each | self addClass: each by: aTypeCollector ]
]

{ #category : 'converting' }
TITTypesCollection >> asClassTree [

	^ TITClassTree fromDictionary: self classesWithCollectors
]

{ #category : 'converting' }
TITTypesCollection >> asSimplifiedClassTree [

	^ self asClassTree
		  mergeRedundantChildren;
		  removeProtoObject;
		  removeVeryLowWeightNodes;
		  sortByWeight;
		  yourself
]

{ #category : 'accessing' }
TITTypesCollection >> classesWithCollectors [

	^ classesWithCollectors
]

{ #category : 'accessing' }
TITTypesCollection >> classesWithCollectors: anObject [

	classesWithCollectors := anObject
]

{ #category : 'enumerating' }
TITTypesCollection >> collect: aBlock [

	^ classesWithCollectors keys collect: [ :pair | aBlock value: pair key ]
]

{ #category : 'hierarchy' }
TITTypesCollection >> commonSuperclassOfTopWeightClasses [

	^ (self topWeightClasses reject: [ :any | any superclass isNil ])
		  ifEmpty: [ nil ]
		  ifNotEmpty: [ :topWeightClasses |
				  | arbitraryOne |
				  arbitraryOne := topWeightClasses anyOne.
				  topWeightClasses
					  inject: arbitraryOne
					  into: [ :commonSuperclass :eachClass |
							  eachClass = arbitraryOne
								  ifTrue: [ commonSuperclass ]
								  ifFalse: [
										  eachClass isMeta = arbitraryOne isMeta
											  ifTrue: [
											  eachClass commonSuperclassSymmetricWith: commonSuperclass ]
											  ifFalse: [ ^ nil ] ] ] ]
]

{ #category : 'hierarchy' }
TITTypesCollection >> commonSuperclassOfTopWeightClassesOrAny [

	| commonSuperclass |
	commonSuperclass := self commonSuperclassOfTopWeightClasses.
	(commonSuperclass = Object or: [ commonSuperclass = ProtoObject ])
		ifTrue: [ ^ self sortedClasses keyAtIndex: 1 ].
	^ commonSuperclass
]

{ #category : 'hierarchy' }
TITTypesCollection >> commonSuperclassOfTopWeightClassesOrNil [

	| commonSuperclass |
	commonSuperclass := self commonSuperclassOfTopWeightClasses.
	(commonSuperclass = Object or: [ commonSuperclass = ProtoObject ])
		ifTrue: [ ^ nil ].
	^ commonSuperclass
]

{ #category : 'enumerating' }
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

{ #category : 'accessing' }
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

{ #category : 'initialization' }
TITTypesCollection >> resetCache [

	sortedClasses := nil
]

{ #category : 'enumerating' }
TITTypesCollection >> select: aBlock [

	^ classesWithCollectors keys select: [ :pair | aBlock value: pair key ]
]

{ #category : 'accessing' }
TITTypesCollection >> size [

	^ classesWithCollectors size
]

{ #category : 'accessing' }
TITTypesCollection >> sortedClasses [

	sortedClasses ifNotNil: [ ^ sortedClasses ].
	(typeInfo types == self and: [
		 typeInfo collectionElementTypes sortedClasses isNotEmpty ])
		ifTrue: [
				classesWithCollectors associationsDo: [ :each |
						(each key isCollectionClass and: [
							 (each key includesBehavior: String) not ]) ifTrue: [
							each value add: TITCollectionElementTypesFoundMarker instance ] ] ].
	^ sortedClasses := ((classesWithCollectors associations select: [
		                     :eachPair |
		                     eachPair value weight >= self minimumWeight ])
		                    sorted: [ :a :b |
		                    a value weight > b value weight ])
		                   asOrderedDictionary
]

{ #category : 'enumerating' }
TITTypesCollection >> topWeightClasses [

	| topWeightClasses topWeight |
	self sortedClasses ifEmpty: [ ^ self sortedClasses ].
	topWeightClasses := Set new.
	topWeight := nil.
	self sortedClasses keysAndValuesDo: [ :class :collectors |
			topWeight
				ifNil: [
						topWeight := collectors weight.
						topWeightClasses add: class ]
				ifNotNil: [
						(collectors weight closeTo: topWeight)
							ifTrue: [ topWeightClasses add: class ]
							ifFalse: [ ^ topWeightClasses ] ] ].
	^ topWeightClasses
]

{ #category : 'accessing' }
TITTypesCollection >> typeInfo: aTypeInfo [

	typeInfo := aTypeInfo
]
