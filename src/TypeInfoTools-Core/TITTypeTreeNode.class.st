Class {
	#name : 'TITTypeTreeNode',
	#superclass : 'TITAbstractTypeTreeNode',
	#instVars : [
		'parentNode',
		'rootNode'
	],
	#category : 'TypeInfoTools-Core-ClassTree',
	#package : 'TypeInfoTools-Core',
	#tag : 'ClassTree'
}

{ #category : 'instance creation' }
TITTypeTreeNode class >> forClass: aClass parent: aNode [

	^ (self forClass: aClass)
		  parentNode: aNode;
		  yourself
]

{ #category : 'converting' }
TITTypeTreeNode >> asRoot [

	| selfAsRoot |
	selfAsRoot := TITTypeTreeRootNode forClass: self representedClass.
	selfAsRoot
		subclassNodes: (self subclassNodes
				 do: [ :each | each parentNode: selfAsRoot ];
				 yourself);
		sources: self sources.
	^ selfAsRoot
]

{ #category : 'merging' }
TITTypeTreeNode >> mergeIntoParentWithMyCollectors [

	^ self.
	self subclassNodes ifNotEmpty: [ ^ self ].
	(self parentNode withParentsIncludesCollectors:
		 self sources collectors) ifFalse: [ ^ self ].
	self sources do: [ :eachCollector |
		self parentNode sources add: eachCollector ].
	self parentNode removeChild: self
]

{ #category : 'accessing' }
TITTypeTreeNode >> parentNode [

	^ parentNode
]

{ #category : 'accessing' }
TITTypeTreeNode >> parentNode: anObject [

	parentNode := anObject
]

{ #category : 'accessing' }
TITTypeTreeNode >> rootNode [

	^ rootNode ifNil: [
			  rootNode := self isRootNode
				              ifTrue: [ self ]
				              ifFalse: [ self parentNode rootNode ] ]
]
