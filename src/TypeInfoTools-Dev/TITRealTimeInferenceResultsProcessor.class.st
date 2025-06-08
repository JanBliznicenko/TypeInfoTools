Class {
	#name : 'TITRealTimeInferenceResultsProcessor',
	#superclass : 'Object',
	#category : 'TypeInfoTools-Dev-RealTime',
	#package : 'TypeInfoTools-Dev',
	#tag : 'RealTime'
}

{ #category : 'private - transforming' }
TITRealTimeInferenceResultsProcessor class >> byNameParts: aDictionaryOfHolder [

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
TITRealTimeInferenceResultsProcessor class >> processAll [

	<script>
	^ self
		  processRetTypes;
		  processVarTypes
]

{ #category : 'processing' }
TITRealTimeInferenceResultsProcessor class >> processRetTypes [

	<script>
	^ self processTypes: '_RetTypes.ston'
]

{ #category : 'processing' }
TITRealTimeInferenceResultsProcessor class >> processTypes: commonNamePart [

	| imageDir basename baselines files typesByProjects byNames byNameParts |
	imageDir := FileLocator imageDirectory.
	basename := imageDir basename.
	baselines := TITDependentPackagesFinder baselinesForInference.
	files := baselines collect: [ :each |
			         | projectName projectDir |
			         projectName := each name allButFirst: 10.
			         projectDir := imageDir parent
			                       / (basename , '_' , projectName).

			         projectDir / (projectName , commonNamePart) ].
	typesByProjects := files
		                   select: [ :each | each exists ]
		                   thenCollect: [ :each |
				                   each readStreamDo: [ :s |
					                   (TITRealTimeInferenceResultsSTONReader on: s)
						                   next ] ].
	byNames := Dictionary new.
	typesByProjects do: [ :eachDictionary |
			eachDictionary keysAndValuesDo: [
					:eachContentReference
					:eachTypeHolder |
					| unifiedName |
					unifiedName := self unifyName: eachContentReference name.
					byNames
						at: unifiedName
						ifPresent: [ :typeHolder |
							byNames at: unifiedName put: typeHolder , eachTypeHolder ]
						ifAbsentPut: eachTypeHolder ] ].
	byNameParts := self byNameParts: byNames.
	self save: byNameParts as: commonNamePart , '-byNameParts.ston'.
	^ self save: byNames as: commonNamePart , '-byNames.ston'
]

{ #category : 'processing' }
TITRealTimeInferenceResultsProcessor class >> processVarTypes [

	<script>
	^ self processTypes: '_VarTypes.ston'
]

{ #category : 'private - transforming' }
TITRealTimeInferenceResultsProcessor class >> save: aDictionaryOfTypes as: aFileName [

	| dictionaryOfTypes |
	dictionaryOfTypes := self sortedBySizes: aDictionaryOfTypes.
	aFileName asFileReference
		ensureDelete;
		writeStreamDo: [ :s | dictionaryOfTypes ].
	dictionaryOfTypes do: [ :each | each convertTypesToClass ].
	^ dictionaryOfTypes
]

{ #category : 'private - transforming' }
TITRealTimeInferenceResultsProcessor class >> sortedBySizes: aDictionaryOfHolder [

	^ (aDictionaryOfHolder associations sorted: [ :a :b |
			   a value size = b value size
				   ifTrue: [ a key < b key ]
				   ifFalse: [ a value size > b value size ] ]) asOrderedDictionary
]

{ #category : 'private - transforming' }
TITRealTimeInferenceResultsProcessor class >> unifyName: aString [

	| simplified |
	simplified := TITNameTyperAdaptor simplifyName: aString.
	simplified size = 1 ifTrue: [ ^ aString asLowercase asSymbol ].
	(simplified first isUppercase and: [ simplified second isLowercase ])
		ifTrue: [ ^ simplified uncapitalized asSymbol ].
	^ simplified asSymbol
]
