Extension { #name : 'String' }

{ #category : '*TypeInfoTools' }
String >> copyAfterSubstring: aSubstring [

	| index |
	aSubstring ifEmpty: [ 
		"preserve compatiblity with `readStream upToAll:`"
		^ String new ].
	index := self findString: aSubstring.
	index > 0 ifFalse: [ ^ self ].
	^ self copyFrom: index + aSubstring size to: self size
]

{ #category : '*TypeInfoTools' }
String >> copyFrom: n UpToSubstring: aSubstring [

	| index |
	aSubstring ifEmpty: [ "preserve compatiblity with `readStream upToAll:`"
		^ String new ].
	index := self findString: aSubstring.
	n > index ifTrue: [ ^ String new ].
	^ self copyFrom: n to: index - 1
]
