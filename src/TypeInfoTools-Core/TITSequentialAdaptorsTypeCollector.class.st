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
		  TITOCTypingVisitorAdaptor.
		  TITRoelTyperAdaptor.
		  TITJ2InfererTyperAdaptor.
		  TITRBRefactoryTyperAdaptor.
		  TITRelatedPackagePriorityCollector.
		  TITNameTyperAdaptor }
]

{ #category : 'instance creation' }
TITSequentialAdaptorsTypeCollector class >> fast [

	^ self new
		  collectorClasses: self fastCollectors;
		  yourself
]

{ #category : 'constants' }
TITSequentialAdaptorsTypeCollector class >> fastCollectors [

	^ {
		  TITRoelTyperAdaptor.
		  TITRBRefactoryTyperAdaptor.
		  TITRelatedPackagePriorityCollector.
		  TITNameTyperAdaptor }
]

{ #category : 'processing' }
TITSequentialAdaptorsTypeCollector >> addTypesTo: aStructureNode [

	self collectors do: [ :each |
			[ each addTypesTo: aStructureNode ]
				on: Error
				do: [ :err |
						err freeze.
						[
							(GrowlMorph
								 openWithLabel: 'Type inference: ' , err className
								 contents: err messageText , String cr , '(click to debug)'
								 backgroundColor: GrowlMorph theme dangerBackgroundColor
								 labelColor: GrowlMorph theme badgeTextColor) actionBlock: [
								err debug ] ] fork ].
			reportingBlock cull: each ]
]

{ #category : 'accessing' }
TITSequentialAdaptorsTypeCollector >> collectorClasses: aCollection [

	^ self collectors: (aCollection collect: [ :each |
				   each new
					   relatedCollector: self;
					   yourself ])
]

{ #category : 'accessing' }
TITSequentialAdaptorsTypeCollector >> collectors [

	^ collectors ifNil: [ self defaultCollectors ]
]

{ #category : 'accessing' }
TITSequentialAdaptorsTypeCollector >> collectors: aCollectionOfCollectors [

	^ collectors := aCollectionOfCollectors
]

{ #category : 'adding' }
TITSequentialAdaptorsTypeCollector >> defaultCollectors [

	^ self collectorClasses: self class allCollectors
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
