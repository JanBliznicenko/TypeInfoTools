Class {
	#name : 'TITReferencingAndReceiverClass',
	#superclass : 'Object',
	#traits : 'TComparable',
	#classTraits : 'TComparable classTrait',
	#instVars : [
		'referencingClass',
		'receiverClass'
	],
	#category : 'TypeInfoTools-RealTimeGatherer-Processing',
	#package : 'TypeInfoTools-RealTimeGatherer',
	#tag : 'Processing'
}

{ #category : 'instance creation' }
TITReferencingAndReceiverClass class >> withReferencingClass: aReferencingClass receiverClass: receiverClass [

	^ self new
		  referencingClass: aReferencingClass;
		  receiverClass: receiverClass;
		  yourself
]

{ #category : 'comparing' }
TITReferencingAndReceiverClass >> < aComparable [
	"Answer whether the receiver is less than the argument."

	^ referencingClass = aComparable referencingClass
		  ifTrue: [ receiverClass name < aComparable receiverClass name ]
		  ifFalse: [
		  referencingClass name < aComparable referencingClass name ]
]

{ #category : 'comparing' }
TITReferencingAndReceiverClass >> = anObject [
	"Answer whether the receiver and anObject represent the same object."

	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	^ referencingClass = anObject referencingClass and: [
		  receiverClass = anObject receiverClass ]
]

{ #category : 'comparing' }
TITReferencingAndReceiverClass >> hash [
	"Answer an integer value that is related to the identity of the receiver."

	^ referencingClass hash bitXor: receiverClass hash
]

{ #category : 'printing' }
TITReferencingAndReceiverClass >> printOn: aStream [
	"Generate a string representation of the receiver based on its instance variables."

	super printOn: aStream.
	aStream
		nextPutAll: ' (';
		print: referencingClass.
	aStream
		nextPutAll: '->';
		print: receiverClass
]

{ #category : 'accessing' }
TITReferencingAndReceiverClass >> receiverClass [

	^ receiverClass
]

{ #category : 'accessing' }
TITReferencingAndReceiverClass >> receiverClass: anObject [

	receiverClass := anObject
]

{ #category : 'accessing' }
TITReferencingAndReceiverClass >> referencingClass [

	^ referencingClass
]

{ #category : 'accessing' }
TITReferencingAndReceiverClass >> referencingClass: anObject [

	referencingClass := anObject
]
