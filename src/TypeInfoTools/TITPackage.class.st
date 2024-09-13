Class {
	#name : 'TITPackage',
	#superclass : 'TITContainerNode',
	#instVars : [
		'#actualPackage',
		'#classes => ToManyRelationSlot inverse: #package inClass: #TITClass'
	],
	#category : 'TypeInfoTools-Structure',
	#package : 'TypeInfoTools',
	#tag : 'Structure'
}

{ #category : 'instance creation' }
TITPackage class >> forActualPackage: aPackage [

	^ self new
		  actualPackage: aPackage;
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
TITPackage >> actualPackage [

	^ actualPackage
]

{ #category : 'accessing' }
TITPackage >> actualPackage: anObject [

	actualPackage := anObject
]

{ #category : 'accessing' }
TITPackage >> classes [

	^ classes ifNil: [
		  classes := self actualPackage definedClasses collect: [ :each |
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

	^ actualPackage organizer
]
