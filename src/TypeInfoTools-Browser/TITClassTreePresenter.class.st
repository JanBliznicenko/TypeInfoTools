Class {
	#name : 'TITClassTreePresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'table',
		'classTree'
	],
	#category : 'TypeInfoTools-Browser-Presenters',
	#package : 'TypeInfoTools-Browser',
	#tag : 'Presenters'
}

{ #category : 'initialization' }
TITClassTreePresenter >> connectPresenters [

	super connectPresenters.

	table
		activateOnDoubleClick;
		beSingleSelection;
		whenActivatedDo: [ :item | item selectedItem representedClass browse ]
]

{ #category : 'layout' }
TITClassTreePresenter >> defaultLayout [

	^ SpBoxLayout newHorizontal
		  add: table;
		  yourself
]

{ #category : 'accessing - model' }
TITClassTreePresenter >> displayColorOf: aNode [

	| intensity |
	classTree maxWeightInTree = classTree minWeightInTree ifTrue: [
		^ self theme textColor ].
	intensity := (aNode weight - classTree minWeightInTree) squared
	             /
	             (classTree maxWeightInTree - classTree minWeightInTree)
		             squared.
	^ self theme textColor
		  mixed: intensity
		  with: self theme disabledTextColor
]

{ #category : 'initialization' }
TITClassTreePresenter >> initializePresenters [

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
TITClassTreePresenter >> setModelBeforeInitialization: aClassTree [

	classTree := aClassTree
]
