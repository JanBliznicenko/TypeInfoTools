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

{ #category : 'testing' }
TITRelativeTypeNodeWithOrigins class >> detectForType: aType origin: anOriginClass ifNone: aBlock [

	^ self subclasses
		  detect: [ :eachSubclass |
		  eachSubclass isForType: aType origin: anOriginClass ]
		  ifNone: aBlock
]

{ #category : 'as yet unclassified' }
TITRelativeTypeNodeWithOrigins class >> forInstanceType [

	^ self new
		  name: '~soleInstance';
		  condition: [ :type :originClass |
			  originClass isMeta and: [ type class = originClass ] ];
		  yourself
]

{ #category : 'as yet unclassified' }
TITRelativeTypeNodeWithOrigins class >> forSelfClassType [

	^ self new
		  name: '#class';
		  condition: [ :type :originClass |
			  type isMeta and: [ type = originClass class ] ];
		  yourself
]

{ #category : 'as yet unclassified' }
TITRelativeTypeNodeWithOrigins class >> forSelfType [

	^ self new
		  name: '#yourself';
		  condition: [ :type :originClass | type = originClass ];
		  yourself
]

{ #category : 'as yet unclassified' }
TITRelativeTypeNodeWithOrigins class >> forUnrelatedType [

	^ self new
]

{ #category : 'testing' }
TITRelativeTypeNodeWithOrigins class >> isForType: aType origin: anOriginClass [

	^ self subclassResponsibility
]

{ #category : 'instance creation' }
TITRelativeTypeNodeWithOrigins class >> newRoot [

	^ self new
]

{ #category : 'instance creation' }
TITRelativeTypeNodeWithOrigins class >> newWithOrigin: anOriginClass [

	^ self new
		  addOrigins: { anOriginClass };
		  yourself
]

{ #category : 'accessing' }
TITRelativeTypeNodeWithOrigins >> condition: aBlock [

	condition := aBlock
]

{ #category : 'testing' }
TITRelativeTypeNodeWithOrigins >> isAcceptableMostPreciseNode [

	^ condition isNotNil
]

{ #category : 'testing' }
TITRelativeTypeNodeWithOrigins >> isForType: aType origin: anOriginClass [

	^ condition value: aType value: anOriginClass
]

{ #category : 'accessing' }
TITRelativeTypeNodeWithOrigins >> name [

	^ name
]

{ #category : 'accessing' }
TITRelativeTypeNodeWithOrigins >> name: aString [

	name := aString
]
