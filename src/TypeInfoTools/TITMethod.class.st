Class {
	#name : 'TITMethod',
	#superclass : 'TITCompiledCodeContainedNode',
	#instVars : [
		'#ownerClass => ToOneRelationSlot inverse: #methods inClass: #TITClass',
		'#compiledMethod',
		'#parameterVariables => ToManyRelationSlot inverse: #method inClass: #TITMethodInputParameter',
		'#temporaryVariables => ToManyRelationSlot inverse: #method inClass: #TITMethodTemporaryVariable'
	],
	#category : 'TypeInfoTools-Structure',
	#package : 'TypeInfoTools',
	#tag : 'Structure'
}

{ #category : 'visiting' }
TITMethod >> accept: anInferenceToolAdaptor [

	^ anInferenceToolAdaptor visitMethod: self
]

{ #category : 'accessing' }
TITMethod >> allBlocks [

	^ self blocks flatCollect: [ :each | each allBlocks ]
]

{ #category : 'accessing' }
TITMethod >> compiledCode [

	^ self compiledMethod
]

{ #category : 'accessing' }
TITMethod >> compiledMethod [

	^ compiledMethod
]

{ #category : 'accessing' }
TITMethod >> compiledMethod: anObject [

	compiledMethod := anObject
]

{ #category : 'accessing' }
TITMethod >> ownerClass [

	^ ownerClass
]

{ #category : 'accessing' }
TITMethod >> ownerClass: anObject [

	ownerClass := anObject
]

{ #category : 'accessing' }
TITMethod >> parameterVariables [

	^ parameterVariables
]

{ #category : 'accessing' }
TITMethod >> parameterVariables: anObject [

	parameterVariables := anObject
]

{ #category : 'accessing' }
TITMethod >> parent [

	^ self ownerClass
]
