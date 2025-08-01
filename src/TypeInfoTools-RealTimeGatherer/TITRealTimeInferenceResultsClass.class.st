Class {
	#name : 'TITRealTimeInferenceResultsClass',
	#superclass : 'TITRealTimeInferenceResultsBehavior',
	#category : 'TypeInfoTools-RealTimeGatherer-Structure',
	#package : 'TypeInfoTools-RealTimeGatherer',
	#tag : 'Structure'
}

{ #category : 'as yet unclassified' }
TITRealTimeInferenceResultsClass class >> forSystemMetaclass: aClass [

	aClass isTrait ifTrue: [ ^ TITRealTimeInferenceResultsTrait ].
	self assert: aClass = Class.
	^ self
]

{ #category : 'accessing' }
TITRealTimeInferenceResultsClass class >> systemClass [

	^ Class
]
