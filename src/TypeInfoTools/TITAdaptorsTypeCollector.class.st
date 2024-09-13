Class {
	#name : 'TITAdaptorsTypeCollector',
	#superclass : 'TITTypeCollector',
	#instVars : [
		'adaptors',
		'reportingBlock'
	],
	#category : 'TypeInfoTools-Inference',
	#package : 'TypeInfoTools',
	#tag : 'Inference'
}

{ #category : 'adding' }
TITAdaptorsTypeCollector >> adaptors [

	^ adaptors
]

{ #category : 'adding' }
TITAdaptorsTypeCollector >> adaptors: aCollectionOfAdaptors [

	adaptors := aCollectionOfAdaptors
]

{ #category : 'adding' }
TITAdaptorsTypeCollector >> addTypesTo: aStructureNode [

	adaptors do: [ :each |
		each addTypesTo: aStructureNode.
		reportingBlock cull: each ]
]

{ #category : 'adding' }
TITAdaptorsTypeCollector >> defaultAdaptors [

	^ {
		  TITRoelTyperAdaptor.
		  TITRBRefactoryTyperAdaptor.
		  TITRelatedPackageAdaptor }
]

{ #category : 'initialization' }
TITAdaptorsTypeCollector >> initialize [

	super initialize.
	reportingBlock := [  ]
]

{ #category : 'adding' }
TITAdaptorsTypeCollector >> reportingBlock: aBlock [

	reportingBlock := aBlock
]
