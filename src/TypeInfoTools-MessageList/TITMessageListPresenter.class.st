Class {
	#name : 'TITMessageListPresenter',
	#superclass : 'StMessageListPresenter',
	#instVars : [
		'typeInfo',
		'maxWeight',
		'typeCollectorsByMessages',
		'lowWeightResults'
	],
	#category : 'TypeInfoTools-MessageList-Presenters',
	#package : 'TypeInfoTools-MessageList',
	#tag : 'Presenters'
}

{ #category : 'weight' }
TITMessageListPresenter >> calculateIsLowWeightMethod: aMethod [

	| collectors |
	collectors := self typeCollectorsByMessages ifEmpty: [ ^ false ].
	collectors at: aMethod ifPresent: [ :collector |
		collector weight * 2 < self maxWeight ifFalse: [ ^ false ] ].
	^ aMethod overriddenMethod
		  ifNil: [ true ]
		  ifNotNil: [ :overriddenMethod |
		  self isLowWeightMethod: overriddenMethod ]
]

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

{ #category : 'weight' }
TITMessageListPresenter >> isLowWeightMethod: aMethod [

	^ self lowWeightResults
		  at: aMethod
		  ifAbsentPut: [ self calculateIsLowWeightMethod: aMethod ]
]

{ #category : 'weight' }
TITMessageListPresenter >> lowWeightResults [

	^ lowWeightResults ifNil: [
		  lowWeightResults := IdentityDictionary new ]
]

{ #category : 'weight' }
TITMessageListPresenter >> maxWeight [

	maxWeight ifNotNil: [ ^ maxWeight ].
	typeInfo ifEmpty: [ ^ 0 ].
	^ maxWeight := typeInfo types sortedClasses associations max: [ :pair |
		               pair value weight ]
]

{ #category : 'sorting' }
TITMessageListPresenter >> sortClassesInCachedHierarchy: aMethodDefinition b: otherMethodDefinition [

	| isFirstLowWeight isSecondLowWeight |
	isFirstLowWeight := self isLowWeightMethod: aMethodDefinition.
	isSecondLowWeight := self isLowWeightMethod: otherMethodDefinition.
	isFirstLowWeight = isSecondLowWeight ifFalse: [ ^ isSecondLowWeight ].
	^ super
		  sortClassesInCachedHierarchy: aMethodDefinition
		  b: otherMethodDefinition
]

{ #category : 'accessing' }
TITMessageListPresenter >> typeCollectorsByMessages [

	typeCollectorsByMessages ifNotNil: [ ^ typeCollectorsByMessages ].
	typeCollectorsByMessages := Dictionary new.
	listPresenter items do: [ :eachMessage |
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
