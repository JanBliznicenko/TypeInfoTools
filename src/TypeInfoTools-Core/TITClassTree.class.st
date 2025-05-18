Class {
	#name : 'TITClassTree',
	#superclass : 'Object',
	#instVars : [
		'rootNode'
	],
	#category : 'TypeInfoTools-Core-ClassTree',
	#package : 'TypeInfoTools-Core',
	#tag : 'ClassTree'
}

{ #category : 'instance creation' }
TITClassTree class >> fromAssociations: aCollectionOfAssociations [

	^ self new
		  addAssociations: aCollectionOfAssociations;
		  yourself
]

{ #category : 'instance creation' }
TITClassTree class >> fromDictionary: aDictionary [

	^ self new
		  addAssociations: aDictionary associations;
		  yourself
]

{ #category : 'adding' }
TITClassTree >> addAssociation: anAssociation [

	self addClass: anAssociation key withSources: anAssociation value
]

{ #category : 'adding' }
TITClassTree >> addAssociations: aCollectionOfAssociations [

	aCollectionOfAssociations do: [ :each | self addAssociation: each ]
]

{ #category : 'adding' }
TITClassTree >> addClass: aClass [

	^ self rootNode addHierarchy: aClass withAllSuperclasses reversed
]

{ #category : 'adding' }
TITClassTree >> addClass: aClass withSources: aTypesCollectionSources [

	^ (self addClass: aClass)
		  sources: aTypesCollectionSources;
		  yourself
]

{ #category : 'accessing' }
TITClassTree >> isEmpty [

	^ self maxWeightInTree isZero
]

{ #category : 'accessing' }
TITClassTree >> maxWeightInTree [

	^ self maxWeightNode weight
]

{ #category : 'accessing' }
TITClassTree >> maxWeightNode [

	^ self rootNode maxWeightNode
]

{ #category : 'merging' }
TITClassTree >> mergeRedundantChildren [

	self rootNode mergeRedundantChildren
]

{ #category : 'accessing' }
TITClassTree >> minWeightInTree [

	^ self minWeightNode weight
]

{ #category : 'accessing' }
TITClassTree >> minWeightNode [

	^ self rootNode minWeightNode
]

{ #category : 'removing' }
TITClassTree >> removeProtoObject [

	self rootNode subclassNodes ifEmpty: [ ^ self ].
	(self rootNode representsClass: ProtoObject) ifFalse: [ ^ self ].
	self rootNode subclassNodes size > 1 ifTrue: [ ^ self ].
	rootNode := rootNode subclassNodes anyOne asRoot
]

{ #category : 'removing' }
TITClassTree >> removeVeryLowWeightNodes [

	self rootNode removeNodesWithBestWeightAtMost:
		self rootNode maxWeightInTree
		* self rootNode insignificantWeightTreshold
]

{ #category : 'accessing' }
TITClassTree >> rootNode [

	^ rootNode ifNil: [ rootNode := TITClassTreeRootNode new ]
]

{ #category : 'sorting' }
TITClassTree >> sortByWeight [

	self rootNode sortByWeight
]
