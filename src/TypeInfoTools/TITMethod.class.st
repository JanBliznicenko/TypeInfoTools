Class {
	#name : 'TITMethod',
	#superclass : 'TITCompiledCodeContainedNode',
	#instVars : [
		'ownerClass',
		'astMethod'
	],
	#category : 'TypeInfoTools-Structure',
	#package : 'TypeInfoTools',
	#tag : 'Structure'
}

{ #category : 'as yet unclassified' }
TITMethod class >> forASTMethodNode: aMethodNode [

	^ self new
		  astMethod: aMethodNode;
		  yourself
]

{ #category : 'visiting' }
TITMethod >> accept: anInferenceToolAdaptor [

	^ anInferenceToolAdaptor visitMethod: self
]

{ #category : 'accessing' }
TITMethod >> allBlocks [

	^ self blocks flatCollect: [ :each | each allBlocks ]
]

{ #category : 'accessing' }
TITMethod >> astMethod [

	^ astMethod
]

{ #category : 'accessing' }
TITMethod >> astMethod: anObject [

	astMethod := anObject
]

{ #category : 'accessing' }
TITMethod >> classDescription [

	^ 'Method'
]

{ #category : 'accessing' }
TITMethod >> compiledCode [

	^ self compiledMethod
]

{ #category : 'accessing' }
TITMethod >> compiledMethod [

	^ astMethod compiledMethod
]

{ #category : 'accessing' }
TITMethod >> method [

	^ self
]

{ #category : 'accessing' }
TITMethod >> name [

	^ self astMethod selector
]

{ #category : 'accessing' }
TITMethod >> ownerClass [

	^ ownerClass ifNil: [
		  ownerClass := TITClass forRealClass: astMethod methodClass ]
]

{ #category : 'accessing' }
TITMethod >> ownerClass: anObject [

	ownerClass := anObject
]

{ #category : 'accessing' }
TITMethod >> parent [

	^ self ownerClass
]

{ #category : 'accessing' }
TITMethod >> realClass [

	^ self ownerClass realClass
]
