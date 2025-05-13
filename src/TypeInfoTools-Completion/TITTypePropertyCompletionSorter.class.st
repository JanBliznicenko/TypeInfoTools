Class {
	#name : 'TITTypePropertyCompletionSorter',
	#superclass : 'CompletionSorter',
	#instVars : [
		'originalCompletionSorter'
	],
	#category : 'TypeInfoTools-Completion',
	#package : 'TypeInfoTools-Completion'
}

{ #category : 'accessing' }
TITTypePropertyCompletionSorter >> originalCompletionSorter [

	^ originalCompletionSorter ifNil: [
		  originalCompletionSorter := CompletionContext sorterClass new ]
]

{ #category : 'sorting' }
TITTypePropertyCompletionSorter >> sortCompletionList: aList [

	| sourceNode type typeWithSuperclasses leastImportantPriority byPriority |
	aList ifEmpty: [ ^ aList ].

	sourceNode := aList anyOne node.

	sourceNode isMessage ifFalse: [
			self halt.
			^ self originalCompletionSorter sortCompletionList: aList ].
	type := sourceNode receiver
		        propertyAt: #type
		        ifAbsent: [
		        ^ self originalCompletionSorter sortCompletionList: aList ].
	typeWithSuperclasses := type withAllSuperclasses.

	leastImportantPriority := typeWithSuperclasses size + 1.
	byPriority := aList groupedBy: [ :eachListItem |
			              typeWithSuperclasses
				              detectIndex: [ :class |
				              class includesSelector: eachListItem contents ]
				              ifNone: [ leastImportantPriority ] ].

	^ (1 to: leastImportantPriority) flatCollect: [ :eachPriority |
			  self originalCompletionSorter sortCompletionList:
				  (byPriority at: eachPriority ifAbsent: [ #(  ) ]) ]
]
