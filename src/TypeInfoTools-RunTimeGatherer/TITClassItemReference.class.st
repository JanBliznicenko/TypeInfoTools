Class {
	#name : 'TITClassItemReference',
	#superclass : 'Object',
	#traits : 'TComparable',
	#classTraits : 'TComparable classTrait',
	#instVars : [
		'originImplementorClass',
		'receiverClass',
		'name',
		'executedMethodClass'
	],
	#category : 'TypeInfoTools-RunTimeGatherer-Structure',
	#package : 'TypeInfoTools-RunTimeGatherer',
	#tag : 'Structure'
}

{ #category : 'comparing' }
TITClassItemReference >> < aComparable [
	"Answer whether the receiver is less than the argument."

	receiverClass = aComparable receiverClass ifTrue: [
		^ name < aComparable name ].
	^ receiverClass name < aComparable receiverClass name
]

{ #category : 'comparing' }
TITClassItemReference >> = anObject [
	"Answer whether the receiver and anObject represent the same object."

	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	^ receiverClass = anObject receiverClass and: [
			  name = anObject name and: [
				  executedMethodClass = anObject executedMethodClass ] ]
]

{ #category : 'accessing' }
TITClassItemReference >> executedMethodClass [
	"Class of a method (class that implements the method) that was actually executed."

	^ executedMethodClass
]

{ #category : 'accessing' }
TITClassItemReference >> executedMethodClass: aClass [

	executedMethodClass := aClass
]

{ #category : 'accessing' }
TITClassItemReference >> executedMethodSelector [

	^ self subclassResponsibility
]

{ #category : 'comparing' }
TITClassItemReference >> hash [
	"Answer an integer value that is related to the identity of the receiver."

	^ receiverClass hash bitXor:
		  (name hash bitXor: executedMethodClass hash)
]

{ #category : 'accessing' }
TITClassItemReference >> name [

	^ name
]

{ #category : 'accessing' }
TITClassItemReference >> name: aSymbol [

	name := aSymbol asSymbol
]

{ #category : 'accessing' }
TITClassItemReference >> originImplementorClass [
	"The top class introducing the item (var or method). In case of variable this is the class that implements the variable. In case of a method, it is the top superclass that implements method with that selector."

	^ originImplementorClass
]

{ #category : 'accessing' }
TITClassItemReference >> originImplementorClass: aClass [

	originImplementorClass := aClass
]

{ #category : 'printing' }
TITClassItemReference >> printOn: aStream [

	super printOn: aStream.
	aStream << ' (' << receiverClass asString << '->' << name asString
	<< ')'
]

{ #category : 'accessing' }
TITClassItemReference >> receiverClass [
	"Class of the actual receiver object, no matter if the executed method is implemented in its class or its superclass."

	^ receiverClass
]

{ #category : 'accessing' }
TITClassItemReference >> receiverClass: anObject [

	receiverClass := anObject
]

{ #category : 'accessing' }
TITClassItemReference >> referencingClass [

	^ self subclassResponsibility
]
