Class {
	#name : 'TITMethod',
	#superclass : 'TITTypedNode',
	#instVars : [
		'ownerClass',
		'astMethod',
		'compilationBlock',
		'compiledMethod'
	],
	#category : 'TypeInfoTools-Core-Structure',
	#package : 'TypeInfoTools-Core',
	#tag : 'Structure'
}

{ #category : 'instance creation' }
TITMethod class >> forOCMethodNode: aMethodNode [

	^ self new
		  astMethod: aMethodNode;
		  yourself
]

{ #category : 'visiting' }
TITMethod >> accept: anInferenceToolAdaptor [

	^ anInferenceToolAdaptor visitMethod: self
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
TITMethod >> compilationBlock [

	^ compilationBlock ifNil: [
		  [ :ocMethod | self realClass >> ocMethod selector asSymbol ] ]
]

{ #category : 'accessing' }
TITMethod >> compilationBlock: aBlock [

	compilationBlock := aBlock
]

{ #category : 'accessing' }
TITMethod >> compiledMethod [

	^ compiledMethod ifNil: [
		  compiledMethod := astMethod compiledMethod ifNil: [
			                    self compilationBlock value: astMethod ] ]
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
