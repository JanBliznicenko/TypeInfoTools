Extension { #name : 'TITClassTree' }

{ #category : '*TypeInfoTools-Browser' }
TITClassTree >> inspectionTree: aBuilder [

	<inspectorPresentationOrder: 10 title: 'Tree'>
	^ aBuilder instantiate: TITClassTreePresenter on: self
]
