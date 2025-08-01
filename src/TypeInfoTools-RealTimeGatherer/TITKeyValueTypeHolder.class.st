Class {
	#name : 'TITKeyValueTypeHolder',
	#superclass : 'TITTypeHolder',
	#instVars : [
		'keyTypes',
		'valueTypes'
	],
	#category : 'TypeInfoTools-RealTimeGatherer-Structure',
	#package : 'TypeInfoTools-RealTimeGatherer',
	#tag : 'Structure'
}

{ #category : 'testing' }
TITKeyValueTypeHolder class >> acceptsClass: aClass [

	^ aClass includesBehavior: Association
]

{ #category : 'adding' }
TITKeyValueTypeHolder class >> allTypesCausingRecursion [

	<script: 'self allTypesCausingRecursion inspect'>
	^ self superclass allTypesCausingRecursion
	  , self typesCausingRecursion
]

{ #category : 'accessing' }
TITKeyValueTypeHolder class >> priority [

	^ 20
]

{ #category : 'copying' }
TITKeyValueTypeHolder >> , anotherHolder [

	^ anotherHolder copyWithKeyValueTypeHolder: self
]

{ #category : 'adding' }
TITKeyValueTypeHolder >> addValueUnchecked: aValue [

	super addValueUnchecked: aValue.
	(thisContext methodClass isCausingRecursion: aValue class) ifTrue: [ ^ self ].
	keyTypes := keyTypes withValue: aValue key.
	valueTypes := valueTypes withValue: aValue value
]

{ #category : 'adding' }
TITKeyValueTypeHolder >> copyWithKeyValueTypeHolder: anotherTypeHolder [

	^ (self copyWithTypeHolder: anotherTypeHolder)
		  keyTypes: keyTypes , anotherTypeHolder keyTypes;
		  valueTypes: valueTypes , anotherTypeHolder valueTypes;
		  yourself
]

{ #category : 'initialization' }
TITKeyValueTypeHolder >> initialize [

	super initialize.
	keyTypes := TITEmptyTypeHolder new.
	valueTypes := TITEmptyTypeHolder new
]

{ #category : 'accessing' }
TITKeyValueTypeHolder >> keyTypes [

	^ keyTypes
]

{ #category : 'accessing' }
TITKeyValueTypeHolder >> keyTypes: anObject [

	keyTypes := anObject
]

{ #category : 'private' }
TITKeyValueTypeHolder >> mergeTypes [

	super mergeTypes.
	keyTypes mergeTypes.
	valueTypes mergeTypes
]

{ #category : 'adding' }
TITKeyValueTypeHolder >> replaceFrom: anotherHolder [

	super replaceFrom: anotherHolder.
	keyTypes replaceFrom: anotherHolder keyTypes.
	valueTypes replaceFrom: anotherHolder valueTypes
]

{ #category : 'accessing' }
TITKeyValueTypeHolder >> valueTypes [

	^ valueTypes
]

{ #category : 'accessing' }
TITKeyValueTypeHolder >> valueTypes: anObject [

	valueTypes := anObject
]
