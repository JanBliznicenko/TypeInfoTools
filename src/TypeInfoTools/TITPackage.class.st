Class {
	#name : 'TITPackage',
	#superclass : 'TITContainerNode',
	#instVars : [
		'#systemPackage',
		'#classes => ToManyRelationSlot inverse: #package inClass: #TITClass'
	],
	#category : 'TypeInfoTools-Structure',
	#package : 'TypeInfoTools',
	#tag : 'Structure'
}

{ #category : 'instance creation' }
TITPackage class >> forActualPackage: aPackage [

	^ self new
		  systemPackage: aPackage;
		  yourself
]

{ #category : 'as yet unclassified' }
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
TITPackage >> classes [

	^ classes ifNil: [
		  classes := self systemPackage definedClasses collect: [ :each |
			             TITClass forActualClass: each ] ]
]

{ #category : 'accessing' }
TITPackage >> classes: anObject [

	classes := anObject
]

{ #category : 'initialization' }
TITPackage >> initialize [

	self class initializeSlots: self.
	super initialize.
]

{ #category : 'accessing' }
TITPackage >> package [

	^ self
]

{ #category : 'accessing' }
TITPackage >> parent [

	^ systemPackage organizer
]

{ #category : 'accessing' }
TITPackage >> systemPackage [

	^ systemPackage
]

{ #category : 'accessing' }
TITPackage >> systemPackage: anObject [

	systemPackage := anObject
]
