Class {
	#name : 'TITMessageListPresenter',
	#superclass : 'StMessageListPresenter',
	#instVars : [
		'typeInfo',
		'maxWeight',
		'typeCollectorsByMessages'
	],
	#category : 'TypeInfoTools-MessageList-Presenters',
	#package : 'TypeInfoTools-MessageList',
	#tag : 'Presenters'
}

{ #category : 'initialization' }
TITMessageListPresenter >> colorOf: item [

	^ (self isLowWeightMethod: item)
		  ifTrue: [ self theme disabledLabelColor ]
		  ifFalse: [ self theme textColor ]
]

{ #category : 'initialization' }
TITMessageListPresenter >> initializePresenters [

	listPresenter := self newTable.
	listPresenter
		sortingBlock: [ :a :b | self sortClassesInCachedHierarchy: a b: b ];
		addColumn: (SpStringTableColumn new
				 title: 'Location';
				 evaluated: [ :item | self locationOf: item ];
				 displayColor: [ :item | self colorOf: item ];
				 yourself);
		addColumn: (SpStringTableColumn new
				 title: 'Selector';
				 evaluated: [ :item | self selectorOf: item ];
				 displayColor: [ :item | self colorOf: item ];
				 yourself);
		addColumn: (SpStringTableColumn new
				 title: 'Package';
				 evaluated: [ :item | self packageNameOf: item ];
				 displayColor: [ :item | self colorOf: item ];
				 yourself);
		beResizable.

	listPresenter outputActivationPort transmitDo: [ :aMethod |
		self doBrowseMethod ].
	listPresenter actions: self messageListActions
]

{ #category : 'accessing' }
TITMessageListPresenter >> isLowWeight: aWeight [

	^ aWeight * 2 < self maxWeight
]

{ #category : 'accessing' }
TITMessageListPresenter >> isLowWeightMethod: aMethod [

	^ self isLowWeight:
		  ((self typeCollectorsByMessages ifEmpty: [ ^ false ])
			   at: aMethod
			   ifAbsent: [ ^ true ]) weight
]

{ #category : 'accessing' }
TITMessageListPresenter >> maxWeight [

	maxWeight ifNotNil: [ ^ maxWeight ].
	typeInfo ifEmpty: [ ^ 0 ].
	^ maxWeight := typeInfo types sortedClasses associations max: [ :pair |
		               pair value weight ]
]

{ #category : 'accessing' }
TITMessageListPresenter >> typeCollectorsByMessages [

	typeCollectorsByMessages ifNotNil: [ ^ typeCollectorsByMessages ].
	typeCollectorsByMessages := Dictionary new.
	allMessages do: [ :eachMessage |
		eachMessage -> (typeInfo types sortedClasses associations
			 detect: [ :any |
			 (any key lookupSelector: eachMessage selector) = eachMessage ]
			 ifFound: [ :typeAndCollectors |
				 typeCollectorsByMessages
					 at: eachMessage
					 put: typeAndCollectors value ]) ].
	^ typeCollectorsByMessages
]

{ #category : 'accessing' }
TITMessageListPresenter >> typeInfo: aTypeInfo [

	typeInfo := aTypeInfo 
]
