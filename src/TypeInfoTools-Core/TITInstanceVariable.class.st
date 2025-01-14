Class {
	#name : 'TITInstanceVariable',
	#superclass : 'TITVariable',
	#instVars : [
		'ownerClass'
	],
	#category : 'TypeInfoTools-Core-Structure',
	#package : 'TypeInfoTools-Core',
	#tag : 'Structure'
}

{ #category : 'instance creation' }
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
