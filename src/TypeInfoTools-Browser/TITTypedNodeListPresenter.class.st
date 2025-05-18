Class {
	#name : 'TITTypedNodeListPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'typesPresenter',
		'collectionElementTypesPresenter',
		'typedNode'
	],
	#category : 'TypeInfoTools-Browser-Presenters',
	#package : 'TypeInfoTools-Browser',
	#tag : 'Presenters'
}

{ #category : 'instance creation' }
TITTypedNodeListPresenter class >> openOn: aVariableNode [

	^ self new
		  typedNode: aVariableNode;
		  open
]

{ #category : 'initialization' }
TITTypedNodeListPresenter >> connectPresenters [

	super connectPresenters.
	typedNode ifNotNil: [ self update ]
]

{ #category : 'layout' }
TITTypedNodeListPresenter >> defaultCollectionLayout [

	^ SpPanedLayout newLeftToRight
		  add: typesPresenter;
		  add: collectionElementTypesPresenter;
		  yourself
]

{ #category : 'layout' }
TITTypedNodeListPresenter >> defaultLayout [

	self hasCollectionElementTypes ifTrue: [
		^ self defaultCollectionLayout ].
	^ self defaultSimpleLayout
]

{ #category : 'layout' }
TITTypedNodeListPresenter >> defaultSimpleLayout [

	^ SpBoxLayout newLeftToRight
		  add: typesPresenter;
		  yourself
]

{ #category : 'layout' }
TITTypedNodeListPresenter >> hasCollectionElementTypes [

	^ typedNode isNotNil and: [
		  typedNode typeInfo collectionElementTypes isNotEmpty ]
]

{ #category : 'initialization' }
TITTypedNodeListPresenter >> initializePresenters [

	super initializePresenters.
	typesPresenter := self instantiate: TITTypesWithSourcesPresenter.
	typesPresenter heading: 'Types'.
	collectionElementTypesPresenter := self instantiate:
		                                   TITTypesWithSourcesPresenter.
	collectionElementTypesPresenter heading: 'Collection element types'
]

{ #category : 'initialization' }
TITTypedNodeListPresenter >> initializeWindow: aWindow [

	super initializeWindow: aWindow.
	self updateWindow: aWindow
]

{ #category : 'initialization' }
TITTypedNodeListPresenter >> typedNode: aTypedNode [

	typedNode := aTypedNode.
	typesPresenter ifNotNil: [ self update ]
]

{ #category : 'updating - presenters' }
TITTypedNodeListPresenter >> update [

	(TITClassTree fromDictionary:
			 typedNode typeInfo types classesWithCollectors)
		mergeRedundantChildren;
		removeProtoObject;
		removeVeryLowWeightNodes;
		sortByWeight;
		inspect.
	typesPresenter typesWithSources:
		typedNode typeInfo types sortedClasses.
	collectionElementTypesPresenter typesWithSources:
		typedNode typeInfo collectionElementTypes sortedClasses.
	self updateLayout.
	self updateWindow
]

{ #category : 'private' }
TITTypedNodeListPresenter >> updateLayout [

	self layout: self defaultLayout
]

{ #category : 'updating - presenters' }
TITTypedNodeListPresenter >> updateWindow [

	self withWindowDo: [ :window | self updateWindow: window ]
]

{ #category : 'updating - presenters' }
TITTypedNodeListPresenter >> updateWindow: aWindow [

	| windowExtent |
	aWindow title: 'Types of '
		,
		(typedNode ifNil: [ '' ] ifNotNil: [ :node | node longDescription uncapitalized ]).
	windowExtent := (self hasCollectionElementTypes
		                 ifTrue: [ 1200 ]
		                 ifFalse: [ 600 ]) @ 400.
	aWindow isDisplayed
		ifTrue: [ aWindow extent: windowExtent ]
		ifFalse: [ aWindow initialExtent: windowExtent ]
]
