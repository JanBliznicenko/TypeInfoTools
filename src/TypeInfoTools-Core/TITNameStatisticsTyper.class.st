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

{ #category : 'instance' }
TITNameStatisticsTyper class >> forReturnTypes [

	<script>
	^ forReturnTypes ifNil: [
		  forReturnTypes := self newFromFiles: 'RetTypes' ]
]

{ #category : 'instance' }
TITNameStatisticsTyper class >> forVariableTypes [
	<script>

	^ forVariableTypes ifNil: [ forVariableTypes := self newFromFiles: 'VarTypes' ]
]

{ #category : 'instance creation' }
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
TITNameStatisticsTyper >> at: aNameWithUnknownCapitalization withRelative: aBoolean ifAbsent: aBlock [

	| name split nodes |
	name := aNameWithUnknownCapitalization uncapitalized asSymbol.

	byNames at: name ifPresent: [ :result |
			result ifNotNil: [
				(result isForNoneRelative: aBoolean not) ifTrue: [ ^ { result } ] ] ].

	split := name splitSymbolsAndCamelCase.

	nodes := OrderedCollection new.

	1 to: split size do: [ :wordAmount |
			| beginningKey endingKey |
			beginningKey := (String streamContents: [ :s |
				                 (split first: wordAmount) do: [ :each |
					                 s nextPutAll: each ] ]) asSymbol.
			byBeginnings at: beginningKey ifPresent: [ :type |
				(type isForNoneRelative: aBoolean not) ifTrue: [ nodes add: type ] ].
			endingKey := (String streamContents: [ :s |
				              (split last: wordAmount) do: [ :each |
					              s nextPutAll: each ] ]) uncapitalized asSymbol.
			byEndings at: endingKey ifPresent: [ :type |
				(type isForNoneRelative: aBoolean not) ifTrue: [ nodes add: type ] ] ].

	^ nodes ifEmpty: aBlock
]

{ #category : 'initialization' }
TITNameStatisticsTyper >> initialize [

	super initialize.
	byNames := IdentityDictionary new.
	byBeginnings := IdentityDictionary new.
	byEndings := IdentityDictionary new
]

{ #category : 'initialization' }
TITNameStatisticsTyper >> loadFromFiles: aFileNameEnding [

	byNames := IdentityDictionary new.
	byBeginnings := IdentityDictionary new.
	byEndings := IdentityDictionary new.
	{
		('ByNames' -> [ :key :value | byNames at: key put: value ]).
		('ByBeginnings' -> [ :key :value | byBeginnings at: key put: value ]).
		('ByEndings' -> [ :key :value | byEndings at: key put: value ]) }
		do: [ :eachPair |
				| fileNameBeginning recordAddBlock |
				fileNameBeginning := eachPair key.
				recordAddBlock := eachPair value.
				(fileNameBeginning , '_' , aFileNameEnding , '.csv')
					asFileReference readStreamDo: [ :s |
						((NeoCSVReader on: s)
							 separator: $;;
							 readHeader;
							 yourself) do: [ :eachRecord |
								recordAddBlock
									value: eachRecord first asSymbol
									value: (TITNameStatisticsTypeEntry
											 fromRawString: eachRecord second
											 ratioString: eachRecord third
											 amountString: eachRecord fourth) ] ] ]
]
