Class {
	#name : 'TITMethodReturnTypesGatherer',
	#superclass : 'Object',
	#category : 'TypeInfoTools-Dev-MethodReturns',
	#package : 'TypeInfoTools-Dev',
	#tag : 'MethodReturns'
}

{ #category : 'as yet unclassified' }
TITMethodReturnTypesGatherer class >> arraysFromFile: aFile [

	| arrays results methods |
	arrays := aFile asFileReference readStreamDo: [ :s |
		          (NeoCSVReader on: s) upToEnd ].

	results := arrays allButFirst asSortedCollection: [ :a :b |
			           a first = b first
				           ifTrue: [
						           a second = b second
							           ifTrue: [ a third < b third ]
							           ifFalse: [ a second < b second ] ]
				           ifFalse: [ a first < b first ] ].

	methods := results collect: [ :each | each first: 3 ].

	"self assert: methods size = methods asSet size."

	^ results
]

{ #category : 'as yet unclassified' }
TITMethodReturnTypesGatherer class >> arraysFromFile: aFile focusingOnPackage: aPackage [

	^ (self arraysFromFile: aFile) select: [ :eachArray |
		  eachArray first = 'Zinc-HTTP' ]
]

{ #category : 'as yet unclassified' }
TITMethodReturnTypesGatherer class >> compareFile: file1 and: file2 [

	<script>
	| results1 results2 |
	results1 := self arraysFromFile: file1.
	results2 := self arraysFromFile: file2.

	{
		('In both files' -> (results1 intersection: results2)).
		('Only in ' , file1 asString -> (results1 difference: results2)).
		('Only in ' , file2 asString -> (results2 difference: results1)) }
		asDictionary inspect
]

{ #category : 'as yet unclassified' }
TITMethodReturnTypesGatherer class >> compareFile: file1 and: file2 focusingOnPackage: aPackage [

	<script>
	| results1 results2 |
	results1 := self arraysFromFile: file1 focusingOnPackage: aPackage.
	results2 := self arraysFromFile: file2 focusingOnPackage: aPackage.

	{
		('In both files' -> (results1 intersection: results2)).
		('Only in ' , file1 asString -> (results1 difference: results2)).
		('Only in ' , file2 asString -> (results2 difference: results1)) }
		asDictionary inspect
]

{ #category : 'as yet unclassified' }
TITMethodReturnTypesGatherer class >> compareFiles [

	<script>
	(self
		 compareFile: 'TIT_static_results_Zinc-HTTP.csv'
		 and: 'types.csv'
		 focusingOnPackage: 'Zinc-HTTP') inspect
]

{ #category : 'as yet unclassified' }
TITMethodReturnTypesGatherer class >> example [

	^ self gatherPackage: 'Zinc-HTTP'
]

{ #category : 'as yet unclassified' }
TITMethodReturnTypesGatherer class >> gatherPackage: packageName [

	| collector package classes methods arrays csvContent |
	collector := TITSequentialAdaptorsTypeCollector new.

	package := self packageOrganizer packageNamed: packageName.

	classes := package definedClasses asArray.

	methods := (classes , (classes collect: [ :each | each class ])
		            sortedAs: [ :eachClass | eachClass name ]) flatCollect: [
			           :eachClass |
			           (eachClass methods sortedAs: [ :eachMethod |
				            eachMethod selector ]) collect: [ :each |
				           TITMethod forOCMethodNode: each ast ] ].

	methods do: [ :each | collector addTypesTo: each ].

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

	('TIT_static_results_' , packageName , '.csv') asFileReference
		ensureDelete;
		writeStreamDo: [ :stream | stream nextPutAll: csvContent ].

	^ methods
]
