Extension { #name : 'StPackageDependency' }

{ #category : '*TypeInfoTools-Dev' }
StPackageDependency >> targetPackages [

	target systemPackage ifNotNil: [ :package | ^ Set with: package ].
	^ Set empty
]
