Class {
	#name : 'TITShowTypesMethodReturnCommand',
	#superclass : 'SycMethodCommand',
	#traits : 'TITTShowTypesCommand',
	#classTraits : 'TITTShowTypesCommand classTrait',
	#category : 'TypeInfoTools-Browser-Commands',
	#package : 'TypeInfoTools-Browser',
	#tag : 'Commands'
}

{ #category : 'testing' }
TITShowTypesMethodReturnCommand class >> canBeExecutedInContext: aSourceCodeContext [

	^ (super canBeExecutedInContext: aSourceCodeContext) and: [
		  aSourceCodeContext isMessageSelected ]
]

{ #category : 'activation' }
TITShowTypesMethodReturnCommand class >> fullBrowserMenuActivation [

	<classAnnotation>
	^ CmdContextMenuActivation byRootGroupItemFor:
		  ClyFullBrowserMethodContext
]

{ #category : 'activation' }
TITShowTypesMethodReturnCommand class >> fullBrowserMenuShortcutActivation [

	<classAnnotation>
	^ CmdShortcutActivation
		  by: $t meta shift
		  for: ClyFullBrowserMethodContext
]

{ #category : 'accessing' }
TITShowTypesMethodReturnCommand >> definingClass [

	^ methods first methodClass
]

{ #category : 'execution' }
TITShowTypesMethodReturnCommand >> executeInJob: job [

	| classes methodNodes collector |
	classes := methods collect: [ :each | each methodClass ] as: Set.
	classes size > 1 ifTrue: [
		self inform:
			'Unable to infer methods from multiple classes, providing results for '
			, ('class ' , self definingClass name) ].

	methodNodes := methods
		               select: [ :each |
		               each methodClass = self definingClass ]
		               thenCollect: [ :each |
		               TITMethod forOCMethodNode: each ].
	collector := TITSequentialAdaptorsTypeCollector fast
		             reportingBlock: [ :typer |
			             job currentValue: job currentValue + 1 ];
		             yourself.
	job max: collector collectors size * methodNodes size.
	methodNodes do: [ :each | collector addTypesTo: each ].

	(methodNodes allSatisfy: [ :each | each typeInfo isEmpty ]) ifTrue: [
		^ self informNoneFound ].

	methodNodes size = 1 ifTrue: [
		^ self showSingleItem: methodNodes anyOne ].

	^ self showMultipleItems: methodNodes
]
