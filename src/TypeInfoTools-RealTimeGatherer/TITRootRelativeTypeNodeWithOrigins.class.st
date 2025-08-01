Class {
	#name : 'TITRootRelativeTypeNodeWithOrigins',
	#superclass : 'TITSubtreeNodeWithOrigins',
	#instVars : [
		'unrelatedChildNode',
		'relatedChildNodes'
	],
	#category : 'TypeInfoTools-RealTimeGatherer-Processing',
	#package : 'TypeInfoTools-RealTimeGatherer',
	#tag : 'Processing'
}

{ #category : 'instance creation' }
TITRootRelativeTypeNodeWithOrigins class >> newRoot [
	^ self new createChildNodes; yourself
]

{ #category : 'accessing' }
TITRootRelativeTypeNodeWithOrigins >> childNodeForType: aType origin: anOriginClass [

	^ relatedChildNodes
		  detect: [ :any | any isForType: aType refAndReceiverClass: anOriginClass ]
		  ifNone: [ unrelatedChildNode ]
]

{ #category : 'initialization' }
TITRootRelativeTypeNodeWithOrigins >> createChildNodes [

	unrelatedChildNode := TITRelativeTypeNodeWithOrigins forUnrelatedType.
	relatedChildNodes := {
		                     TITRelativeTypeNodeWithOrigins forInstanceType.
		                     TITRelativeTypeNodeWithOrigins forSelfClassType.
		                     TITRelativeTypeNodeWithOrigins forSelfType }.
	childNodes := relatedChildNodes , { unrelatedChildNode }
]

{ #category : 'accessing' }
TITRootRelativeTypeNodeWithOrigins >> forType: aType addOrigin: anOriginClass [

	(self childNodeForType: aType origin: anOriginClass) addaRefAndReceiverClass:
		anOriginClass
]

{ #category : 'accessing' }
TITRootRelativeTypeNodeWithOrigins >> forType: aType addRefAndReceiverClasses: aCollectionOfClasses [

	aCollectionOfClasses do: [ :eachOriginClass |
		self forType: aType addOrigin: eachOriginClass ]
]
