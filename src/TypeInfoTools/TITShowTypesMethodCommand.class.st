Class {
	#name : 'TITShowTypesMethodCommand',
	#superclass : 'SycMethodCommand',
	#traits : 'TITTShowTypesCommand',
	#classTraits : 'TITTShowTypesCommand classTrait',
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

	| classes class types |
	classes := methods
		           collect: [ :each | each classBinding value ]
		           as: Set.
	class := classes anyOne.
	classes size > 1 ifTrue: [
		self inform:
			'Unable to infer variables from multiple classes, providing results for class '
			, class name.
		methods := methods select: [ :each |
			           each classBinding value = class ] ].

	types := self types.

	types size = 1 ifTrue: [
		| pair |
		pair := types anyOne.
		^ self showMethodFrom: pair value forMethod: pair key ].

	self showMultipleMethodsFrom: types forClass: class
]

{ #category : 'execution' }
TITShowTypesMethodCommand >> types [

	| collector |
	collector := TypeCollector new.
	collector extractClass: methods anyOne classBinding value.
	^ methods collect: [ :each |
		  each
		  -> ((collector packagedResultsForCompiledMethod: each) collect: [
				   :eachType | eachType types ]) ]
]
