Class {
	#name : 'TITCombinationInferencedMessageHeuristic',
	#superclass : 'CoASTNodeFetcherHeuristic',
	#category : 'TypeInfoTools-Completion',
	#package : 'TypeInfoTools',
	#tag : 'Completion'
}

{ #category : 'requests' }
TITCombinationInferencedMessageHeuristic >> appliesForNode: aNode inContext: aContext [

	^ aContext completionClass isNotNil
		and: [ aNode receiver isVariable ]
]

{ #category : 'requests' }
TITCombinationInferencedMessageHeuristic >> buildFetcherFor: aMessageNode inContext: aContext [

	[ self tryBuildFetcherFor: aMessageNode inContext: aContext ]
		on: Error
		do: [
			^ CoInitializeInferencedMessageHeuristic new
				  next: self next;
				  buildFetcherFor: aMessageNode inContext: aContext ]
]

{ #category : 'requests' }
TITCombinationInferencedMessageHeuristic >> tryBuildFetcherFor: aMessageNode inContext: aContext [

	| receiver titVariable collector |
	receiver := aMessageNode receiver.
	titVariable := TITVariable forASTVariableNode: receiver.
	collector := TITSequentialAdaptorsTypeCollector new.
	collector addTypesTo: titVariable.
	titVariable typeInfo types sortedClasses inspect.
	self error
]
