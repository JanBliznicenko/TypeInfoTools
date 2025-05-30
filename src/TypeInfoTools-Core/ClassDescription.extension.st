Extension { #name : 'ClassDescription' }

{ #category : '*TypeInfoTools-Core' }
ClassDescription >> commonSuperclassSymmetricWith: aClass [
	"return the next common superclass between me and aClass. If any of us is the superclass, answer it"

	<reflection:
	'Class structural inspection - Iterating and querying hierarchy'>
	aClass ifNil: [ ^ nil ].
	^ self withAllSuperclasses
		  detect: [ :class | aClass withAllSuperclasses includes: class ]
		  ifNone: nil
]
