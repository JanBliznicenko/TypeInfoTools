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

	^ (DADependencyChecker new
		   shouldComputeMessageSendDependencies: false;
		   daPackageFor: aPackage name) dependencies flatCollectAsSet: [
		  :each | each referencedClasses ]
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
		  , (self classesDependedBy: aPackage) ]
]

{ #category : 'accessing' }
TITRelatedPackagePriorityCollector >> sourceName [

	^ 'Related packages'
]

{ #category : 'processing' }
TITRelatedPackagePriorityCollector >> visitTypedNode: aTypedNode [

	relatedClasses := self relatedClassesTo:
		                  aTypedNode package systemPackage.
	aTypedNode typeInfo addTypes: relatedClasses by: self.
	aTypedNode typeInfo
		addCollectionElementTypes: relatedClasses
		by: self
]

{ #category : 'accessing' }
TITRelatedPackagePriorityCollector >> weight [

	^ 0.1
]
