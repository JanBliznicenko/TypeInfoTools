Class {
	#name : 'TITNameStatisticsRelativeTypeEntry',
	#superclass : 'TITNameStatisticsTypeEntry',
	#instVars : [
		'selector'
	],
	#category : 'TypeInfoTools-Core-NameStatistics',
	#package : 'TypeInfoTools-Core',
	#tag : 'NameStatistics'
}

{ #category : 'instance creation' }
TITNameStatisticsRelativeTypeEntry class >> fromRawString: aString ratio: aRatio amount: anAmount [

	^ self new
		  selector: aString allButFirst asSymbol;
		  ratio: aRatio;
		  amount: anAmount;
		  yourself
]

{ #category : 'testing' }
TITNameStatisticsRelativeTypeEntry >> isForNoneRelative: aBoolean [

	^ aBoolean not
]

{ #category : 'accessing' }
TITNameStatisticsRelativeTypeEntry >> selector: anObject [

	selector := anObject
]

{ #category : 'as yet unclassified' }
TITNameStatisticsRelativeTypeEntry >> typeForReceiverClass: aClass [

	(aClass respondsTo: selector) ifFalse: [
		TITEntryNotApplicable signal ].
	^ (Message selector: selector) sendTo: aClass
]
