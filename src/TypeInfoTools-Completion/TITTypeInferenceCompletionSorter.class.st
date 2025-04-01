Class {
	#name : 'TITTypeInferenceCompletionSorter',
	#superclass : 'CompletionSorter',
	#instVars : [
		'weightGroupSorter'
	],
	#category : 'TypeInfoTools-Completion',
	#package : 'TypeInfoTools-Completion'
}

{ #category : 'sorting' }
TITTypeInferenceCompletionSorter >> sortCompletionList: aList [

	| sourceNode titNode collector |
	aList ifEmpty: [ ^ aList ].

	[
	sourceNode := aList anyOne node.
	titNode := TITTypedNodeCreationVisitor visit: sourceNode receiver.
	titNode compilationBlock: [ :ocMethod |
		TITPartialCompiler compileMethod: ocMethod ].
	collector := TITSequentialAdaptorsTypeCollector new.
	collector addTypesTo: titNode ]
		on: Error
		do: [ :error |
			^ self weightGroupSorter sortCompletionList: aList ].

	^ self weightGroupSorter sortCompletionList: aList
]

{ #category : 'accessing' }
TITTypeInferenceCompletionSorter >> weightGroupSorter [

	^ weightGroupSorter ifNil: [
		  weightGroupSorter := CompletionContext sorterClass new ]
]
