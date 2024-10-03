Class {
	#name : 'TITStructureNodeTypeCollector',
	#superclass : 'TITStructureNodeVisitor',
	#category : 'TypeInfoTools-Inference',
	#package : 'TypeInfoTools',
	#tag : 'Inference'
}

{ #category : 'processing' }
TITStructureNodeTypeCollector >> addTypesTo: aStructureNode [

	aStructureNode accept: self
]

{ #category : 'accessing' }
TITStructureNodeTypeCollector >> sourceName [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
TITStructureNodeTypeCollector >> weight [

	^ self subclassResponsibility
]
