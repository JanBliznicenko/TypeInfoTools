Class {
	#name : 'TITTypeNodeWithOrigins',
	#superclass : 'Object',
	#instVars : [
		'type',
		'origins',
		'subclassNodes'
	],
	#category : 'TypeInfoTools-RealTimeGatherer-Structure',
	#package : 'TypeInfoTools-RealTimeGatherer',
	#tag : 'Structure'
}

{ #category : 'as yet unclassified' }
TITTypeNodeWithOrigins class >> withType: aClass [

	^ self new
		  type: aClass;
		  yourself
]

{ #category : 'comparing' }
TITTypeNodeWithOrigins >> = otherNode [

	^ self type = otherNode type
]

{ #category : 'accessing' }
TITTypeNodeWithOrigins >> addOrigins: aCollectionOfClasses [

	self haltIf: [ origins includesAnyOf: aCollectionOfClasses ].
	origins addAll: aCollectionOfClasses
]

{ #category : 'accessing' }
TITTypeNodeWithOrigins >> atTypeHierarchy: aClassHierarchy addOrigins: aCollectionOfClasses [

	| directSubclass subclassNode |
	aClassHierarchy ifEmpty: [ ^ self addOrigins: aCollectionOfClasses ].
	directSubclass := aClassHierarchy first.
	subclassNode := subclassNodes
		                at: directSubclass
		                ifAbsentPut: [ self class withType: directSubclass ].
	^ subclassNode
		  atTypeHierarchy: aClassHierarchy allButFirst
		  addOrigins: aCollectionOfClasses
]

{ #category : 'comparing' }
TITTypeNodeWithOrigins >> hash [

	^ self type hash
]

{ #category : 'initialization' }
TITTypeNodeWithOrigins >> initialize [

	super initialize.
	subclassNodes := Dictionary new
]

{ #category : 'accessing' }
TITTypeNodeWithOrigins >> origins [

	^ origins
]

{ #category : 'accessing' }
TITTypeNodeWithOrigins >> subclassNodes [

	^ subclassNodes
]

{ #category : 'accessing' }
TITTypeNodeWithOrigins >> type [

	^ type
]

{ #category : 'accessing' }
TITTypeNodeWithOrigins >> type: anObject [

	type := anObject
]
