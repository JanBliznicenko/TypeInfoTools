Class {
	#name : 'TITRBRefactoryTyperAdaptor',
	#superclass : 'TITStructureNodeTypeCollector',
	#instVars : [
		'typers'
	],
	#category : 'TypeInfoTools-Core-Inference',
	#package : 'TypeInfoTools-Core',
	#tag : 'Inference'
}

{ #category : 'constants' }
TITRBRefactoryTyperAdaptor class >> invalidClassNames [

	^ Set
		  with: #GHObjectGhost
		  with: #Mock
		  with: #GHClassGhost
		  with: #GHObjectGhostStub
]

{ #category : 'constants' }
TITRBRefactoryTyperAdaptor class >> invalidClasses [

	^ self invalidClassNames
		  select: [ :each | Smalltalk globals includesKey: each ]
		  thenCollect: [ :each | Smalltalk globals at: each ]
]

{ #category : 'constants' }
TITRBRefactoryTyperAdaptor class >> replacements [

	^ { (ProtoObject -> Object) } asDictionary
]

{ #category : 'as yet unclassified' }
TITRBRefactoryTyperAdaptor >> filterTypes: aCollectionOfClasses [

	| invalidClasses replacements |
	invalidClasses := self class invalidClasses.
	replacements := self class replacements.
	^ aCollectionOfClasses
		  reject: [ :each | invalidClasses includes: each ]
		  thenCollect: [ :each | replacements at: each ifAbsent: [ each ] ]
]

{ #category : 'initialization' }
TITRBRefactoryTyperAdaptor >> initialize [

	super initialize.
	typers := IdentityDictionary new
]

{ #category : 'accessing' }
TITRBRefactoryTyperAdaptor >> sourceName [

	^ 'RBRefactoryTyper'
]

{ #category : 'as yet unclassified' }
TITRBRefactoryTyperAdaptor >> typerOf: aClass [

	^ typers
		  at: aClass
		  ifAbsentPut: [ RBRefactoryTyper new runOn: aClass ]
]

{ #category : 'processing' }
TITRBRefactoryTyperAdaptor >> visitInstanceVariable: aVariable [

	| typer types collectionElementTypes |
	typer := self typerOf: aVariable realClass.

	types := self filterTypes:
		         ((typer guessTypesFor: aVariable name)
			          collect: #realClass
			          as: Set).
	collectionElementTypes := self filterTypes:
		                          ((typer guessTypesFor:
			                            '-' , aVariable name , '-')
			                           collect: #realClass
			                           as: Set).
	aVariable typeInfo
		addTypes: types by: self;
		addCollectionElementTypes: collectionElementTypes by: self
]

{ #category : 'accessing' }
TITRBRefactoryTyperAdaptor >> weight [

	^ 2
]
