Class {
	#name : 'TITShowTypesTemoraryVariableCommand',
	#superclass : 'SycSourceCodeCommand',
	#traits : 'TITTShowTypesCommand',
	#classTraits : 'TITTShowTypesCommand classTrait',
	#category : 'TypeInfoTools-Commands',
	#package : 'TypeInfoTools',
	#tag : 'Commands'
}

{ #category : 'execution' }
TITShowTypesTemoraryVariableCommand >> executeInJob: job [

	| titVariable collector |
	titVariable := TITTemporaryVariable forASTVariableNode: sourceNode.

	collector := TITSequentialAdaptorsTypeCollector new
		             reportingBlock: [ :typer |
			             job currentValue: job currentValue + 1 ];
		             yourself.
	job max: collector collectors size.
	collector addTypesTo: titVariable.

	titVariable typeInfo ifEmpty: [ ^ self informNoneFound ].

	^ self showSingleItem: titVariable
]
