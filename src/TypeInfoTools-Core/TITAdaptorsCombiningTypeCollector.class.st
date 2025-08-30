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

{ #category : 'instance creation' }
TITAdaptorsCombiningTypeCollector class >> all [

	^ self new
		  collectorClasses: self allCollectors;
		  yourself
]

{ #category : 'constants' }
TITAdaptorsCombiningTypeCollector class >> allCollectors [

	^ {
		  TITTypeMeTyperAdaptor.
		  TITRoelTyperAdaptor.
		  TITRBRefactoryTyperAdaptor.
		  TITJ2InfererTyperAdaptor.
		  TITNameStatisticsTyperAdaptor.
		  TITNameHeuristicsTyperAdaptor.
		  TITRelatedPackagePriorityCollector }
]

{ #category : 'instance creation' }
TITAdaptorsCombiningTypeCollector class >> default [

	^ self new
		  collectorClasses: self defaultCollectors;
		  yourself
]

{ #category : 'constants' }
TITAdaptorsCombiningTypeCollector class >> defaultCollectors [

	^ {
		  TITTypeMeTyperAdaptor.
		  TITRoelTyperAdaptor.
		  TITRBRefactoryTyperAdaptor.
		  TITNameStatisticsTyperAdaptor.
		  TITNameHeuristicsTyperAdaptor.
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
		  TITNameStatisticsTyperAdaptor.
		  TITNameHeuristicsTyperAdaptor.
		  TITRelatedPackagePriorityCollector }
]

{ #category : 'instance creation' }
TITAdaptorsCombiningTypeCollector class >> noStat [

	^ self new
		  collectorClasses: self noStatCollectors;
		  yourself
]

{ #category : 'constants' }
TITAdaptorsCombiningTypeCollector class >> noStatCollectors [

	^ {
		  TITTypeMeTyperAdaptor.
		  TITRoelTyperAdaptor.
		  TITRBRefactoryTyperAdaptor.
		  TITNameHeuristicsTyperAdaptor.
		  TITRelatedPackagePriorityCollector }
]

{ #category : 'instance creation' }
TITAdaptorsCombiningTypeCollector class >> noTypeMe [

	^ self new
		  collectorClasses: self noTypeMeCollectors;
		  yourself
]

{ #category : 'constants' }
TITAdaptorsCombiningTypeCollector class >> noTypeMeCollectors [

	^ {
		  TITRoelTyperAdaptor.
		  TITRBRefactoryTyperAdaptor.
		  TITNameStatisticsTyperAdaptor.
		  TITNameHeuristicsTyperAdaptor.
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
