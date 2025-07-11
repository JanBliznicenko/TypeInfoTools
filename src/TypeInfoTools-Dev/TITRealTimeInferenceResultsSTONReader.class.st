Class {
	#name : 'TITRealTimeInferenceResultsSTONReader',
	#superclass : 'STONReader',
	#category : 'TypeInfoTools-Dev-RealTime',
	#package : 'TypeInfoTools-Dev',
	#tag : 'RealTime'
}

{ #category : 'parsing-internal' }
TITRealTimeInferenceResultsSTONReader >> parseClass [

	^ self replaceParsedClass: super parseClass
]

{ #category : 'parsing-internal' }
TITRealTimeInferenceResultsSTONReader >> replaceParsedClass: parsedClass [

	(parsedClass includesBehavior: Behavior) ifFalse: [ ^ parsedClass ].

	(parsedClass includesBehavior: Metaclass) ifTrue: [
			parsedClass = TraitedMetaclass ifTrue: [
				^ TITRealTimeInferenceResultsTraitedMetaclass ].
			parsedClass = MetaclassForTraits ifTrue: [
				^ TITRealTimeInferenceResultsMetaclassForTraits ].
			parsedClass = Metaclass ifFalse: [ self error ].
			^ TITRealTimeInferenceResultsMetaclass ].

	parsedClass isTrait ifTrue: [ ^ TITRealTimeInferenceResultsTrait ].
	parsedClass = Class ifFalse: [ self error ].
	^ TITRealTimeInferenceResultsClass
]
