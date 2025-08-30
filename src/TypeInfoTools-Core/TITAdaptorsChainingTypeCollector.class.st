Class {
	#name : 'TITAdaptorsChainingTypeCollector',
	#superclass : 'TITAdaptorsCombiningTypeCollector',
	#category : 'TypeInfoTools-Core-Inference',
	#package : 'TypeInfoTools-Core',
	#tag : 'Inference'
}

{ #category : 'accessing' }
TITAdaptorsChainingTypeCollector class >> sourceName [

	^ 'Chaining'
]

{ #category : 'processing' }
TITAdaptorsChainingTypeCollector >> addTypesTo: aStructureNode [

	self collectors do: [ :each |
			| maxWeightNode |
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
			reportingBlock cull: each.
			maxWeightNode := aStructureNode typeInfo types
				                 asClassTreeForPresenting maxWeightNode.
			maxWeightNode representedClass ifNotNil: [
				maxWeightNode weight > 0.1 ifTrue: [ ^ self ] ] ]
]
