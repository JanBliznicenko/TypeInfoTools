Extension { #name : 'Class' }

{ #category : '*TypeInfoTools-Core' }
Class >> threeWayCompareTo: otherClass [

	^ self name threeWayCompareTo: otherClass name
]
