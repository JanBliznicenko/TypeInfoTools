Class {
	#name : 'TITRelatedPackagePriorityCollector',
	#superclass : 'TITStructureNodeTypeCollector',
	#instVars : [
		'relatedClasses',
		'classesByPackageNameRoot'
	],
	#category : 'TypeInfoTools-Core-Inference',
	#package : 'TypeInfoTools-Core',
	#tag : 'Inference'
}

{ #category : 'processing' }
TITRelatedPackagePriorityCollector >> classesByPackageNameRoot: aNameRoot [

	^ classesByPackageNameRoot
		  at: aNameRoot asSymbol
		  ifPresent: [ :foundClasses | foundClasses ]
		  ifAbsentPut: [
			  Array streamContents: [ :s |
				  self packageOrganizer packagesDo: [ :eachPackage |
					  (eachPackage name includesSubstring: aNameRoot) ifTrue: [
						  s nextPutAll: eachPackage definedClasses ] ] ] ]
]

{ #category : 'processing' }
TITRelatedPackagePriorityCollector >> classesDependedBy: aPackage [

	^ (StDependencyChecker new
		   shouldComputeMessageSendDependencies: false;
		   daPackageFor: aPackage name) dependencies flatCollectAsSet: [
		  :each | each referencedClasses ]
]

{ #category : 'processing' }
TITRelatedPackagePriorityCollector >> classesRelevantToAllPackages [

	^ Set withAll: {
			  Class.
			  Metaclass.
			  ClassDescription.
			  Behavior.
			  Boolean.
			  Exception.
			  Error.
			  String.
			  Symbol.
			  Collection.
			  Array.
			  OrderedCollection.
			  Set.
			  Dictionary.
			  SortedCollection.
			  IdentitySet.
			  OrderedDictionary.
			  Interval.
			  Magnitude.
			  Number.
			  Character.
			  Float.
			  Fraction.
			  Integer }
]

{ #category : 'initialization' }
TITRelatedPackagePriorityCollector >> initialize [

	super initialize.
	relatedClasses := Dictionary new.
	classesByPackageNameRoot := Dictionary new
]

{ #category : 'processing' }
TITRelatedPackagePriorityCollector >> relatedClassesTo: aPackage [

	^ relatedClasses at: aPackage ifAbsentPut: [
			  | nameRoot |
			  nameRoot := aPackage name copyUpTo: $-.
			  (self classesByPackageNameRoot: nameRoot) asSet
			  , (self classesDependedBy: aPackage)
			  , self classesRelevantToAllPackages ]
]

{ #category : 'accessing' }
TITRelatedPackagePriorityCollector >> sourceName [

	^ 'Related packages'
]

{ #category : 'visiting' }
TITRelatedPackagePriorityCollector >> visitTypedNode: aTypedNode [

	| relatedClassesToPackage |
	relatedClassesToPackage := self relatedClassesTo:
		                           aTypedNode package systemPackage.
	aTypedNode typeInfo addTypes: relatedClassesToPackage by: self.
	aTypedNode typeInfo
		addCollectionElementTypes: relatedClassesToPackage
		by: self
]

{ #category : 'accessing' }
TITRelatedPackagePriorityCollector >> weight [

	^ 0.1
]
