Class {
	#name : 'TITShowTypesTempVariableCommand',
	#superclass : 'SycSourceCodeCommand',
	#traits : 'TITTShowTypesCommand',
	#classTraits : 'TITTShowTypesCommand classTrait',
	#category : 'TypeInfoTools-Browser-Commands',
	#package : 'TypeInfoTools-Browser',
	#tag : 'Commands'
}

{ #category : 'testing' }
TITShowTypesTempVariableCommand class >> canBeExecutedInContext: aSourceCodeContext [

	^ (super canBeExecutedInContext: aSourceCodeContext) and: [
		  aSourceCodeContext isArgOrTempVariableSelected ]
]

{ #category : 'activation' }
TITShowTypesTempVariableCommand class >> sourceCodeMenuActivation [

	<classAnnotation>
	^ SycSourceCodeMenuActivation byRootGroupItemFor:
		  ClyMethodSourceCodeContext
]

{ #category : 'activation' }
TITShowTypesTempVariableCommand class >> sourceCodeShortcutActivation [

	<classAnnotation>
	^ CmdShortcutActivation
		  by: $t meta shift
		  for: ClyMethodSourceCodeContext
]

{ #category : 'execution' }
TITShowTypesTempVariableCommand >> executeInJob: job [

	| titVariable collector |
	titVariable := TITTemporaryVariable forOCVariableNode: sourceNode.

	collector := TITSequentialAdaptorsTypeCollector fast
		             reportingBlock: [ :typer |
			             job currentValue: job currentValue + 1 ];
		             yourself.
	job max: collector collectors size.
	collector addTypesTo: titVariable.

	titVariable typeInfo ifEmpty: [ ^ self informNoneFound ].

	^ self showSingleItem: titVariable
]
