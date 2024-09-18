Class {
	#name : 'TITRoelTyperAdaptor',
	#superclass : 'TITInferenceToolAdaptor',
	#instVars : [
		'resultsByClasses',
		'resultsByMethods'
	],
	#category : 'TypeInfoTools-Inference',
	#package : 'TypeInfoTools',
	#tag : 'Inference'
}

{ #category : 'initialization' }
TITRoelTyperAdaptor >> initialize [

	super initialize.
	resultsByClasses := IdentityDictionary new.
	resultsByMethods := IdentityDictionary new
]

{ #category : 'accessing' }
TITRoelTyperAdaptor >> name [

	^ 'RoelTyper'
]

{ #category : 'accessing' }
TITRoelTyperAdaptor >> resultsForClass: aClass [

	^ resultsByClasses
		  at: aClass systemClass
		  ifAbsentPut: [ TypeCollector typeInstvarsOfClass: aClass systemClass ]
]

{ #category : 'accessing' }
TITRoelTyperAdaptor >> resultsForMethod: aMethod [

	resultsByClasses
		at: aMethod class systemClass
		ifPresent: [ self halt ].
	^ resultsByMethods
		  at: aMethod compiledMethod
		  ifAbsentPut: [ TypeCollector typeTmpsIn: aMethod compiledMethod ]
]

{ #category : 'accessing' }
TITRoelTyperAdaptor >> visitBlockTemporaryVariable: aBlockTemp [

	| actualMethod results |
	actualMethod := aBlockTemp method compiledMethod.
	results := self resultsForMethod: actualMethod.
	aBlockTemp typeInfo addTypes: (results at:
			 '_block' , aBlockTemp block methodLevelIndex asString , '->'
			 , aBlockTemp name) types
]

{ #category : 'accessing' }
TITRoelTyperAdaptor >> visitInstanceVariable: aVariable [

	| results |
	results := self resultsForClass: aVariable class.
	aVariable typeInfo addTypes: (results at: aVariable name) types
]

{ #category : 'accessing' }
TITRoelTyperAdaptor >> visitMethodInputParameter: aMethodTemp [

	self visitMethodLevelTemporaryVariable: aMethodTemp
]

{ #category : 'accessing' }
TITRoelTyperAdaptor >> visitMethodLevelTemporaryVariable: aMethodTemp [

	| actualMethod results |
	actualMethod := aMethodTemp method compiledMethod.
	results := self resultsForMethod: actualMethod.
	aMethodTemp typeInfo addTypes: (results at: aMethodTemp name) types
]

{ #category : 'accessing' }
TITRoelTyperAdaptor >> visitMethodTemporaryVariable: aMethodTemp [

	self visitMethodLevelTemporaryVariable: aMethodTemp
]
