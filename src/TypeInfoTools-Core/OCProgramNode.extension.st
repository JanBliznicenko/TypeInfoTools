Extension { #name : 'OCProgramNode' }

{ #category : '*TypeInfoTools-Core' }
OCProgramNode >> inspectionTypes: specBuilder [

	<inspectorPresentationOrder: 55 title: 'Types'>
	^ specBuilder newList
		  items: (self
				   propertyAt: TITMetaLinksInsertionVisitor typeProperty
				   ifAbsent: [ Bag new ]) values;
		  display: [ :typeHolder | typeHolder asString ];
		  yourself
]

{ #category : '*TypeInfoTools-Core' }
OCProgramNode class >> validMetaLinkArguments [

	^ RFReification keysByEntities at: self
]

{ #category : '*TypeInfoTools-Core' }
OCProgramNode >> validMetaLinkArguments [

	^ self class validMetaLinkArguments
]
