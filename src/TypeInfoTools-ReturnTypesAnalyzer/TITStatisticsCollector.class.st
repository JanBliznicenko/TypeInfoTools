Class {
	#name : 'TITStatisticsCollector',
	#superclass : 'Object',
	#instVars : [
		'packages',
		'inferrers',
		'typesStream',
		'timesStream'
	],
	#category : 'TypeInfoTools-ReturnTypesAnalyzer',
	#package : 'TypeInfoTools-ReturnTypesAnalyzer'
}

{ #category : 'as yet unclassified' }
TITStatisticsCollector >> inferAll [

	self packages do: [ :eachPackage | self inferPackage: eachPackage ]
]

{ #category : 'as yet unclassified' }
TITStatisticsCollector >> inferItem: anInferrableItem [

	self printItem: anInferrableItem on: typesStream.
	self printItem: anInferrableItem on: timesStream.

	1 to: self inferrers size do: [ :index |
	self inferItem: anInferrableItem withInferrerIndex: index ].

	typesStream
		crlf;
		flush.
	timesStream
		crlf;
		flush
]

{ #category : 'as yet unclassified' }
TITStatisticsCollector >> inferItem: anInferrableItem withInferrerIndex: inferrerIndex [
	"index instead of inferrer to prevent caching"

	| node timeToRun topType topNode |
	timeToRun := [
		             self repetitions timesRepeat: [
				             node := (self titNodeForItem: anInferrableItem).
				             node accept: (self inferrers at: inferrerIndex) ] ]
		             timeToRunWithoutGC / self repetitions.
	topNode := node typeInfo types asClassTreeForPresenting maxWeightNode.
	topType := topNode weight <= 0.1
		           ifTrue: [ nil ]
		           ifFalse: [ topNode representedClass ].
	typesStream
		nextPutAll: ';';
		nextPutAll: (topType ifNil: [ '' ]) asString.
	timesStream nextPutAll: ';'.
	timeToRun printOn: timesStream showingDecimalPlaces: 1
]

{ #category : 'as yet unclassified' }
TITStatisticsCollector >> inferPackage: aPackage [

	(aPackage name , '_' , self itemsName , '_times_ms.csv')
		asFileReference
		ensureDelete;
		writeStreamDo: [ :timesS |
				(aPackage name , '_' , self itemsName , '_types.csv')
					asFileReference
					ensureDelete;
					writeStreamDo: [ :typesS |
							typesStream := typesS.
							timesStream := timesS.
							{
								typesStream.
								timesStream } do: [ :eachStream |
										self printItemKindNameOn: eachStream.
										self inferrers do: [ :eachInferrer |
												eachStream << ';' << eachInferrer sourceName ].
										eachStream crlf ].
							(self itemsInPackage: aPackage) do: [ :eachItem |
									self inferItem: eachItem ] ] ]
]

{ #category : 'accessing' }
TITStatisticsCollector >> inferrers [

	^ {
		  TITRoelTyperAdaptor new.
		  TITTypeMeTyperAdaptor new.
		  TITNameStatisticsTyperAdaptor new.
		  TITAdaptorsChainingTypeCollector default.
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
TITStatisticsCollector >> itemsInPackage: aPackage [

	^ self subclassResponsibility
]

{ #category : 'as yet unclassified' }
TITStatisticsCollector >> itemsName [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
TITStatisticsCollector >> packages [

	^ { 'Athens-Cairo'. 'Metacello-Core'. 'OSWindow-Core'. 'XML-Parser'.
	  'Zinc-HTTP'. 'Spec2-Layout'. 'Roassal'. 'Roassal-Layouts' }
		  collect: [ :each | self packageOrganizer packageNamed: each ]
]

{ #category : 'as yet unclassified' }
TITStatisticsCollector >> printItem: anInferrableItem on: aStream [

	self subclassResponsibility
]

{ #category : 'as yet unclassified' }
TITStatisticsCollector >> printItemKindNameOn: eachStream [

	self subclassResponsibility
]

{ #category : 'as yet unclassified' }
TITStatisticsCollector >> repetitions [

	^ 10
]

{ #category : 'as yet unclassified' }
TITStatisticsCollector >> titNodeForItem: anInferrableItem [

	^ self subclassResponsibility
]
