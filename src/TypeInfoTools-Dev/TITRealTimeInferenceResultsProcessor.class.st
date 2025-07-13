Class {
	#name : 'TITRealTimeInferenceResultsProcessor',
	#superclass : 'Object',
	#category : 'TypeInfoTools-Dev-RealTime',
	#package : 'TypeInfoTools-Dev',
	#tag : 'RealTime'
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
	^ self processTypes: '_VarTypes.ston'
]

{ #category : 'as yet unclassified' }
TITRealTimeInferenceResultsProcessor class >> retTypesFilename [

	^ '_RetTypes.ston'
]

{ #category : 'as yet unclassified' }
TITRealTimeInferenceResultsProcessor class >> varTypesFilename [

	^ '_VarTypes.ston'
]
