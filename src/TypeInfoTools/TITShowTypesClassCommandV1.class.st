Class {
	#name : 'TITShowTypesClassCommandV1',
	#superclass : 'SycClassCommand',
	#traits : 'TITTShowTypesCommandV1',
	#classTraits : 'TITTShowTypesCommandV1 classTrait',
	#category : 'TypeInfoTools-Commands',
	#package : 'TypeInfoTools',
	#tag : 'Commands'
}

{ #category : 'testing' }
TITShowTypesClassCommandV1 class >> canBeExecutedInContext: aToolContext [

	^ super canBeExecutedInContext: aToolContext
]

{ #category : 'activation' }
TITShowTypesClassCommandV1 class >> fullBrowserMenuActivation [

	<classAnnotation>
	^ CmdContextMenuActivation byRootGroupItemFor:
		  ClyFullBrowserClassContext
]

{ #category : 'activation' }
TITShowTypesClassCommandV1 class >> sourceCodeMenuActivation [

	<classAnnotation>
	^ SycSourceCodeMenuActivation byRootGroupItemFor:
		  ClySourceCodeContext
]

{ #category : 'execution' }
TITShowTypesClassCommandV1 >> execute [

	| types |
	types := self types.
	types size = 1 ifTrue: [
		| pair |
		pair := types anyOne.
		^ self showClassFrom: pair value forClass: pair key ].

	self showMultipleClassesFrom: types
]

{ #category : 'execution' }
TITShowTypesClassCommandV1 >> types [

	^ classes collect: [ :each |
		  each
		  ->
			  ((TypeCollector typeInstvarsOfClass: each) collect: [ :eachType |
				   eachType types ]) ]
]
