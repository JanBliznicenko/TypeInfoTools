Class {
	#name : 'TITTypedNode',
	#superclass : 'TITStructureNode',
	#instVars : [
		'#typeInfo => ToOneRelationSlot inverse: #node inClass: #TITTypeInfo'
	],
	#category : 'TypeInfoTools-Core-Structure',
	#package : 'TypeInfoTools-Core',
	#tag : 'Structure'
}

{ #category : 'instance creation' }
TITTypedNode class >> forOCNode: anOCNode [

	^ TITTypedNodeCreationVisitor visit: anOCNode
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
