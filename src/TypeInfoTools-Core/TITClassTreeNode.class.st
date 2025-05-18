Class {
	#name : 'TITClassTreeNode',
	#superclass : 'TITAbstractClassTreeNode',
	#instVars : [
		'parentNode',
		'rootNode'
	],
	#category : 'TypeInfoTools-Core-ClassTree',
	#package : 'TypeInfoTools-Core',
	#tag : 'ClassTree'
}

{ #category : 'instance creation' }
TITClassTreeNode class >> forClass: aClass parent: aNode [

	^ (self forClass: aClass)
		  parentNode: aNode;
		  yourself
]

{ #category : 'converting' }
TITClassTreeNode >> asRoot [

	| selfAsRoot |
	selfAsRoot := TITClassTreeRootNode forClass: self representedClass.
	selfAsRoot
		subclassNodes: (self subclassNodes
				 do: [ :each | each parentNode: selfAsRoot ];
				 yourself);
		sources: self sources.
	^ selfAsRoot
]

{ #category : 'merging' }
TITClassTreeNode >> mergeIntoParentWithMyCollectors [

	^ self.
	self subclassNodes ifNotEmpty: [ ^ self ].
	(self parentNode withParentsIncludesCollectors:
		 self sources collectors) ifFalse: [ ^ self ].
	self sources do: [ :eachCollector |
		self parentNode sources add: eachCollector ].
	self parentNode removeChild: self
]

{ #category : 'accessing' }
TITClassTreeNode >> parentNode [

	^ parentNode
]

{ #category : 'accessing' }
TITClassTreeNode >> parentNode: anObject [

	parentNode := anObject
]

{ #category : 'accessing' }
TITClassTreeNode >> rootNode [

	^ rootNode ifNil: [
			  rootNode := self isRootNode
				              ifTrue: [ self ]
				              ifFalse: [ self parentNode rootNode ] ]
]
