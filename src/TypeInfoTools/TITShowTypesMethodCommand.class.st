Class {
	#name : 'TITShowTypesMethodCommand',
	#superclass : 'SycMethodCommand',
	#traits : 'TTITShowTypesCommand',
	#classTraits : 'TTITShowTypesCommand classTrait',
	#category : 'TypeInfoTools-Commands',
	#package : 'TypeInfoTools',
	#tag : 'Commands'
}

{ #category : 'activation' }
TITShowTypesMethodCommand class >> fullBrowserMenuActivation [

	<classAnnotation>
	^ CmdContextMenuActivation byRootGroupItemFor:
		  ClyFullBrowserMethodContext
]

{ #category : 'execution' }
TITShowTypesMethodCommand >> execute [

	methods size = 1 ifTrue: [ ^ (self typesOf: methods anyOne) inspect ].

	((methods sortedAs: #name) collect: [ :each |
		 each -> (self typesOf: each) ]) asOrderedDictionary inspect
]

{ #category : 'execution' }
TITShowTypesMethodCommand >> typesOf: aMethod [

	^ (TypeCollector typeTmpsIn: aMethod) collect: #types
]
