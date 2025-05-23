Class {
	#name : 'TITMethodReturnTypesGatherer',
	#superclass : 'Object',
	#category : 'TypeInfoTools-Core-Inference',
	#package : 'TypeInfoTools-Core',
	#tag : 'Inference'
}

{ #category : 'as yet unclassified' }
TITMethodReturnTypesGatherer class >> compareFiles [

	<script>
	| lines1 lines2 firstLine results1 results2 |
	lines1 := ('TIT_static_results_Zinc-HTTP.csv' asFileReference readStreamDo: [ :s |
		           s upToEnd ]) lines.
	lines2 := ('types.csv' asFileReference readStreamDo: [ :s |
		           s upToEnd ]) lines.

	firstLine := lines1 first.

	results1 := lines1 allButFirst asSortedCollection.
	results2 := (lines2 select: [ :each | each beginsWith: '"Zinc-HTTP"' ])
		            asSortedCollection.

	self assert: results1 size = results1 asSet size.
	self assert: results2 size = results2 asSet size.

	{
		(results1 intersection: results2).
		(results1 difference: results2).
		(results2 difference: results1).} inspect
]

{ #category : 'as yet unclassified' }
TITMethodReturnTypesGatherer class >> example [

	^ self gatherPackage: 'Zinc-HTTP'
]

{ #category : 'as yet unclassified' }
TITMethodReturnTypesGatherer class >> gatherPackage: packageName [

	| collector package methods arrays csvContent |
	collector := TITSequentialAdaptorsTypeCollector new.

	package := self packageOrganizer packageNamed: packageName.

	methods := package definedClasses flatCollectAsSet: [ :eachClass |
			           (eachClass methods, eachClass class methods) collect: [ :each |
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
		writeStreamDo: [ :stream | stream nextPutAll: csvContent ].

	^ methods
]
