Class {
	#name : 'TITShowTypesTempCommandV1',
	#superclass : 'SycSourceCodeCommand',
	#traits : 'TITTShowTypesCommandV1',
	#classTraits : 'TITTShowTypesCommandV1 classTrait',
	#category : 'TypeInfoTools-Commands',
	#package : 'TypeInfoTools',
	#tag : 'Commands'
}

{ #category : 'testing' }
TITShowTypesTempCommandV1 class >> canBeExecutedInContext: aSourceCodeContext [

	^ (super canBeExecutedInContext: aSourceCodeContext) and: [
		  aSourceCodeContext isArgOrTempVariableSelected ]
]

{ #category : 'activation' }
TITShowTypesTempCommandV1 class >> sourceCodeMenuActivation [

	<classAnnotation>
	^ SycSourceCodeMenuActivation byRootGroupItemFor:
		  ClyMethodSourceCodeContext
]

{ #category : 'execution' }
TITShowTypesTempCommandV1 >> execute [

	self showSingleItem: self types forVariableNamed: sourceNode name
]

{ #category : 'execution' }
TITShowTypesTempCommandV1 >> types [

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
