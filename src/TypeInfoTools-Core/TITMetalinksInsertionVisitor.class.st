Class {
	#name : 'TITMetaLinksInsertionVisitor',
	#superclass : 'OCProgramNodeVisitor',
	#instVars : [
		'linksByPackages',
		'links',
		'typeHoldersForClasses'
	],
	#category : 'TypeInfoTools-Core-RealTime',
	#package : 'TypeInfoTools-Core',
	#tag : 'RealTime'
}

{ #category : 'as yet unclassified' }
TITMetaLinksInsertionVisitor class >> typeProperty [

	^ #realTypes
]

{ #category : 'visiting' }
TITMetaLinksInsertionVisitor >> addArgumentsLinkTo: aMethodNode [

	"| argumentsLink |
	argumentsLink := MetaLink new.
	argumentsLink
		metaObject: [ :arguments |
				arguments withIndexDo: [ :eachArgument :index |
							self halt.
							self
								saveTypeOf: eachArgument
								to: (aMethodNode arguments at: index) ] ];
		selector: #value:;
		arguments: #( arguments );
		control: #before.
	links add: argumentsLink.
	aMethodNode link: argumentsLink"
]

{ #category : 'adding' }
TITMetaLinksInsertionVisitor >> addLinksToClass: aClass [

	aClass methods do: [ :eachMethod | self addLinksToMethod: eachMethod ]
]

{ #category : 'adding' }
TITMetaLinksInsertionVisitor >> addLinksToMethod: aMethod [

	self visit: aMethod ast
]

{ #category : 'adding' }
TITMetaLinksInsertionVisitor >> addLinksToPackageNamed: aPackageName [

	| package definedClasses |
	package := self packageOrganizer packageNamed: aPackageName.

	definedClasses := package definedClasses.
	definedClasses , (definedClasses collect: #class) do: [ :eachClass |
		self addLinksToClass: eachClass ]
]

{ #category : 'visiting' }
TITMetaLinksInsertionVisitor >> addReturnLinkTo: aMethodNode [

	| link |
	link := MetaLink new.
	link
		metaObject: [ :arguments :value |
				self halt.
				self saveTypeOf: value to: aMethodNode ];
		selector: #value:value:;
		arguments: #(arguments value  );
		control: #before.
	links add: link.
	aMethodNode link: link
]

{ #category : 'initialization' }
TITMetaLinksInsertionVisitor >> initialize [

	super initialize.
	links := OrderedCollection new.
	typeHoldersForClasses := IdentityDictionary new
]

{ #category : 'instance creation' }
TITMetaLinksInsertionVisitor >> newTypeHolderFor: anObject [

	^ typeHoldersForClasses at: anObject class ifAbsentPut: (({
			    TITDictionaryTypeHolder.
			    TITCollectionTypeHolder.
			    TITKeyValueTypeHolder.
			    TITTypeHolder } detect: [ :any |
			    any acceptsClass: anObject class ]) newForValue: anObject)
]

{ #category : 'visiting' }
TITMetaLinksInsertionVisitor >> saveTypeOf: aValue to: aNode [

	(aNode propertyAt: self class typeProperty ifAbsentPut: Bag new) add:
		(self newTypeHolderFor: aValue)
]

{ #category : 'cleanup' }
TITMetaLinksInsertionVisitor >> uninstallAll [

	links
		do: [ :eachLink | eachLink uninstall ];
		removeAll
]

{ #category : 'visiting' }
TITMetaLinksInsertionVisitor >> visitAssignmentNode: anAssignmentNode [

	| link |
	link := MetaLink new.
	link
		metaObject: [ :value :newValue |
				self halt.
				self saveTypeOf: value to: anAssignmentNode ];
		selector: #value:value:;
		arguments: #( value newValue );
		control: #before.
	links add: link.
	anAssignmentNode link: link
]

{ #category : 'visiting' }
TITMetaLinksInsertionVisitor >> visitMessageNode: aNode [

	| link |
	link := MetaLink new.
	link
		metaObject: [ :returnedValue |
				self halt.
				self saveTypeOf: returnedValue to: aNode ];
		selector: #value:;
		arguments: #( value );
		control: #after.
	links add: link.
	aNode link: link
]

{ #category : 'visiting' }
TITMetaLinksInsertionVisitor >> visitMethodNode: aMethodNode [

	self addArgumentsLinkTo: aMethodNode.
	self addReturnLinkTo: aMethodNode.
	super visitMethodNode: aMethodNode
]
