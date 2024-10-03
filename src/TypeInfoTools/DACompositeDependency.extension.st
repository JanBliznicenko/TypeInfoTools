Extension { #name : 'DACompositeDependency' }

{ #category : '*TypeInfoTools' }
DACompositeDependency >> referencedClasses [

	^ self dependencies flatCollectAsSet: [ :each |
		  each referencedClasses ]
]
