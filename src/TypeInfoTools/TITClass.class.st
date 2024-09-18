Class {
	#name : 'TITClass',
	#superclass : 'TITContainerNode',
	#instVars : [
		'#package => ToOneRelationSlot inverse: #classes inClass: #TITPackage',
		'#methods => ToManyRelationSlot inverse: #ownerClass inClass: #TITMethod',
		'#instanceVariables => ToManyRelationSlot inverse: #ownerClass inClass: #TITInstanceVariable',
		'#sharedVariables => ToManyRelationSlot inverse: #ownerClass inClass: #TITSharedVariable',
		'#systemClass'
	],
	#category : 'TypeInfoTools-Structure',
	#package : 'TypeInfoTools',
	#tag : 'Structure'
}

{ #category : 'visiting' }
TITClass >> accept: anInferenceToolAdaptor [

	^ anInferenceToolAdaptor visitClass: self
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
TITClass >> package [

	^ package
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
TITClass >> sharedVariables [

	^ sharedVariables
]

{ #category : 'accessing' }
TITClass >> sharedVariables: anObject [

	sharedVariables := anObject
]

{ #category : 'accessing' }
TITClass >> systemClass [

	^ systemClass
]

{ #category : 'accessing' }
TITClass >> systemClass: anObject [

	systemClass := anObject
]
