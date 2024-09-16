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

	^ adaptors ifNil: [ self defaultAdaptors ]
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
		  TITRelatedPackageAdaptor new.
		  TITRoelTyperAdaptor new.
		  TITRBRefactoryTyperAdaptor new }
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
