Class {
	#name : 'TITShowTypesMethodCommandV1',
	#superclass : 'SycMethodCommand',
	#traits : 'TITTShowTypesCommandV1',
	#classTraits : 'TITTShowTypesCommandV1 classTrait',
	#category : 'TypeInfoTools-Commands',
	#package : 'TypeInfoTools',
	#tag : 'Commands'
}

{ #category : 'activation' }
TITShowTypesMethodCommandV1 class >> fullBrowserMenuActivation [

	<classAnnotation>
	^ CmdContextMenuActivation byRootGroupItemFor:
		  ClyFullBrowserMethodContext
]

{ #category : 'execution' }
TITShowTypesMethodCommandV1 >> execute [

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
TITShowTypesMethodCommandV1 >> types [

	| collector |
	collector := TypeCollector new.
	collector extractClass: methods anyOne classBinding value.
	^ methods collect: [ :each |
		  each
		  -> ((collector packagedResultsForCompiledMethod: each) collect: [
				   :eachType | eachType types ]) ]
]
