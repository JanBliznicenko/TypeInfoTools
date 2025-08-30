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
		sourceNode parent replaceNode: sourceNode withNode: sourceNode receiver.
		titNode := TITTypedNodeCreationVisitor visit: sourceNode receiver.
		titNode compilationBlock: [ :ocMethod | self halt.
			TITPartialCompiler compileMethod: ocMethod ].
		collector := TITAdaptorsFusionTypeCollector default.
		collector addTypesTo: titNode ]
		on: Error
		do: [ :error |
				self halt.
				^ self weightGroupSorter sortCompletionList: aList ].
	titNode typeInfo types isEmpty ifFalse: [
		^ aList sorted: [ :a :b | (titNode typeInfo types sortedClasses keys first includesSelector: a contents) and: [ (titNode typeInfo types sortedClasses keys first includesSelector: a contents) not ]] ].
	^ aList
]

{ #category : 'accessing' }
TITTypeInferenceCompletionSorter >> weightGroupSorter [

	^ weightGroupSorter ifNil: [
		  weightGroupSorter := CompletionContext sorterClass new ]
]
