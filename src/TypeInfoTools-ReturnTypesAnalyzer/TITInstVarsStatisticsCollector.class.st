Class {
	#name : 'TITInstVarsStatisticsCollector',
	#superclass : 'TITStatisticsCollector',
	#category : 'TypeInfoTools-ReturnTypesAnalyzer',
	#package : 'TypeInfoTools-ReturnTypesAnalyzer'
}

{ #category : 'as yet unclassified' }
TITInstVarsStatisticsCollector class >> inferAll [

	<script>
	self new inferAll
]

{ #category : 'accessing' }
TITInstVarsStatisticsCollector >> inferrers [

	^ {
		  TITJ2InfererTyperAdaptor new.
		  TITRoelTyperAdaptor new.
		  TITTypeMeTyperAdaptor new.
		  TITNameStatisticsTyperAdaptor new.
		  TITAdaptorsChainingTypeCollector default.
		  (TITAdaptorsFusionTypeCollector default
			   sourceName: 'Fusion(all)';
			   yourself).
		  (TITAdaptorsFusionTypeCollector default
			   sourceName: 'Fusion';
			   yourself).
		  (TITAdaptorsFusionTypeCollector noStat
			   sourceName: 'Fusion(noStat)';
			   yourself).
		  (TITAdaptorsFusionTypeCollector heuristic
			   sourceName: 'Fusion(heur)';
			   yourself) }
]

{ #category : 'as yet unclassified' }
TITInstVarsStatisticsCollector >> itemsInPackage: aPackage [

	^ (aPackage classes asArray sorted: [ :a :b | a name < b name ])
		  flatCollect: [ :each |
				  (each instanceVariables sorted: [ :a :b | a name < b name ])
				  ,
				  (each class instanceVariables sorted: [ :a :b | a name < b name ]) ]
]

{ #category : 'as yet unclassified' }
TITInstVarsStatisticsCollector >> itemsName [

	^ 'instVars'
]

{ #category : 'as yet unclassified' }
TITInstVarsStatisticsCollector >> printItem: anInferrableItem on: aStream [

	aStream
		nextPutAll: anInferrableItem owningClass name;
		nextPutAll: '>';
		nextPutAll: anInferrableItem name
]

{ #category : 'as yet unclassified' }
TITInstVarsStatisticsCollector >> printItemKindNameOn: eachStream [

	eachStream nextPutAll: 'Name'
]

{ #category : 'as yet unclassified' }
TITInstVarsStatisticsCollector >> repetitions [

	^ 10
]

{ #category : 'as yet unclassified' }
TITInstVarsStatisticsCollector >> titNodeForItem: anInstanceVariable [

	^ TITInstanceVariable forSystemInstanceVariable: anInstanceVariable
]
