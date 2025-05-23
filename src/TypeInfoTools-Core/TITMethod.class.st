Class {
	#name : 'TITMethod',
	#superclass : 'TITTypedNode',
	#instVars : [
		'ownerClass',
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
		  ocProgramNode: aMethodNode;
		  yourself
]

{ #category : 'visiting' }
TITMethod >> accept: anInferenceToolAdaptor [

	^ anInferenceToolAdaptor visitMethod: self
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
			  compiledMethod := self ocProgramNode compiledMethod ifNil: [
				                    self compilationBlock value:
					                    self ocProgramNode ] ]
]

{ #category : 'accessing' }
TITMethod >> method [

	^ self
]

{ #category : 'accessing' }
TITMethod >> name [

	^ self selector
]

{ #category : 'accessing' }
TITMethod >> ownerClass [

	^ ownerClass ifNil: [
		  ownerClass := TITClass forRealClass:
			                self ocProgramNode methodClass ]
]

{ #category : 'accessing' }
TITMethod >> ownerClass: anObject [

	ownerClass := anObject
]

{ #category : 'accessing' }
TITMethod >> parent [

	^ self ownerClass
]

{ #category : 'printing' }
TITMethod >> printOn: aStream [

	super printOn: aStream.

	aStream
		nextPutAll: ' (';
		nextPutAll: self name;
		nextPut: $)
]

{ #category : 'accessing' }
TITMethod >> realClass [

	^ self ownerClass realClass
]

{ #category : 'accessing' }
TITMethod >> selector [

	^ (self ocProgramNode ifNil: [ self compiledMethod ]) selector
]
