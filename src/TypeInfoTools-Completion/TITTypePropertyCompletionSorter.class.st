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

	| sourceNode type typeWithSuperclasses leastImportantPriority byPriority list |
	aList ifEmpty: [ ^ aList ].

	list := aList asOrderedCollection removeDuplicates asArray.

	sourceNode := list anyOne node.

	sourceNode isMessage ifFalse: [
			self halt.
			^ self originalCompletionSorter sortCompletionList: list ].
	type := sourceNode receiver
		        propertyAt: #type
		        ifAbsent: [
		        ^ self originalCompletionSorter sortCompletionList: list ].
	typeWithSuperclasses := type withAllSuperclasses.

	leastImportantPriority := typeWithSuperclasses size + 1.
	byPriority := list groupedBy: [ :eachListItem |
			              typeWithSuperclasses
				              detectIndex: [ :class |
				              class includesSelector: eachListItem contents ]
				              ifNone: [ leastImportantPriority ] ].

	^ (1 to: leastImportantPriority) flatCollect: [ :eachPriority |
			  self originalCompletionSorter sortCompletionList:
				  (byPriority at: eachPriority ifAbsent: [ #(  ) ]) ]
]
