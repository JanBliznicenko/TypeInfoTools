Class {
	#name : 'TITRunTimeInferenceResultsProcessor',
	#superclass : 'Object',
	#category : 'TypeInfoTools-RunTimeGatherer-Processing',
	#package : 'TypeInfoTools-RunTimeGatherer',
	#tag : 'Processing'
}

{ #category : 'processing' }
TITRunTimeInferenceResultsProcessor class >> processAll [

	<script>
	^ self
		  processRetTypes;
		  processVarTypes
]

{ #category : 'processing' }
TITRunTimeInferenceResultsProcessor class >> processRetTypes [

	<script>
	^ self processTypes: self retTypesFilename 
]

{ #category : 'processing' }
TITRunTimeInferenceResultsProcessor class >> processTypes: aFilename [

	^ self subclassResponsibility
]

{ #category : 'processing' }
TITRunTimeInferenceResultsProcessor class >> processVarTypes [

	<script>
	^ self processTypes: self varTypesFilename
]

{ #category : 'as yet unclassified' }
TITRunTimeInferenceResultsProcessor class >> retTypesFilename [

	^ TITMetaLinksRunTimeTypeInferer retTypesFilename
]

{ #category : 'as yet unclassified' }
TITRunTimeInferenceResultsProcessor class >> varTypesFilename [

	^ TITMetaLinksRunTimeTypeInferer varTypesFilename
]
