Class {
	#name : 'TITTypedNodePresenter',
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
TITTypedNodePresenter class >> openOn: aVariableNode [

	^ self new
		  typedNode: aVariableNode;
		  open
]

{ #category : 'initialization' }
TITTypedNodePresenter >> connectPresenters [

	super connectPresenters.
	typedNode ifNotNil: [ self update ]
]

{ #category : 'layout' }
TITTypedNodePresenter >> defaultCollectionLayout [

	^ SpPanedLayout newLeftToRight
		  add: typesPresenter;
		  add: collectionElementTypesPresenter;
		  yourself
]

{ #category : 'layout' }
TITTypedNodePresenter >> defaultLayout [

	self hasCollectionElementTypes ifTrue: [
		^ self defaultCollectionLayout ].
	^ self defaultSimpleLayout
]

{ #category : 'layout' }
TITTypedNodePresenter >> defaultSimpleLayout [

	^ SpBoxLayout newLeftToRight
		  add: typesPresenter;
		  yourself
]

{ #category : 'layout' }
TITTypedNodePresenter >> hasCollectionElementTypes [

	^ typedNode isNotNil and: [
		  typedNode typeInfo collectionElementTypes isNotEmpty ]
]

{ #category : 'initialization' }
TITTypedNodePresenter >> initializePresenters [

	super initializePresenters.
	typesPresenter := self instantiate: TITTypesWithSourcesPresenter.
	typesPresenter heading: 'Types'.
	collectionElementTypesPresenter := self instantiate:
		                                   TITTypesWithSourcesPresenter.
	collectionElementTypesPresenter heading: 'Collection element types'
]

{ #category : 'initialization' }
TITTypedNodePresenter >> initializeWindow: aWindow [

	super initializeWindow: aWindow.
	self updateWindow: aWindow
]

{ #category : 'initialization' }
TITTypedNodePresenter >> typedNode: aTypedNode [

	typedNode := aTypedNode.
	typesPresenter ifNotNil: [ self update ]
]

{ #category : 'updating - presenters' }
TITTypedNodePresenter >> update [

	typesPresenter typesWithSources:
		typedNode typeInfo types sortedClasses.
	collectionElementTypesPresenter typesWithSources:
		typedNode typeInfo collectionElementTypes sortedClasses.
	self updateLayout.
	self updateWindow
]

{ #category : 'private' }
TITTypedNodePresenter >> updateLayout [

	self layout: self defaultLayout
]

{ #category : 'updating - presenters' }
TITTypedNodePresenter >> updateWindow [

	self withWindowDo: [ :window | self updateWindow: window ]
]

{ #category : 'updating - presenters' }
TITTypedNodePresenter >> updateWindow: aWindow [

	| windowExtent |
	aWindow title: 'Types of '
		,
		(typedNode ifNil: [ '' ] ifNotNil: [ :node | node longDescription ]).
	windowExtent := (self hasCollectionElementTypes
		                 ifTrue: [ 1200 ]
		                 ifFalse: [ 600 ]) @ 400.
	aWindow isDisplayed
		ifTrue: [ aWindow extent: windowExtent ]
		ifFalse: [ aWindow initialExtent: windowExtent ]
]
