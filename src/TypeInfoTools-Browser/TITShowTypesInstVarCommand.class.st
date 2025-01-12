Class {
	#name : 'TITShowTypesInstVarCommand',
	#superclass : 'SycVariableCommand',
	#traits : 'TITTShowTypesCommand',
	#classTraits : 'TITTShowTypesCommand classTrait',
	#category : 'TypeInfoTools-Browser-Commands',
	#package : 'TypeInfoTools-Browser',
	#tag : 'Commands'
}

{ #category : 'testing' }
TITShowTypesInstVarCommand class >> canBeExecutedInContext: aToolContext [

	^ (super canBeExecutedInContext: aToolContext) and: [
		  aToolContext isGlobalVariableSelected not ]
]

{ #category : 'activation' }
TITShowTypesInstVarCommand class >> fullBrowserMenuActivation [

	<classAnnotation>
	^ CmdContextMenuActivation byRootGroupItemFor:
		  ClyFullBrowserVariableContext
]

{ #category : 'activation' }
TITShowTypesInstVarCommand class >> fullBrowserMenuShortcutActivation [
   <classAnnotation>

   ^CmdShortcutActivation by: $t meta shift for: ClyFullBrowserVariableContext
]

{ #category : 'activation' }
TITShowTypesInstVarCommand class >> sourceCodeMenuActivation [

	<classAnnotation>
	^ SycSourceCodeMenuActivation byRootGroupItemFor:
		  ClySourceCodeContext
]

{ #category : 'activation' }
TITShowTypesInstVarCommand class >> sourceCodeShortcutActivation [
   <classAnnotation>

   ^CmdShortcutActivation by: $t meta shift for: ClySourceCodeContext
]

{ #category : 'accessing' }
TITShowTypesInstVarCommand >> definingClass [

	^ variables first actualVariable owningClass
]

{ #category : 'execution' }
TITShowTypesInstVarCommand >> executeInJob: job [

	| systemVariables classes variableNodes collector |
	systemVariables := variables collect: [ :each | each actualVariable ].
	classes := systemVariables
		           collect: [ :each | each owningClass ]
		           as: Set.
	classes size > 1 ifTrue: [
		self inform:
			'Unable to infer variables from multiple classes, providing results for '
			, (systemVariables size = 1
					 ifTrue: [ 'variable ''' , systemVariables anyOne name , '''' ]
					 ifFalse: [ 'class ' , self definingClass name ]) ].

	variableNodes := systemVariables
		                 select: [ :each |
		                 each owningClass = self definingClass ]
		                 thenCollect: [ :each |
		                 TITInstanceVariable forSystemInstanceVariable: each ].
	collector := TITSequentialAdaptorsTypeCollector new
		             reportingBlock: [ :typer |
			             job currentValue: job currentValue + 1 ];
		             yourself.
	job max: collector collectors size * variableNodes size.
	variableNodes do: [ :each | collector addTypesTo: each ].

	(variableNodes allSatisfy: [ :each | each typeInfo isEmpty ])
		ifTrue: [ ^ self informNoneFound ].

	variableNodes size = 1 ifTrue: [
		^ self showSingleItem: variableNodes anyOne ].

	^ self showInstVarsFrom: variableNodes
]
