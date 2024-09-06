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

	self flag: 'blocks'.
	^ ((TypeCollector typeTmpsIn: method) at: sourceNode name) types
]
