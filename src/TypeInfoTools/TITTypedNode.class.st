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

{ #category : 'accessing' }
TITTypedNode >> initialize [

	super initialize.
	typeInfo := TITTypeInfo new
]

{ #category : 'class membership' }
TITTypedNode >> ownerClass [

	^ self parent ownerClass
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
