Extension { #name : 'VirtualMachine' }

{ #category : '*TypeInfoTools-Core' }
VirtualMachine >> getCompiledMethodsInMachineCode [
    
    ^ self getMachineCodeContent select: [ :e | e isCompiledBlock or: [ e isCompiledMethod ] ]
]

{ #category : '*TypeInfoTools-Core' }
VirtualMachine >> getMachineCodeContent [
	"Answer the contents of the code zone as an array of pair-wise element, address in ascending
     address order. Answer a string for a runtime routine or abstract label (beginning, end, etc),
     a CompiledMethod for a CMMethod, or a selector (presumably a Symbol) for a PIC.
     If there is an argument and it is true, then collect inner information about the CogMethod."

	<primitive: 253>
	self primitiveFail
]
