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
TITNameStatisticsTyperAdaptor >> searchNameStatisticsForNode: aTITNode in: aTyper withRelative: aBoolean [

	| typeEntries types |
	typeEntries := aTyper
		               at:
		               (TITNameHeuristicsTyperAdaptor simplifyName:
			                aTITNode name)
		               withRelative: aBoolean
		               ifAbsent: [ ^ false ].
	types := Set new.

	typeEntries do: [ :each |
			[
			types add:
				(each typeForReceiverClass: aTITNode ownerClass realClass) ]
				on: TITEntryNotApplicable
				do: [ "do nothing" ] ].
	types ifEmpty: [ ^ false ].
	aTITNode typeInfo addTypes: types by: self.
	^ true
]

{ #category : 'visiting' }
TITNameStatisticsTyperAdaptor >> visitMessageSend: aMessageSend [

	self
		searchNameStatisticsForNode: aMessageSend
		in: TITNameStatisticsTyper forReturnTypes withRelative: false
]

{ #category : 'visiting' }
TITNameStatisticsTyperAdaptor >> visitMethod: aMethod [

	self
		searchNameStatisticsForNode: aMethod
		in: TITNameStatisticsTyper forReturnTypes
		withRelative: true
]

{ #category : 'visiting' }
TITNameStatisticsTyperAdaptor >> visitVariable: aVariable [

	self
		searchNameStatisticsForNode: aVariable
		in: TITNameStatisticsTyper forVariableTypes
		withRelative: true
]

{ #category : 'accessing' }
TITNameStatisticsTyperAdaptor >> weight [

	^ 1
]
