Class {
	#name : 'TITNameStatisticsTypeEntry',
	#superclass : 'Object',
	#instVars : [
		'ratio',
		'amount'
	],
	#category : 'TypeInfoTools-Core-NameStatistics',
	#package : 'TypeInfoTools-Core',
	#tag : 'NameStatistics'
}

{ #category : 'instance creation' }
TITNameStatisticsTypeEntry class >> fromRawString: aString ratio: aRatio amount: anAmount [

	^ self subclassResponsibility
]

{ #category : 'instance creation' }
TITNameStatisticsTypeEntry class >> fromRawString: aString ratioString: aRatioString amountString: anAmountString [

	| ratio amount |
	ratio := aRatioString asNumber.
	ratio < 0.5 ifTrue: [ self error: 'Invalid ratio' ].
	ratio > 1 ifTrue: [ self error: 'Invalid ratio' ].
	amount := anAmountString asNumber.
	amount < 1 ifTrue: [ self error: 'Invalid amount' ].
	aString first isUppercase ifTrue: [
			^ TITNameStatisticsSpecificTypeEntry
				  fromRawString: aString
				  ratio: ratio
				  amount: amount ].
	aString first = $# ifTrue: [
			^ TITNameStatisticsRelativeTypeEntry
				  fromRawString: aString
				  ratio: ratio
				  amount: amount ].
	self error: 'Unknown string type encountered'
]

{ #category : 'accessing' }
TITNameStatisticsTypeEntry >> amount [

	^ amount
]

{ #category : 'accessing' }
TITNameStatisticsTypeEntry >> amount: anObject [

	amount := anObject
]

{ #category : 'accessing' }
TITNameStatisticsTypeEntry >> ratio [

	^ ratio
]

{ #category : 'accessing' }
TITNameStatisticsTypeEntry >> ratio: anObject [

	ratio := anObject
]

{ #category : 'as yet unclassified' }
TITNameStatisticsTypeEntry >> typeForReceiverClass: anObject [

	^ self subclassResponsibility
]
