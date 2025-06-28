Class {
	#name : 'TITMetaLinksResultsProcessor',
	#superclass : 'Object',
	#category : 'TypeInfoTools-Dev-RealTime',
	#package : 'TypeInfoTools-Dev',
	#tag : 'RealTime'
}

{ #category : 'as yet unclassified' }
TITMetaLinksResultsProcessor class >> byNameParts: aDictionaryOfHolder [

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

{ #category : 'prcessing' }
TITMetaLinksResultsProcessor class >> processAll [

	<script>
	^ self
		  processRetTypes;
		  processVarTypes
]

{ #category : 'as yet unclassified' }
TITMetaLinksResultsProcessor class >> processRetTypes [

	<script>
	^ self processTypes: '_RetTypes.ston'
]

{ #category : 'as yet unclassified' }
TITMetaLinksResultsProcessor class >> processTypes: commonNamePart [

	| imageDir basename baselines files typesByProjects byNames byNameParts |
	imageDir := FileLocator imageDirectory.
	basename := imageDir basename.
	baselines := TITDependentPackagesFinder baselinesForTyping.
	files := baselines collect: [ :each |
			         | projectName projectDir |
			         projectName := each name allButFirst: 10.
			         projectDir := imageDir parent
			                       / (basename , '_' , projectName).

			         projectDir / (projectName , commonNamePart) ].
	typesByProjects := files
		                   select: [ :each | each exists ]
		                   thenCollect: [ :each |
		                   each readStreamDo: [ :s | STON fromStream: s ] ].
	byNames := Dictionary new.
	typesByProjects do: [ :eachDictionary |
			eachDictionary keysAndValuesDo: [ :eachName :eachTypes |
					name := self unifyName: eachName.
					byNames
						at: name
						ifPresent: [ :types | byNames at: name put: types , eachTypes ]
						ifAbsentPut: eachTypes ] ].
	byNameParts := self byNameParts: byNames.
	self save: byNameParts as: commonNamePart , '-byNameParts.ston'.
	^ self save: byNames as: commonNamePart , '-byNames.ston'
]

{ #category : 'as yet unclassified' }
TITMetaLinksResultsProcessor class >> processVarTypes [

	<script>
	^ self processTypes: '_VarTypes.ston'
]

{ #category : 'prcessing' }
TITMetaLinksResultsProcessor class >> save: aDictionaryOfTypes as: aFileName [

	| dictionaryOfTypes |
	dictionaryOfTypes := self sortedBySizes: aDictionaryOfTypes.
	aFileName asFileReference
		ensureDelete;
		writeStreamDo: [ :s | dictionaryOfTypes ].
	dictionaryOfTypes do: [ :each | each convertTypesToClass ].
	^ dictionaryOfTypes
]

{ #category : 'as yet unclassified' }
TITMetaLinksResultsProcessor class >> sortedBySizes: aDictionaryOfHolder [

	^ (aDictionaryOfHolder associations sorted: [ :a :b |
			   a value size = b value size
				   ifTrue: [ a key < b key ]
				   ifFalse: [ a value size > b value size ] ]) asOrderedDictionary
]

{ #category : 'as yet unclassified' }
TITMetaLinksResultsProcessor class >> unifyName: aString [

	| simplified |
	simplified := TITNameTyperAdaptor simplifyName: aString.
	simplified size = 1 ifTrue: [ ^ aString asLowercase asSymbol ].
	(simplified first isUppercase and: [ simplified second isLowercase ])
		ifTrue: [ ^ simplified uncapitalized asSymbol ].
	^ simplified asSymbol
]
