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

{ #category : 'as yet unclassified' }
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

{ #category : 'class membership' }
TITTypedNode >> ownerClass [

	^ self parent ownerClass
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
