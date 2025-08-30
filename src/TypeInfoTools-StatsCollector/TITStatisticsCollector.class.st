Class {
	#name : 'TITStatisticsCollector',
	#superclass : 'Object',
	#instVars : [
		'typesStream',
		'timesStream'
	],
	#category : 'TypeInfoTools-StatsCollector',
	#package : 'TypeInfoTools-StatsCollector'
}

{ #category : 'processing' }
TITStatisticsCollector >> inferAll [

	self packages do: [ :eachPackage | self inferPackage: eachPackage ]
]

{ #category : 'processing' }
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

{ #category : 'processing' }
TITStatisticsCollector >> inferItem: anInferrableItem withInferrerIndex: inferrerIndex [
	"index instead of inferrer to prevent caching"

	| node timeToRun topNode |
	timeToRun := ([
		              node := self titNodeForItem: anInferrableItem.
		              node accept: (self inferrers at: inferrerIndex) ]
		              benchFor: 500 milliSeconds) timePerExecution.
	topNode := node typeInfo types asClassTreeForPresenting maxWeightNode.
	typesStream nextPutAll: ';'.
	topNode weight > 0.1 ifTrue: [
		typesStream nextPutAll: topNode representedClass asString ].
	timesStream nextPutAll: ';'.
	timesStream nextPutAll: timeToRun asMicroseconds asString
]

{ #category : 'processing' }
TITStatisticsCollector >> inferPackage: aPackage [

	(aPackage name , '_' , self itemsName , '_times_μs.csv')
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

{ #category : 'configuration' }
TITStatisticsCollector >> inferrers [

	^ {
		  TITRoelTyperAdaptor new.
		  TITTypeMeTyperAdaptor new.
		  TITNameStatisticsTyperAdaptor new.
		  TITAdaptorsChainingTypeCollector default.
		  (TITAdaptorsFusionTypeCollector all
			   sourceName: 'Fusion(all)';
			   yourself).
		  (TITAdaptorsFusionTypeCollector default
			   sourceName: 'Fusion';
			   yourself).
		  (TITAdaptorsFusionTypeCollector noStat
			   sourceName: 'Fusion(noStat)';
			   yourself).
		  (TITAdaptorsFusionTypeCollector noTypeMe
			   sourceName: 'Fusion(noTypeMe)';
			   yourself).
		  (TITAdaptorsFusionTypeCollector heuristic
			   sourceName: 'Fusion(heur)';
			   yourself) }
]

{ #category : 'hooks' }
TITStatisticsCollector >> itemsInPackage: aPackage [

	^ self subclassResponsibility
]

{ #category : 'hooks' }
TITStatisticsCollector >> itemsName [

	^ self subclassResponsibility
]

{ #category : 'configuration' }
TITStatisticsCollector >> packages [

	^ { 'Athens-Cairo'. 'Metacello-Core'. 'OSWindow-Core'. 'Zinc-HTTP'.
	  'Spec2-Layout'. 'Roassal'. 'Roassal-Layouts' } collect: [ :each |
		  self packageOrganizer packageNamed: each ]
]

{ #category : 'printing' }
TITStatisticsCollector >> printItem: anInferrableItem on: aStream [

	self subclassResponsibility
]

{ #category : 'printing' }
TITStatisticsCollector >> printItemKindNameOn: eachStream [

	self subclassResponsibility
]

{ #category : 'hooks' }
TITStatisticsCollector >> titNodeForItem: anInferrableItem [

	^ self subclassResponsibility
]
