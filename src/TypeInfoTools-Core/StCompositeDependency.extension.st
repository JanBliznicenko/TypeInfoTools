Extension { #name : 'StCompositeDependency' }

{ #category : '*TypeInfoTools-Core' }
StCompositeDependency >> referencedClasses [

	^ self dependencies flatCollectAsSet: [ :each |
		  each referencedClasses ]
]
