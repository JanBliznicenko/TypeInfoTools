Class {
	#name : 'TITTypeNodeWithOrigins',
	#superclass : 'Object',
	#instVars : [
		'type',
		'origins',
		'subclassNodes',
		'ratio',
		'allOrigins',
		'otherBranches'
	],
	#category : 'TypeInfoTools-RealTimeGatherer-Processing',
	#package : 'TypeInfoTools-RealTimeGatherer',
	#tag : 'Processing'
}

{ #category : 'accessing' }
TITTypeNodeWithOrigins class >> minimumAcceptableTypeRatio [
	"ratio of type occurences encompassed by a single type in order to be accepted as valid type for the var/method"

	^ 0.98
]

{ #category : 'accessing' }
TITTypeNodeWithOrigins class >> minimumAcceptableTypeUsagesAmount [
	"amount of type occurences encompassed by a single type in order to be accepted as valid type for the var/method"

	^ 10
]

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
	allOrigins := nil.
	otherBranches := nil.
	ratio := nil.
	origins addAll: aCollectionOfClasses
]

{ #category : 'as yet unclassified' }
TITTypeNodeWithOrigins >> allOrigins [

	^ allOrigins ifNil: [
			  allOrigins := origins
			                ,
			                (subclassNodes flatCollectAsSet: [ :each |
				                 each allOrigins ]) ]
]

{ #category : 'accessing' }
TITTypeNodeWithOrigins >> atTypeHierarchy: aClassHierarchy addOrigins: aCollectionOfClasses [

	| directSubclass subclassNode |
	aClassHierarchy ifEmpty: [ ^ self addOrigins: aCollectionOfClasses ].
	directSubclass := aClassHierarchy last.
	subclassNode := subclassNodes
		                at: directSubclass
		                ifAbsentPut: [ self class withType: directSubclass ].
	^ subclassNode
		  atTypeHierarchy: aClassHierarchy allButLast
		  addOrigins: aCollectionOfClasses
]

{ #category : 'comparing' }
TITTypeNodeWithOrigins >> hash [

	^ self type hash
]

{ #category : 'initialization' }
TITTypeNodeWithOrigins >> initialize [

	super initialize.
	subclassNodes := Dictionary new.
	origins := Set new.
]

{ #category : 'as yet unclassified' }
TITTypeNodeWithOrigins >> mostPreciseNode [

	^ self
		  mostPreciseNodeWithOtherBranches: {  }
		  ifFound: [ :innerFoundNode | innerFoundNode ]
]

{ #category : 'as yet unclassified' }
TITTypeNodeWithOrigins >> mostPreciseNodeWithOtherBranches: aListOfBranches ifFound: aBlock [

	| amountFromOtherBranches amountFromThisBranch |
	otherBranches := aListOfBranches.
	amountFromThisBranch := self allOrigins size.
	amountFromThisBranch < self class minimumAcceptableTypeUsagesAmount
		ifTrue: [ ^ nil ].
	amountFromOtherBranches := otherBranches sumNumbers: [ :each |
		                           each allOrigins size ].
	ratio := amountFromThisBranch
	         / (amountFromThisBranch + amountFromOtherBranches).
	ratio < self class minimumAcceptableTypeRatio ifTrue: [ ^ nil ].
	self subclassNodes do: [ :each |
			each
				mostPreciseNodeWithOtherBranches:
				(aListOfBranches , self subclassNodes values copyWithout: each)
				ifFound: [ :innerFoundNode | ^ aBlock cull: innerFoundNode ] ].
	^ aBlock cull: self
]

{ #category : 'accessing' }
TITTypeNodeWithOrigins >> name [

	^ type name
]

{ #category : 'accessing' }
TITTypeNodeWithOrigins >> origins [

	^ origins
]

{ #category : 'as yet unclassified' }
TITTypeNodeWithOrigins >> ratio [
	self shouldBeImplemented.
]

{ #category : 'as yet unclassified' }
TITTypeNodeWithOrigins >> ratioWithOtherBranches: aListOfBranches [

	| amountFromOtherBranches amountFromThisBranch |
	ratio ifNotNil: [ ^ ratio ].
	amountFromOtherBranches := aListOfBranches sumNumbers: [ :each |
		                           each allOrigins size ].
	amountFromThisBranch := self allOrigins size.
	^ ratio := amountFromThisBranch
	           / (amountFromThisBranch + amountFromOtherBranches)
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
