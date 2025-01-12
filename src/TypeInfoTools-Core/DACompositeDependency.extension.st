Extension { #name : 'DACompositeDependency' }

{ #category : '*TypeInfoTools-Core' }
DACompositeDependency >> referencedClasses [

	^ self dependencies flatCollectAsSet: [ :each |
		  each referencedClasses ]
]
