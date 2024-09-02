Class {
	#name : 'TITShowTypesInstanceVariableCommand',
	#superclass : 'SycVariableCommand',
	#traits : 'TTITShowTypesCommand',
	#classTraits : 'TTITShowTypesCommand classTrait',
	#category : 'TypeInfoTools-Commands',
	#package : 'TypeInfoTools',
	#tag : 'Commands'
}

{ #category : 'testing' }
TITShowTypesInstanceVariableCommand class >> canBeExecutedInContext: aToolContext [

	^ (super canBeExecutedInContext: aToolContext) and: [
		  aToolContext isGlobalVariableSelected not ]
]

{ #category : 'testing' }
TITShowTypesInstanceVariableCommand class >> fullBrowserMenuActivation [

	<classAnnotation>
	^ CmdContextMenuActivation byRootGroupItemFor:
		  ClyFullBrowserVariableContext
]

{ #category : 'testing' }
TITShowTypesInstanceVariableCommand class >> sourceCodeMenuActivation [

	<classAnnotation>
	^ SycSourceCodeMenuActivation byRootGroupItemFor:
		  ClySourceCodeContext
]

{ #category : 'execution' }
TITShowTypesInstanceVariableCommand >> execute [

	| actualVariables |
	actualVariables := variables collect: [ :each | each actualVariable ].

	actualVariables size = 1 ifTrue: [
		^ (self typesOf: actualVariables anyOne) inspect ].

	((actualVariables sortedAs: #name) collect: [ :each |
		 each -> (self typesOf: each) ]) asOrderedDictionary inspect
]

{ #category : 'execution' }
TITShowTypesInstanceVariableCommand >> typesOf: aVariable [

	^ (TypeCollector
		   typeInstvar: aVariable name
		   ofClass: aVariable owningClass) types
]
