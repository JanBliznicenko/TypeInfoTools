Extension { #name : 'Context' }

{ #category : '*TypeInfoTools-Dev' }
Context >> mayBeInRecursion [

	^ (self sender findContextSuchThat: [ :context |
		   context compiledCode == self compiledCode ]) isNotNil
]
