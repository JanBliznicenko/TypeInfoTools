Class {
	#name : 'TITRealTimeInferenceResultsUnifier',
	#superclass : 'TITRealTimeInferenceResultsProcessor',
	#category : 'TypeInfoTools-RealTimeGatherer-Processing',
	#package : 'TypeInfoTools-RealTimeGatherer',
	#tag : 'Processing'
}

{ #category : 'processing' }
TITRealTimeInferenceResultsUnifier class >> processAll [

	<script>
	^ super processAll
]

{ #category : 'processing' }
TITRealTimeInferenceResultsUnifier class >> processTypes: commonNamePart [

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
					                   (TITRealTimeInferenceResultsSTONReader on: s)
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
TITRealTimeInferenceResultsUnifier class >> save: aDictionaryOfHolders as: aFileName [

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
TITRealTimeInferenceResultsUnifier class >> sorted: aDictionaryOfHolders [

	^ (aDictionaryOfHolders associations sortedAs: [ :each | each key ])
		  asOrderedDictionary
]
