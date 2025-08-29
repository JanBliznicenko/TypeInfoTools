Class {
	#name : 'TITRoelTyperAdaptor',
	#superclass : 'TITStructureNodeTypeCollector',
	#instVars : [
		'resultsByMethods',
		'resultsByClasses'
	],
	#category : 'TypeInfoTools-Core-Inference',
	#package : 'TypeInfoTools-Core',
	#tag : 'Inference'
}

{ #category : 'accessing' }
TITRoelTyperAdaptor class >> sourceName [

	^ 'RoelTyper'
]

{ #category : 'initialization' }
TITRoelTyperAdaptor >> initialize [

	super initialize.
	resultsByMethods := Dictionary new.
	resultsByClasses := Dictionary new
]

{ #category : 'as yet unclassified' }
TITRoelTyperAdaptor >> resultsForClass: aClass [

	^ resultsByClasses
		  at: aClass realClass
		  ifAbsentPut: [
		  TypeCollector typeInstvarsOfClass: aClass realClass ]
]

{ #category : 'accessing' }
TITRoelTyperAdaptor >> resultsForMethod: aMethod [

	^ resultsByMethods
		  at: aMethod compiledMethod
		  ifAbsentPut: [ TypeCollector typeTmpsIn: aMethod compiledMethod ]
]

{ #category : 'visiting' }
TITRoelTyperAdaptor >> visitBlockTemporaryVariable: aBlockTemp [

	| actualMethod results |
	actualMethod := aBlockTemp method compiledMethod.
	results := self resultsForMethod: actualMethod.
	aBlockTemp typeInfo
		addTypes: (results at:
				 ('_block' , aBlockTemp block index asString , '->'
				  , aBlockTemp name) asSymbol) types
		by: self
]

{ #category : 'visiting' }
TITRoelTyperAdaptor >> visitInstanceVariable: aVariable [

	| results |
	results := self resultsForClass: aVariable realClass.
	aVariable typeInfo
		addTypes: (results at: aVariable name asSymbol) types
		by: self
]

{ #category : 'visiting' }
TITRoelTyperAdaptor >> visitMethod: aMethod [

	| actualMethod results |
	actualMethod := aMethod compiledMethod.
	results := self resultsForMethod: actualMethod.
	aMethod typeInfo addTypes: (results at: '^' asSymbol) types by: self
]

{ #category : 'visiting' }
TITRoelTyperAdaptor >> visitMethodInputParameter: aMethodTemp [

	self visitMethodLevelTemporaryVariable: aMethodTemp
]

{ #category : 'visiting' }
TITRoelTyperAdaptor >> visitMethodLevelTemporaryVariable: aMethodTemp [

	| actualMethod results |
	actualMethod := aMethodTemp method compiledMethod.
	results := self resultsForMethod: actualMethod.
	aMethodTemp typeInfo
		addTypes: (results at: aMethodTemp name asSymbol) types
		by: self
]

{ #category : 'visiting' }
TITRoelTyperAdaptor >> visitMethodTemporaryVariable: aMethodTemp [

	self visitMethodLevelTemporaryVariable: aMethodTemp
]

{ #category : 'accessing' }
TITRoelTyperAdaptor >> weight [

	^ 2
]
