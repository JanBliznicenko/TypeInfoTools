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

{ #category : 'adding' }
TITKeyValueTypeHolder >> addValue: aValue [

	super addValue: aValue.
	keyTypes := keyTypes withValue: aValue.
	valueTypes := valueTypes withValue: aValue
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
