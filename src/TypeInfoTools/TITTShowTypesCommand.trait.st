Trait {
	#name : 'TITTShowTypesCommand',
	#category : 'TypeInfoTools-Commands',
	#package : 'TypeInfoTools',
	#tag : 'Commands'
}

{ #category : 'as yet unclassified' }
TITTShowTypesCommand >> areEmptyResultsOfClass: aDictionaryOfCollections [

	^ aDictionaryOfCollections allSatisfy: [ :each |
		  self areEmptyResultsOfMethodOrInstVars: each ]
]

{ #category : 'as yet unclassified' }
TITTShowTypesCommand >> areEmptyResultsOfMethodOrInstVars: aDictionaryOfCollections [

	^ aDictionaryOfCollections allSatisfy: [ :each |
		  self areEmptyResultsOfSingleItem: each ]
]

{ #category : 'as yet unclassified' }
TITTShowTypesCommand >> areEmptyResultsOfMultipleClasses: aDictionaryOfCollections [

	^ aDictionaryOfCollections allSatisfy: [ :each |
		  self areEmptyResultsOfClass: each ]
]

{ #category : 'as yet unclassified' }
TITTShowTypesCommand >> areEmptyResultsOfSingleItem: aCollection [

	^ aCollection isEmpty
]

{ #category : 'accessing' }
TITTShowTypesCommand >> defaultMenuIconName [

	^ #hierarchy
]

{ #category : 'accessing' }
TITTShowTypesCommand >> defaultMenuItemName [

	^ 'Infer Types'
]

{ #category : 'as yet unclassified' }
TITTShowTypesCommand >> informNoneFound [

	self inform: 'No types were found'
]

{ #category : 'as yet unclassified' }
TITTShowTypesCommand >> resultsOfClassFrom: aDictionary [

	| resultsByMethod resultsOfInstVars results |
	resultsByMethod := Dictionary new.
	resultsOfInstVars := Dictionary new.

	aDictionary keysAndValuesDo: [ :key :types |
		key first = $_
			ifTrue: [
				| methodNameAndVarKey methodName varKey |
				methodNameAndVarKey := key splitOn: '>>'.
				methodName := methodNameAndVarKey first copyWithoutFirst.
				varKey := methodNameAndVarKey second.
				(resultsByMethod
					 at: '#' , methodName
					 ifAbsentPut: [ Dictionary new ]) at: varKey put: types ]
			ifFalse: [ resultsOfInstVars at: key put: types ] ].

	results := OrderedDictionary new.
	resultsOfInstVars ifNotEmpty: [
		results
			at: 'instance variables'
			put: (self resultsOfInstVarsFrom: resultsOfInstVars) ].
	(resultsByMethod associations sortedAs: [ :each | each key ]) do: [
		:each |
		results at: each key put: (self resultsOfMethodFrom: each value) ].
	^ results
]

{ #category : 'as yet unclassified' }
TITTShowTypesCommand >> resultsOfInstVarsFrom: aDictionary [

	^ ((aDictionary associations collect: [ :singleItemTypesByKeys |
		    singleItemTypesByKeys key
		    -> (self resultsOfSingleItemFrom: singleItemTypesByKeys value) ])
		   sortedAs: [ :each | each key ]) asOrderedDictionary
]

{ #category : 'as yet unclassified' }
TITTShowTypesCommand >> resultsOfMethodFrom: aDictionary [

	^ ((aDictionary associations collect: [ :singleItemTypesByKeys |
		    (singleItemTypesByKeys key copyAfterSubstring: '>>')
		    -> (self resultsOfSingleItemFrom: singleItemTypesByKeys value) ])
		   sorted: [ :a :b |
			   | aKey bKey |
			   aKey := a key.
			   bKey := b key.
			   (aKey first ~= $_ or: [ bKey first = $_ ]) and: [
				   (aKey first ~= $_ and: [ bKey first = $_ ]) or: [ aKey < bKey ] ] ])
		  asOrderedDictionary
]

{ #category : 'as yet unclassified' }
TITTShowTypesCommand >> resultsOfMultipleClassesFrom: aCollectionOfAssociations [

	^ (aCollectionOfAssociations collect: [ :eachPair |
		   eachPair key -> (self resultsOfClassFrom: eachPair value) ])
		  asOrderedDictionary
]

{ #category : 'as yet unclassified' }
TITTShowTypesCommand >> resultsOfMultipleMethodsFrom: aCollectionOfAssociationsByMethods [

	^ ((aCollectionOfAssociationsByMethods collect: [ :eachPair |
		    eachPair key selector
		    -> (self resultsOfMethodFrom: eachPair value) ]) sortedAs: [
		   :each | each key ]) asOrderedDictionary
]

{ #category : 'as yet unclassified' }
TITTShowTypesCommand >> resultsOfSingleItemFrom: aCollection [

	^ (aCollection reject: [ :any | any = Object ]) asArray
]

{ #category : 'as yet unclassified' }
TITTShowTypesCommand >> showClassFrom: aCollection forClass: aClass [

	| results |
	results := self resultsOfClassFrom: aCollection.
	(self areEmptyResultsOfClass: results) ifTrue: [
		^ self informNoneFound ].

	^ results inspectWithLabel: 'Type info for class ' , aClass name
]

{ #category : 'as yet unclassified' }
TITTShowTypesCommand >> showInstVarsFrom: aCollection forClass: aClass [

	| results |
	results := self resultsOfInstVarsFrom: aCollection.
	(self areEmptyResultsOfMethodOrInstVars: results) ifTrue: [
		^ self informNoneFound ].

	^ results inspectWithLabel:
		  'Type info for instance variables of class ' , aClass name
]

{ #category : 'as yet unclassified' }
TITTShowTypesCommand >> showMethodFrom: aCollection forMethod: aMethod [

	| results |
	results := self resultsOfMethodFrom: aCollection.
	(self areEmptyResultsOfMethodOrInstVars: results) ifTrue: [
		^ self informNoneFound ].

	^ results inspectWithLabel: 'Type info for ' , aMethod asString
]

{ #category : 'as yet unclassified' }
TITTShowTypesCommand >> showMultipleClassesFrom: aCollectionOfAssociations [

	| results |
	results := self resultsOfMultipleClassesFrom: aCollectionOfAssociations.
	(self areEmptyResultsOfMultipleClasses: results) ifTrue: [
		^ self informNoneFound ].

	^ results inspectWithLabel: 'Type info for multiple classes'
]

{ #category : 'as yet unclassified' }
TITTShowTypesCommand >> showMultipleMethodsFrom: aDictionaryByMethods forClass: aClass [

	| results |
	results := self resultsOfMultipleMethodsFrom: aDictionaryByMethods.
	(self areEmptyResultsOfClass: results) ifTrue: [
		^ self informNoneFound ].

	^ results inspectWithLabel: 'Type info for class ' , aClass name
]

{ #category : 'as yet unclassified' }
TITTShowTypesCommand >> showSingleItem: aCollection forVariableNamed: aVarName [

	| results |
	results := self resultsOfSingleItemFrom: aCollection.
	(self areEmptyResultsOfSingleItem: results) ifTrue: [
		^ self informNoneFound ].

	^ results inspectWithLabel:
		  'Type info for variable ''' , aVarName , ''''
]
