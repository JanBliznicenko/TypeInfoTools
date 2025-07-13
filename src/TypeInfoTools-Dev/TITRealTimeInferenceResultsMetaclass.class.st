Class {
	#name : 'TITRealTimeInferenceResultsMetaclass',
	#superclass : 'TITRealTimeInferenceResultsBehavior',
	#category : 'TypeInfoTools-Dev-RealTime',
	#package : 'TypeInfoTools-Dev',
	#tag : 'RealTime'
}

{ #category : 'accessing' }
TITRealTimeInferenceResultsMetaclass class >> systemClass [

	^ Metaclass
]

{ #category : 'instance creation' }
TITRealTimeInferenceResultsMetaclass class >> systemClassFrom: systemClass [

	^ systemClass class
]
