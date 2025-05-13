Extension { #name : 'CoASTHeuristicsResultSetBuilder' }

{ #category : '*TypeInfoTools-Completion' }
CoASTHeuristicsResultSetBuilder >> originalVisitMessageNode: aMessageNode [

	completionContext completionToken ifEmpty: [
		^ super visitMessageNode: aMessageNode ].

	^ self
		  configureFetcherForNode: aMessageNode
		  usingHeuristicAvoidingRepetitions: self messageHeuristic
]

{ #category : '*TypeInfoTools-Completion' }
CoASTHeuristicsResultSetBuilder >> titVisitMessageNode: aMessageNode [

	| completion |
	completionContext completionToken ifEmpty: [
		^ super visitMessageNode: aMessageNode ].

	completion := self
		              configureFetcherForNode: aMessageNode
		              usingHeuristicAvoidingRepetitions:
		              self messageHeuristic.

	completion sorter: TITTypePropertyCompletionSorter new.
	
	^ completion
]

{ #category : '*TypeInfoTools-Completion' }
CoASTHeuristicsResultSetBuilder >> visitMessageNode: aMessageNode [

	^ self titVisitMessageNode: aMessageNode
]
