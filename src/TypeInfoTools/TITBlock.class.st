Class {
	#name : 'TITBlock',
	#superclass : 'TITCompiledCodeContainedNode',
	#instVars : [
		'#parent => ToOneRelationSlot inverse: #blocks inClass: #TITCompiledCodeContainedNode',
		'#compiledBlock',
		'#parentLevelIndex',
		'#methodLevelIndex',
		'#temporaryVariables => ToManyRelationSlot inverse: #block inClass: #TITBlockTemporaryVariable'
	],
	#category : 'TypeInfoTools-Structure',
	#package : 'TypeInfoTools',
	#tag : 'Structure'
}

{ #category : 'visiting' }
TITBlock >> accept: anInferenceToolAdaptor [

	^ anInferenceToolAdaptor visitBlock: self
]

{ #category : 'accessing' }
TITBlock >> allBlocks [

	^ self blocks flatCollect: [ :each | each allBlocks ]
]

{ #category : 'accessing' }
TITBlock >> compiledBlock [

	^ compiledBlock
]

{ #category : 'accessing' }
TITBlock >> compiledBlock: anObject [

	compiledBlock := anObject
]

{ #category : 'accessing' }
TITBlock >> compiledCode [

	^ self compiledBlock
]

{ #category : 'accessing' }
TITBlock >> method [

	^ self parent method
]

{ #category : 'accessing' }
TITBlock >> methodLevelIndex [

	^ methodLevelIndex
]

{ #category : 'accessing' }
TITBlock >> methodLevelIndex: anObject [

	methodLevelIndex := anObject
]

{ #category : 'accessing' }
TITBlock >> ownerClass [

	^ self parent ownerClass
]

{ #category : 'accessing' }
TITBlock >> parent [

	^ parent
]

{ #category : 'accessing' }
TITBlock >> parent: anObject [

	parent := anObject
]

{ #category : 'accessing' }
TITBlock >> parentLevelIndex [

	^ parentLevelIndex
]

{ #category : 'accessing' }
TITBlock >> parentLevelIndex: anObject [

	parentLevelIndex := anObject
]

{ #category : 'accessing' }
TITBlock >> realClass [

	^ self parent realClass
]
