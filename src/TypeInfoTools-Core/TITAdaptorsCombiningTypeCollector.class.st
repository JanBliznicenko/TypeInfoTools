Class {
	#name : 'TITAdaptorsCombiningTypeCollector',
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
TITAdaptorsCombiningTypeCollector class >> allCollectors [

	^ {
		  TITTypeMeTyperAdaptor.
		  TITRoelTyperAdaptor.
		  TITRBRefactoryTyperAdaptor.
		  TITJ2InfererTyperAdaptor.
		  TITNameTyperAdaptor.
		  TITRelatedPackagePriorityCollector }
]

{ #category : 'instance creation' }
TITAdaptorsCombiningTypeCollector class >> fast [

	^ self new
		  collectorClasses: self fastCollectors;
		  yourself
]

{ #category : 'constants' }
TITAdaptorsCombiningTypeCollector class >> fastCollectors [

	^ {
		  TITTypeMeTyperAdaptor.
		  TITRoelTyperAdaptor.
		  TITRBRefactoryTyperAdaptor.
		  TITNameTyperAdaptor.
		  TITRelatedPackagePriorityCollector }
]

{ #category : 'instance creation' }
TITAdaptorsCombiningTypeCollector class >> heuristic [

	^ self new
		  collectorClasses: self heuristicCollectors;
		  yourself
]

{ #category : 'constants' }
TITAdaptorsCombiningTypeCollector class >> heuristicCollectors [

	^ {
		  TITTypeMeTyperAdaptor.
		  TITNameTyperAdaptor.
		  TITRelatedPackagePriorityCollector }
]

{ #category : 'accessing' }
TITAdaptorsCombiningTypeCollector >> collectorClasses: aCollection [

	^ self collectors: (aCollection collect: [ :each |
				   each new
					   messageSendCollector: self;
					   yourself ])
]

{ #category : 'accessing' }
TITAdaptorsCombiningTypeCollector >> collectors [

	^ collectors ifNil: [ self defaultCollectors ]
]

{ #category : 'accessing' }
TITAdaptorsCombiningTypeCollector >> collectors: aCollectionOfCollectors [

	^ collectors := aCollectionOfCollectors
]

{ #category : 'adding' }
TITAdaptorsCombiningTypeCollector >> defaultCollectors [

	^ self collectorClasses: self class allCollectors
]

{ #category : 'initialization' }
TITAdaptorsCombiningTypeCollector >> initialize [

	super initialize.
	reportingBlock := [  ]
]

{ #category : 'adding' }
TITAdaptorsCombiningTypeCollector >> reportingBlock: aBlock [

	reportingBlock := aBlock
]

{ #category : 'visiting' }
TITAdaptorsCombiningTypeCollector >> visitTypedNode: aTypedNode [

	^ self addTypesTo: aTypedNode
]

{ #category : 'accessing' }
TITAdaptorsCombiningTypeCollector >> weight [

	^ self collectors sumNumbers: [ :each | each weight ]
]
