Class {
	#name : 'TITTypesWithSourcesPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'table',
		'typesWithSources',
		'headingLabel'
	],
	#category : 'TypeInfoTools-GUI',
	#package : 'TypeInfoTools',
	#tag : 'GUI'
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
		addColumn:
			((SpStringTableColumn title: 'Type' evaluated: [ :pair | pair key ])
				 width: 250;
				 beSortable;
				 yourself);
		addColumn: ((SpStringTableColumn
				  title: 'Sources'
				  evaluated: [ :pair | pair value ])
				 beSortable;
				 yourself)
]

{ #category : 'accessing' }
TITTypesWithSourcesPresenter >> typesWithSources: anOrderedDictionary [

	typesWithSources := anOrderedDictionary.

	table ifNotNil: [ self updateTable ]
]

{ #category : 'updating - presenters' }
TITTypesWithSourcesPresenter >> updateTable [

	table items: typesWithSources associations
]
