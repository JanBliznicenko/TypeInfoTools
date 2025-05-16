Extension { #name : 'CompiledMethod' }

{ #category : '*TypeInfoTools-Core' }
CompiledMethod >> methodProfilingData [
	"Collect the branch and send data for cogMethod, storing it into arrayObj."

	"If the method is frameless, it has no message sends. No need to continue."

	<primitive: 217>
	self primitiveFailed
]
