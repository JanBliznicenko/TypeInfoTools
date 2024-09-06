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
TITShowTypesInstanceVariableCommand >> definingClass [

	^ variables first definingClass
]

{ #category : 'execution' }
TITShowTypesInstanceVariableCommand >> execute [

	| types classes |
	types := self types.
	classes := variables collect: [ :each | each definingClass ] as: Set.
	classes size > 1 ifTrue: [
		self inform:
			'Unable to infer variables from multiple classes, providing results for '
			, (types size = 1
					 ifTrue: [ 'variable ''' , types keys anyOne , '''' ]
					 ifFalse: [ 'class ' , self definingClass name ]) ].

	types size = 1 ifTrue: [
		| pair |
		pair := types associations anyOne.
		^ self showSingleItem: pair value forVariableNamed: pair key ].

	self showInstVarsFrom: types forClass: self definingClass
]

{ #category : 'execution' }
TITShowTypesInstanceVariableCommand >> types [

	| results |
	results := TypeCollector typeInstvarsOfClass: self definingClass.
	results keysAndValuesRemove: [ :key :value |
		variables noneSatisfy: [ :each | each name = key ] ].
	^ results collect: [ :each | each types ]
]
