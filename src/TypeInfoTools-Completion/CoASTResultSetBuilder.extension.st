Extension { #name : 'CoASTResultSetBuilder' }

{ #category : '*TypeInfoTools-Completion' }
CoASTResultSetBuilder >> originalParseNode [

	| n |
	^ node ifNil: [
		n := completionContext completionClass compiler
			source: completionContext source;
			isScripting: completionContext isScripting;
			parse.
		OCTypingVisitor new visit: n.
		(n nodeBeforeOffset: completionContext position) ifNil: [ n ] ]
]

{ #category : '*TypeInfoTools-Completion' }
CoASTResultSetBuilder >> parseNode [

	^ self titParseNode
]

{ #category : '*TypeInfoTools-Completion' }
CoASTResultSetBuilder >> titParseNode [

	^ node ifNil: [
			  | methodNode contextNode |
			  methodNode := completionContext completionClass compiler
				                source: completionContext source;
				                isScripting: completionContext isScripting;
				                parse.
			  contextNode := (methodNode nodeBeforeOffset:
				                  completionContext position) ifNil: [ methodNode ].
			  TITOCNodeTypingVisitor new visit: contextNode.
			  contextNode ]
]
