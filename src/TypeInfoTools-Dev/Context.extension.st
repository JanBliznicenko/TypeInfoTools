Extension { #name : 'Context' }

{ #category : '*TypeInfoTools-Dev' }
Context >> mayBeInRecursion [

	| context compiledCode sameContexts |
	compiledCode := self compiledCode.
	context := self.
	sameContexts := 0.
	[ context isNil ] whileFalse: [
			context compiledCode == compiledCode ifTrue: [
				sameContexts := sameContexts + 1 ].
			sameContexts > 10 ifTrue: [ ^ true ].
			context := context sender ].
	^ false
]
