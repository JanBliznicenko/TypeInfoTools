Class {
	#name : 'TITTypedNode',
	#superclass : 'TITStructureNode',
	#instVars : [
		'#typeInfo => ToOneRelationSlot inverse: #node inClass: #TITTypeInfo',
		'#ocProgramNode'
	],
	#category : 'TypeInfoTools-Core-Structure',
	#package : 'TypeInfoTools-Core',
	#tag : 'Structure'
}

{ #category : 'testing' }
TITTypedNode >> assumesNameOtherMeansSameClass [

	^ false
]

{ #category : 'accessing' }
TITTypedNode >> compilationBlock: aBlock [
	"do nothing, hook for subclasses"

	
]

{ #category : 'testing' }
TITTypedNode >> ifNotProcessedByAnyCollectorAccept: aVisitor [

	self processedByAnyCollector ifFalse: [ self accept: aVisitor ]
]

{ #category : 'accessing' }
TITTypedNode >> initialize [

	super initialize.
	typeInfo := TITTypeInfo new
]

{ #category : 'accessing' }
TITTypedNode >> ocProgramNode [

	^ ocProgramNode
]

{ #category : 'accessing' }
TITTypedNode >> ocProgramNode: anOCNode [

	ocProgramNode := anOCNode
]

{ #category : 'accessing' }
TITTypedNode >> ownerClass [

	^ self parent ownerClass
]

{ #category : 'printing' }
TITTypedNode >> printOn: aStream [

	super printOn: aStream.
	self typeInfo ifEmpty: [ ^ self ].
	aStream nextPut: $[.
	self typeInfo types size printOn: aStream.
	aStream nextPut: $]
]

{ #category : 'testing' }
TITTypedNode >> processedByAnyCollector [

	^ self typeInfo processedByAnyCollector
]

{ #category : 'class membership' }
TITTypedNode >> realClass [

	^ self parent realClass
]

{ #category : 'accessing' }
TITTypedNode >> typeInfo [

	^ typeInfo
]

{ #category : 'accessing' }
TITTypedNode >> typeInfo: anObject [

	typeInfo := anObject
]
