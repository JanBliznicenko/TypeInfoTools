Class {
	#name : 'TITRoelTyperAdaptor',
	#superclass : 'TITStructureNodeTypeCollector',
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

{ #category : 'processing' }
TITRoelTyperAdaptor >> resultsForClass: aClass [

	^ resultsByClasses
		  at: aClass realClass
		  ifAbsentPut: [
		  TypeCollector typeInstvarsOfClass: aClass realClass ]
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
TITRoelTyperAdaptor >> sourceName [

	^ 'RoelTyper'
]

{ #category : 'processing' }
TITRoelTyperAdaptor >> visitBlockTemporaryVariable: aBlockTemp [

	| actualMethod results |
	actualMethod := aBlockTemp method compiledMethod.
	results := self resultsForMethod: actualMethod.
	aBlockTemp typeInfo
		addTypes: (results at:
				 '_block' , aBlockTemp block methodLevelIndex asString , '->'
				 , aBlockTemp name) types
		by: self
]

{ #category : 'processing' }
TITRoelTyperAdaptor >> visitInstanceVariable: aVariable [

	| results |
	results := self resultsForClass: aVariable realClass.
	aVariable typeInfo
		addTypes: (results at: aVariable name) types
		by: self
]

{ #category : 'processing' }
TITRoelTyperAdaptor >> visitMethodInputParameter: aMethodTemp [

	self visitMethodLevelTemporaryVariable: aMethodTemp
]

{ #category : 'processing' }
TITRoelTyperAdaptor >> visitMethodLevelTemporaryVariable: aMethodTemp [

	| actualMethod results |
	actualMethod := aMethodTemp method compiledMethod.
	results := self resultsForMethod: actualMethod.
	aMethodTemp typeInfo
		addTypes: (results at: aMethodTemp name) types
		by: self
]

{ #category : 'processing' }
TITRoelTyperAdaptor >> visitMethodTemporaryVariable: aMethodTemp [

	self visitMethodLevelTemporaryVariable: aMethodTemp
]

{ #category : 'accessing' }
TITRoelTyperAdaptor >> weight [

	^ 2
]
