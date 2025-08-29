Class {
	#name : 'TITJ2InfererTyperAdaptor',
	#superclass : 'TITStructureNodeTypeCollector',
	#instVars : [
		'inferers'
	],
	#category : 'TypeInfoTools-Core-Inference',
	#package : 'TypeInfoTools-Core',
	#tag : 'Inference'
}

{ #category : 'accessing' }
TITJ2InfererTyperAdaptor class >> sourceName [

	^ 'J2Inferer'
]

{ #category : 'visiting' }
TITJ2InfererTyperAdaptor >> addTypesForJ2Item: aJ2Item to: aTITItem [

	| types |
	types := aJ2Item possibleClasses classes collect: [ :eachJ2Class |
		         eachJ2Class analysedClass ].
	types remove: UndefinedObject ifAbsent: [ ].
	aTITItem typeInfo addTypes: types by: self
]

{ #category : 'public' }
TITJ2InfererTyperAdaptor >> createInfererForClass: aClass [

	| inferer |
	inferer := J2Inferer withNotifier: J2NullNotifier new.
	inferer
		enqueueClass: aClass;
		enqueueClass: aClass class.
	inferer runAndWait.
	^ inferer
]

{ #category : 'accessing' }
TITJ2InfererTyperAdaptor >> infererOf: aClass [

	^ inferers
		  at: aClass
		  ifAbsentPut: [ self createInfererForClass: aClass ]
]

{ #category : 'initialization' }
TITJ2InfererTyperAdaptor >> initialize [

	super initialize.
	inferers := Dictionary new
]

{ #category : 'accessing' }
TITJ2InfererTyperAdaptor >> typeInfoOf: aClass [

	^ (self infererOf: aClass) typeInfoFor: aClass
]

{ #category : 'visiting' }
TITJ2InfererTyperAdaptor >> visitInstanceVariable: aVariable [

	self
		addTypesForJ2Item:
			((self typeInfoOf: aVariable realClass) instanceVariable:
				 aVariable name)
		to: aVariable
]

{ #category : 'visiting' }
TITJ2InfererTyperAdaptor >> visitMethod: aMethod [

	self
		addTypesForJ2Item:
			((self typeInfoOf: aMethod realClass) methodTypeFor:
				 aMethod compiledMethod) returnValue
		to: aMethod
]

{ #category : 'visiting' }
TITJ2InfererTyperAdaptor >> visitMethodInputParameter: aMethodInputParameter [

	self
		addTypesForJ2Item:
			(((self typeInfoOf: aMethodInputParameter realClass)
				  methodTypeFor: aMethodInputParameter compiledMethod)
				 parameterFor: aMethodInputParameter name
				 ifAbsent: [ ^ self error: 'Parameter not found' ])
		to: aMethodInputParameter
]

{ #category : 'accessing' }
TITJ2InfererTyperAdaptor >> weight [

	^ 2
]
