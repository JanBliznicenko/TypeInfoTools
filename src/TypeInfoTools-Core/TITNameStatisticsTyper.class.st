Class {
	#name : 'TITNameStatisticsTyper',
	#superclass : 'Object',
	#instVars : [
		'byNames',
		'byBeginnings',
		'byEndings'
	],
	#classInstVars : [
		'forReturnTypes',
		'forVariableTypes'
	],
	#category : 'TypeInfoTools-Core-NameStatistics',
	#package : 'TypeInfoTools-Core',
	#tag : 'NameStatistics'
}

{ #category : 'as yet unclassified' }
TITNameStatisticsTyper class >> forReturnTypes [

	<script>
	^ forReturnTypes ifNil: [
		  forReturnTypes := self newFromFiles: 'RetTypes' ]
]

{ #category : 'as yet unclassified' }
TITNameStatisticsTyper class >> forVariableTypes [
	<script>

	^ forVariableTypes ifNil: [ forVariableTypes := self newFromFiles: 'VarTypes' ]
]

{ #category : 'as yet unclassified' }
TITNameStatisticsTyper class >> newFromFiles: aFileNameEnding [

	^ self new
		  loadFromFiles: aFileNameEnding;
		  yourself
]

{ #category : 'initialization' }
TITNameStatisticsTyper class >> reset [

	<script>
	forReturnTypes := nil.
	forVariableTypes := nil
]

{ #category : 'accessing' }
TITNameStatisticsTyper >> at: aName ifAbsent: aBlock [

	| resultByBeginning resultByEnding |
	byNames at: aName ifPresent: [ :result | ^ result ].
	resultByBeginning := byBeginnings
		                     at: aName
		                     ifAbsent: [
		                     ^ byEndings at: aName ifAbsent: aBlock ].
	resultByEnding := byEndings
		                  at: aName
		                  ifAbsent: [ ^ resultByBeginning ].
	resultByEnding ratio ** 10 * resultByEnding amount
	> (resultByBeginning ratio ** 10 * resultByBeginning amount) ifTrue: [
		^ resultByEnding ].
	^ resultByBeginning
]

{ #category : 'initialization' }
TITNameStatisticsTyper >> initialize [

	super initialize.
	byNames := IdentityDictionary new.
	byBeginnings := IdentityDictionary new.
	byEndings := IdentityDictionary new
]

{ #category : 'as yet unclassified' }
TITNameStatisticsTyper >> loadFromFiles: aFileNameEnding [

	byNames := IdentityDictionary new.
	byBeginnings := IdentityDictionary new.
	byEndings := IdentityDictionary new.
	{
		('ByNames' -> [ :key :value | byNames at: key put: value ]).
		('ByBeginnings' -> [ :key :value | byBeginnings at: key put: value ]).
		('ByEndings' -> [ :key :value | byEndings at: key put: value ]) }
		do: [ :eachPair |
				(eachPair key , '_' , aFileNameEnding , '.csv') asFileReference
					readStreamDo: [ :s |
							s nextLine.
							s upToEnd lines allButFirstDo: [ :eachLine |
									| items |
									items := eachLine splitOn: $;.
									eachPair value
										value: items first asSymbol
										value: (TITNameStatisticsTypeEntry
												 fromRawString: items second
												 ratioString: items third
												 amountString: items fourth) ] ] ]
]
