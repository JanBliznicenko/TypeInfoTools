Class {
	#name : 'TITClassContentReference',
	#superclass : 'Object',
	#traits : 'TComparable',
	#classTraits : 'TComparable classTrait',
	#instVars : [
		'contentClass',
		'name'
	],
	#category : 'TypeInfoTools-Dev-RealTime',
	#package : 'TypeInfoTools-Dev',
	#tag : 'RealTime'
}

{ #category : 'as yet unclassified' }
TITClassContentReference class >> toClass: aClass name: aSymbol [

	^ self new
		  contentClass: aClass;
		  name: aSymbol;
		  yourself
]

{ #category : 'comparing' }
TITClassContentReference >> < aComparable [
	"Answer whether the receiver is less than the argument."

	contentClass = aComparable contentClass ifTrue: [
		^ name < aComparable name ].
	^ contentClass name < aComparable contentClass name
]

{ #category : 'comparing' }
TITClassContentReference >> = aComparable [
	"Compare the receiver with the argument and answer with true if the
	receiver is equal to the argument. Otherwise answer false."

	^ contentClass = aComparable contentClass and: [
		  name = aComparable name ]
]

{ #category : 'accessing' }
TITClassContentReference >> contentClass [

	^ contentClass
]

{ #category : 'accessing' }
TITClassContentReference >> contentClass: aClass [

	contentClass := aClass
]

{ #category : 'comparing' }
TITClassContentReference >> hash [
	"Hash must be redefined whenever = is redefined."

	^ contentClass hash bitXor: name hash
]

{ #category : 'accessing' }
TITClassContentReference >> name [

	^ name
]

{ #category : 'accessing' }
TITClassContentReference >> name: aSymbol [

	name := aSymbol asSymbol
]

{ #category : 'printing' }
TITClassContentReference >> printOn: aStream [

	super printOn: aStream.
	aStream << ' (' << contentClass asString << '->' << name asString
	<< ')'
]
