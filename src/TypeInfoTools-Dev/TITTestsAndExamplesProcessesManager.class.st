Class {
	#name : 'TITTestsAndExamplesProcessesManager',
	#superclass : 'Object',
	#instVars : [
		'baselineNames',
		'processHandlers',
		'mutex'
	],
	#category : 'TypeInfoTools-Dev-RealTime',
	#package : 'TypeInfoTools-Dev',
	#tag : 'RealTime'
}

{ #category : 'accessing' }
TITTestsAndExamplesProcessesManager >> getNextBaselineName [

	^ mutex critical: [
		  (baselineNames ifEmpty: [ OrderedCollection with: nil ])
			  removeFirst ]
]

{ #category : 'initialization' }
TITTestsAndExamplesProcessesManager >> initialize [

	super initialize.
	mutex := Mutex new
]
