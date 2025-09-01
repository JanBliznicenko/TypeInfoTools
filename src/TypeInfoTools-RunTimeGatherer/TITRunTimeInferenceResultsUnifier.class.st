Class {
	#name : 'TITRunTimeInferenceResultsUnifier',
	#superclass : 'TITRunTimeInferenceResultsProcessor',
	#category : 'TypeInfoTools-RunTimeGatherer-Processing',
	#package : 'TypeInfoTools-RunTimeGatherer',
	#tag : 'Processing'
}

{ #category : 'processing' }
TITRunTimeInferenceResultsUnifier class >> processAll [

	<script>
	^ super processAll
]

{ #category : 'processing' }
TITRunTimeInferenceResultsUnifier class >> processTypes: commonNamePart [

	| imageDir basename baselines files typesByProjects unified |
	imageDir := FileLocator imageDirectory.
	basename := imageDir basename.
	baselines := TITDependentPackagesFinder baselinesForInference.
	files := baselines collect: [ :each |
			         | projectName projectDir |
			         projectName := each name allButFirst: 10.
			         projectDir := imageDir parent
			                       / (basename , '_' , projectName).

			         projectDir / (projectName , commonNamePart , '.ston') ].
	typesByProjects := files
		                   select: [ :each | each exists ]
		                   thenCollect: [ :each |
				                   each readStreamDo: [ :s |
					                   (TITRunTimeInferenceResultsSTONReader on: s)
						                   next ] ].
	unified := Dictionary new.
	typesByProjects do: [ :eachDictionary |
			eachDictionary keysAndValuesDo: [
					:eachContentReference
					:eachTypeHolder |
					unified
						at: eachContentReference
						ifPresent: [ :typeHolder |
							unified
								at: eachContentReference
								put: typeHolder , eachTypeHolder ]
						ifAbsentPut: eachTypeHolder ] ].
	^ self save: unified as: commonNamePart
]

{ #category : 'private - transforming' }
TITRunTimeInferenceResultsUnifier class >> save: aDictionaryOfHolders as: aFileName [

	| sortedDictionary |
	sortedDictionary := self sorted: aDictionaryOfHolders.
	(aFileName asFileReference , 'ston')
		ensureDelete;
		writeStreamDo: [ :s | 
			(STON writer on: s)
		prettyPrint: true;
		referencePolicy: #ignore;
		nextPut: sortedDictionary ].
	^ sortedDictionary
]

{ #category : 'private - transforming' }
TITRunTimeInferenceResultsUnifier class >> sorted: aDictionaryOfHolders [

	^ (aDictionaryOfHolders associations sortedAs: [ :each | each key ])
		  asOrderedDictionary
]
