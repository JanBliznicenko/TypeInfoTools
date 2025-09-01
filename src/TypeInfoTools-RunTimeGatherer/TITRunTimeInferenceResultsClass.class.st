Class {
	#name : 'TITRunTimeInferenceResultsClass',
	#superclass : 'TITRunTimeInferenceResultsBehavior',
	#category : 'TypeInfoTools-RunTimeGatherer-Structure',
	#package : 'TypeInfoTools-RunTimeGatherer',
	#tag : 'Structure'
}

{ #category : 'as yet unclassified' }
TITRunTimeInferenceResultsClass class >> forSystemMetaclass: aClass [

	aClass isTrait ifTrue: [ ^ TITRunTimeInferenceResultsTrait ].
	self assert: aClass = Class.
	^ self
]

{ #category : 'accessing' }
TITRunTimeInferenceResultsClass class >> systemClass [

	^ Class
]
