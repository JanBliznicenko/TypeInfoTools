Trait {
	#name : 'TITTShowTypesCommandV1',
	#category : 'TypeInfoTools-Commands',
	#package : 'TypeInfoTools',
	#tag : 'Commands'
}

{ #category : 'as yet unclassified' }
TITTShowTypesCommandV1 >> areEmptyResultsOfClass: aDictionaryOfCollections [

	^ aDictionaryOfCollections allSatisfy: [ :each |
		  self areEmptyResultsOfMethodOrInstVars: each ]
]

{ #category : 'as yet unclassified' }
TITTShowTypesCommandV1 >> areEmptyResultsOfMethodOrInstVars: aDictionaryOfCollections [

	^ aDictionaryOfCollections allSatisfy: [ :each |
		  self areEmptyResultsOfSingleItem: each ]
]

{ #category : 'as yet unclassified' }
TITTShowTypesCommandV1 >> areEmptyResultsOfMultipleClasses: aDictionaryOfCollections [

	^ aDictionaryOfCollections allSatisfy: [ :each |
		  self areEmptyResultsOfClass: each ]
]

{ #category : 'as yet unclassified' }
TITTShowTypesCommandV1 >> areEmptyResultsOfSingleItem: aCollection [

	^ aCollection isEmpty
]

{ #category : 'accessing' }
TITTShowTypesCommandV1 >> defaultMenuIconName [

	^ #hierarchy
]

{ #category : 'accessing' }
TITTShowTypesCommandV1 >> defaultMenuItemName [

	^ 'Infer Types v1'
]

{ #category : 'as yet unclassified' }
TITTShowTypesCommandV1 >> informNoneFound [

	self inform: 'No types were found'
]

{ #category : 'as yet unclassified' }
TITTShowTypesCommandV1 >> resultsOfClassFrom: aDictionary [

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
TITTShowTypesCommandV1 >> resultsOfInstVarsFrom: aDictionary [

	^ ((aDictionary associations collect: [ :singleItemTypesByKeys |
		    singleItemTypesByKeys key
		    -> (self resultsOfSingleItemFrom: singleItemTypesByKeys value) ])
		   sortedAs: [ :each | each key ]) asOrderedDictionary
]

{ #category : 'as yet unclassified' }
TITTShowTypesCommandV1 >> resultsOfMethodFrom: aDictionary [

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
TITTShowTypesCommandV1 >> resultsOfMultipleClassesFrom: aCollectionOfAssociations [

	^ (aCollectionOfAssociations collect: [ :eachPair |
		   eachPair key -> (self resultsOfClassFrom: eachPair value) ])
		  asOrderedDictionary
]

{ #category : 'as yet unclassified' }
TITTShowTypesCommandV1 >> resultsOfMultipleMethodsFrom: aCollectionOfAssociationsByMethods [

	^ ((aCollectionOfAssociationsByMethods collect: [ :eachPair |
		    eachPair key selector
		    -> (self resultsOfMethodFrom: eachPair value) ]) sortedAs: [
		   :each | each key ]) asOrderedDictionary
]

{ #category : 'as yet unclassified' }
TITTShowTypesCommandV1 >> resultsOfSingleItemFrom: aCollection [

	^ (aCollection reject: [ :any | any = Object ]) asArray sorted: [ :a :b |
		  (a isCollectionClass and: [ b isCollectionClass not ]) or: [
			  (a isCollectionClass or: [ b isCollectionClass not ]) and: [
				  (a isMagnitudeClass and: [ b isMagnitudeClass not ]) or: [
					  (a isMagnitudeClass or: [ b isMagnitudeClass not ]) and: [
						  (b includesBehavior: a) or: [
							  (a includesBehavior: b) not and: [ a name < b name ] ] ] ] ] ] ]
]

{ #category : 'as yet unclassified' }
TITTShowTypesCommandV1 >> showClassFrom: aCollection forClass: aClass [

	| results |
	results := self resultsOfClassFrom: aCollection.
	(self areEmptyResultsOfClass: results) ifTrue: [
		^ self informNoneFound ].

	^ results inspectWithLabel: 'Type info for class ' , aClass name
]

{ #category : 'as yet unclassified' }
TITTShowTypesCommandV1 >> showInstVarsFrom: aCollection forClass: aClass [

	| results |
	results := self resultsOfInstVarsFrom: aCollection.
	(self areEmptyResultsOfMethodOrInstVars: results) ifTrue: [
		^ self informNoneFound ].

	^ results inspectWithLabel:
		  'Type info for instance variables of class ' , aClass name
]

{ #category : 'as yet unclassified' }
TITTShowTypesCommandV1 >> showMethodFrom: aCollection forMethod: aMethod [

	| results |
	results := self resultsOfMethodFrom: aCollection.
	(self areEmptyResultsOfMethodOrInstVars: results) ifTrue: [
		^ self informNoneFound ].

	^ results inspectWithLabel: (String streamContents: [ :s |
			   s << 'Type info for '.
			   aMethod printOn: s ])
]

{ #category : 'as yet unclassified' }
TITTShowTypesCommandV1 >> showMultipleClassesFrom: aCollectionOfAssociations [

	| results |
	results := self resultsOfMultipleClassesFrom: aCollectionOfAssociations.
	(self areEmptyResultsOfMultipleClasses: results) ifTrue: [
		^ self informNoneFound ].

	^ results inspectWithLabel: 'Type info for multiple classes'
]

{ #category : 'as yet unclassified' }
TITTShowTypesCommandV1 >> showMultipleMethodsFrom: aDictionaryByMethods forClass: aClass [

	| results |
	results := self resultsOfMultipleMethodsFrom: aDictionaryByMethods.
	(self areEmptyResultsOfClass: results) ifTrue: [
		^ self informNoneFound ].

	^ results inspectWithLabel: 'Type info for class ' , aClass name
]

{ #category : 'as yet unclassified' }
TITTShowTypesCommandV1 >> showSingleItem: aCollection forVariableNamed: aVarName [

	| results |
	results := self resultsOfSingleItemFrom: aCollection.
	(self areEmptyResultsOfSingleItem: results) ifTrue: [
		^ self informNoneFound ].


	^ results inspectWithLabel:
		  'Type info for variable ''' , aVarName , ''''
]
