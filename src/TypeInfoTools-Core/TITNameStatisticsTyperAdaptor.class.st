Class {
	#name : 'TITNameStatisticsTyperAdaptor',
	#superclass : 'TITStructureNodeTypeCollector',
	#category : 'TypeInfoTools-Core-Inference',
	#package : 'TypeInfoTools-Core',
	#tag : 'Inference'
}

{ #category : 'accessing' }
TITNameStatisticsTyperAdaptor class >> sourceName [

	^ 'NameStatistics'
]

{ #category : 'visiting' }
TITNameStatisticsTyperAdaptor >> searchNameStatisticsForNode: aTITNode in: aTyper [

	| typeEntry type |
	typeEntry := aTyper
		             at:
		             (TITNameHeuristicsTyperAdaptor unifyName: aTITNode name)
		             ifAbsent: [ ^ false ].
	type := typeEntry typeForReceiverClass: aTITNode ownerClass realClass.
	type ifNil: [ ^ false ].
	aTITNode typeInfo addTypes: { type } by: self.
	^ true
]

{ #category : 'visiting' }
TITNameStatisticsTyperAdaptor >> visitMessageSend: aMessageSend [

	self
		searchNameStatisticsForNode: aMessageSend
		in: TITNameStatisticsTyper forReturnTypes
]

{ #category : 'visiting' }
TITNameStatisticsTyperAdaptor >> visitMethod: aMethod [

	self
		searchNameStatisticsForNode: aMethod
		in: TITNameStatisticsTyper forReturnTypes
]

{ #category : 'visiting' }
TITNameStatisticsTyperAdaptor >> visitVariable: aVariable [

	self
		searchNameStatisticsForNode: aVariable
		in: TITNameStatisticsTyper forVariableTypes
]

{ #category : 'accessing' }
TITNameStatisticsTyperAdaptor >> weight [

	^ 1
]
