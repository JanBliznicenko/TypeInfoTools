Class {
	#name : 'TITRealTimeInferenceResultsBehavior',
	#superclass : 'Object',
	#instVars : [
		'name'
	],
	#category : 'TypeInfoTools-RealTimeGatherer-Structure',
	#package : 'TypeInfoTools-RealTimeGatherer',
	#tag : 'Structure'
}

{ #category : 'instance creation' }
TITRealTimeInferenceResultsBehavior class >> fromSton: stonReader [

	| theClassName |
	theClassName := stonReader parseListSingleton.
	^ self class environment
		  at: theClassName
		  ifPresent: [ :systemClass | self systemClassFrom: systemClass ]
		  ifAbsent: [ self named: theClassName ]
]

{ #category : 'instance creation' }
TITRealTimeInferenceResultsBehavior class >> named: theClassName [

	^ self new
		  name: theClassName;
		  yourself
]

{ #category : 'accessing' }
TITRealTimeInferenceResultsBehavior class >> systemClass [

	^ Behavior
]

{ #category : 'instance creation' }
TITRealTimeInferenceResultsBehavior class >> systemClassFrom: systemClass [

	^ systemClass
]

{ #category : 'comparing' }
TITRealTimeInferenceResultsBehavior >> = aComparable [

	^ self class = aComparable class and: [ name = aComparable name ]
]

{ #category : 'comparing' }
TITRealTimeInferenceResultsBehavior >> hash [

	^ self class hash bitXor: name hash
]

{ #category : 'accessing' }
TITRealTimeInferenceResultsBehavior >> name [

	^ name
]

{ #category : 'accessing' }
TITRealTimeInferenceResultsBehavior >> name: aString [

	name := aString
]

{ #category : 'ston persistence' }
TITRealTimeInferenceResultsBehavior >> stonOn: stonWriter [

	stonWriter
		writeObject: self systemClass
		listSingleton: self name asSymbol
]

{ #category : 'accessing' }
TITRealTimeInferenceResultsBehavior >> systemClass [
	^ self class systemClass
]
