Class {
	#name : 'TITRelativeTypeNodeWithOrigins',
	#superclass : 'TITSubtreeNodeWithOrigins',
	#instVars : [
		'condition',
		'name'
	],
	#category : 'TypeInfoTools-RealTimeGatherer-Processing',
	#package : 'TypeInfoTools-RealTimeGatherer',
	#tag : 'Processing'
}

{ #category : 'instance creation' }
TITRelativeTypeNodeWithOrigins class >> forInstanceType [

	^ self new
		  name: #'#soleInstance';
		  condition: [ :type :refAndReceiverClass |
			  refAndReceiverClass receiverClass isMeta and: [ type class = refAndReceiverClass receiverClass ] ];
		  yourself
]

{ #category : 'instance creation' }
TITRelativeTypeNodeWithOrigins class >> forSelfClassType [

	^ self new
		  name: #'#class';
		  condition: [ :type :refAndReceiverClass |
			  type isMeta and: [
					  type = refAndReceiverClass receiverClass class ] ];
		  yourself
]

{ #category : 'instance creation' }
TITRelativeTypeNodeWithOrigins class >> forSelfType [

	^ self new
		  name: #'#yourself';
		  condition: [ :type :refAndReceiverClass |
			  type = refAndReceiverClass receiverClass ];
		  yourself
]

{ #category : 'instance creation' }
TITRelativeTypeNodeWithOrigins class >> forUnrelatedType [

	^ self new
]

{ #category : 'instance creation' }
TITRelativeTypeNodeWithOrigins class >> newRoot [

	^ self new
]

{ #category : 'instance creation' }
TITRelativeTypeNodeWithOrigins class >> newWithRefAndReceiverClass: aRefAndReceiverClass [

	^ self new
		  addaRefAndReceiverClasses: { aRefAndReceiverClass };
		  yourself
]

{ #category : 'comparing' }
TITRelativeTypeNodeWithOrigins >> = anObject [
	"Answer whether the receiver and anObject represent the same object."

	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	^ name = anObject name
]

{ #category : 'accessing' }
TITRelativeTypeNodeWithOrigins >> condition: aBlock [

	condition := aBlock
]

{ #category : 'comparing' }
TITRelativeTypeNodeWithOrigins >> hash [
	"Answer an integer value that is related to the identity of the receiver."

	^ name hash
]

{ #category : 'testing' }
TITRelativeTypeNodeWithOrigins >> isAcceptableMostPreciseNode [

	^ condition isNotNil
]

{ #category : 'testing' }
TITRelativeTypeNodeWithOrigins >> isForType: aType refAndReceiverClass: aRefAndReceiverClass [

	^ condition value: aType value: aRefAndReceiverClass
]

{ #category : 'accessing' }
TITRelativeTypeNodeWithOrigins >> name [

	^ name
]

{ #category : 'accessing' }
TITRelativeTypeNodeWithOrigins >> name: aString [

	name := aString asSymbol
]
