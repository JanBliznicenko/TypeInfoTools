Class {
	#name : 'TITPackage',
	#superclass : 'TITStructureNode',
	#instVars : [
		'systemPackage'
	],
	#category : 'TypeInfoTools-Core-Structure',
	#package : 'TypeInfoTools-Core',
	#tag : 'Structure'
}

{ #category : 'instance creation' }
TITPackage class >> forActualPackage: aPackage [

	^ self new
		  systemPackage: aPackage;
		  yourself
]

{ #category : 'instance creation' }
TITPackage class >> forSystemPackage: aPackage [

	^ self new
		  systemPackage: aPackage;
		  yourself
]

{ #category : 'instance creation' }
TITPackage class >> named: aPackageName [

	^ self forActualPackage:
		  (self packageOrganizer packageNamed: aPackageName)
]

{ #category : 'visiting' }
TITPackage >> accept: anInferenceToolAdaptor [

	^ anInferenceToolAdaptor visitPackage: self
]

{ #category : 'accessing' }
TITPackage >> classDescription [

	^ 'Package'
]

{ #category : 'accessing' }
TITPackage >> longDescription [

	^ self shortDescription
]

{ #category : 'accessing' }
TITPackage >> name [

	^ self systemPackage name
]

{ #category : 'accessing' }
TITPackage >> package [

	^ self
]

{ #category : 'accessing' }
TITPackage >> parent [

	^ TITNoNode new
]

{ #category : 'accessing' }
TITPackage >> systemPackage [

	^ systemPackage
]

{ #category : 'accessing' }
TITPackage >> systemPackage: anObject [

	systemPackage := anObject
]
