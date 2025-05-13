Class {
	#name : 'TITClass',
	#superclass : 'TITTypedNode',
	#instVars : [
		'package',
		'realClass'
	],
	#category : 'TypeInfoTools-Core-Structure',
	#package : 'TypeInfoTools-Core',
	#tag : 'Structure'
}

{ #category : 'instance creation' }
TITClass class >> forRealClass: aClass [

	^ self new
		  realClass: aClass;
		  yourself
]

{ #category : 'instance creation' }
TITClass class >> forRealClass: aClass node: anOCNode [

	^ self new
		  realClass: aClass;
		  ocProgramNode: anOCNode;
		  yourself
]

{ #category : 'visiting' }
TITClass >> accept: anInferenceToolAdaptor [

	^ anInferenceToolAdaptor visitClass: self
]

{ #category : 'accessing' }
TITClass >> classDescription [

	^ 'Class'
]

{ #category : 'accessing' }
TITClass >> name [

	^ realClass name
]

{ #category : 'accessing' }
TITClass >> package [

	^ package ifNil: [
		  package := TITPackage forSystemPackage: self realClass package ]
]

{ #category : 'accessing' }
TITClass >> package: anObject [

	package := anObject
]

{ #category : 'accessing' }
TITClass >> parent [

	^ self package
]

{ #category : 'accessing' }
TITClass >> realClass [

	^ realClass
]

{ #category : 'accessing' }
TITClass >> realClass: anObject [

	realClass := anObject
]
