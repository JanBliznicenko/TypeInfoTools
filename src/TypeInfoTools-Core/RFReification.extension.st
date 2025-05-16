Extension { #name : 'RFReification' }

{ #category : '*TypeInfoTools-Core' }
RFReification class >> keysByEntities [

	<script: 'self keysByEntities inspect'>
	^ ((((OCProgramNode withAllSubclasses copyWith: Variable) sortedAs: [
		     :each | each name ]) collect: [ :eachNodeType |
			    eachNodeType -> (self allSubclasses
				     select: [ :each |
						     each entities anySatisfy: [ :anyNodeType |
							     eachNodeType withAllSuperclasses includes: anyNodeType ] ]
				     thenCollect: [ :each | each key ]) sorted asArray ]) reject: [
		   :any | any value isEmpty ]) asOrderedDictionary
]

{ #category : '*TypeInfoTools-Core' }
RFReification class >> uniqueKeysByEntities [
	"keys not present in all the nodes"

	<script: 'self uniqueKeysByEntities inspect'>
	| keysByEntities commonKeys |
	keysByEntities := self keysByEntities.
	commonKeys := (keysByEntities removeKey: OCProgramNode) asSet.
	^ keysByEntities collect: [ :eachCollection |
		  eachCollection copyWithoutAll: commonKeys ]
]
