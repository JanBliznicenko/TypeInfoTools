Class {
	#name : 'TITStructureNodeVisitor',
	#superclass : 'Object',
	#category : 'TypeInfoTools-Inference',
	#package : 'TypeInfoTools',
	#tag : 'Inference'
}

{ #category : 'processing' }
TITStructureNodeVisitor >> visitBlock: aBlock [

	aBlock temporaryVariables do: [ :each |
		self visitBlockTemporaryVariable: each ].
	aBlock blocks do: [ :each | self visitBlock: each ]
]

{ #category : 'processing' }
TITStructureNodeVisitor >> visitBlockTemporaryVariable: aBlockTemporaryVariable [

	^ self visitTemporaryVariable: aBlockTemporaryVariable
]

{ #category : 'processing' }
TITStructureNodeVisitor >> visitClass: aClass [

	aClass methods do: [ :each | self visitMethod: each ].
	aClass instanceVariables do: [ :each |
		self visitInstanceVariable: each ].
	aClass sharedVariables do: [ :each | self visitSharedVariable: each ]
]

{ #category : 'processing' }
TITStructureNodeVisitor >> visitInstanceVariable: anInstanceVariable [

	^ self visitVariable: anInstanceVariable
]

{ #category : 'processing' }
TITStructureNodeVisitor >> visitMethod: aMethod [

	aMethod parameterVariables do: [ :each |
		self visitMethodInputParameter: each ].
	aMethod temporaryVariables do: [ :each |
		self visitMethodTemporaryVariable: each ].
	aMethod blocks do: [ :each | self visitBlock: each ]
]

{ #category : 'processing' }
TITStructureNodeVisitor >> visitMethodInputParameter: aMethodInputParameter [

	^ self visitTemporaryVariable: aMethodInputParameter
]

{ #category : 'processing' }
TITStructureNodeVisitor >> visitMethodReturn: aMethodReturn [

	^ self visitTypedNode: aMethodReturn
]

{ #category : 'processing' }
TITStructureNodeVisitor >> visitMethodTemporaryVariable: aMethodTemporaryVariable [

	^ self visitTemporaryVariable: aMethodTemporaryVariable
]

{ #category : 'processing' }
TITStructureNodeVisitor >> visitPackage: aPackage [

	aPackage classes do: [ :each | self visitClass: each ]
]

{ #category : 'processing' }
TITStructureNodeVisitor >> visitSharedVariable: aSharedVariable [

	^ self visitVariable: aSharedVariable

	
]

{ #category : 'processing' }
TITStructureNodeVisitor >> visitTemporaryVariable: aTemporaryVariable [

	^ self visitVariable: aTemporaryVariable
]

{ #category : 'processing' }
TITStructureNodeVisitor >> visitTypedNode: aTypedNode [
	"adds types to the typedNode's typeInfo - to be overridden if applicable"

	
]

{ #category : 'processing' }
TITStructureNodeVisitor >> visitVariable: aVariable [

	^ self visitTypedNode: aVariable
]
