Class {
	#name : 'TITSharedVariable',
	#superclass : 'TITVariable',
	#instVars : [
		'#ownerClass => ToOneRelationSlot inverse: #sharedVariables inClass: #TITClass'
	],
	#category : 'TypeInfoTools-Structure',
	#package : 'TypeInfoTools',
	#tag : 'Structure'
}

{ #category : 'visiting' }
TITSharedVariable >> accept: anInferenceToolAdaptor [

	^ anInferenceToolAdaptor visitSharedVariable: self
]

{ #category : 'accessing' }
TITSharedVariable >> ownerClass [

	^ ownerClass
]

{ #category : 'accessing' }
TITSharedVariable >> ownerClass: anObject [

	ownerClass := anObject
]

{ #category : 'accessing' }
TITSharedVariable >> parent [

	^ self ownerClass
]

{ #category : 'accessing' }
TITSharedVariable >> realClass [

	^ self ownerClass realClass
]
