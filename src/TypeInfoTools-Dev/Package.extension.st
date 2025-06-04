Extension { #name : 'Package' }

{ #category : '*TypeInfoTools-Dev' }
Package >> threeWayCompareTo: anotherPackage [

	^ self name threeWayCompareTo: anotherPackage name
]
