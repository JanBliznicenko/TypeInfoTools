Class {
	#name : 'TITInstVarsStatisticsCollector',
	#superclass : 'TITStatisticsCollector',
	#category : 'TypeInfoTools-StatsCollector',
	#package : 'TypeInfoTools-StatsCollector'
}

{ #category : 'as yet unclassified' }
TITInstVarsStatisticsCollector class >> inferAll [

	<script>
	self new inferAll
]

{ #category : 'hooks' }
TITInstVarsStatisticsCollector >> itemsInPackage: aPackage [

	^ (aPackage definedClasses asArray sorted: [ :a :b | a name < b name ])
		  flatCollect: [ :each |
				  (each instanceVariables sorted: [ :a :b | a name < b name ])
				  ,
				  (each class instanceVariables sorted: [ :a :b | a name < b name ]) ]
]

{ #category : 'hooks' }
TITInstVarsStatisticsCollector >> itemsName [

	^ 'instVars'
]

{ #category : 'printing' }
TITInstVarsStatisticsCollector >> printClassNameOf: anInferrableItem on: aStream [

	aStream nextPutAll: anInferrableItem owningClass name
]

{ #category : 'printing' }
TITInstVarsStatisticsCollector >> printItemKindNameOn: eachStream [

	eachStream nextPutAll: 'Name'
]

{ #category : 'hooks' }
TITInstVarsStatisticsCollector >> titNodeForItem: anInstanceVariable [

	^ TITInstanceVariable forSystemInstanceVariable: anInstanceVariable
]
