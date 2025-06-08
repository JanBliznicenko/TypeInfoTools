Class {
	#name : 'TITRealTimeInferenceResultsBehavior',
	#superclass : 'Object',
	#instVars : [
		'name'
	],
	#category : 'TypeInfoTools-Dev-RealTime',
	#package : 'TypeInfoTools-Dev',
	#tag : 'RealTime'
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
