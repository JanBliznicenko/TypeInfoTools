Extension { #name : 'Bag' }

{ #category : '*TypeInfoTools-Core' }
Bag >> values [

	| values |
	values := Array new: contents size.
	self sortedElements withIndexDo: [ :assoc :index |
		values at: index put: assoc key ].
	^ values
]
