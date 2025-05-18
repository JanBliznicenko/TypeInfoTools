Class {
	#name : 'TITTypedNodeTreePresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'typesLabel',
		'collectionElementTypesLabel',
		'typedNode',
		'classTreePresenter',
		'collectionElementClassTreePresenter'
	],
	#category : 'TypeInfoTools-Browser-Presenters',
	#package : 'TypeInfoTools-Browser',
	#tag : 'Presenters'
}

{ #category : 'instance creation' }
TITTypedNodeTreePresenter class >> openOn: aVariableNode [

	^ (self on: aVariableNode) open
]

{ #category : 'accessing - model' }
TITTypedNodeTreePresenter >> classTreeOf: typesCollection [

	^ (TITClassTree fromDictionary: typesCollection classesWithCollectors)
		  mergeRedundantChildren;
		  removeProtoObject;
		  removeVeryLowWeightNodes;
		  sortByWeight;
		  yourself
]

{ #category : 'layout' }
TITTypedNodeTreePresenter >> defaultCollectionLayout [

	^ SpPanedLayout newLeftToRight
		  add: (SpBoxLayout newTopToBottom
				   add: typesLabel expand: false;
				   add: classTreePresenter;
				   yourself);
		  add: (SpBoxLayout newTopToBottom
				   add: collectionElementTypesLabel expand: false;
				   add: collectionElementClassTreePresenter;
				   yourself);
		  yourself
]

{ #category : 'layout' }
TITTypedNodeTreePresenter >> defaultLayout [

	self hasCollectionElementTypes ifTrue: [
		^ self defaultCollectionLayout ].
	^ self defaultSimpleLayout
]

{ #category : 'layout' }
TITTypedNodeTreePresenter >> defaultSimpleLayout [

	^ SpBoxLayout newLeftToRight
		  add: classTreePresenter;
		  yourself
]

{ #category : 'layout' }
TITTypedNodeTreePresenter >> hasCollectionElementTypes [

	^ typedNode isNotNil and: [
		  typedNode typeInfo collectionElementTypes isNotEmpty ]
]

{ #category : 'initialization' }
TITTypedNodeTreePresenter >> initializePresenters [

	super initializePresenters.
	typesLabel := self newLabel.
	typesLabel label: 'Types'.
	collectionElementTypesLabel := self newLabel.
	collectionElementTypesLabel label: 'Collection element types'.

	classTreePresenter := self
		                      instantiate: TITClassTreePresenter
		                      on:
		                      (self classTreeOf: typedNode typeInfo types).
	collectionElementClassTreePresenter := self
		                                       instantiate:
		                                       TITClassTreePresenter
		                                       on:
		                                       (self classTreeOf:
			                                        typedNode typeInfo
				                                        collectionElementTypes)
]

{ #category : 'initialization' }
TITTypedNodeTreePresenter >> initializeWindow: aWindow [

	| windowExtent |
	super initializeWindow: aWindow.
	aWindow title: 'Types of ' , (typedNode
			 ifNil: [ '' ]
			 ifNotNil: [ :node | node longDescription uncapitalized ]).
	windowExtent := (self hasCollectionElementTypes
		                 ifTrue: [ 1300 ]
		                 ifFalse: [ 700 ]) @ 400.
	aWindow initialExtent: windowExtent
]

{ #category : 'accessing - model' }
TITTypedNodeTreePresenter >> setModelBeforeInitialization: aTypedNode [

	typedNode := aTypedNode
]
