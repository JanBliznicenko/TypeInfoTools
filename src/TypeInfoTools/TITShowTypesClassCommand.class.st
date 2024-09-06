Class {
	#name : 'TITShowTypesClassCommand',
	#superclass : 'SycClassCommand',
	#traits : 'TITTShowTypesCommand',
	#classTraits : 'TITTShowTypesCommand classTrait',
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

	| types |
	types := self types.
	types size = 1 ifTrue: [
		| pair |
		pair := types anyOne.
		^ self showClassFrom: pair value forClass: pair key ].

	self showMultipleClassesFrom: types
]

{ #category : 'execution' }
TITShowTypesClassCommand >> types [

	^ classes collect: [ :each |
		  each
		  ->
			  ((TypeCollector typeInstvarsOfClass: each) collect: [ :eachType |
				   eachType types ]) ]
]
