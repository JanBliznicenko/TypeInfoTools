Class {
	#name : 'TITShowTypesTempCommand',
	#superclass : 'SycSourceCodeCommand',
	#traits : 'TITTShowTypesCommand',
	#classTraits : 'TITTShowTypesCommand classTrait',
	#category : 'TypeInfoTools-Commands',
	#package : 'TypeInfoTools',
	#tag : 'Commands'
}

{ #category : 'testing' }
TITShowTypesTempCommand class >> canBeExecutedInContext: aSourceCodeContext [

	^ (super canBeExecutedInContext: aSourceCodeContext) and: [
		  aSourceCodeContext isArgOrTempVariableSelected ]
]

{ #category : 'activation' }
TITShowTypesTempCommand class >> sourceCodeMenuActivation [

	<classAnnotation>
	^ SycSourceCodeMenuActivation byRootGroupItemFor:
		  ClyMethodSourceCodeContext
]

{ #category : 'execution' }
TITShowTypesTempCommand >> execute [

	self showSingleItem: self types forVariableNamed: sourceNode name
]

{ #category : 'execution' }
TITShowTypesTempCommand >> types [

	| varParent key |
	varParent := sourceNode parent.
	key := varParent isBlock
		       ifTrue: [
			       | blockIndex |
			       blockIndex := method ast blockNodes indexOf:
				                     sourceNode parent.
			       '_block' , blockIndex asString , '->' , sourceNode name ]
		       ifFalse: [ sourceNode name ].
	^ ((TypeCollector typeTmpsIn: method) at: key asSymbol) types
]
