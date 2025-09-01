Class {
	#name : 'TITTypeTreePresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'table',
		'classTree'
	],
	#category : 'TypeInfoTools-TreePresenter-Presenters',
	#package : 'TypeInfoTools-TreePresenter',
	#tag : 'Presenters'
}

{ #category : 'initialization' }
TITTypeTreePresenter >> connectPresenters [

	super connectPresenters.

	table
		activateOnDoubleClick;
		beSingleSelection;
		whenActivatedDo: [ :item | item selectedItem representedClass browse ]
]

{ #category : 'layout' }
TITTypeTreePresenter >> defaultLayout [

	^ SpBoxLayout newHorizontal
		  add: table;
		  yourself
]

{ #category : 'accessing - model' }
TITTypeTreePresenter >> displayColorOf: aNode [

	| intensity |
	classTree maxWeightInTree = classTree minWeightInTree ifTrue: [
		^ self theme textColor ].
	intensity := aNode weight - classTree minWeightInTree
	             /
	             (classTree maxWeightInTree - classTree minWeightInTree).
	^ self theme textColor
		  mixed: intensity
		  with: self theme disabledTextColor
]

{ #category : 'initialization' }
TITTypeTreePresenter >> initializePresenters [

	super initializePresenters.
	table := self newTreeTable
		         roots: classTree rootNode subclassNodes;
		         children: [ :each | each subclassNodes ];
		         addColumn: ((SpStringTableColumn
				           title: 'Type'
				           evaluated: [ :node | node representedClass name ])
				          displayColor: [ :node | self displayColorOf: node ];
				          width: 300;
				          yourself);
		         addColumn: ((SpStringTableColumn
				           title: 'Sources'
				           evaluated: [ :node |
					           (node sources ifNil: [ '' ]) asString ])
				          displayColor: [ :node | self displayColorOf: node ];
				          yourself);
		         beResizable;
		         expandAll;
		         yourself
]

{ #category : 'accessing - model' }
TITTypeTreePresenter >> setModelBeforeInitialization: aClassTree [

	classTree := aClassTree
]
