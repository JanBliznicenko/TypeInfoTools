Class {
	#name : 'TITMethodsStatisticsCollector',
	#superclass : 'TITStatisticsCollector',
	#category : 'TypeInfoTools-StatsCollector',
	#package : 'TypeInfoTools-StatsCollector'
}

{ #category : 'as yet unclassified' }
TITMethodsStatisticsCollector class >> inferAll [

	<script>
	self new inferAll
]

{ #category : 'hooks' }
TITMethodsStatisticsCollector >> itemsInPackage: aPackage [

	^ aPackage methods sorted: [ :a :b |
			  a methodClass name = b methodClass name
				  ifTrue: [ a selector < b selector ]
				  ifFalse: [ a methodClass name < b methodClass name ] ]
]

{ #category : 'hooks' }
TITMethodsStatisticsCollector >> itemsName [

	^ 'methods'
]

{ #category : 'printing' }
TITMethodsStatisticsCollector >> printClassNameOf: anInferrableItem on: aStream [

	aStream nextPutAll: anInferrableItem methodClass name
]

{ #category : 'printing' }
TITMethodsStatisticsCollector >> printItemKindNameOn: eachStream [

	eachStream nextPutAll: 'Selector'
]

{ #category : 'hooks' }
TITMethodsStatisticsCollector >> titNodeForItem: aMethod [

	^ TITMethod forOCMethodNode: aMethod ast
]
