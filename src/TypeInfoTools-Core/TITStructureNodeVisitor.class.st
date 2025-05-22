Class {
	#name : 'TITStructureNodeVisitor',
	#superclass : 'Object',
	#category : 'TypeInfoTools-Core-Inference',
	#package : 'TypeInfoTools-Core',
	#tag : 'Inference'
}

{ #category : 'adding' }
TITStructureNodeVisitor class >> addTypesTo: aTITNode [

	^ self new addTypesTo: aTITNode
]

{ #category : 'processing' }
TITStructureNodeVisitor >> addTypesTo: aStructureNode [

	self subclassResponsibility
]

{ #category : 'visiting' }
TITStructureNodeVisitor >> visitBlock: aBlock [

	^ self visitTypedNode: aBlock
]

{ #category : 'visiting' }
TITStructureNodeVisitor >> visitBlockTemporaryVariable: aBlockTemporaryVariable [

	^ self visitTemporaryVariable: aBlockTemporaryVariable
]

{ #category : 'visiting' }
TITStructureNodeVisitor >> visitClass: aClass [

	^ self visitTypedNode: aClass
]

{ #category : 'visiting' }
TITStructureNodeVisitor >> visitInstanceVariable: anInstanceVariable [

	^ self visitVariable: anInstanceVariable
]

{ #category : 'visiting' }
TITStructureNodeVisitor >> visitMessageSend: aMessageSend [

	^ self visitTypedNode: aMessageSend
]

{ #category : 'visiting' }
TITStructureNodeVisitor >> visitMethod: aMethod [

	^ self visitTypedNode: aMethod
]

{ #category : 'visiting' }
TITStructureNodeVisitor >> visitMethodInputParameter: aMethodInputParameter [

	^ self visitTemporaryVariable: aMethodInputParameter
]

{ #category : 'visiting' }
TITStructureNodeVisitor >> visitMethodTemporaryVariable: aMethodTemporaryVariable [

	^ self visitTemporaryVariable: aMethodTemporaryVariable
]

{ #category : 'visiting' }
TITStructureNodeVisitor >> visitPackage: aPackage [

	aPackage definedClasses do: [ :each | self visitClass: each ]
]

{ #category : 'visiting' }
TITStructureNodeVisitor >> visitSharedVariable: aSharedVariable [

	^ self visitVariable: aSharedVariable

	
]

{ #category : 'visiting' }
TITStructureNodeVisitor >> visitTemporaryVariable: aTemporaryVariable [

	^ self visitVariable: aTemporaryVariable
]

{ #category : 'visiting' }
TITStructureNodeVisitor >> visitTypedNode: aTypedNode [
	"adds types to the typedNode's typeInfo - to be overridden if applicable"

	
]

{ #category : 'visiting' }
TITStructureNodeVisitor >> visitVariable: aVariable [

	^ self visitTypedNode: aVariable
]
