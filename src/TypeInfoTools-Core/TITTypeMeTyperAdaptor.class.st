Class {
	#name : 'TITTypeMeTyperAdaptor',
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
TITTypeMeTyperAdaptor class >> sourceName [

	^ 'TypeMe'
]

{ #category : 'visiting' }
TITTypeMeTyperAdaptor >> visitMethod: aMethod [

	| actualMethod results |
	actualMethod := aMethod compiledMethod.
	results := (TypeMe new
		            initialize: { actualMethod };
		            runHeuristics) typeResults.
	results size < 1 ifTrue: [ ^ self ].
	results size > 1 ifTrue: [ self halt ].
	aMethod typeInfo
		addTypes: { (Smalltalk classNamed: results anyOne last) }
		by: self
]

{ #category : 'accessing' }
TITTypeMeTyperAdaptor >> weight [

	^ 1
]
