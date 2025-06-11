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

{ #category : 'as yet unclassified' }
TITMetaLinksResultsProcessor class >> processRetTypes [

	<script>
	^ self processTypes: '_RetTypes.ston'
]

{ #category : 'as yet unclassified' }
TITMetaLinksResultsProcessor class >> processTypes: commonNamePart [

	| imageDir basename baselines files typesByProjects mergedDictionary |
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
	mergedDictionary := Dictionary new.
	typesByProjects do: [ :eachDictionary |
			eachDictionary keysAndValuesDo: [ :eachName :eachTypes |
					name := self unifyName: eachName.
					mergedDictionary
						at: name
						ifPresent: [ :types |
						mergedDictionary at: name put: types , eachTypes ]
						ifAbsentPut: eachTypes convertTypesToClass ] ].
	(self sortedBySizes: (self byNameParts: mergedDictionary)) inspect.
	^ (self sortedBySizes: mergedDictionary) inspect
]

{ #category : 'as yet unclassified' }
TITMetaLinksResultsProcessor class >> processVarTypes [

	<script>
	^ self processTypes: '_VarTypes.ston'
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
