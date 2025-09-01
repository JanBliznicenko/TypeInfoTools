Class {
	#name : 'TITRunTimeInferenceResultsBehavior',
	#superclass : 'Object',
	#instVars : [
		'name'
	],
	#category : 'TypeInfoTools-RunTimeGatherer-Structure',
	#package : 'TypeInfoTools-RunTimeGatherer',
	#tag : 'Structure'
}

{ #category : 'as yet unclassified' }
TITRunTimeInferenceResultsBehavior class >> forSystemClass: aClass [

	^ (self forSystemMetaclass: aClass class) named: aClass name asSymbol
]

{ #category : 'as yet unclassified' }
TITRunTimeInferenceResultsBehavior class >> forSystemMetaclass: aClass [

	(aClass includesBehavior: Behavior) ifFalse: [ ^ aClass ].

	(aClass includesBehavior: Metaclass) ifTrue: [
		^ TITRunTimeInferenceResultsMetaclass forSystemMetaclass: aClass ].

	^ TITRunTimeInferenceResultsClass forSystemMetaclass: aClass
]

{ #category : 'instance creation' }
TITRunTimeInferenceResultsBehavior class >> fromSton: stonReader [

	| theClassName |
	theClassName := stonReader parseListSingleton.
	^ self class environment
		  at: theClassName
		  ifPresent: [ :systemClass | self systemClassFrom: systemClass ]
		  ifAbsent: [ self named: theClassName ]
]

{ #category : 'instance creation' }
TITRunTimeInferenceResultsBehavior class >> named: theClassName [

	^ self new
		  name: theClassName;
		  yourself
]

{ #category : 'accessing' }
TITRunTimeInferenceResultsBehavior class >> systemClass [

	^ Behavior
]

{ #category : 'instance creation' }
TITRunTimeInferenceResultsBehavior class >> systemClassFrom: systemClass [

	^ systemClass
]

{ #category : 'comparing' }
TITRunTimeInferenceResultsBehavior >> = aComparable [

	^ self class = aComparable class and: [ name = aComparable name ]
]

{ #category : 'comparing' }
TITRunTimeInferenceResultsBehavior >> hash [

	^ self class hash bitXor: name hash
]

{ #category : 'testing' }
TITRunTimeInferenceResultsBehavior >> isMeta [

	^ false
]

{ #category : 'accessing' }
TITRunTimeInferenceResultsBehavior >> name [

	^ name
]

{ #category : 'accessing' }
TITRunTimeInferenceResultsBehavior >> name: aString [

	name := aString
]

{ #category : 'ston persistence' }
TITRunTimeInferenceResultsBehavior >> stonOn: stonWriter [

	stonWriter
		writeObject: self systemMetaclass
		listSingleton: self name asSymbol
]

{ #category : 'accessing' }
TITRunTimeInferenceResultsBehavior >> systemClassIfAbsent: aBlock [

	^ (self class environment classNamed: self name asSymbol) ifNil:
		  aBlock
]

{ #category : 'accessing' }
TITRunTimeInferenceResultsBehavior >> systemMetaclass [
	^ self class systemClass
]

{ #category : 'accessing - class hierarchy' }
TITRunTimeInferenceResultsBehavior >> withAllSuperclasses [

	^ { self }
]
