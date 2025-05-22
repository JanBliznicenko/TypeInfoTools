Extension { #name : 'OCProgramNode' }

{ #category : '*TypeInfoTools-Core' }
OCProgramNode class >> validMetaLinkArguments [

	^ RFReification keysByEntities at: self
]

{ #category : '*TypeInfoTools-Core' }
OCProgramNode >> validMetaLinkArguments [

	^ self class validMetaLinkArguments
]
