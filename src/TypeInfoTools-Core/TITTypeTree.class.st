Class {
	#name : 'TITTypeTree',
	#superclass : 'Object',
	#instVars : [
		'rootNode'
	],
	#category : 'TypeInfoTools-Core-ClassTree',
	#package : 'TypeInfoTools-Core',
	#tag : 'ClassTree'
}

{ #category : 'instance creation' }
TITTypeTree class >> fromAssociations: aCollectionOfAssociations [

	^ self new
		  addAssociations: aCollectionOfAssociations;
		  yourself
]

{ #category : 'instance creation' }
TITTypeTree class >> fromDictionary: aDictionary [

	^ self new
		  addAssociations: aDictionary associations;
		  yourself
]

{ #category : 'adding' }
TITTypeTree >> addAssociation: anAssociation [

	self addClass: anAssociation key withSources: anAssociation value
]

{ #category : 'adding' }
TITTypeTree >> addAssociations: aCollectionOfAssociations [

	aCollectionOfAssociations do: [ :each | self addAssociation: each ]
]

{ #category : 'adding' }
TITTypeTree >> addClass: aClass [

	^ self rootNode addHierarchy:
		  (aClass withAllSuperclasses copyWith: nil) reversed
]

{ #category : 'adding' }
TITTypeTree >> addClass: aClass withSources: aTypesCollectionSources [

	^ (self addClass: aClass)
		  sources: aTypesCollectionSources;
		  yourself
]

{ #category : 'accessing' }
TITTypeTree >> isEmpty [

	^ self maxWeightInTree isZero
]

{ #category : 'accessing' }
TITTypeTree >> maxWeightInTree [

	^ self maxWeightNode weight
]

{ #category : 'accessing' }
TITTypeTree >> maxWeightNode [

	^ self rootNode maxWeightNode
]

{ #category : 'merging' }
TITTypeTree >> mergeRedundantChildren [

	self rootNode mergeRedundantChildren
]

{ #category : 'accessing' }
TITTypeTree >> minWeightInTree [

	^ self minWeightNode weight
]

{ #category : 'accessing' }
TITTypeTree >> minWeightNode [

	^ self rootNode minWeightNode
]

{ #category : 'modifying' }
TITTypeTree >> prepareForPresenting [

	self
		mergeRedundantChildren;
		removeCommonRootNodes;
		removeVeryLowWeightNodes;
		sortByWeight
]

{ #category : 'removing' }
TITTypeTree >> removeCommonRootNodes [

	[ self tryRemoveCommonRootNode ] whileTrue: [ ]
]

{ #category : 'removing' }
TITTypeTree >> removeVeryLowWeightNodes [

	self rootNode removeNodesWithBestWeightAtMost:
		self rootNode maxWeightInTree
		* self rootNode insignificantWeightTreshold
]

{ #category : 'accessing' }
TITTypeTree >> rootNode [

	^ rootNode ifNil: [ rootNode := TITTypeTreeRootNode new ]
]

{ #category : 'sorting' }
TITTypeTree >> sortByWeight [

	self rootNode sortByWeight
]

{ #category : 'removing' }
TITTypeTree >> tryRemoveCommonRootNode [

	self rootNode subclassNodes size = 1 ifFalse: [ ^ false ].
	({
		 nil.
		 ProtoObject } anySatisfy: [ :each |
		 self rootNode representsClass: each ]) ifFalse: [ ^ false ].
	rootNode := rootNode subclassNodes anyOne asRoot.
	^ true
]
