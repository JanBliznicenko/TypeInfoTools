Class {
	#name : 'TITRelatedPackageAdaptor',
	#superclass : 'TITInferenceToolAdaptor',
	#instVars : [
		'relatedClasses',
		'relatedClassesByNameRoot'
	],
	#category : 'TypeInfoTools-Inference',
	#package : 'TypeInfoTools',
	#tag : 'Inference'
}

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
TITRelatedPackageAdaptor >> relatedClassesAt: aNameRoot [

	^ relatedClassesByNameRoot
		  at: aNameRoot asSymbol
		  ifPresent: [ :foundClasses | foundClasses ]
		  ifAbsentPut: [
			  Array streamContents: [ :s |
				  self packageOrganizer packagesDo: [ :eachPackage |
					  (eachPackage name includesSubstring: aNameRoot) ifTrue: [
						  s nextPutAll: eachPackage definedClasses ] ] ] ]
]

{ #category : 'accessing' }
TITRelatedPackageAdaptor >> relatedClassesTo: aPackage [

	^ relatedClasses at: aPackage ifAbsentPut: [
		  | nameRoot |
		  nameRoot := aPackage name copyUpTo: $-.
		  (self relatedClassesAt: nameRoot)
		  , (self relatedClassesAt: 'Kernel')
		  , (self relatedClassesAt: 'Collections') ]
]

{ #category : 'accessing' }
TITRelatedPackageAdaptor >> visitTypedNode: aTypedNode [

	^ self relatedClassesTo: aTypedNode package actualPackage
]
