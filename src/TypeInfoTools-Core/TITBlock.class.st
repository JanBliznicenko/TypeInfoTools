Class {
	#name : 'TITBlock',
	#superclass : 'TITTypedNode',
	#instVars : [
		'parent',
		'index'
	],
	#category : 'TypeInfoTools-Core-Structure',
	#package : 'TypeInfoTools-Core',
	#tag : 'Structure'
}

{ #category : 'instance creation' }
TITBlock class >> forOCBlockNode: aBlockNode [

	^ self new
		  ocProgramNode: aBlockNode;
		  yourself
]

{ #category : 'visiting' }
TITBlock >> accept: anInferenceToolAdaptor [

	^ anInferenceToolAdaptor visitBlock: self
]

{ #category : 'accessing' }
TITBlock >> classDescription [

	^ 'Block'
]

{ #category : 'accessing' }
TITBlock >> index [

	^ index ifNil: [
		  index := self method ocProgramNode blockNodes indexOf: self ocProgramNode ]
]

{ #category : 'accessing' }
TITBlock >> longDescription [

	^ String streamContents: [ :s |
		  s << self shortDescription.
		  self method shortDescriptionJoinedBy: ' in ' to: s ]
]

{ #category : 'accessing' }
TITBlock >> method [

	^ self parent method
]

{ #category : 'accessing' }
TITBlock >> name [

	^ index asString
]

{ #category : 'accessing' }
TITBlock >> ownerClass [

	^ self parent ownerClass
]

{ #category : 'accessing' }
TITBlock >> parent [

	^ parent ifNil: [
		  parent := TITMethod forOCMethodNode: self ocProgramNode methodNode ]
]

{ #category : 'accessing' }
TITBlock >> parent: anObject [

	parent := anObject
]

{ #category : 'accessing' }
TITBlock >> realClass [

	^ self parent realClass
]

{ #category : 'accessing' }
TITBlock >> shortDescription [

	^ self classDescription , ' ' , self name
]
