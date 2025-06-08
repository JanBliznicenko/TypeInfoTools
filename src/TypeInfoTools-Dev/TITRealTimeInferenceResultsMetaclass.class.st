Class {
	#name : 'TITRealTimeInferenceResultsMetaclass',
	#superclass : 'TITRealTimeInferenceResultsBehavior',
	#category : 'TypeInfoTools-Dev-RealTime',
	#package : 'TypeInfoTools-Dev',
	#tag : 'RealTime'
}

{ #category : 'instance creation' }
TITRealTimeInferenceResultsMetaclass class >> systemClassFrom: systemClass [

	^ systemClass class
]

{ #category : 'instance creation' }
TITRealTimeInferenceResultsMetaclass >> fromSton: stonReader [

	| theClass |
	theClass := super fromSton: stonReader.
	^ theClass class
]
