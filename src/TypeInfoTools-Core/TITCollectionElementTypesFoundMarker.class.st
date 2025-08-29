Class {
	#name : 'TITCollectionElementTypesFoundMarker',
	#superclass : 'TITStructureNodeTypeCollector',
	#classInstVars : [
		'instance'
	],
	#category : 'TypeInfoTools-Core-Inference',
	#package : 'TypeInfoTools-Core',
	#tag : 'Inference'
}

{ #category : 'accessing' }
TITCollectionElementTypesFoundMarker class >> instance [

	^ instance ifNil: [ instance := self new ]
]

{ #category : 'class initialization' }
TITCollectionElementTypesFoundMarker class >> reset [

	<script>
	instance := nil
]

{ #category : 'accessing' }
TITCollectionElementTypesFoundMarker class >> sourceName [

	^ 'Element types found'
]

{ #category : 'accessing' }
TITCollectionElementTypesFoundMarker >> weight [

	^ 1.2
]
