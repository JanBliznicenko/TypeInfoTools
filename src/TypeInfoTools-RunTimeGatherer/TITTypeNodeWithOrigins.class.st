Class {
	#name : 'TITTypeNodeWithOrigins',
	#superclass : 'Object',
	#instVars : [
		'childNodes'
	],
	#category : 'TypeInfoTools-RunTimeGatherer-Processing',
	#package : 'TypeInfoTools-RunTimeGatherer',
	#tag : 'Processing'
}

{ #category : 'enumerating' }
TITTypeNodeWithOrigins >> allReferencingClasses [

	^ self subclassResponsibility 
]

{ #category : 'accessing' }
TITTypeNodeWithOrigins >> childNodes [

	^ childNodes
]

{ #category : 'initialization' }
TITTypeNodeWithOrigins >> initialize [

	super initialize.
	childNodes := Array empty
]

{ #category : 'as yet unclassified' }
TITTypeNodeWithOrigins >> inspectionTreeIn: specBuilder [

	<inspectorPresentationOrder: 910 title: 'Tree'>
	^ specBuilder newTree
		  roots: { self };
		  children: [ :aNode | aNode childNodes ];
		  expandRoots
]

{ #category : 'testing' }
TITTypeNodeWithOrigins >> isAcceptableMostPreciseNode [

	^ false
]

{ #category : 'querying' }
TITTypeNodeWithOrigins >> mostPreciseNode [

	^ self subclassResponsibility
]
