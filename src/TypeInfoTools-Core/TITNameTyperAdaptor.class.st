Class {
	#name : 'TITNameTyperAdaptor',
	#superclass : 'TITStructureNodeTypeCollector',
	#instVars : [
		'results',
		'collectionElementResults',
		'typedNode'
	],
	#classInstVars : [
		'typicalNames',
		'collectionClasses'
	],
	#category : 'TypeInfoTools-Core-Inference',
	#package : 'TypeInfoTools-Core',
	#tag : 'Inference'
}

{ #category : 'accessing' }
TITNameTyperAdaptor class >> collectionClasses [

	^ collectionClasses ifNil: [
			  collectionClasses := Collection withAllSubclasses asSet
				                       copyWithoutAll:
				                       TITCollectionTypeHolder atomicCollectionTypes ]
]

{ #category : 'class initialization' }
TITNameTyperAdaptor class >> reset [

	<script>
	typicalNames := nil.
	collectionClasses := nil
]

{ #category : 'processing' }
TITNameTyperAdaptor class >> simplifyName: aString [

	aString size < 3 ifTrue: [ ^ aString ].
	aString size > 3 ifTrue: [
			((aString beginsWith: 'any') or: [ aString beginsWith: 'any' ])
				ifTrue: [
				aString fourth isUppercase ifTrue: [ ^ aString allButFirst: 3 ] ].
			aString size > 4 ifTrue: [
					(aString beginsWith: 'each') ifTrue: [
						aString fifth isUppercase ifTrue: [ ^ aString allButFirst: 4 ] ] ].
			aString size > 5 ifTrue: [
					(aString beginsWith: 'other') ifTrue: [
						aString fifth isUppercase ifTrue: [ ^ aString allButFirst: 5 ] ] ] ].
	aString first = $a ifFalse: [ ^ aString ].
	aString second isUppercase ifTrue: [ ^ aString allButFirst: 1 ].
	aString second = $n ifFalse: [ ^ aString ].
	aString third isUppercase ifTrue: [ ^ aString allButFirst: 2 ].
	^ aString
]

{ #category : 'accessing' }
TITNameTyperAdaptor class >> typicalNames [

	^ typicalNames ifNil: [
			  typicalNames := {
				                  ('Object' -> { Object }).
				                  ('S' -> {
					                   String.
					                   Stream }).
				                  ('I' -> { Integer }).
				                  ('Id' -> {
					                   Integer.
					                   UUID }).
				                  ('Name' -> { String }).
				                  ('Selector' -> { Symbol }).
				                  ('Index' -> { Integer }).
				                  ('Amount' -> { Integer }).
				                  ('Length' -> {
					                   Number.
					                   Duration.
					                   Timespan }).
				                  ('Count' -> { Integer }).
				                  ('Avg' -> { Number }).
				                  ('Average' -> { Number }).
				                  ('Max' -> { Number }).
				                  ('Min' -> { Number }) } asDictionary ]
]

{ #category : 'processing' }
TITNameTyperAdaptor >> checkName: aString [

	(self checkSingularName: aString) ifNotEmpty: [ :foundClasses |
		^ results addAll: foundClasses ].

	aString isPlural ifFalse: [ ^ {  } ].
	collectionElementResults addAll: (self checkPluralName: aString).
	^ results addAll: self class collectionClasses
]

{ #category : 'processing' }
TITNameTyperAdaptor >> checkPluralName: aString [

	^ self typesForName: aString singularize
]

{ #category : 'processing' }
TITNameTyperAdaptor >> checkSingularName: aString [

	^ self typesForName: aString
]

{ #category : 'processing' }
TITNameTyperAdaptor >> classesIncludingName: aString [

	aString size < 4 ifTrue: [ ^ {  } ].
	^ ((Smalltalk globals keys
		    select: [ :each | self isName: aString consideredTypeName: each ]
		    thenCollect: [ :each | Smalltalk at: each ]) select: [ :each |
		   each isBehavior ]) asSet
]

{ #category : 'processing' }
TITNameTyperAdaptor >> isName: aNodeName consideredTypeName: aClassName [

	| firstLowercaseIndex classWithoutPrefix |
	(aClassName beginsWith: aNodeName) ifTrue: [ ^ true ].
	firstLowercaseIndex := aClassName
		                       detectIndex: [ :aCharacter |
		                       aCharacter isLowercase ]
		                       ifNone: 2.
	classWithoutPrefix := aClassName
		                      copyFrom: (firstLowercaseIndex - 1 max: 1)
		                      to: aClassName size.
	^ classWithoutPrefix includesSubstring: aNodeName
]

{ #category : 'processing' }
TITNameTyperAdaptor >> isOtherOfSameClass: aString [

	^ typedNode assumesNameOtherMeansSameClass and: [
		  (aString beginsWith: 'Other') or: [ aString beginsWith: 'Another' ] ]
]

{ #category : 'constants' }
TITNameTyperAdaptor >> majorityTreshold [

	^ 4 / 5
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

{ #category : 'visiting' }
TITNameTyperAdaptor >> processTypedNode: aTypedNode [

	| simplifiedName wordClusters |
	results := Set new.
	collectionElementResults := Set new.
	typedNode := aTypedNode.

	simplifiedName := (self simplifyName: aTypedNode name) capitalized.

	wordClusters := OrderedCollection new.
	wordClusters add: OrderedCollection new.
	simplifiedName splitSymbolsAndCamelCase do: [ :each |
			each = 'Or'
				ifTrue: [
						wordClusters last ifNotEmpty: [
							wordClusters add: OrderedCollection new ] ]
				ifFalse: [ wordClusters last add: each ] ].

	wordClusters do: [ :each | self processCluster: each ].

	self removeImprobableResults.

	aTypedNode typeInfo
		addTypes: results by: self;
		addCollectionElementTypes: collectionElementResults by: self
]

{ #category : 'visiting' }
TITNameTyperAdaptor >> removeImprobableResults [

	(typedNode name includesSubstring: 'test' caseSensitive: false)
		ifFalse: [
		results removeAllSuchThat: [ :each | each inheritsFrom: TestCase ] ]
]

{ #category : 'processing' }
TITNameTyperAdaptor >> simplifyName: aString [

	^ self class simplifyName: aString
]

{ #category : 'accessing' }
TITNameTyperAdaptor >> sourceName [

	^ 'Var name'
]

{ #category : 'processing' }
TITNameTyperAdaptor >> typesForName: aString [

	self class typicalNames at: aString ifPresent: [ :typicalClasses |
			^ typicalClasses flatCollect: [ :each |
				  each withAllSuperclasses copyUpTo: Object ] ].
	aString size < 2 ifTrue: [ ^ Set new ].
	(self isOtherOfSameClass: aString) ifTrue: [
		^ Set with: typedNode realClass ].
	^ self classesIncludingName: aString
]

{ #category : 'visiting' }
TITNameTyperAdaptor >> visitMessageSend: aMessageSend [

	| implementors |
	aMessageSend ocProgramNode isUnary ifFalse: [ ^ self ].
	implementors := SystemNavigation default allImplementorsOf:
		                aMessageSend selector.
	(implementors count: [ :each |
		 each protocolName beginsWith: 'access' ])
	< (implementors size * self majorityTreshold) ifTrue: [ ^ self ].
	self processTypedNode: aMessageSend
]

{ #category : 'visiting' }
TITNameTyperAdaptor >> visitMethod: aMethod [

	aMethod selector isUnary ifFalse: [ ^ self ].
	(aMethod compiledMethod protocolName beginsWith: 'access') ifFalse: [
		^ self ].
	self processTypedNode: aMethod
]

{ #category : 'visiting' }
TITNameTyperAdaptor >> visitVariable: aVariable [

	^ self processTypedNode: aVariable
]

{ #category : 'accessing' }
TITNameTyperAdaptor >> weight [

	^ 1
]
