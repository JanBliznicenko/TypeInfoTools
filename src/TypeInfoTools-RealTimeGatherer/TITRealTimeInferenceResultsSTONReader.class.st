Class {
	#name : 'TITRealTimeInferenceResultsSTONReader',
	#superclass : 'STONReader',
	#category : 'TypeInfoTools-RealTimeGatherer-Processing',
	#package : 'TypeInfoTools-RealTimeGatherer',
	#tag : 'Processing'
}

{ #category : 'parsing-internal' }
TITRealTimeInferenceResultsSTONReader >> parseClass [

	^ self replaceParsedClass: super parseClass
]

{ #category : 'parsing-internal' }
TITRealTimeInferenceResultsSTONReader >> replaceParsedClass: parsedClass [

	(parsedClass includesBehavior: Behavior) ifFalse: [ ^ parsedClass ].

	^ TITRealTimeInferenceResultsBehavior forSystemMetaclass: parsedClass
]
