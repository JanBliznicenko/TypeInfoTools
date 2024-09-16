Class {
	#name : 'TITRelatedPackageAdaptor',
	#superclass : 'TITInferenceToolAdaptor',
	#instVars : [
		'relatedClasses',
		'classesByPackageNameRoot'
	],
	#category : 'TypeInfoTools-Inference',
	#package : 'TypeInfoTools',
	#tag : 'Inference'
}

{ #category : 'accessing' }
TITRelatedPackageAdaptor >> classesByPackageNameRoot: aNameRoot [

	^ classesByPackageNameRoot
		  at: aNameRoot asSymbol
		  ifPresent: [ :foundClasses | foundClasses ]
		  ifAbsentPut: [
			  Array streamContents: [ :s |
				  self packageOrganizer packagesDo: [ :eachPackage |
					  (eachPackage name includesSubstring: aNameRoot) ifTrue: [
						  s nextPutAll: eachPackage definedClasses ] ] ] ]
]

{ #category : 'accessing' }
TITRelatedPackageAdaptor >> classesDependedBy: aPackage [

	^ (DADependencyChecker new
		   shouldComputeMessageSendDependencies: false;
		   daPackageFor: aPackage name) dependencies collect: [ :each |
		  each dependencyOnClass ]
]

{ #category : 'initialization' }
TITRelatedPackageAdaptor >> initialize [

	super initialize.
	relatedClasses := Dictionary new
]

{ #category : 'accessing' }
TITRelatedPackageAdaptor >> name [

	^ 'Related packages'
]

{ #category : 'accessing' }
TITRelatedPackageAdaptor >> relatedClassesTo: aPackage [

	^ relatedClasses at: aPackage ifAbsentPut: [
		  | nameRoot |
		  nameRoot := aPackage name copyUpTo: $-.
		  (self classesByPackageNameRoot: nameRoot) asSet
		  , (self classesDependedBy: aPackage) ]
]

{ #category : 'accessing' }
TITRelatedPackageAdaptor >> visitTypedNode: aTypedNode [

	aTypedNode typeInfo prioritizedClasses:
		(self relatedClassesTo: aTypedNode package actualPackage)
]
