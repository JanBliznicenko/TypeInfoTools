Class {
	#name : 'TITShowTypesInstanceVariableCommand',
	#superclass : 'SycVariableCommand',
	#traits : 'TITTShowTypesCommand',
	#classTraits : 'TITTShowTypesCommand classTrait',
	#category : 'TypeInfoTools-Commands',
	#package : 'TypeInfoTools',
	#tag : 'Commands'
}

{ #category : 'testing' }
TITShowTypesInstanceVariableCommand class >> canBeExecutedInContext: aToolContext [

	^ (super canBeExecutedInContext: aToolContext) and: [
		  aToolContext isGlobalVariableSelected not ]
]

{ #category : 'activation' }
TITShowTypesInstanceVariableCommand class >> fullBrowserMenuActivation [

	<classAnnotation>
	^ CmdContextMenuActivation byRootGroupItemFor:
		  ClyFullBrowserVariableContext
]

{ #category : 'activation' }
TITShowTypesInstanceVariableCommand class >> sourceCodeMenuActivation [

	<classAnnotation>
	^ SycSourceCodeMenuActivation byRootGroupItemFor:
		  ClySourceCodeContext
]

{ #category : 'accessing' }
TITShowTypesInstanceVariableCommand >> definingClass [

	^ variables first actualVariable owningClass
]

{ #category : 'execution' }
TITShowTypesInstanceVariableCommand >> execute [

	| systemVariables variableNodes classes |
	systemVariables := variables collect: [ :each | each actualVariable ].
	classes := systemVariables collect: [ :each | each owningClass ] as: Set.
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
	variableNodes do: [:each | TITSequentialAdaptorsTypeCollector new addTypesTo: each].

	(variableNodes allSatisfy: [ :each | each typeInfo isEmpty ])
		ifTrue: [ ^ self informNoneFound ].

	variableNodes size = 1 ifTrue: [
		^ self showSingleItem: variableNodes anyOne ].

	^ self showInstVarsFrom: variableNodes
]

{ #category : 'as yet unclassified' }
TITShowTypesInstanceVariableCommand >> showSingleItem: aVariableNode [

	| results collectionResults |
	results := aVariableNode typeInfo types allByProbability.

	results inspectWithLabel:
		'Type info for variable ''' , aVariableNode name , ''''.


	collectionResults := aVariableNode typeInfo collectionElementTypes
		                     allByProbability.

	collectionResults isEmpty ifTrue: [ ^ self ].
	collectionResults inspectWithLabel:
		'Collection element type info for variable ''' , aVariableNode name , ''''
]
