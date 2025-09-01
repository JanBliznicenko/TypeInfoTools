Class {
	#name : 'TITAbstractTypeTreeNode',
	#superclass : 'Object',
	#instVars : [
		'representedClass',
		'subclassNodes',
		'sources',
		'maxWeightNode',
		'minWeightNode'
	],
	#category : 'TypeInfoTools-Core-ClassTree',
	#package : 'TypeInfoTools-Core',
	#tag : 'ClassTree'
}

{ #category : 'instance creation' }
TITAbstractTypeTreeNode class >> forClass: aClass [

	^ self new
		  representedClass: aClass;
		  yourself
]

{ #category : 'adding' }
TITAbstractTypeTreeNode >> addHierarchy: aHierarchy [

	| subHierarchy nextInHierarchy |
	aHierarchy ifEmpty: [ ^ self ].
	aHierarchy first = self representedClass ifFalse: [
		self error: 'Not the same hierarchy' ].
	subHierarchy := aHierarchy allButFirst ifEmpty: [ ^ self ].
	nextInHierarchy := subHierarchy first.
	self subclassNodes
		detect: [ :any | any representsClass: nextInHierarchy ]
		ifFound: [ :found | ^ found addHierarchy: subHierarchy ].
	^ self createSubclassWithHierarchy: subHierarchy
]

{ #category : 'constants' }
TITAbstractTypeTreeNode >> childrenMajorityTreshold [

	^ 2 / 3
]

{ #category : 'adding' }
TITAbstractTypeTreeNode >> createSubclassWithHierarchy: aHierarchy [

	| childClass childNode |
	childClass := aHierarchy first.
	childNode := TITTypeTreeNode forClass: aHierarchy first parent: self.
	subclassNodes add: childNode.
	^ childNode addHierarchy: aHierarchy
]

{ #category : 'accessing' }
TITAbstractTypeTreeNode >> findMaxWeightNode [

	^ self subclassNodes inject: self into: [ :topNode :eachChild |
			  eachChild maxWeightInTree > topNode weight
				  ifTrue: [ eachChild maxWeightNode ]
				  ifFalse: [ topNode ] ]
]

{ #category : 'accessing' }
TITAbstractTypeTreeNode >> findMinWeightNode [

	^ self subclassNodes inject: self into: [ :topNode :eachChild |
			  eachChild minWeightInTree < topNode weight
				  ifTrue: [ eachChild minWeightNode ]
				  ifFalse: [ topNode ] ]
]

{ #category : 'testing' }
TITAbstractTypeTreeNode >> includesCollector: aCollector [

	^ self sources includesCollector: aCollector
]

{ #category : 'initialization' }
TITAbstractTypeTreeNode >> initialize [

	super initialize.
	subclassNodes := OrderedCollection new
]

{ #category : 'constants' }
TITAbstractTypeTreeNode >> insignificantWeightTreshold [

	^ 1 / 10
]

{ #category : 'merging' }
TITAbstractTypeTreeNode >> isLowWeight [

	^ self weight
	  < (self rootNode maxWeightInTree * self lowWeightTreshold)
]

{ #category : 'testing' }
TITAbstractTypeTreeNode >> isRootNode [

	^ false
]

{ #category : 'constants' }
TITAbstractTypeTreeNode >> lowWeightTreshold [

	^ 1 / 2
]

{ #category : 'accessing' }
TITAbstractTypeTreeNode >> maxWeightInTree [

	^ self maxWeightNode weight
]

{ #category : 'accessing' }
TITAbstractTypeTreeNode >> maxWeightNode [

	^ maxWeightNode ifNil: [ maxWeightNode := self findMaxWeightNode ]
]

{ #category : 'merging' }
TITAbstractTypeTreeNode >> mergeChildrenMajority [

	| uniqueCollectorsInChildren subclassCount |
	uniqueCollectorsInChildren := (self subclassNodes flatCollectAsSet: [
		                               :each | each sources collectors ])
		                              reject: [ :any |
		                              self includesCollector: any ].
	subclassCount := self representedClass subclasses size.
	uniqueCollectorsInChildren
		select: [ :eachCollector |
				(self subclassNodes count: [ :eachChild |
					 eachChild includesCollector: eachCollector ])
				>= (subclassCount * self childrenMajorityTreshold) ]
		thenDo: [ :eachCollector | self sources add: eachCollector ]
]

{ #category : 'merging' }
TITAbstractTypeTreeNode >> mergeRedundantChildren [

	| copy |
	copy := self subclassNodes asArray.
	copy do: [ :each | each mergeRedundantChildren ].
	self mergeChildrenMajority.
	copy do: [ :each | each mergeIntoParentWithMyCollectors ]
]

{ #category : 'accessing' }
TITAbstractTypeTreeNode >> minWeightInTree [

	^ self minWeightNode weight
]

{ #category : 'accessing' }
TITAbstractTypeTreeNode >> minWeightNode [

	^ minWeightNode ifNil: [ minWeightNode := self findMinWeightNode ]
]

{ #category : 'accessing' }
TITAbstractTypeTreeNode >> parentNode [

	^ self subclassResponsibility 
]

{ #category : 'printing' }
TITAbstractTypeTreeNode >> printOn: aStream [

	super printOn: aStream.

	aStream << ' ('.
	self representedClass printOn: aStream.
	aStream << ')'
]

{ #category : 'removing' }
TITAbstractTypeTreeNode >> removeChild: aNode [

	subclassNodes remove: aNode
]

{ #category : 'removing' }
TITAbstractTypeTreeNode >> removeNodesWithBestWeightAtMost: aWeight [

	subclassNodes do: [ :each |
		each removeNodesWithBestWeightAtMost: aWeight ].
	subclassNodes removeAllSuchThat: [ :each |
		each maxWeightInTree < aWeight ].
	maxWeightNode := nil.
	minWeightNode := nil
]

{ #category : 'accessing' }
TITAbstractTypeTreeNode >> representedClass [

	^ representedClass
]

{ #category : 'accessing' }
TITAbstractTypeTreeNode >> representedClass: anObject [

	representedClass := anObject
]

{ #category : 'testing' }
TITAbstractTypeTreeNode >> representsClass: aClass [

	^ self representedClass = aClass
]

{ #category : 'accessing' }
TITAbstractTypeTreeNode >> rootNode [

	^ self subclassResponsibility 
]

{ #category : 'sorting' }
TITAbstractTypeTreeNode >> sortByWeight [

	self subclassNodes do: [ :each | each sortByWeight ].
	subclassNodes sort: [ :a :b |
			a maxWeightInTree = b maxWeightInTree
				ifTrue: [ a representedClass name < b representedClass name ]
				ifFalse: [ a maxWeightInTree > b maxWeightInTree ] ]
]

{ #category : 'accessing' }
TITAbstractTypeTreeNode >> sources [

	^ sources ifNil: [ sources := TITTypesCollectionSources new ]
]

{ #category : 'accessing' }
TITAbstractTypeTreeNode >> sources: aTypesCollectionSources [

	sources := aTypesCollectionSources
]

{ #category : 'accessing' }
TITAbstractTypeTreeNode >> subclassNodes [

	^ subclassNodes
]

{ #category : 'accessing' }
TITAbstractTypeTreeNode >> subclassNodes: anObject [

	subclassNodes := anObject
]

{ #category : 'accessing' }
TITAbstractTypeTreeNode >> weight [

	^ self sources weight
]

{ #category : 'merging' }
TITAbstractTypeTreeNode >> withParentsIncludesCollectors: otherCollectors [

	^ (self sources collectors includesAll: otherCollectors) or: [
		  self parentNode withParentsIncludesCollectors: otherCollectors ]
]
