Class {
	#name : 'TITTypeHolder',
	#superclass : 'Object',
	#instVars : [
		'type'
	],
	#category : 'TypeInfoTools-Core-RealTime',
	#package : 'TypeInfoTools-Core',
	#tag : 'RealTime'
}

{ #category : 'testing' }
TITTypeHolder class >> acceptsClass: aClass [

	^ true
]

{ #category : 'instance creation' }
TITTypeHolder class >> newForValue: anObject [

	^ self new fillFromValue: anObject
]

{ #category : 'converting' }
TITTypeHolder >> asString [

	^ String streamContents: [ :s | self asStringOn: s ]
]

{ #category : 'converting' }
TITTypeHolder >> asStringOn: aStream [

	self type printOn: aStream
]

{ #category : 'accessing' }
TITTypeHolder >> fillFromValue: anObject [

	type := anObject class
]

{ #category : 'printing' }
TITTypeHolder >> printOn: aStream [

	super printOn: aStream.
	aStream nextPutAll: ' ('.
	self asStringOn: aStream.
	aStream nextPut: $)
]

{ #category : 'accessing' }
TITTypeHolder >> type [

	^ type
]

{ #category : 'accessing' }
TITTypeHolder >> type: aClass [

	type := aClass
]
