Class {
	#name : 'TITInstanceVariable',
	#superclass : 'TITVariable',
	#instVars : [
		'#ownerClass => ToOneRelationSlot inverse: #instanceVariables inClass: #TITClass'
	],
	#category : 'TypeInfoTools-Structure',
	#package : 'TypeInfoTools',
	#tag : 'Structure'
}

{ #category : 'as yet unclassified' }
TITInstanceVariable class >> forSystemInstanceVariable: aVariable [

	^ self new
		  name: aVariable name;
		  ownerClass: (TITClass forRealClass: aVariable owningClass)
]

{ #category : 'visiting' }
TITInstanceVariable >> accept: anInferenceToolAdaptor [

	^ anInferenceToolAdaptor visitInstanceVariable: self
]

{ #category : 'accessing' }
TITInstanceVariable >> classDescription [

	^ 'Instance variable'
]

{ #category : 'accessing' }
TITInstanceVariable >> ownerClass [

	^ ownerClass
]

{ #category : 'accessing' }
TITInstanceVariable >> ownerClass: anObject [

	ownerClass := anObject
]

{ #category : 'accessing' }
TITInstanceVariable >> parent [

	^ self ownerClass
]

{ #category : 'accessing' }
TITInstanceVariable >> realClass [

	^ self ownerClass realClass
]
