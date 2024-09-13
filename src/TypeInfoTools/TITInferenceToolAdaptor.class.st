Class {
	#name : 'TITInferenceToolAdaptor',
	#superclass : 'TITTypeCollector',
	#category : 'TypeInfoTools-Inference',
	#package : 'TypeInfoTools',
	#tag : 'Inference'
}

{ #category : 'accessing' }
TITInferenceToolAdaptor >> addTypesTo: aStructureNode [

	aStructureNode accept: self
]

{ #category : 'accessing' }
TITInferenceToolAdaptor >> name [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
TITInferenceToolAdaptor >> visitBlock: aBlock [

	aBlock temporaryVariables do: [ :each |
		self visitBlockTemporaryVariable: each ].
	aBlock blocks do: [ :each | self visitBlock: each ]
]

{ #category : 'accessing' }
TITInferenceToolAdaptor >> visitBlockTemporaryVariable: aBlockTemporaryVariable [

	^ self visitTemporaryVariable: aBlockTemporaryVariable
]

{ #category : 'accessing' }
TITInferenceToolAdaptor >> visitClass: aClass [

	aClass methods do: [ :each | self visitMethod: each ].
	aClass instanceVariables do: [ :each |
		self visitInstanceVariable: each ].
	aClass sharedVariables do: [ :each | self visitSharedVariable: each ]
]

{ #category : 'accessing' }
TITInferenceToolAdaptor >> visitInstanceVariable: anInstanceVariable [

	^ self visitTypedNode: anInstanceVariable
]

{ #category : 'accessing' }
TITInferenceToolAdaptor >> visitMethod: aMethod [

	aMethod parameterVariables do: [ :each |
		self visitMethodInputParameter: each ].
	aMethod temporaryVariables do: [ :each |
		self visitMethodTemporaryVariable: each ].
	aMethod blocks do: [ :each | self visitBlock: each ]
]

{ #category : 'accessing' }
TITInferenceToolAdaptor >> visitMethodInputParameter: aMethodInputParameter [

	^ self visitTemporaryVariable: aMethodInputParameter
]

{ #category : 'accessing' }
TITInferenceToolAdaptor >> visitMethodReturn: aMethodReturn [

	^ self visitTypedNode: aMethodReturn
]

{ #category : 'accessing' }
TITInferenceToolAdaptor >> visitMethodTemporaryVariable: aMethodTemporaryVariable [

	^ self visitTemporaryVariable: aMethodTemporaryVariable
]

{ #category : 'accessing' }
TITInferenceToolAdaptor >> visitPackage: aPackage [

	aPackage classes do: [ :each | self visitClass: each ]
]

{ #category : 'accessing' }
TITInferenceToolAdaptor >> visitSharedVariable: aSharedVariable [

	^ self visitTypedNode: aSharedVariable

	
]

{ #category : 'accessing' }
TITInferenceToolAdaptor >> visitTemporaryVariable: aTemporaryVariable [

	^ self visitTypedNode: aTemporaryVariable
]

{ #category : 'accessing' }
TITInferenceToolAdaptor >> visitTypedNode: aTypedNode [
	"do nothing by default - override to add types to its typeInfo"

	
]
