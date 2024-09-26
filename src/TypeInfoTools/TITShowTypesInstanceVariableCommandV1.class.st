Class {
	#name : 'TITShowTypesInstanceVariableCommandV1',
	#superclass : 'SycVariableCommand',
	#traits : 'TITTShowTypesCommandV1',
	#classTraits : 'TITTShowTypesCommandV1 classTrait',
	#category : 'TypeInfoTools-Commands',
	#package : 'TypeInfoTools',
	#tag : 'Commands'
}

{ #category : 'testing' }
TITShowTypesInstanceVariableCommandV1 class >> canBeExecutedInContext: aToolContext [

	^ (super canBeExecutedInContext: aToolContext) and: [
		  aToolContext isGlobalVariableSelected not ]
]

{ #category : 'testing' }
TITShowTypesInstanceVariableCommandV1 class >> fullBrowserMenuActivation [

	<classAnnotation>
	^ CmdContextMenuActivation byRootGroupItemFor:
		  ClyFullBrowserVariableContext
]

{ #category : 'testing' }
TITShowTypesInstanceVariableCommandV1 class >> sourceCodeMenuActivation [

	<classAnnotation>
	^ SycSourceCodeMenuActivation byRootGroupItemFor:
		  ClySourceCodeContext
]

{ #category : 'execution' }
TITShowTypesInstanceVariableCommandV1 >> definingClass [

	^ variables first definingClass
]

{ #category : 'execution' }
TITShowTypesInstanceVariableCommandV1 >> execute [

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
TITShowTypesInstanceVariableCommandV1 >> types [

	| results |
	results := TypeCollector typeInstvarsOfClass: self definingClass.
	results keysAndValuesRemove: [ :key :value |
		variables noneSatisfy: [ :each | each name = key ] ].
	^ results collect: [ :each | each types ]
]
