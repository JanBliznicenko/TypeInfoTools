Class {
	#name : 'TITSequentialAdaptorsTypeCollector',
	#superclass : 'Object',
	#instVars : [
		'adaptors',
		'reportingBlock'
	],
	#category : 'TypeInfoTools-Inference',
	#package : 'TypeInfoTools',
	#tag : 'Inference'
}

{ #category : 'adding' }
TITSequentialAdaptorsTypeCollector >> adaptors [

	^ adaptors ifNil: [ self defaultAdaptors ]
]

{ #category : 'adding' }
TITSequentialAdaptorsTypeCollector >> adaptors: aCollectionOfAdaptors [

	adaptors := aCollectionOfAdaptors
]

{ #category : 'adding' }
TITSequentialAdaptorsTypeCollector >> addTypesTo: aStructureNode [

	self adaptors do: [ :each |
		each addTypesTo: aStructureNode.
		reportingBlock cull: each ]
]

{ #category : 'adding' }
TITSequentialAdaptorsTypeCollector >> defaultAdaptors [

	^ {
		  TITRelatedPackagePriorityCollector new.
		  TITRoelTyperAdaptor new.
		  TITRBRefactoryTyperAdaptor new }
]

{ #category : 'initialization' }
TITSequentialAdaptorsTypeCollector >> initialize [

	super initialize.
	reportingBlock := [  ]
]

{ #category : 'adding' }
TITSequentialAdaptorsTypeCollector >> reportingBlock: aBlock [

	reportingBlock := aBlock
]
