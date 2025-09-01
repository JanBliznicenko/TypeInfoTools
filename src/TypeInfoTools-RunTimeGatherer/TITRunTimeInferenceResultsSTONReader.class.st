Class {
	#name : 'TITRunTimeInferenceResultsSTONReader',
	#superclass : 'STONReader',
	#category : 'TypeInfoTools-RunTimeGatherer-Processing',
	#package : 'TypeInfoTools-RunTimeGatherer',
	#tag : 'Processing'
}

{ #category : 'parsing-internal' }
TITRunTimeInferenceResultsSTONReader >> parseClass [

	^ self replaceParsedClass: super parseClass
]

{ #category : 'parsing-internal' }
TITRunTimeInferenceResultsSTONReader >> replaceParsedClass: parsedClass [

	(parsedClass includesBehavior: Behavior) ifFalse: [ ^ parsedClass ].

	^ TITRunTimeInferenceResultsBehavior forSystemMetaclass: parsedClass
]
