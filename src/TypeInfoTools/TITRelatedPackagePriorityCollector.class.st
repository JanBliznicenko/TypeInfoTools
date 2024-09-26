Class {
	#name : 'TITRelatedPackagePriorityCollector',
	#superclass : 'TITStructureNodeVisitor',
	#instVars : [
		'relatedClasses',
		'classesByPackageNameRoot'
	],
	#category : 'TypeInfoTools-Inference',
	#package : 'TypeInfoTools',
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
		   daPackageFor: aPackage name) dependencies flatCollect: [ :each |
		  each dependencies collect: [ :each | each theClass ] ]
]

{ #category : 'initialization' }
TITRelatedPackagePriorityCollector >> initialize [

	super initialize.
	relatedClasses := Dictionary new.
	classesByPackageNameRoot := Dictionary new
]

{ #category : 'accessing' }
TITRelatedPackagePriorityCollector >> name [

	^ 'Related packages'
]

{ #category : 'processing' }
TITRelatedPackagePriorityCollector >> relatedClassesTo: aPackage [

	^ relatedClasses at: aPackage ifAbsentPut: [
		  | nameRoot |
		  nameRoot := aPackage name copyUpTo: $-.
		  (self classesByPackageNameRoot: nameRoot) asSet
		  , (self classesDependedBy: aPackage) ]
]

{ #category : 'processing' }
TITRelatedPackagePriorityCollector >> visitTypedNode: aTypedNode [

	aTypedNode typeInfo setOrIntersectWithPrioritizedClasses:
		(self relatedClassesTo: aTypedNode package systemPackage)
]
