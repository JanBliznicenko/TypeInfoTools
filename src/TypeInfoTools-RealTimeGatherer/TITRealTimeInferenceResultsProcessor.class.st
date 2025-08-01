Class {
	#name : 'TITRealTimeInferenceResultsProcessor',
	#superclass : 'Object',
	#category : 'TypeInfoTools-RealTimeGatherer-Processing',
	#package : 'TypeInfoTools-RealTimeGatherer',
	#tag : 'Processing'
}

{ #category : 'processing' }
TITRealTimeInferenceResultsProcessor class >> processAll [

	<script>
	^ self
		  processRetTypes;
		  processVarTypes
]

{ #category : 'processing' }
TITRealTimeInferenceResultsProcessor class >> processRetTypes [

	<script>
	^ self processTypes: self retTypesFilename 
]

{ #category : 'processing' }
TITRealTimeInferenceResultsProcessor class >> processTypes: aFilename [

	^ self subclassResponsibility
]

{ #category : 'processing' }
TITRealTimeInferenceResultsProcessor class >> processVarTypes [

	<script>
	^ self processTypes: self varTypesFilename
]

{ #category : 'as yet unclassified' }
TITRealTimeInferenceResultsProcessor class >> retTypesFilename [

	^ TITMetaLinksRealTimeTypeInferer retTypesFilename
]

{ #category : 'as yet unclassified' }
TITRealTimeInferenceResultsProcessor class >> varTypesFilename [

	^ TITMetaLinksRealTimeTypeInferer varTypesFilename
]
