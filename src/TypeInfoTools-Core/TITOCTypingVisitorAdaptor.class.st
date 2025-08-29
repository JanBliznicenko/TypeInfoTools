Class {
	#name : 'TITOCTypingVisitorAdaptor',
	#superclass : 'TITStructureNodeTypeCollector',
	#instVars : [
		'typingVisitor',
		'visitors'
	],
	#category : 'TypeInfoTools-Core-Inference',
	#package : 'TypeInfoTools-Core',
	#tag : 'Inference'
}

{ #category : 'accessing' }
TITOCTypingVisitorAdaptor class >> sourceName [

	^ 'OCTypingVisitor'
]

{ #category : 'private' }
TITOCTypingVisitorAdaptor >> classesWithSlotsFor: aClass [

	aClass = Object ifTrue: [ ^ #(  ) ].
	aClass ifNil: [ ^ #(  ) ].
	(self classesWithSlotsFor: aClass superclass) ifNotEmpty: [
		:superclasses | ^ superclasses copyWith: aClass ].
	aClass slots ifEmpty: [ ^ #(  ) ].
	^ { aClass }
]

{ #category : 'private' }
TITOCTypingVisitorAdaptor >> createVisitorForClass: aClass [

	| visitor classes |
	visitor := OCTypingVisitor new.
	classes := (self classesWithSlotsFor: aClass) asSet.
	classes add: aClass.
	classes do: [ :eachClass |
		eachClass methodsDo: [ :eachMethod | visitor visit: eachMethod ast ] ].
	^ visitor
]

{ #category : 'initialization' }
TITOCTypingVisitorAdaptor >> initialize [

	super initialize.
	visitors := Dictionary new
]

{ #category : 'private' }
TITOCTypingVisitorAdaptor >> typeOf: aTITNode [

	aTITNode ocProgramNode ifNil: [ ^ self ].
	^ (self visitorOf: aTITNode realClass) visit: aTITNode ocProgramNode
]

{ #category : 'accessing' }
TITOCTypingVisitorAdaptor >> typingVisitor [

	^ typingVisitor ifNil: [ typingVisitor := OCTypingVisitor new ]
]

{ #category : 'visiting' }
TITOCTypingVisitorAdaptor >> visitInstanceVariable: aVariable [

	^ self typeOf: aVariable
]

{ #category : 'visiting' }
TITOCTypingVisitorAdaptor >> visitMessageSend: aMessageSend [

	^ self typeOf: aMessageSend
]

{ #category : 'visiting' }
TITOCTypingVisitorAdaptor >> visitMethod: aMethod [

	^ self typeOf: aMethod
]

{ #category : 'visiting' }
TITOCTypingVisitorAdaptor >> visitMethodInputParameter: aMethodTemp [

	^ self typeOf: aMethodTemp
]

{ #category : 'visiting' }
TITOCTypingVisitorAdaptor >> visitTemporaryVariable: aVariable [

	^ self typeOf: aVariable
]

{ #category : 'private' }
TITOCTypingVisitorAdaptor >> visitorOf: aClass [

	^ visitors
		  at: aClass
		  ifAbsentPut: [ self createVisitorForClass: aClass ]
]

{ #category : 'accessing' }
TITOCTypingVisitorAdaptor >> weight [

	^ 2
]
