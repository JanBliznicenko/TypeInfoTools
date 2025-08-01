Class {
	#name : 'TITAlternativeTreesRootNodeWithOrigins',
	#superclass : 'TITTypeNodeWithOrigins',
	#category : 'TypeInfoTools-RealTimeGatherer-Processing',
	#package : 'TypeInfoTools-RealTimeGatherer',
	#tag : 'Processing'
}

{ #category : 'enumerating' }
TITAlternativeTreesRootNodeWithOrigins >> allReferencingClasses [

	| allOrigins |
	allOrigins := childNodes first allReferencingClasses.
	self assert: [
			childNodes allButFirst allSatisfy: [ :each |
				each allReferencingClasses = allOrigins ] ].
	^ allOrigins
]

{ #category : 'accessing' }
TITAlternativeTreesRootNodeWithOrigins >> forType: aType addRefAndReceiverClasses: aRefAndReceiverClasses [

	self childNodes do: [ :eachChild |
		eachChild forType: aType addRefAndReceiverClasses: aRefAndReceiverClasses ]
]

{ #category : 'initialization' }
TITAlternativeTreesRootNodeWithOrigins >> initialize [

	super initialize.
	childNodes := {
		              TITSpecificTypeNodeWithOrigins.
		              TITRootRelativeTypeNodeWithOrigins } collect: [ :each |
		              each newRoot ]
]

{ #category : 'querying' }
TITAlternativeTreesRootNodeWithOrigins >> mostPreciseNode [

	| mostPreciseSubnodes |
	mostPreciseSubnodes := self childNodes
		                       collect: [ :eachAlternativeNode |
		                       eachAlternativeNode mostPreciseNode ]
		                       thenSelect: [ :each | each isNotNil ].
	mostPreciseSubnodes ifEmpty: [ ^ nil ].
	^ mostPreciseSubnodes
		  inject: mostPreciseSubnodes anyOne
		  into: [ :max :each |
				  each ratio > max ratio
					  ifTrue: [ each ]
					  ifFalse: [ max ] ]
]
