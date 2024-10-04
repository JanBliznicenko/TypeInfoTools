Class {
	#name : 'TITClass',
	#superclass : 'TITContainerNode',
	#instVars : [
		'#package => ToOneRelationSlot inverse: #classes inClass: #TITPackage',
		'#methods => ToManyRelationSlot inverse: #ownerClass inClass: #TITMethod',
		'#instanceVariables => ToManyRelationSlot inverse: #ownerClass inClass: #TITInstanceVariable',
		'#sharedVariables => ToManyRelationSlot inverse: #ownerClass inClass: #TITSharedVariable',
		'#realClass'
	],
	#category : 'TypeInfoTools-Structure',
	#package : 'TypeInfoTools',
	#tag : 'Structure'
}

{ #category : 'as yet unclassified' }
TITClass class >> forRealClass: aClass [

	^ self new
		  realClass: aClass;
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

{ #category : 'initialization' }
TITClass >> initialize [

	self class initializeSlots: self.
	super initialize.
]

{ #category : 'accessing' }
TITClass >> instanceVariables [

	^ instanceVariables
]

{ #category : 'accessing' }
TITClass >> instanceVariables: anObject [

	instanceVariables := anObject
]

{ #category : 'accessing' }
TITClass >> methods [

	^ methods
]

{ #category : 'accessing' }
TITClass >> methods: anObject [

	methods := anObject
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

{ #category : 'accessing' }
TITClass >> sharedVariables [

	^ sharedVariables
]

{ #category : 'accessing' }
TITClass >> sharedVariables: anObject [

	sharedVariables := anObject
]
