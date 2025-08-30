Class {
	#name : 'TITRealTimeInferenceResultsAnalyser',
	#superclass : 'TITRealTimeInferenceResultsProcessor',
	#category : 'TypeInfoTools-RealTimeGatherer-Processing',
	#package : 'TypeInfoTools-RealTimeGatherer',
	#tag : 'Processing'
}

{ #category : 'processing' }
TITRealTimeInferenceResultsAnalyser class >> createTypeTableFrom: refAndReceiverByTypesByKeys reversedBlock: aReversedBlock as: aFileName [

	| rootNodesByKeys |
	rootNodesByKeys := self createTypesWithOriginsForestFrom:
		                   refAndReceiverByTypesByKeys.
	self
		createTypeTableFromClassForest: rootNodesByKeys
		reversedBlock: aReversedBlock
		as: aFileName
]

{ #category : 'processing' }
TITRealTimeInferenceResultsAnalyser class >> createTypeTableFromClassForest: rootNodesByNames reversedBlock: aReversedBlock as: aFileName [

	| typeTable |
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
				writer writeHeader: { #Name. #Type. #Ratio. #Amount}.
				typeTable associations sorted do: [ :eachNameAndType |
							| nameKey typeName ratio sources |
							nameKey := eachNameAndType name.
							typeName := eachNameAndType value name.
							ratio := eachNameAndType value ratio asFloat
								         printShowingDecimalPlaces: 2.
							sources := eachNameAndType value allReferencingClasses size.
							writer nextPut: {
										nameKey.
										typeName.
										ratio.
										sources } ] ]
]

{ #category : 'processing' }
TITRealTimeInferenceResultsAnalyser class >> createTypesWithOriginsForestFrom: aDictionaryOfTypesWithRefAndReceiverClasses [

	| rootNodesByNames |
	rootNodesByNames := Dictionary new.

	aDictionaryOfTypesWithRefAndReceiverClasses keysAndValuesDo: [
			:eachKey
			:eachRefAndReceiverClassesByTypes |
			| rootNode |
			rootNode := TITAlternativeTreesRootNodeWithOrigins new.
			rootNodesByNames at: eachKey put: rootNode.
			eachRefAndReceiverClassesByTypes keysAndValuesDo: [
					:eachType
					:eachRefAndReceiverClasses |
					rootNode
						forType: eachType
						addRefAndReceiverClasses: eachRefAndReceiverClasses ] ].

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

	^ 30
]

{ #category : 'processing' }
TITRealTimeInferenceResultsAnalyser class >> processAll [

	<script>
	^ super processAll
]

{ #category : 'processing' }
TITRealTimeInferenceResultsAnalyser class >> processByNameParts: refAndReceiverByTypesByNames reversedBlock: aReversedBlock to: aFileName [

	| refAndReceiverByTypesByNameParts contributorsDictionary |
	refAndReceiverByTypesByNameParts := Dictionary empty.
	contributorsDictionary := Dictionary empty.
	refAndReceiverByTypesByNames keysAndValuesDo: [
			:eachEntireName
			:eachDictionaryOfRefAndReceverClassesByTypes |
			| parts |
			parts := aReversedBlock value:
				         eachEntireName splitSymbolsAndCamelCase.
			1 to: parts size do: [ :lastPartIndex |
					| nameKey dictionaryOfReferencingClassesByTypes |
					nameKey := Symbol streamContents: [ :stream |
							           (aReversedBlock value: (parts first: lastPartIndex))
								           do: [ :eachPart | stream << eachPart ] ].
					dictionaryOfReferencingClassesByTypes := refAndReceiverByTypesByNameParts
						                                         at: nameKey
						                                         ifAbsentPut:
						                                         Dictionary empty.
					(contributorsDictionary
						 at: nameKey
						 ifAbsentPut: SortedCollection new) add: eachEntireName.
					eachDictionaryOfRefAndReceverClassesByTypes keysAndValuesDo: [
							:eachType
							:eachRefAndReceiverClasses |
							(dictionaryOfReferencingClassesByTypes
								 at: eachType
								 ifAbsentPut: TITReferencingAndReceiverClassesSet new)
								addAll: eachRefAndReceiverClasses ] ] ].

	refAndReceiverByTypesByNameParts associations do: [ :eachAssoc |
			| nameKey dictionaryOfSourcesByTypes |
			nameKey := eachAssoc key.
			dictionaryOfSourcesByTypes := eachAssoc value.
			(contributorsDictionary at: nameKey) size = 1 ifTrue: [
				refAndReceiverByTypesByNameParts removeKey: nameKey ] ].

	self save: refAndReceiverByTypesByNameParts as: aFileName.
	self
		createTypeTableFrom: refAndReceiverByTypesByNameParts
		reversedBlock: aReversedBlock
		as: aFileName
]

{ #category : 'processing' }
TITRealTimeInferenceResultsAnalyser class >> processByNames: typesDictionary to: aFileName [

	| refAndReceiverByTypesByNames |
	refAndReceiverByTypesByNames := Dictionary empty.
	typesDictionary keysAndValuesDo: [
			:eachContentReference
			:eachTypeHolder |
			| types nameKey dictionaryOfRefAndReceiverClassesByTypes |
			types := eachTypeHolder types.
			types ifNotEmpty: [
					nameKey := self unifyName: eachContentReference name.
					dictionaryOfRefAndReceiverClassesByTypes := refAndReceiverByTypesByNames
						                                            at: nameKey
						                                            ifAbsentPut:
						                                            Dictionary empty.
					types do: [ :eachType |
							(dictionaryOfRefAndReceiverClassesByTypes
								 at: eachType
								 ifAbsentPut: TITReferencingAndReceiverClassesSet new)
								addReceiverClass: eachContentReference receiverClass
								referencingClass: eachContentReference referencingClass ] ] ].
	self save: refAndReceiverByTypesByNames as: aFileName.
	self
		createTypeTableFrom: refAndReceiverByTypesByNames
		reversedBlock: nil
		as: aFileName.
	^ refAndReceiverByTypesByNames
]

{ #category : 'processing' }
TITRealTimeInferenceResultsAnalyser class >> processRetTypes [

	<script>
	^ super processRetTypes
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
TITRealTimeInferenceResultsAnalyser class >> processVarTypes [

	<script>
	^ super processVarTypes
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
			parts := aReversedBlock value: eachName splitSymbolsAndCamelCase.
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
	dictionaryOfTypes do: [ :eachDictionaryOfReferencingClassesByTypes |
			eachDictionaryOfReferencingClassesByTypes do: [ :eachCollection |
				eachCollection sorted ] ].
	(aFileName asFileReference , 'ston')
		ensureDelete;
		writeStreamDo: [ :s |
				(STON writer on: s)
					prettyPrint: true;
					referencePolicy: #ignore;
					nextPut: dictionaryOfTypes ].
	^ dictionaryOfTypes
]

{ #category : 'private - transforming' }
TITRealTimeInferenceResultsAnalyser class >> sortedBySizes: aDictionaryOfHolder [

	^ (aDictionaryOfHolder associations sortedAs: [ :each | each key ])
		  asOrderedDictionary
]

{ #category : 'private - transforming' }
TITRealTimeInferenceResultsAnalyser class >> unifyName: aString [

	^ (TITNameHeuristicsTyperAdaptor simplifyName: aString) uncapitalized asSymbol
]
