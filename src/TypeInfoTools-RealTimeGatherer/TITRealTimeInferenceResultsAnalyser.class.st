Class {
	#name : 'TITRealTimeInferenceResultsAnalyser',
	#superclass : 'TITRealTimeInferenceResultsProcessor',
	#category : 'TypeInfoTools-RealTimeGatherer-Processing',
	#package : 'TypeInfoTools-RealTimeGatherer',
	#tag : 'Processing'
}

{ #category : 'processing' }
TITRealTimeInferenceResultsAnalyser class >> createTypeTableFrom: aDictionaryOfTypesWithOrigins as: aFileName [

	| rootNodesByNames |
	rootNodesByNames := self createTypesWithOriginsForestFrom:
		                    aDictionaryOfTypesWithOrigins.
	^ self createTypeTableFromClassForest: rootNodesByNames as: aFileName
]

{ #category : 'processing' }
TITRealTimeInferenceResultsAnalyser class >> createTypeTableFromClassForest: rootNodesByNames as: aFileName [

	| typeTable |
	typeTable := rootNodesByNames
		             collect: [ :eachRootNode |
		             eachRootNode mostPreciseNode ]
		             thenReject: [ :any |
				             any isNil or: [
						             {
							             Object.
							             ProtoObject.
							             nil } includes: any type ] ].
	aFileName asFileReference , 'csv' writeStreamDo: [ :stream |
			| writer |
			writer := NeoCSVWriter on: stream.
			writer separator: self csvSeparator.
			writer writeHeader: { #Name. #Type }.
			typeTable associations sorted do: [ :eachNameAndType |
					writer nextPut: {
							eachNameAndType key.
							eachNameAndType value name } ] ]
]

{ #category : 'processing' }
TITRealTimeInferenceResultsAnalyser class >> createTypesWithOriginsForestFrom: aDictionaryOfTypesWithOrigins [

	| rootNodesByNames |
	rootNodesByNames := Dictionary new.

	aDictionaryOfTypesWithOrigins keysAndValuesDo: [
			:eachKey
			:eachOriginsCollectionsByTypes |
			| rootNode |
			rootNode := TITTypeNodeWithOrigins withType: nil.
			rootNodesByNames at: eachKey put: rootNode.
			eachOriginsCollectionsByTypes keysAndValuesDo: [
					:eachType
					:eachOriginsCollections |
					rootNode
						atTypeHierarchy: eachType withAllSuperclasses
						addOrigins: eachOriginsCollections ] ].

	^ rootNodesByNames
]

{ #category : 'processing' }
TITRealTimeInferenceResultsAnalyser class >> csvSeparator [

	^ $;
]

{ #category : 'accessing' }
TITRealTimeInferenceResultsAnalyser class >> minimumAcceptableTypeRatio [
	"ratio of type occurences encompassed by a single type in order to be accepted as valid type for the var/method"

	^ 0.98
]

{ #category : 'processing' }
TITRealTimeInferenceResultsAnalyser class >> processAll [

	<script>
	^ super processAll
]

{ #category : 'processing' }
TITRealTimeInferenceResultsAnalyser class >> processByNameParts: dictionaryByNames reversedBlock: aReversedBlock to: aFileName [

	| resultingDictionary |
	resultingDictionary := Dictionary empty.
	dictionaryByNames keysAndValuesDo: [
			:eachEntireName
			:eachSourceDictionaryOfSourcesByTypes |
			| parts |
			parts := aReversedBlock value: eachEntireName splitCamelCase.
			1 to: parts size do: [ :lastPartIndex |
					| nameKey dictionaryOfSourcesByTypes |
					nameKey := Symbol streamContents: [ :stream |
							           (aReversedBlock value: (parts first: lastPartIndex))
								           do: [ :eachPart | stream << eachPart ] ].
					dictionaryOfSourcesByTypes := resultingDictionary
						                              at: nameKey
						                              ifAbsentPut: Dictionary empty.
					eachSourceDictionaryOfSourcesByTypes keysAndValuesDo: [
							:eachType
							:eachSourceClassesCollection |
							(dictionaryOfSourcesByTypes
								 at: eachType
								 ifAbsentPut: OrderedCollection empty) addAll:
								eachSourceClassesCollection ] ] ].
	self save: resultingDictionary as: aFileName.
	self createTypeTableFrom: resultingDictionary as: aFileName
]

{ #category : 'processing' }
TITRealTimeInferenceResultsAnalyser class >> processByNames: typesDictionary to: aFileName [

	| resultingDictionary |
	resultingDictionary := Dictionary empty.
	typesDictionary keysAndValuesDo: [
			:eachContentReference
			:eachTypeHolder |
			| types nameKey dictionaryOfSourcesByTypes |
			types := eachTypeHolder types.
			types ifNotEmpty: [
					nameKey := self unifyName: eachContentReference name.
					dictionaryOfSourcesByTypes := resultingDictionary
						                              at: nameKey
						                              ifAbsentPut: Dictionary empty.
					types do: [ :eachType |
							(dictionaryOfSourcesByTypes
								 at: eachType
								 ifAbsentPut: OrderedCollection empty) add:
								eachContentReference contentClass ] ] ].
	self save: resultingDictionary as: aFileName.
	self createTypeTableFrom: resultingDictionary as: aFileName.
	^ resultingDictionary
]

{ #category : 'processing' }
TITRealTimeInferenceResultsAnalyser class >> processTypes: commonNamePart [

	| imageDir file typesDictionary byNames byBeginnings byEnds |
	imageDir := FileLocator imageDirectory.
	file := imageDir / commonNamePart , 'ston'.
	typesDictionary := file readStreamDo: [ :s |
		                   (TITRealTimeInferenceResultsSTONReader on: s)
			                   next ].

	byNames := self
		           processByNames: typesDictionary
		           to: 'ByNames' , commonNamePart.
	byBeginnings := self
		                processByNameParts: byNames
		                reversedBlock: #yourself
		                to: 'ByBeginnings' , commonNamePart.
	byEnds := self
		          processByNameParts: byNames
		          reversedBlock: #reversed
		          to: 'ByEndings' , commonNamePart.
	^ byNames
]

{ #category : 'private - transforming' }
TITRealTimeInferenceResultsAnalyser class >> save: aDictionaryOfTypes as: aFileName [

	| dictionaryOfTypes |
	dictionaryOfTypes := self sortedBySizes: aDictionaryOfTypes.
	dictionaryOfTypes do: [ :eachDictionaryOfSourcesByTypes |
			eachDictionaryOfSourcesByTypes do: [ :eachCollection |
				eachCollection sort: [ :a :b | a name < b name ] ] ].
	(aFileName asFileReference , 'ston')
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
