Class {
	#name : 'TITShowTypesClassCommand',
	#superclass : 'SycClassCommand',
	#traits : 'TTITShowTypesCommand',
	#classTraits : 'TTITShowTypesCommand classTrait',
	#category : 'TypeInfoTools-Commands',
	#package : 'TypeInfoTools',
	#tag : 'Commands'
}

{ #category : 'testing' }
TITShowTypesClassCommand class >> canBeExecutedInContext: aToolContext [

	^ super canBeExecutedInContext: aToolContext
]

{ #category : 'activation' }
TITShowTypesClassCommand class >> fullBrowserMenuActivation [

	<classAnnotation>
	^ CmdContextMenuActivation byRootGroupItemFor:
		  ClyFullBrowserClassContext
]

{ #category : 'activation' }
TITShowTypesClassCommand class >> sourceCodeMenuActivation [

	<classAnnotation>
	^ SycSourceCodeMenuActivation byRootGroupItemFor:
		  ClySourceCodeContext
]

{ #category : 'execution' }
TITShowTypesClassCommand >> execute [

	classes size = 1 ifTrue: [
		^ (self typesOf: classes anyOne) inspect ].

	((classes sortedAs: #name) collect: [ :each |
		 each -> (self typesOf: each) ]) asOrderedDictionary inspect
]

{ #category : 'execution' }
TITShowTypesClassCommand >> typesOf: aClass [

	^ (TypeCollector typeInstvarsOfClass: aClass) collect: #types
]
