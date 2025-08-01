Class {
	#name : 'TITDictionaryTypeHolder',
	#superclass : 'TITCollectionTypeHolder',
	#instVars : [
		'keyTypes'
	],
	#category : 'TypeInfoTools-RealTimeGatherer-Structure',
	#package : 'TypeInfoTools-RealTimeGatherer',
	#tag : 'Structure'
}

{ #category : 'testing' }
TITDictionaryTypeHolder class >> acceptsClass: aClass [

	^ aClass = Dictionary or: [
		  aClass = OrderedDictionary or: [ aClass = SmallDictionary ] ]
]

{ #category : 'adding' }
TITDictionaryTypeHolder class >> allTypesCausingRecursion [

	<script: 'self allTypesCausingRecursion inspect'>
	^ self superclass allTypesCausingRecursion
	  , self typesCausingRecursion
]

{ #category : 'accessing' }
TITDictionaryTypeHolder class >> priority [

	^ 30
]

{ #category : 'copying' }
TITDictionaryTypeHolder >> , anotherHolder [

	^ anotherHolder copyWithDictionaryTypeHolder: self
]

{ #category : 'adding' }
TITDictionaryTypeHolder >> addValueUnchecked: aValue [

	super addValueUnchecked: aValue.
	(thisContext methodClass isCausingRecursion: aValue class) ifTrue: [ ^ self ].
	aValue keysDo: [ :eachKey | ^ keyTypes := keyTypes withValue: eachKey ]
]

{ #category : 'adding' }
TITDictionaryTypeHolder >> copyWithDictionaryTypeHolder: anotherTypeHolder [

	^ (self copyWithCollectionHolder: anotherTypeHolder)
		  keyTypes: keyTypes , anotherTypeHolder keyTypes;
		  yourself
]

{ #category : 'initialization' }
TITDictionaryTypeHolder >> initialize [

	super initialize.
	keyTypes := TITEmptyTypeHolder new
]

{ #category : 'accessing' }
TITDictionaryTypeHolder >> keyTypes [

	^ keyTypes
]

{ #category : 'accessing' }
TITDictionaryTypeHolder >> keyTypes: anObject [

	keyTypes := anObject
]

{ #category : 'private' }
TITDictionaryTypeHolder >> mergeTypes [

	super mergeTypes.
	keyTypes mergeTypes
]

{ #category : 'adding' }
TITDictionaryTypeHolder >> replaceFrom: anotherHolder [

	super replaceFrom: anotherHolder.
	keyTypes replaceFrom: anotherHolder keyTypes
]
