Extension { #name : 'StCompositeDependency' }

{ #category : '*TypeInfoTools-Dev' }
StCompositeDependency >> targetPackages [

	^ self dependencies flatCollectAsSet: [ :each | each targetPackages ]
]
