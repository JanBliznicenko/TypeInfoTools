Class {
	#name : 'TITSubtreeNodeWithOrigins',
	#superclass : 'TITTypeNodeWithOrigins',
	#instVars : [
		'ratio',
		'otherBranches',
		'refAndReceiverClasses',
		'allReferencingClasses'
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
TITSubtreeNodeWithOrigins >> addaRefAndReceiverClass: aRefAndReceiverClass [

	allReferencingClasses := nil.
	otherBranches := nil.
	ratio := nil.
	refAndReceiverClasses add: aRefAndReceiverClass
]

{ #category : 'accessing' }
TITSubtreeNodeWithOrigins >> addaRefAndReceiverClasses: aRefAndReceiverClasses [

	allReferencingClasses := nil.
	otherBranches := nil.
	ratio := nil.
	refAndReceiverClasses addAll: aRefAndReceiverClasses
]

{ #category : 'querying' }
TITSubtreeNodeWithOrigins >> allChildReferencingClasses [

	^ childNodes flatCollectAsSet: [ :each | each allReferencingClasses ]
]

{ #category : 'enumerating' }
TITSubtreeNodeWithOrigins >> allReferencingClasses [

	^ allReferencingClasses ifNil: [ allReferencingClasses := self findAllReferencingClasses ]
]

{ #category : 'querying' }
TITSubtreeNodeWithOrigins >> findAllReferencingClasses [

	^ refAndReceiverClasses , self allChildReferencingClasses
]

{ #category : 'initialization' }
TITSubtreeNodeWithOrigins >> initialize [

	super initialize.
	refAndReceiverClasses := TITReferencingAndReceiverClassesSet new.
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
	amountFromThisBranch := self allReferencingClasses size.
	amountFromThisBranch
	<
	TITRealTimeInferenceResultsAnalyser minimumAcceptableTypeUsagesAmount
		ifTrue: [ ^ nil ].
	amountFromOtherBranches := otherBranches sumNumbers: [ :each |
		                           each allReferencingClasses size ].
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
		                           each allReferencingClasses size ].
	amountFromThisBranch := self allReferencingClasses size.
	^ ratio := amountFromThisBranch
	           / (amountFromThisBranch + amountFromOtherBranches)
]

{ #category : 'accessing' }
TITSubtreeNodeWithOrigins >> referencingAndReceiverClasses [

	^ refAndReceiverClasses
]
