Class {
	#name : 'TITNameTyperAdaptor',
	#superclass : 'TITStructureNodeTypeCollector',
	#instVars : [
		'results',
		'collectionElementResults'
	],
	#category : 'TypeInfoTools-Core-Inference',
	#package : 'TypeInfoTools-Core',
	#tag : 'Inference'
}

{ #category : 'processing' }
TITNameTyperAdaptor >> checkName: aString [

	(self checkSingularName: aString) ifNotEmpty: [ :foundClasses |
		^ results addAll: foundClasses ].
	^ collectionElementResults addAll: (self checkPluralName: aString)
]

{ #category : 'processing' }
TITNameTyperAdaptor >> checkPluralName: aString [

	| singular |
	aString isPlural ifFalse: [ ^ Set empty ].
	singular := aString singularize.
	^ self typesForName: aString
]

{ #category : 'processing' }
TITNameTyperAdaptor >> checkSingularName: aString [

	^ self typesForName: aString
]

{ #category : 'accessing' }
TITNameTyperAdaptor >> priority [

	^ 5
]

{ #category : 'processing' }
TITNameTyperAdaptor >> processCluster: words [

	| entireName |
	entireName := String streamContents: [ :s |
		              words do: [ :each | s nextPutAll: each ] ].
	(self checkName: entireName) ifNotEmpty: [ ^ self ].

	words do: [ :each | self checkName: each ]
]

{ #category : 'processing' }
TITNameTyperAdaptor >> simplifyName: aString [

	aString size < 2 ifTrue: [ ^ aString ].
	aString first = $a ifFalse: [ ^ aString ].
	aString second isUppercase ifTrue: [ ^ aString allButFirst: 1 ].
	aString size = 2 ifTrue: [ ^ aString ].
	aString second = $n ifFalse: [ ^ aString ].
	aString third isUppercase ifFalse: [ ^ aString ].
	^ aString allButFirst: 2
]

{ #category : 'accessing' }
TITNameTyperAdaptor >> sourceName [

	^ 'Var name'
]

{ #category : 'processing' }
TITNameTyperAdaptor >> typesForName: aString [

	| foundClasses typicalNames |
	foundClasses := aString size < 2
		                ifTrue: [ Set new ]
		                ifFalse: [
			                ((Smalltalk globals keys
				                  select: [ :each |
				                  (each beginsWith: aString) or: [
					                  each endsWith: aString ] ]
				                  thenCollect: [ :each | Smalltalk at: each ])
				                 select: [ :each | each isBehavior ]) asSet ].
	typicalNames := {
		                ('S' -> {
			                 String.
			                 Stream }).
		                ('I' -> { Integer }).
		                ('Name' -> { String }).
		                ('Selector' -> { Symbol }).
		                ('Index' -> { Integer }).
		                ('Amount' -> { Integer }).
		                ('Count' -> { Integer }).
		                ('Avg' -> { Number }).
		                ('Average' -> { Number }).
		                ('Max' -> { Number }).
		                ('Min' -> { Number }) } asDictionary.
	typicalNames
		at: aString
		ifPresent: [ :typicalClasses | foundClasses addAll: typicalClasses ].
	^ foundClasses
]

{ #category : 'visiting' }
TITNameTyperAdaptor >> visitVariable: aVariable [

	| simplifiedName wordClusters |
	results := Set new.
	collectionElementResults := Set new.

	simplifiedName := (self simplifyName: aVariable name) capitalized.

	wordClusters := OrderedCollection new.
	wordClusters add: OrderedCollection new.
	simplifiedName splitCamelCase do: [ :each |
		each = 'Or'
			ifTrue: [
				wordClusters last ifNotEmpty: [
					wordClusters add: OrderedCollection new ] ]
			ifFalse: [ wordClusters last add: each ] ].

	wordClusters do: [ :each | self processCluster: each ].

	aVariable typeInfo
		addTypes: results by: self;
		addCollectionElementTypes: collectionElementResults by: self
]

{ #category : 'accessing' }
TITNameTyperAdaptor >> weight [

	^ 1
]
