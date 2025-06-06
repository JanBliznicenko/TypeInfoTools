Extension { #name : 'MetacelloVersion' }

{ #category : '*TypeInfoTools-Dev' }
MetacelloVersion >> loadedSystemPackages [
	"Answers the list of loaded system packages associated with this version. Beware: If any other baseline loaded unrelated package with the same name, it gets includes anyway"

	| packages |
	packages := Set new.
	self spec
		projectDo: [ :ignored |  ]
		packageDo: [ :pkg |
				self packageOrganizer
					packageNamed: pkg name
					ifPresent: [ :systemPackage | packages add: systemPackage ] ]
		groupDo: [ :ignored |  ].
	^ packages asSortedCollection: [ :a :b | a name < b name ]
]
