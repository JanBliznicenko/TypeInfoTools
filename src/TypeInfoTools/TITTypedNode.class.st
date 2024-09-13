Class {
	#name : 'TITTypedNode',
	#superclass : 'TITStructureNode',
	#instVars : [
		'#typeInfo => ToOneRelationSlot inverse: #node inClass: #TITTypeInfo'
	],
	#category : 'TypeInfoTools-Structure',
	#package : 'TypeInfoTools',
	#tag : 'Structure'
}

{ #category : 'class membership' }
TITTypedNode >> ownerClass [

	^ self parent ownerClass
]

{ #category : 'accessing' }
TITTypedNode >> typeInfo [

	^ typeInfo
]

{ #category : 'accessing' }
TITTypedNode >> typeInfo: anObject [

	typeInfo := anObject
]
