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
TITStatisticsCollector class >> inferAll [

	<script>
	self new inferAll inspect
]

{ #category : 'as yet unclassified' }
TITStatisticsCollector >> inferAll [

	self packages do: [ :eachPackage | self inferPackage: eachPackage ]
]

{ #category : 'as yet unclassified' }
TITStatisticsCollector >> inferMethod: eachMethod [

	typesStream nextPutAll: eachMethod printString.
	timesStream nextPutAll: eachMethod printString.
	1 to: self inferrers size do: [ :index |
	self inferMethod: eachMethod withInferrerIndex: index ].
	typesStream
		crlf;
		flush.
	timesStream
		crlf;
		flush
]

{ #category : 'as yet unclassified' }
TITStatisticsCollector >> inferMethod: eachMethod withInferrerIndex: inferrerIndex [
	"index instead of inferrer to prevent caching"

	| node timeToRun topType topNode |
	timeToRun := [
		             10 timesRepeat: [
				             node := TITMethod forOCMethodNode: eachMethod ast.
				             node accept: (self inferrers at: inferrerIndex) ] ]
		             timeToRunWithoutGC / 10.
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

	(aPackage name , '_methods_times_microsec.csv') asFileReference
		ensureDelete;
		writeStreamDo: [ :timesS |
				(aPackage name , '_methods_types.csv') asFileReference
					ensureDelete;
					writeStreamDo: [ :typesS |
							typesStream := typesS.
							timesStream := timesS.
							{
								typesStream.
								timesStream } do: [ :eachStream |
										eachStream nextPutAll: 'Class>>#method'.
										self inferrers do: [ :eachInferrer |
												eachStream << ';' << eachInferrer sourceName ].
										eachStream crlf ].
							(aPackage methods sorted: [ :a :b |
										 a methodClass name = b methodClass name
											 ifTrue: [ a selector < b selector ]
											 ifFalse: [ a methodClass name < b methodClass name ] ])
								do: [ :eachMethod | self inferMethod: eachMethod ] ] ]
]

{ #category : 'accessing' }
TITStatisticsCollector >> inferrers [

	^ {
		  TITRoelTyperAdaptor new.
		  TITTypeMeTyperAdaptor new.
		  TITAdaptorsChainingTypeCollector fast.
		  (TITAdaptorsFusionTypeCollector fast
			   sourceName: 'Fusion(fast)';
			   yourself).
		  (TITAdaptorsFusionTypeCollector heuristic
			   sourceName: 'Fusion(heuristic)';
			   yourself) }
]

{ #category : 'accessing' }
TITStatisticsCollector >> packages [

	^ { 'Athens-Cairo'. 'Metacello-Core'. 'OSWindow-Core'. 'XML-Parser'.
	  'Zinc-HTTP'. 'Spec2-Layout'. 'Roassal'. 'Roassal-Layouts' }
		  collect: [ :each | self packageOrganizer packageNamed: each ]
]
