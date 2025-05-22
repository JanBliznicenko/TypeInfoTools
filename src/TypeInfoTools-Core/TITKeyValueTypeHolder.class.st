Class {
	#name : 'TITKeyValueTypeHolder',
	#superclass : 'TITTypeHolder',
	#instVars : [
		'keyTypes',
		'valueTypes'
	],
	#category : 'TypeInfoTools-Core-RealTime',
	#package : 'TypeInfoTools-Core',
	#tag : 'RealTime'
}

{ #category : 'testing' }
TITKeyValueTypeHolder class >> acceptsClass: aClass [

	^ aClass includesBehavior: Association
]

{ #category : 'copying' }
TITKeyValueTypeHolder >> , anotherHolder [

	^ anotherHolder copyWithKeyValueTypeHolder: self
]

{ #category : 'adding' }
TITKeyValueTypeHolder >> addValue: aValue [

	super addValue: aValue.
	keyTypes := keyTypes withValue: aValue.
	valueTypes := valueTypes withValue: aValue
]

{ #category : 'converting' }
TITKeyValueTypeHolder >> convertTypesToString [

	super convertTypesToString.
	keyTypes convertTypesToString.
	valueTypes convertTypesToString
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
