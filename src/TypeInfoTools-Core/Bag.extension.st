Extension { #name : 'Bag' }

{ #category : '*TypeInfoTools-Core' }
Bag >> countAsEqual: aBlock [

	| sum |
	sum := 0.
	self associationsDo: [ :eachAssociation |
			(aBlock value: eachAssociation key) ifTrue: [
				sum := sum + eachAssociation value ] ].
	^ sum
]

{ #category : '*TypeInfoTools-Core' }
Bag >> values [

	| values |
	values := Array new: contents size.
	self sortedElements withIndexDo: [ :assoc :index |
		values at: index put: assoc key ].
	^ values
]
