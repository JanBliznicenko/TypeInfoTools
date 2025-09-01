Class {
	#name : 'TITNameStatisticsSpecificTypeEntry',
	#superclass : 'TITNameStatisticsTypeEntry',
	#instVars : [
		'className'
	],
	#category : 'TypeInfoTools-Core-NameStatistics',
	#package : 'TypeInfoTools-Core',
	#tag : 'NameStatistics'
}

{ #category : 'instance creation' }
TITNameStatisticsSpecificTypeEntry class >> fromRawString: aString ratio: aRatio amount: anAmount [

	^ self new
		  className: aString asSymbol;
		  ratio: aRatio;
		  amount: anAmount;
		  yourself
]

{ #category : 'accessing' }
TITNameStatisticsSpecificTypeEntry >> className: anObject [

	className := anObject
]

{ #category : 'as yet unclassified' }
TITNameStatisticsSpecificTypeEntry >> typeForReceiverClass: anObject [

	^ (self class environment classOrTraitNamed: className) ifNil: [
		  TITEntryNotApplicable signal ]
]
