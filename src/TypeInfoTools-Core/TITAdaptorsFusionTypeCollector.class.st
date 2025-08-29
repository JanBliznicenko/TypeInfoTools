Class {
	#name : 'TITAdaptorsFusionTypeCollector',
	#superclass : 'TITAdaptorsCombiningTypeCollector',
	#category : 'TypeInfoTools-Core-Inference',
	#package : 'TypeInfoTools-Core',
	#tag : 'Inference'
}

{ #category : 'accessing' }
TITAdaptorsFusionTypeCollector class >> sourceName [

	^ 'Fusion'
]

{ #category : 'processing' }
TITAdaptorsFusionTypeCollector >> addTypesTo: aStructureNode [

	self collectors do: [ :each |
			[ each addTypesTo: aStructureNode ]
				on: Error
				do: [ :err |
						err freeze.
						[
							(GrowlMorph
								 openWithLabel: 'Type inference: ' , err className
								 contents: err messageText , String cr , '(click to debug)'
								 backgroundColor: GrowlMorph theme dangerBackgroundColor
								 labelColor: GrowlMorph theme badgeTextColor) actionBlock: [
								err debug ] ] fork ].
			reportingBlock cull: each ]
]
