Class {
	#name : 'TITMetalinksInsertionVisitor',
	#superclass : 'OCProgramNodeVisitor',
	#instVars : [
		'linksByPackages'
	],
	#category : 'TypeInfoTools-Core-RealTime',
	#package : 'TypeInfoTools-Core',
	#tag : 'RealTime'
}

{ #category : 'initialization' }
TITMetalinksInsertionVisitor >> initialize [

	super initialize.
	linksByPackages := Dictionary new
]

{ #category : 'cleanup' }
TITMetalinksInsertionVisitor >> uninstallAll [

	linksByPackages recursiveDo: [ :eachPackageGroup |
		eachPackageGroup do: [ :eachLink | eachLink uninstall ] ].
	linksByPackages := Dictionary empty
]
