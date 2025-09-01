Class {
	#name : 'TITReferencingAndReceiverClassesSet',
	#superclass : 'Set',
	#traits : 'TITTReferencingAndReceiverClasses',
	#classTraits : 'TITTReferencingAndReceiverClasses classTrait',
	#category : 'TypeInfoTools-RunTimeGatherer-Processing',
	#package : 'TypeInfoTools-RunTimeGatherer',
	#tag : 'Processing'
}

{ #category : 'adding' }
TITReferencingAndReceiverClassesSet >> addReceiverClass: aReceiverClass referencingClass: aReferencingClass [

	^ self add: (TITReferencingAndReceiverClass
			   withReferencingClass: aReferencingClass
			   receiverClass: aReceiverClass)
]

{ #category : 'adding' }
TITReferencingAndReceiverClassesSet >> addReferencingClass: aReferencingClass receiverClass: aReceiverClass [

	^ self add: (TITReferencingAndReceiverClass
			   withReferencingClass: aReferencingClass
			   receiverClass: aReceiverClass)
]

{ #category : 'enumerating' }
TITReferencingAndReceiverClassesSet >> receiverClasses [

	^ self collect: [ :each | each receiverClass ] as: Set
]

{ #category : 'enumerating' }
TITReferencingAndReceiverClassesSet >> receiverClassesSorted [

	^ self receiverClasses sorted: [ :a :b | a name < b name ]
]

{ #category : 'enumerating' }
TITReferencingAndReceiverClassesSet >> referencingClasses [

	^ self collect: [ :each | each referencingClass ] as: Set
]

{ #category : 'enumerating' }
TITReferencingAndReceiverClassesSet >> referencingClassesSorted [

	^ self referencingClasses sorted: [ :a :b | a name < b name ]
]

{ #category : 'sorting' }
TITReferencingAndReceiverClassesSet >> sorted [

	^ (SortedCollection sortBlock: [ :a :b |
				   a referencingClass = b referencingClass
					   ifTrue: [ a receiverClass name < b receiverClass name ]
					   ifFalse: [ a referencingClass name < b referencingClass name ] ])
		  addAll: self;
		  yourself
]
