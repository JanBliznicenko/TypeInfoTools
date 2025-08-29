Class {
	#name : 'TITStructureNodeTypeCollector',
	#superclass : 'TITStructureNodeVisitor',
	#instVars : [
		'relatedCollector'
	],
	#category : 'TypeInfoTools-Core-Inference',
	#package : 'TypeInfoTools-Core',
	#tag : 'Inference'
}

{ #category : 'processing' }
TITStructureNodeTypeCollector >> addTypesTo: aStructureNode [

	aStructureNode accept: self
]

{ #category : 'accessing' }
TITStructureNodeTypeCollector >> messageSendCollector [

	^ relatedCollector ifNil: [ self ]
]

{ #category : 'accessing' }
TITStructureNodeTypeCollector >> messageSendCollector: aTypeCollector [

	relatedCollector := aTypeCollector
]

{ #category : 'visiting' }
TITStructureNodeTypeCollector >> visitBlock: aBlock [

	aBlock typeInfo addTypes: (Set with: BlockClosure) by: self
]

{ #category : 'visiting' }
TITStructureNodeTypeCollector >> visitClass: aClass [

	aClass typeInfo addTypes: (Set with: aClass realClass) by: self
]

{ #category : 'visiting' }
TITStructureNodeTypeCollector >> visitMessageSend: aMessageSend [
	"need type of receiver and with that, type of return value of 'type of receiver'>>#selector"

	| receiver receiverTypes compiledMethod titMethod |
	receiver := aMessageSend receiver.
	receiver ifNotProcessedByAnyCollectorAccept: self messageSendCollector.
	receiverTypes := receiver typeInfo types sortedClasses ifEmpty: [
		                 ^ self ].
	compiledMethod := ((receiverTypes keyAtIndex: 1) lookupSelector:
		                   aMessageSend selector asSymbol) ifNil: [ ^ self ].
	titMethod := TITMethod forOCMethodNode: compiledMethod ast.
	titMethod accept: self.
	aMessageSend typeInfo addAllFrom: titMethod typeInfo
]
