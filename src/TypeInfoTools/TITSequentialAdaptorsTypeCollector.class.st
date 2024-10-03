Class {
	#name : 'TITSequentialAdaptorsTypeCollector',
	#superclass : 'Object',
	#instVars : [
		'collectors',
		'reportingBlock'
	],
	#category : 'TypeInfoTools-Inference',
	#package : 'TypeInfoTools',
	#tag : 'Inference'
}

{ #category : 'adding' }
TITSequentialAdaptorsTypeCollector >> addTypesTo: aStructureNode [

	self collectors do: [ :each |
		each addTypesTo: aStructureNode.
		reportingBlock cull: each ]
]

{ #category : 'adding' }
TITSequentialAdaptorsTypeCollector >> collectors [

	^ collectors ifNil: [ self defaultCollectors ]
]

{ #category : 'adding' }
TITSequentialAdaptorsTypeCollector >> collectors: aCollectionOfCollectors [

	collectors := aCollectionOfCollectors
]

{ #category : 'adding' }
TITSequentialAdaptorsTypeCollector >> defaultCollectors [

	^ {
		  TITRelatedPackagePriorityCollector new.
		  TITRoelTyperAdaptor new.
		  TITRBRefactoryTyperAdaptor new.
		  TITNameTyperAdaptor new }
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
