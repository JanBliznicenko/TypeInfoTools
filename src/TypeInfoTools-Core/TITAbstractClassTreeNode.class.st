Class {
	#name : 'TITAbstractClassTreeNode',
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
TITAbstractClassTreeNode class >> forClass: aClass [

	^ self new
		  representedClass: aClass;
		  yourself
]

{ #category : 'adding' }
TITAbstractClassTreeNode >> addHierarchy: aHierarchy [

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
TITAbstractClassTreeNode >> childrenMajorityTreshold [

	^ 2 / 3
]

{ #category : 'adding' }
TITAbstractClassTreeNode >> createSubclassWithHierarchy: aHierarchy [

	| childClass childNode |
	childClass := aHierarchy first.
	childNode := TITClassTreeNode forClass: aHierarchy first parent: self.
	subclassNodes add: childNode.
	^ childNode addHierarchy: aHierarchy
]

{ #category : 'accessing' }
TITAbstractClassTreeNode >> findMaxWeightNode [

	^ self subclassNodes inject: self into: [ :topNode :eachChild |
			  eachChild maxWeightInTree > topNode weight
				  ifTrue: [ eachChild maxWeightNode ]
				  ifFalse: [ topNode ] ]
]

{ #category : 'accessing' }
TITAbstractClassTreeNode >> findMinWeightNode [

	^ self subclassNodes inject: self into: [ :topNode :eachChild |
			  eachChild minWeightInTree < topNode weight
				  ifTrue: [ eachChild minWeightNode ]
				  ifFalse: [ topNode ] ]
]

{ #category : 'testing' }
TITAbstractClassTreeNode >> includesCollector: aCollector [

	^ self sources includesCollector: aCollector
]

{ #category : 'initialization' }
TITAbstractClassTreeNode >> initialize [

	super initialize.
	subclassNodes := OrderedCollection new
]

{ #category : 'constants' }
TITAbstractClassTreeNode >> insignificantWeightTreshold [

	^ 1 / 10
]

{ #category : 'merging' }
TITAbstractClassTreeNode >> isLowWeight [

	^ self weight
	  < (self rootNode maxWeightInTree * self lowWeightTreshold)
]

{ #category : 'testing' }
TITAbstractClassTreeNode >> isRootNode [

	^ false
]

{ #category : 'constants' }
TITAbstractClassTreeNode >> lowWeightTreshold [

	^ 1 / 2
]

{ #category : 'accessing' }
TITAbstractClassTreeNode >> maxWeightInTree [

	^ self maxWeightNode weight
]

{ #category : 'accessing' }
TITAbstractClassTreeNode >> maxWeightNode [

	^ maxWeightNode ifNil: [ maxWeightNode := self findMaxWeightNode ]
]

{ #category : 'merging' }
TITAbstractClassTreeNode >> mergeChildrenMajority [

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
TITAbstractClassTreeNode >> mergeRedundantChildren [

	| copy |
	copy := self subclassNodes asArray.
	copy do: [ :each | each mergeRedundantChildren ].
	self mergeChildrenMajority.
	copy do: [ :each | each mergeIntoParentWithMyCollectors ]
]

{ #category : 'accessing' }
TITAbstractClassTreeNode >> minWeightInTree [

	^ self minWeightNode weight
]

{ #category : 'accessing' }
TITAbstractClassTreeNode >> minWeightNode [

	^ minWeightNode ifNil: [ minWeightNode := self findMinWeightNode ]
]

{ #category : 'accessing' }
TITAbstractClassTreeNode >> parentNode [

	^ self subclassResponsibility 
]

{ #category : 'printing' }
TITAbstractClassTreeNode >> printOn: aStream [

	super printOn: aStream.

	aStream << ' ('.
	self representedClass printOn: aStream.
	aStream << ')'
]

{ #category : 'removing' }
TITAbstractClassTreeNode >> removeChild: aNode [

	subclassNodes remove: aNode
]

{ #category : 'removing' }
TITAbstractClassTreeNode >> removeNodesWithBestWeightAtMost: aWeight [

	subclassNodes do: [ :each |
		each removeNodesWithBestWeightAtMost: aWeight ].
	subclassNodes removeAllSuchThat: [ :each |
		each maxWeightInTree < aWeight ].
	maxWeightNode := nil.
	minWeightNode := nil
]

{ #category : 'accessing' }
TITAbstractClassTreeNode >> representedClass [

	^ representedClass
]

{ #category : 'accessing' }
TITAbstractClassTreeNode >> representedClass: anObject [

	representedClass := anObject
]

{ #category : 'testing' }
TITAbstractClassTreeNode >> representsClass: aClass [

	^ self representedClass = aClass
]

{ #category : 'accessing' }
TITAbstractClassTreeNode >> rootNode [

	^ self subclassResponsibility 
]

{ #category : 'sorting' }
TITAbstractClassTreeNode >> sortByWeight [

	self subclassNodes do: [ :each | each sortByWeight ].
	subclassNodes sort: [ :a :b |
			a maxWeightInTree = b maxWeightInTree
				ifTrue: [ a representedClass name < b representedClass name ]
				ifFalse: [ a maxWeightInTree > b maxWeightInTree ] ]
]

{ #category : 'accessing' }
TITAbstractClassTreeNode >> sources [

	^ sources ifNil: [ sources := TITTypesCollectionSources new ]
]

{ #category : 'accessing' }
TITAbstractClassTreeNode >> sources: aTypesCollectionSources [

	sources := aTypesCollectionSources
]

{ #category : 'accessing' }
TITAbstractClassTreeNode >> subclassNodes [

	^ subclassNodes
]

{ #category : 'accessing' }
TITAbstractClassTreeNode >> subclassNodes: anObject [

	subclassNodes := anObject
]

{ #category : 'accessing' }
TITAbstractClassTreeNode >> weight [

	^ self sources weight
]

{ #category : 'merging' }
TITAbstractClassTreeNode >> withParentsIncludesCollectors: otherCollectors [

	^ (self sources collectors includesAll: otherCollectors) or: [
		  self parentNode withParentsIncludesCollectors: otherCollectors ]
]
