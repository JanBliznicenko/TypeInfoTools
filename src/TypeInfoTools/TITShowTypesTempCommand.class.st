Class {
	#name : 'TITShowTypesTempCommand',
	#superclass : 'SycSourceCodeCommand',
	#traits : 'TTITShowTypesCommand',
	#classTraits : 'TTITShowTypesCommand classTrait',
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

	(self typesOf: sourceNode in: method) inspect
]

{ #category : 'execution' }
TITShowTypesTempCommand >> typesOf: aTempVariable in: aMethod [

	^ ((TypeCollector typeTmpsIn: aMethod) at: aTempVariable name) types
]
