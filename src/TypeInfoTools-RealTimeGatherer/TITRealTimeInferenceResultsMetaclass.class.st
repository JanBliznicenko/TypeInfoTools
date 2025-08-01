Class {
	#name : 'TITRealTimeInferenceResultsMetaclass',
	#superclass : 'TITRealTimeInferenceResultsBehavior',
	#category : 'TypeInfoTools-RealTimeGatherer-Structure',
	#package : 'TypeInfoTools-RealTimeGatherer',
	#tag : 'Structure'
}

{ #category : 'as yet unclassified' }
TITRealTimeInferenceResultsMetaclass class >> forSystemMetaclass: aClass [

	aClass = TraitedMetaclass ifTrue: [
		^ TITRealTimeInferenceResultsTraitedMetaclass ].
	aClass = MetaclassForTraits ifTrue: [
		^ TITRealTimeInferenceResultsMetaclassForTraits ].
	self assert: aClass = Metaclass.
	^ self
]

{ #category : 'accessing' }
TITRealTimeInferenceResultsMetaclass class >> systemClass [

	^ Metaclass
]

{ #category : 'instance creation' }
TITRealTimeInferenceResultsMetaclass class >> systemClassFrom: systemClass [

	^ systemClass class
]

{ #category : 'testing' }
TITRealTimeInferenceResultsMetaclass >> isMeta [

	^ true
]
