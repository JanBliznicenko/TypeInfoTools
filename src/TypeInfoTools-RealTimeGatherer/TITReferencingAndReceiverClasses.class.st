Class {
	#name : 'TITReferencingAndReceiverClasses',
	#superclass : 'Object',
	#instVars : [
		'referencingClasses',
		'receiverClasses'
	],
	#category : 'TypeInfoTools-RealTimeGatherer-Processing',
	#package : 'TypeInfoTools-RealTimeGatherer',
	#tag : 'Processing'
}

{ #category : 'adding' }
TITReferencingAndReceiverClasses >> addReceiverClass: aClass [

	self haltIf: [ receiverClasses includes: aClass ].
	receiverClasses add: aClass
]

{ #category : 'adding' }
TITReferencingAndReceiverClasses >> addReceiverClass: aReceiverClass referencingClass: aReferencingClass [

	self
		addReceiverClass: aReceiverClass;
		addReferencingClass: aReferencingClass
]

{ #category : 'adding' }
TITReferencingAndReceiverClasses >> addReferencingClass: aClass [

	self haltIf: [ referencingClasses includes: aClass ].
	referencingClasses add: aClass
]

{ #category : 'initialization' }
TITReferencingAndReceiverClasses >> initialize [

	super initialize.
	referencingClasses := Bag new.
	receiverClasses := Bag new
]
