Class {
	#name : 'TITBlock',
	#superclass : 'TITCompiledCodeContainedNode',
	#instVars : [
		'parent',
		'astBlockNode',
		'index'
	],
	#category : 'TypeInfoTools-Core-Structure',
	#package : 'TypeInfoTools-Core',
	#tag : 'Structure'
}

{ #category : 'as yet unclassified' }
TITBlock class >> forASTBlockNode: anASTBlockNode [

	^ self new
		  astBlockNode: anASTBlockNode;
		  yourself
]

{ #category : 'visiting' }
TITBlock >> accept: anInferenceToolAdaptor [

	^ anInferenceToolAdaptor visitBlock: self
]

{ #category : 'accessing' }
TITBlock >> astBlockNode [

	^ astBlockNode
]

{ #category : 'accessing' }
TITBlock >> astBlockNode: anObject [

	astBlockNode := anObject
]

{ #category : 'accessing' }
TITBlock >> classDescription [

	^ 'Block'
]

{ #category : 'accessing' }
TITBlock >> compiledCode [

	^ self compiledBlock
]

{ #category : 'accessing' }
TITBlock >> index [

	^ index ifNil: [
		  index := self method astMethod blockNodes indexOf: astBlockNode ]
]

{ #category : 'accessing' }
TITBlock >> longDescription [

	^ self shortDescription , ' in ' , self method shortDescription
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
		  parent := TITMethod forASTMethodNode: astBlockNode methodNode ]
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
