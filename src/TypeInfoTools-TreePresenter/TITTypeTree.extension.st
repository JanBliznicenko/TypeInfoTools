Extension { #name : 'TITTypeTree' }

{ #category : '*TypeInfoTools-TreePresenter' }
TITTypeTree >> inspectionTree: aBuilder [

	<inspectorPresentationOrder: 10 title: 'Tree'>
	^ aBuilder instantiate: TITTypeTreePresenter on: self
]
