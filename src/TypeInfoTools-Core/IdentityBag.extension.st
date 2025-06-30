Extension { #name : 'IdentityBag' }

{ #category : '*TypeInfoTools-Core' }
IdentityBag >> collect: collectBlock [
	"Evaluate aBlock with each of the receiver's elements as the argument.
	Collect the resulting values into a collection like the receiver. Answer
	the new collection.

	Note: the returned collection is of the same species. If this species
	does not accomdate the values of aBlock, look at collect:as:"

	| result |
	result := self class new.
	self associationsDo: [ :eachAssociation |
			| collectedValue |
			collectedValue := collectBlock value: eachAssociation key.
			result add: collectedValue withOccurrences: eachAssociation value ].
	^ result
]

{ #category : '*TypeInfoTools-Core' }
IdentityBag >> collect: collectBlock thenSelect: selectBlock [
	"Evaluates collectBlock for each element, then selects elements for which selectBlock returns true."

	"(#(1 2 3 4) collect: [:e | e * 2] thenSelect: [:e | e > 5]) >>> #(6 8)"

	| result |
	result := self class new.
	self associationsDo: [ :eachAssociation |
			| collectedValue |
			collectedValue := collectBlock value: eachAssociation key.
			(selectBlock value: collectedValue) ifTrue: [
				result add: collectedValue withOccurrences: eachAssociation value ] ].
	^ result
]

{ #category : '*TypeInfoTools-Core' }
IdentityBag >> count: aBlock [

	| sum |
	sum := 0.
	self associationsDo: [ :eachAssociation |
			(aBlock value: eachAssociation key) ifTrue: [
				sum := sum + eachAssociation value ] ].
	^ sum
]
