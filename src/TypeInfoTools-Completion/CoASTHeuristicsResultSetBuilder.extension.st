Extension { #name : 'CoASTHeuristicsResultSetBuilder' }

{ #category : '*TypeInfoTools-Completion' }
CoASTHeuristicsResultSetBuilder >> visitMessageNode: aMessageNode [

	| completion |
	completionContext completionToken ifEmpty: [
		^ super visitMessageNode: aMessageNode ].

	completion := self
		              configureFetcherForNode: aMessageNode
		              usingHeuristicAvoidingRepetitions:
		              self messageHeuristic.

	completion sorter: TITTypeInferenceCompletionSorter new.
	
	^ completion
]
