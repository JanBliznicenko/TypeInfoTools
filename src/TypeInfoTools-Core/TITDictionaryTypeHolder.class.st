Class {
	#name : 'TITDictionaryTypeHolder',
	#superclass : 'TITCollectionTypeHolder',
	#instVars : [
		'keyTypes'
	],
	#category : 'TypeInfoTools-Core-RealTime',
	#package : 'TypeInfoTools-Core',
	#tag : 'RealTime'
}

{ #category : 'testing' }
TITDictionaryTypeHolder class >> acceptsClass: aClass [

	^ aClass = Dictionary or: [
		  aClass = OrderedDictionary or: [ aClass = SmallDictionary ] ]
]

{ #category : 'adding' }
TITDictionaryTypeHolder >> addValue: aValue [

	super addValue: aValue.
	aValue keysDo: [ :eachKey | ^ keyTypes := keyTypes withValue: eachKey ]
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

{ #category : 'adding' }
TITDictionaryTypeHolder >> replaceFrom: anotherHolder [

	super replaceFrom: anotherHolder.
	keyTypes replaceFrom: anotherHolder keyTypes
]
