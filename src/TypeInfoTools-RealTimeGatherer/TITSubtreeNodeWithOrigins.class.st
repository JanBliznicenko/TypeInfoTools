Class {
	#name : 'TITSubtreeNodeWithOrigins',
	#superclass : 'TITTypeNodeWithOrigins',
	#instVars : [
		'origins',
		'ratio',
		'allOrigins',
		'otherBranches'
	],
	#category : 'TypeInfoTools-RealTimeGatherer-Processing',
	#package : 'TypeInfoTools-RealTimeGatherer',
	#tag : 'Processing'
}

{ #category : 'instance creation' }
TITSubtreeNodeWithOrigins class >> newRoot [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
TITSubtreeNodeWithOrigins >> addOrigin: anOriginClass [

	allOrigins := nil.
	otherBranches := nil.
	ratio := nil.
	origins add: anOriginClass
]

{ #category : 'accessing' }
TITSubtreeNodeWithOrigins >> addOrigins: aCollectionOfClasses [

	aCollectionOfClasses do: [ :each | self addOrigin: each ]
]

{ #category : 'querying' }
TITSubtreeNodeWithOrigins >> allChildOrigins [

	^ self childNodes flatCollect: [ :each | each allOrigins ]
]

{ #category : 'enumerating' }
TITSubtreeNodeWithOrigins >> allOrigins [

	^ allOrigins ifNil: [ allOrigins := self findAllOrigins ]
]

{ #category : 'querying' }
TITSubtreeNodeWithOrigins >> findAllOrigins [

	^ origins , self allChildOrigins
]

{ #category : 'initialization' }
TITSubtreeNodeWithOrigins >> initialize [

	super initialize.
	origins := Set new.
]

{ #category : 'querying' }
TITSubtreeNodeWithOrigins >> mostPreciseNode [

	^ self
		  mostPreciseNodeWithOtherBranches: {  }
		  ifFound: [ :innerFoundNode | innerFoundNode ]
]

{ #category : 'querying' }
TITSubtreeNodeWithOrigins >> mostPreciseNodeWithOtherBranches: aListOfBranches ifFound: aBlock [

	| amountFromOtherBranches amountFromThisBranch |
	otherBranches := aListOfBranches.
	amountFromThisBranch := self allOrigins size.
	amountFromThisBranch
	<
	TITRealTimeInferenceResultsAnalyser minimumAcceptableTypeUsagesAmount
		ifTrue: [ ^ nil ].
	amountFromOtherBranches := otherBranches sumNumbers: [ :each |
		                           each allOrigins size ].
	ratio := amountFromThisBranch
	         / (amountFromThisBranch + amountFromOtherBranches).
	ratio
	< TITRealTimeInferenceResultsAnalyser minimumAcceptableTypeRatio
		ifTrue: [ ^ nil ].
	self childNodes do: [ :each |
			each
				mostPreciseNodeWithOtherBranches:
				(aListOfBranches , self childNodes copyWithout: each)
				ifFound: [ :innerFoundNode | ^ aBlock cull: innerFoundNode ] ].
	self isAcceptableMostPreciseNode ifTrue: [ ^ aBlock cull: self ].
	^ nil
]

{ #category : 'accessing' }
TITSubtreeNodeWithOrigins >> origins [

	^ origins
]

{ #category : 'accessing' }
TITSubtreeNodeWithOrigins >> ratio [

	^ ratio ifNil: [
			  self error:
				  'Ratio needs to be computed first using #ratioWithOtherBranches: or #mostPreciseNode' ]
]

{ #category : 'querying' }
TITSubtreeNodeWithOrigins >> ratioWithOtherBranches: aListOfBranches [

	| amountFromOtherBranches amountFromThisBranch |
	ratio ifNotNil: [ ^ ratio ].
	amountFromOtherBranches := aListOfBranches sumNumbers: [ :each |
		                           each allOrigins size ].
	amountFromThisBranch := self allOrigins size.
	^ ratio := amountFromThisBranch
	           / (amountFromThisBranch + amountFromOtherBranches)
]
