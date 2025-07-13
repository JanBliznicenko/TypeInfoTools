Class {
	#name : 'TITRealTimeInferenceResultsAnalyser',
	#superclass : 'TITRealTimeInferenceResultsProcessor',
	#category : 'TypeInfoTools-Dev-RealTime',
	#package : 'TypeInfoTools-Dev',
	#tag : 'RealTime'
}

{ #category : 'private - transforming' }
TITRealTimeInferenceResultsAnalyser class >> byNameParts: aDictionaryOfHolder [

	| merged |
	merged := Dictionary new.
	aDictionaryOfHolder keysAndValuesDo: [ :key :holder |
			key splitCamelCase do: [ :eachPart |
					| newKey |
					newKey := eachPart uncapitalized asSymbol.
					merged
						at: newKey
						ifPresent: [ :foundHolder |
						merged at: newKey put: foundHolder , holder ]
						ifAbsentPut: [ holder ] ] ].
	^ merged
]

{ #category : 'private - transforming' }
TITRealTimeInferenceResultsAnalyser class >> save: aDictionaryOfTypes as: aFileName [

	| dictionaryOfTypes |
	dictionaryOfTypes := self sortedBySizes: aDictionaryOfTypes.
	aFileName asFileReference
		ensureDelete;
		writeStreamDo: [ :s | STON put: dictionaryOfTypes onStreamPretty: s ].
	^ dictionaryOfTypes
]

{ #category : 'private - transforming' }
TITRealTimeInferenceResultsAnalyser class >> sortedBySizes: aDictionaryOfHolder [

	^ (aDictionaryOfHolder associations sorted: [ :a :b |
			   a value size = b value size
				   ifTrue: [ a key < b key ]
				   ifFalse: [ a value size > b value size ] ]) asOrderedDictionary
]

{ #category : 'private - transforming' }
TITRealTimeInferenceResultsAnalyser class >> unifyName: aString [

	| simplified |
	simplified := TITNameTyperAdaptor simplifyName: aString.
	simplified size = 1 ifTrue: [ ^ aString asLowercase asSymbol ].
	(simplified first isUppercase and: [ simplified second isLowercase ])
		ifTrue: [ ^ simplified uncapitalized asSymbol ].
	^ simplified asSymbol
]
