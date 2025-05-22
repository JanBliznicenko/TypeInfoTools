Class {
	#name : 'TITMyClass',
	#superclass : 'Object',
	#instVars : [
		'myVar'
	],
	#category : 'TITMyClass',
	#package : 'TITMyClass'
}

{ #category : 'examples' }
TITMyClass class >> example [

	self new
		myMethod1;
		myMethod2
]

{ #category : 'as yet unclassified' }
TITMyClass >> myMethod1 [

	myVar := 1.
	self myMethodWithParameter: myVar.
	^ myVar
]

{ #category : 'as yet unclassified' }
TITMyClass >> myMethod2 [

	| myTemp2 |
	myTemp2 := true not.
	myTemp2 not.
	self myMethodWithParameter: myTemp2
]

{ #category : 'as yet unclassified' }
TITMyClass >> myMethodWithParameter: aParameter [

	aParameter asString
]
