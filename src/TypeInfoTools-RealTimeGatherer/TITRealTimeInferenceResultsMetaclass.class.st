Class {
	#name : 'TITRealTimeInferenceResultsMetaclass',
	#superclass : 'TITRealTimeInferenceResultsBehavior',
	#category : 'TypeInfoTools-RealTimeGatherer-Structure',
	#package : 'TypeInfoTools-RealTimeGatherer',
	#tag : 'Structure'
}

{ #category : 'accessing' }
TITRealTimeInferenceResultsMetaclass class >> systemClass [

	^ Metaclass
]

{ #category : 'instance creation' }
TITRealTimeInferenceResultsMetaclass class >> systemClassFrom: systemClass [

	^ systemClass class
]
