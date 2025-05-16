Class {
	#name : 'TITMetalinksRealTimeTypeInferer',
	#superclass : 'Object',
	#instVars : [
		'typeCollectionsByNodes',
		'returnLinkBlock',
		'assignmentLinkBlock',
		'argumentsLinkBlock',
		'returnSelfLinkBlock',
		'links',
		'linkedPackages'
	],
	#category : 'TypeInfoTools-Core-RealTime',
	#package : 'TypeInfoTools-Core',
	#tag : 'RealTime'
}

{ #category : 'adding' }
TITMetalinksRealTimeTypeInferer >> addLinksToArgumentsOfMethodNode: aMethodNode [

	MetaLink new
		metaObject: [ :arguments |
			arguments do: [ :each |
					self addTypeOf: each asPossibleTypeOf: each ] ];
		selector: #value:;
		arguments: #( arguments )
]

{ #category : 'adding' }
TITMetalinksRealTimeTypeInferer >> addLinksToMethod: aMethod [

	| class |
	class := aMethod methodClass ifNil: [ ^ self ].
	aMethod ast link: (links add: (argumentsLinkBlock value: aMethod)).
	aMethod ast assignmentNodes
		select: [ :eachNode | eachNode variable isInstanceVariable ]
		thenDo: [ :eachNode |
			eachNode link: (links add: (assignmentLinkBlock value: class)) ].
	aMethod ast allChildren
		select: [ :eachNode | eachNode isReturn ]
		thenDo: [ :eachNode |
				eachNode link:
					(links add:
						 (returnLinkBlock value: aMethod selector value: class)) ].
	aMethod ast lastIsReturn ifFalse: [
			aMethod ast link:
				(links add:
					 (returnSelfLinkBlock value: aMethod selector value: class)) ]
]

{ #category : 'adding' }
TITMetalinksRealTimeTypeInferer >> addLinksToPackageNamed: aPackageName [

	| package definedClasses |
	package := aPackageName asPackage.
	(linkedPackages includes: package) ifTrue: [ ^ self ].

	definedClasses := package definedClasses.
	definedClasses , (definedClasses collect: #class) do: [ :eachClass |
			eachClass methods do: [ :eachMethod |
				self addLinksToMethod: eachMethod ] ]
]

{ #category : 'adding' }
TITMetalinksRealTimeTypeInferer >> addTypeOf: aValue asPossibleTypeOf: aNode [

	(self typeCollectorFor: aValue) addTypeOf: aValue to: aNode
]

{ #category : 'initialization' }
TITMetalinksRealTimeTypeInferer >> initialize [

	super initialize.
	typeCollectionsByNodes := IdentityDictionary new
]
