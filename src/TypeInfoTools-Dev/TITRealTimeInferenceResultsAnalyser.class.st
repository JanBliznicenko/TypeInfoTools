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

{ #category : 'processing' }
TITRealTimeInferenceResultsAnalyser class >> processAll [

	<script>
	^ super processAll
]

{ #category : 'processing' }
TITRealTimeInferenceResultsAnalyser class >> processTypes: commonNamePart [

	| imageDir file typesDictionary byNames |
	imageDir := FileLocator imageDirectory.
	file := imageDir / commonNamePart.
	typesDictionary := file readStreamDo: [ :s |
		                   (TITRealTimeInferenceResultsSTONReader on: s)
			                   next ].
	byNames := Dictionary new.
	typesDictionary keysAndValuesDo: [
			:eachContentReference
			:eachTypeHolder |
			| unifiedName dictionaryOfSourcesByTypes |
			unifiedName := self unifyName: eachContentReference name.
			dictionaryOfSourcesByTypes := byNames
				                              at: unifiedName
				                              ifAbsentPut: Dictionary new.
			eachTypeHolder types do: [ :eachType |
					(dictionaryOfSourcesByTypes
						 at: eachType
						 ifAbsentPut: SortedCollection new) add:
						eachContentReference contentClass ] ].
	^ self save: byNames as: 'ByNames' , commonNamePart
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
