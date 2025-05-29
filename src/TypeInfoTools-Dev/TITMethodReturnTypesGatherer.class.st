Class {
	#name : 'TITMethodReturnTypesGatherer',
	#superclass : 'Object',
	#instVars : [
		'packageNames',
		'timesToRun',
		'methodsByPackages'
	],
	#category : 'TypeInfoTools-Dev-MethodReturns',
	#package : 'TypeInfoTools-Dev',
	#tag : 'MethodReturns'
}

{ #category : 'as yet unclassified' }
TITMethodReturnTypesGatherer class >> arraysFromFile: aFile [

	| arrays sortedArrays |
	arrays := aFile asFileReference readStreamDo: [ :s |
		          (NeoCSVReader on: s) upToEnd ].

	sortedArrays := SortedCollection sortBlock: [ :a :b |
			                a first = b first
				                ifTrue: [
						                a second = b second
							                ifTrue: [ a third < b third ]
							                ifFalse: [ a second < b second ] ]
				                ifFalse: [ a first < b first ] ].

	arrays allButFirstDo: [ :eachArray |
			sortedArrays add:
				(eachArray collect: [ :eachItem | eachItem asSymbol ]) ].

	^ sortedArrays
]

{ #category : 'as yet unclassified' }
TITMethodReturnTypesGatherer class >> compareFile: file1 and: file2 [

	| results1 results2 |
	results1 := self dictionariesFromFile: file1.
	results2 := self dictionariesFromFile: file2.

	^ self
		  compareResults: results1
		  as: file1
		  and: results2
		  as: file2
]

{ #category : 'as yet unclassified' }
TITMethodReturnTypesGatherer class >> compareFile: file1 and: file2 focusingOnPackage: aPackage [

	| results1 results2 |
	results1 := self dictionariesFromFile: file1 focusingOnPackage: aPackage.
	results2 := self dictionariesFromFile: file2 focusingOnPackage: aPackage.

	^ self
		  compareResults: results1
		  as: file1
		  and: results2
		  as: file2
]

{ #category : 'as yet unclassified' }
TITMethodReturnTypesGatherer class >> compareResults: results1 as: file1 and: results2 as: file2 [

	| sameType differentType onlyIn1 onlyIn2 allKeys |
	sameType := OrderedCollection new.
	differentType := OrderedCollection new.
	onlyIn1 := OrderedCollection new.
	onlyIn2 := OrderedCollection new.

	results1 keysAndValuesDo: [ :method :typeAt1 |
			results2
				at: method
				ifPresent: [ :typeAt2 |
						typeAt1 = typeAt2
							ifTrue: [ sameType add: (method copyWith: typeAt1) ]
							ifFalse: [
									differentType add: (method copyWithAll: {
												 typeAt1.
												 typeAt2 }) ] ]
				ifAbsent: [ onlyIn1 add: (method copyWith: typeAt1) ] ].
	results2 keysAndValuesDo: [ :method :typeAt2 |
			results1
				at: method
				ifAbsent: [ onlyIn2 add: (method copyWith: typeAt2) ] ].

	allKeys := results1 keys asSet , results2 keys.
	self
		assert: allKeys size
			=
			(sameType size + differentType size + onlyIn1 size + onlyIn2 size)
		description:
		'Results have different amount of items compared to original files'.

	^ {
		  ('Same type' -> sameType).
		  ('Different type' -> differentType).
		  ('Only in 1st (' , file1 asString , ')' -> onlyIn1).
		  ('Only in 2nd (' , file2 asString , ')' -> onlyIn2) } asOrderedDictionary
]

{ #category : 'as yet unclassified' }
TITMethodReturnTypesGatherer class >> dictionariesFromFile: aFile [

	| sortedArrays dictionaries |
	sortedArrays := self arraysFromFile: aFile.

	dictionaries := sortedArrays
		                collect: [ :eachArray |
				                ((eachArray first: 3) collect: [ :eachItem |
					                 eachItem asSymbol ]) -> eachArray last asSymbol ]
		                as: OrderedDictionary.

	self
		assert: sortedArrays size = dictionaries size
		description: 'There are duplicate entires in ' , aFile asString.

	^ dictionaries
]

{ #category : 'as yet unclassified' }
TITMethodReturnTypesGatherer class >> dictionariesFromFile: aFile focusingOnPackage: aPackage [

	^ ((self dictionariesFromFile: aFile) associations select: [ :each |
		   each key first = #'Zinc-HTTP' ]) asOrderedDictionary
]

{ #category : 'as yet unclassified' }
TITMethodReturnTypesGatherer class >> example [

	| packageName gatherer timeToRun results |
	packageName := 'Zinc-HTTP'.
	gatherer := self gatherPackage: packageName.
	timeToRun := gatherer timeToRun: packageName.
	results := gatherer methodsOf: packageName.
	timeToRun inspect.
	results inspect.
	^ results
]

{ #category : 'as yet unclassified' }
TITMethodReturnTypesGatherer class >> exampleCompareFiles [

	| result |
	result := self
		          compareFile: 'TIT_static_results_Zinc-HTTP.csv'
		          and: 'types.csv'
		          focusingOnPackage: 'Zinc-HTTP'.
	result inspect
]

{ #category : 'as yet unclassified' }
TITMethodReturnTypesGatherer class >> gatherPackage: aPackageName [

	^ self new
		  packageNames: { aPackageName };
		  gatherPackages;
		  yourself
]

{ #category : 'as yet unclassified' }
TITMethodReturnTypesGatherer >> gatherPackage: aPackageName [

	| collector package classes methods arrays csvContent |
	collector := TITSequentialAdaptorsTypeCollector new.

	package := self packageOrganizer packageNamed: aPackageName.

	classes := package definedClasses asArray.

	methods := (classes , (classes collect: [ :each | each class ])
		            sortedAs: [ :eachClass | eachClass name ]) flatCollect: [
			           :eachClass |
			           (eachClass methods sortedAs: [ :eachMethod |
				            eachMethod selector ]) collect: [ :each |
				           TITMethod forOCMethodNode: each ast ] ].

	[ :job |
		job title: 'Collecting types'.
		job max: methods size.
		timesToRun at: aPackageName put: [
				methods withIndexDo: [ :each :index |
						job title:
							'Collecting types - ' , each compiledMethod printString.
						job currentValue: index.
						collector addTypesTo: each ] ] timeToRun ] asJob run.

	arrays := methods
		          select: [ :each |
			          each typeInfo types
				          commonSuperclassOfTopWeightClassesOrAny isNotNil ]
		          thenCollect: [ :each |
				          {
					          each ownerClass package name asString.
					          each realClass name asString.
					          each selector asString.
					          each typeInfo types
						          commonSuperclassOfTopWeightClassesOrAny name asString } ].

	csvContent := String streamContents: [ :s |
			              s << '"Package","Class","Selector","Types"'.
			              s lf.
			              arrays do: [ :eachArray |
					              eachArray
						              do: [ :eachItem | s << '"' << eachItem << '"' ]
						              separatedBy: [ s << ',' ].
					              s lf ] ].

	('TIT_static_results_' , aPackageName , '.csv') asFileReference
		ensureDelete;
		writeStreamDo: [ :stream | stream nextPutAll: csvContent ].

	methodsByPackages at: aPackageName put: methods
]

{ #category : 'as yet unclassified' }
TITMethodReturnTypesGatherer >> gatherPackages [

	packageNames do: [ :each | self gatherPackage: each ]
]

{ #category : 'initialization' }
TITMethodReturnTypesGatherer >> initialize [

	super initialize.
	timesToRun := Dictionary new.
	methodsByPackages := Dictionary new
]

{ #category : 'accessing' }
TITMethodReturnTypesGatherer >> methodsByPackages [

	^ methodsByPackages
]

{ #category : 'accessing' }
TITMethodReturnTypesGatherer >> methodsOf: aPackageName [

	^ methodsByPackages at: aPackageName asSymbol
]

{ #category : 'accessing' }
TITMethodReturnTypesGatherer >> packageNames: aListOfPackageNames [

	packageNames := aListOfPackageNames collect: [ :each | each asSymbol ]
]

{ #category : 'accessing' }
TITMethodReturnTypesGatherer >> timeToRun [

	timesToRun ifEmpty: [ ^ 0 seconds ].
	^ timesToRun values sum
]

{ #category : 'accessing' }
TITMethodReturnTypesGatherer >> timeToRun: aPackageName [

	^ timesToRun at: aPackageName asSymbol
]

{ #category : 'accessing' }
TITMethodReturnTypesGatherer >> timesToRun [

	^ timesToRun
]
