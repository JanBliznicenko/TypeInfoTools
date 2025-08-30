Class {
	#name : 'TITMethodsStatisticsCollector',
	#superclass : 'TITStatisticsCollector',
	#category : 'TypeInfoTools-ReturnTypesAnalyzer',
	#package : 'TypeInfoTools-ReturnTypesAnalyzer'
}

{ #category : 'as yet unclassified' }
TITMethodsStatisticsCollector class >> inferAll [

	<script>
	self new inferAll
]

{ #category : 'as yet unclassified' }
TITMethodsStatisticsCollector >> itemsInPackage: aPackage [

	^ aPackage methods sorted: [ :a :b |
			  a methodClass name = b methodClass name
				  ifTrue: [ a selector < b selector ]
				  ifFalse: [ a methodClass name < b methodClass name ] ]
]

{ #category : 'as yet unclassified' }
TITMethodsStatisticsCollector >> itemsName [

	^ 'methods'
]

{ #category : 'as yet unclassified' }
TITMethodsStatisticsCollector >> printItem: anInferrableItem on: aStream [

	anInferrableItem printOn: aStream
]

{ #category : 'as yet unclassified' }
TITMethodsStatisticsCollector >> printItemKindNameOn: eachStream [

	eachStream nextPutAll: 'Class>>#method'
]

{ #category : 'as yet unclassified' }
TITMethodsStatisticsCollector >> titNodeForItem: aMethod [

	^ TITMethod forOCMethodNode: aMethod ast
]
