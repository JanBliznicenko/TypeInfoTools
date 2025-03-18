Class {
	#name : 'TITSequentialAdaptorsTypeCollector',
	#superclass : 'TITStructureNodeVisitor',
	#instVars : [
		'collectors',
		'reportingBlock'
	],
	#category : 'TypeInfoTools-Core-Inference',
	#package : 'TypeInfoTools-Core',
	#tag : 'Inference'
}

{ #category : 'constants' }
TITSequentialAdaptorsTypeCollector class >> allCollectors [

	^ {
		  TITRoelTyperAdaptor.
		  TITJ2InfererTyperAdaptor.
		  TITRBRefactoryTyperAdaptor.
		  TITRelatedPackagePriorityCollector.
		  TITNameTyperAdaptor }
]

{ #category : 'instance creation' }
TITSequentialAdaptorsTypeCollector class >> fast [

	^ self new
		  collectors: self fastCollectors;
		  yourself
]

{ #category : 'constants' }
TITSequentialAdaptorsTypeCollector class >> fastCollectors [

	^ {
		  TITRoelTyperAdaptor.
		  TITRelatedPackagePriorityCollector.
		  TITNameTyperAdaptor }
]

{ #category : 'processing' }
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

	^ self class allCollectors collect: [ :each |
		  each new
			  relatedCollector: self;
			  yourself ]
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

{ #category : 'visiting' }
TITSequentialAdaptorsTypeCollector >> visitTypedNode: aTypedNode [

	^ self addTypesTo: aTypedNode
]
