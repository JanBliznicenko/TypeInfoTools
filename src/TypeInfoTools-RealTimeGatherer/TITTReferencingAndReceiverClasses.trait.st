Trait {
	#name : 'TITTReferencingAndReceiverClasses',
	#category : 'TypeInfoTools-RealTimeGatherer-Processing',
	#package : 'TypeInfoTools-RealTimeGatherer',
	#tag : 'Processing'
}

{ #category : 'adding' }
TITTReferencingAndReceiverClasses >> addReceiverClass: aReceiverClass referencingClass: aReferencingClass [

	^ self add: (TITReferencingAndReceiverClass
			   withReferencingClass: aReferencingClass
			   receiverClass: aReceiverClass)
]

{ #category : 'adding' }
TITTReferencingAndReceiverClasses >> addReferencingClass: aReferencingClass receiverClass: aReceiverClass [

	^ self add: (TITReferencingAndReceiverClass
			   withReferencingClass: aReferencingClass
			   receiverClass: aReceiverClass)
]

{ #category : 'enumerating' }
TITTReferencingAndReceiverClasses >> receiverClasses [

	^ self collect: [ :each | each receiverClass ] as: Set
]

{ #category : 'enumerating' }
TITTReferencingAndReceiverClasses >> receiverClassesSorted [

	^ self receiverClasses sorted: [ :a :b | a name < b name ]
]

{ #category : 'enumerating' }
TITTReferencingAndReceiverClasses >> referencingClasses [

	^ self collect: [ :each | each referencingClass ] as: Set
]

{ #category : 'enumerating' }
TITTReferencingAndReceiverClasses >> referencingClassesSorted [

	^ self referencingClasses sorted: [ :a :b | a name < b name ]
]
