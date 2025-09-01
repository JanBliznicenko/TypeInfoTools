Class {
	#name : 'TITRunTimeInferenceResultsMetaclass',
	#superclass : 'TITRunTimeInferenceResultsBehavior',
	#category : 'TypeInfoTools-RunTimeGatherer-Structure',
	#package : 'TypeInfoTools-RunTimeGatherer',
	#tag : 'Structure'
}

{ #category : 'as yet unclassified' }
TITRunTimeInferenceResultsMetaclass class >> forSystemMetaclass: aClass [

	aClass = TraitedMetaclass ifTrue: [
		^ TITRunTimeInferenceResultsTraitedMetaclass ].
	aClass = MetaclassForTraits ifTrue: [
		^ TITRunTimeInferenceResultsMetaclassForTraits ].
	self assert: aClass = Metaclass.
	^ self
]

{ #category : 'accessing' }
TITRunTimeInferenceResultsMetaclass class >> systemClass [

	^ Metaclass
]

{ #category : 'instance creation' }
TITRunTimeInferenceResultsMetaclass class >> systemClassFrom: systemClass [

	^ systemClass class
]

{ #category : 'testing' }
TITRunTimeInferenceResultsMetaclass >> isMeta [

	^ true
]
