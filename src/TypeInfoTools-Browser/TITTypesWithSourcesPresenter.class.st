Class {
	#name : 'TITTypesWithSourcesPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'table',
		'typesWithSources',
		'headingLabel',
		'maxWeight'
	],
	#category : 'TypeInfoTools-Browser-Presenters',
	#package : 'TypeInfoTools-Browser',
	#tag : 'Presenters'
}

{ #category : 'initialization' }
TITTypesWithSourcesPresenter >> connectPresenters [

	super connectPresenters.

	table
		activateOnDoubleClick;
		beSingleSelection;
		whenActivatedDo: [ :item | item selectedItem key browse ].

	typesWithSources ifNotNil: [ self updateTable ]
]

{ #category : 'layout' }
TITTypesWithSourcesPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: headingLabel expand: false;
		  add: table;
		  yourself
]

{ #category : 'accessing' }
TITTypesWithSourcesPresenter >> heading: aString [

	headingLabel label: aString
]

{ #category : 'initialization' }
TITTypesWithSourcesPresenter >> initializePresenters [

	super initializePresenters.
	headingLabel := self newLabel.
	headingLabel displayBold: [ :x | true ].
	table := self newTable.
	table
		addColumn: ((SpStringTableColumn
				  title: 'Type'
				  evaluated: [ :pair | pair key name ])
				 width: 250;
				 beSortable;
				 displayColor: [ :pair |
					 (self isLowWeight: pair value weight)
						 ifTrue: [ self theme disabledTextColor ]
						 ifFalse: [ self theme textColor ] ];
				 yourself);
		addColumn: ((SpStringTableColumn
				  title: 'Sources'
				  evaluated: [ :pair | pair value asString ])
				 beSortable;
				 displayColor: [ :pair |
					 (self isLowWeight: pair value weight)
						 ifTrue: [ self theme disabledTextColor ]
						 ifFalse: [ self theme textColor ] ];
				 yourself)
]

{ #category : 'testing' }
TITTypesWithSourcesPresenter >> isLowWeight: aWeight [

	^ aWeight * 2 < self maxWeight
]

{ #category : 'accessing' }
TITTypesWithSourcesPresenter >> maxWeight [

	maxWeight ifNotNil: [ ^ maxWeight ].
	table items ifEmpty: [ ^ 0 ].
	^ maxWeight := table items max: [ :pair | pair value weight ]
]

{ #category : 'accessing' }
TITTypesWithSourcesPresenter >> typesWithSources: anOrderedDictionary [

	typesWithSources := anOrderedDictionary.

	table ifNotNil: [ self updateTable ].

	maxWeight := nil
]

{ #category : 'updating - presenters' }
TITTypesWithSourcesPresenter >> updateTable [

	table items: typesWithSources associations
]
