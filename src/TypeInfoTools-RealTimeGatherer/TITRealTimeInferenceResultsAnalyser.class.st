Class {
	#name : 'TITRealTimeInferenceResultsAnalyser',
	#superclass : 'TITRealTimeInferenceResultsProcessor',
	#category : 'TypeInfoTools-RealTimeGatherer-Processing',
	#package : 'TypeInfoTools-RealTimeGatherer',
	#tag : 'Processing'
}

{ #category : 'processing' }
TITRealTimeInferenceResultsAnalyser class >> createTypeTableFrom: aDictionaryOfTypesWithOrigins reversedBlock: aReversedBlock as: aFileName [

	| rootNodesByNames |
	rootNodesByNames := self createTypesWithOriginsForestFrom:
		                    aDictionaryOfTypesWithOrigins.
	^ self
		  createTypeTableFromClassForest: rootNodesByNames
		  reversedBlock: aReversedBlock
		  as: aFileName
]

{ #category : 'processing' }
TITRealTimeInferenceResultsAnalyser class >> createTypeTableFromClassForest: rootNodesByNames reversedBlock: aReversedBlock as: aFileName [

	| typeTable new |
	new := (rootNodesByNames at: #New).
	self halt.
	typeTable := rootNodesByNames
		             collect: [ :eachRootNode |
		             eachRootNode mostPreciseNode ]
		             thenReject: [ :any | any isNil ].
	self
		removeUnneccessarilyLongKeysFrom: typeTable
		reversedBlock: aReversedBlock.
	(aFileName asFileReference , 'csv')
		ensureDelete;
		writeStreamDo: [ :stream |
				| writer |
				writer := NeoCSVWriter on: stream.
				writer separator: self csvSeparator.
				writer writeHeader: { #Name. #Type }.
				typeTable associations sorted do: [ :eachNameAndType |
							| nameKey typeName ratio sources |
							nameKey := eachNameAndType name.
							typeName := eachNameAndType value name.
							ratio := eachNameAndType value ratio asFloat
								         printShowingDecimalPlaces: 2.
							sources := eachNameAndType value allOrigins size.
							writer nextPut: {
										nameKey.
										typeName.
										ratio.
										sources } ] ]
]

{ #category : 'processing' }
TITRealTimeInferenceResultsAnalyser class >> createTypesWithOriginsForestFrom: aDictionaryOfTypesWithOrigins [

	| rootNodesByNames |
	rootNodesByNames := Dictionary new.

	aDictionaryOfTypesWithOrigins keysAndValuesDo: [
			:eachKey
			:eachOriginsCollectionsByTypes |
			| rootNode |
			rootNode := TITAlternativeTreesRootNodeWithOrigins new.
			rootNodesByNames at: eachKey put: rootNode.
			eachOriginsCollectionsByTypes keysAndValuesDo: [
				:eachType
				:eachOriginsCollections |
				rootNode forType: eachType addOrigins: eachOriginsCollections ] ].

	^ rootNodesByNames
]

{ #category : 'processing' }
TITRealTimeInferenceResultsAnalyser class >> csvSeparator [

	^ $;
]

{ #category : 'accessing' }
TITRealTimeInferenceResultsAnalyser class >> minimumAcceptableTypeRatio [
	"ratio of type occurences encompassed by a single type in order to be accepted as valid type for the var/method"

	^ 0.8
]

{ #category : 'accessing' }
TITRealTimeInferenceResultsAnalyser class >> minimumAcceptableTypeUsagesAmount [
	"amount of type occurences encompassed by a single type in order to be accepted as valid type for the var/method"

	^ 10
]

{ #category : 'processing' }
TITRealTimeInferenceResultsAnalyser class >> processAll [

	<script>
	^ super processAll
]

{ #category : 'processing' }
TITRealTimeInferenceResultsAnalyser class >> processByNameParts: dictionaryByNames reversedBlock: aReversedBlock to: aFileName [

	| resultingDictionary contributorsDictionary |
	resultingDictionary := Dictionary empty.
	contributorsDictionary := Dictionary empty.
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
					(contributorsDictionary
						 at: nameKey
						 ifAbsentPut: SortedCollection new) add: eachEntireName.
					eachSourceDictionaryOfSourcesByTypes keysAndValuesDo: [
							:eachType
							:eachSourceClassesCollection |
							(dictionaryOfSourcesByTypes
								 at: eachType
								 ifAbsentPut: OrderedCollection empty) addAll:
								eachSourceClassesCollection ] ] ].
	resultingDictionary associations do: [ :eachAssoc |
			| nameKey dictionaryOfSourcesByTypes |
			nameKey := eachAssoc key.
			dictionaryOfSourcesByTypes := eachAssoc value.
			(contributorsDictionary at: nameKey) size = 1 ifTrue: [
				resultingDictionary removeKey: nameKey ] ].
	self save: resultingDictionary as: aFileName.
	self
		createTypeTableFrom: resultingDictionary
		reversedBlock: aReversedBlock
		as: aFileName
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
	self createTypeTableFrom: resultingDictionary reversedBlock: nil as: aFileName.
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

{ #category : 'processing' }
TITRealTimeInferenceResultsAnalyser class >> removeUnneccessarilyLongKeysFrom: typeTable reversedBlock: aReversedBlock [

	| nameKeyBlock |
	aReversedBlock ifNil: [ ^ self "no removing needed" ].
	nameKeyBlock := [ :parts :size |
		                Symbol streamContents: [ :stream |
				                (aReversedBlock value: (parts first: size)) do: [
					                :eachPart | stream << eachPart ] ] ].
	typeTable associations do: [ :eachAssoc |
			| eachName eachNode parts |
			eachName := eachAssoc key.
			eachNode := eachAssoc value.
			parts := aReversedBlock value: eachName splitCamelCase.
			((1 to: parts size - 1) anySatisfy: [ :eachPartsLength |
					 | shorterNameKey |
					 shorterNameKey := nameKeyBlock
						                   value: parts
						                   value: eachPartsLength.
					 typeTable
						 at: shorterNameKey
						 ifPresent: [ :shorterTypeNode | shorterTypeNode = eachNode ]
						 ifAbsent: [ false ] ]) ifTrue: [ typeTable removeKey: eachName ] ]
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
	simplified first isLowercase ifTrue: [
		^ simplified capitalized asSymbol ].
	^ simplified asSymbol
]
