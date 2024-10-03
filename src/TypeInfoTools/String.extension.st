Extension { #name : 'String' }

{ #category : '*TypeInfoTools' }
String >> capitalizedAs: otherString [
	"Adjust the capitalization of the receiver to match that of otherString."

	^ self collectWithIndex: [ :each :index |
		  (otherString at: index ifAbsent: $a) isUppercase
			  ifTrue: [ each asUppercase ]
			  ifFalse: [ each asLowercase ] ]
]

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

{ #category : '*TypeInfoTools' }
String >> isPlural [

	| irregularPlurals singularExceptions wordLowercase |
	irregularPlurals := { 'children'. 'men'. 'women'. 'people'. 'mice'.
	                    'teeth'. 'feet'. 'geese'. 'criteria'. 'data'.
	                    'phenomena'. 'lice'. 'cacti'. 'nuclei'. 'fungi'.
	                    'bacteria'. 'indices'. 'matrices'. 'oxen' }.
	singularExceptions := #( 'news' 'series' 'species' 'deer' 'sheep'
	                         'fish' 'aircraft' 'information'
	                         'equipment' ).
	wordLowercase := self asLowercase.

	(singularExceptions anySatisfy: [ :any | wordLowercase endsWith: any ])
		ifTrue: [ ^ false ].

	(irregularPlurals anySatisfy: [ :any | wordLowercase endsWith: any ])
		ifTrue: [ ^ true ].

	((wordLowercase endsWith: 's') and: [
		 (wordLowercase endsWith: 'ss') not and: [
			 (wordLowercase endsWith: 'us') not and: [
				 (wordLowercase endsWith: 'is') not ] ] ]) ifTrue: [ ^ true ].

	^ false
]

{ #category : '*TypeInfoTools' }
String >> singularize [

	| irregularPlurals singularExceptions wordLowercase singularForm |
	irregularPlurals := {
		                    ('children' -> 'child').
		                    ('men' -> 'man').
		                    ('women' -> 'woman').
		                    ('people' -> 'person').
		                    ('mice' -> 'mouse').
		                    ('teeth' -> 'tooth').
		                    ('feet' -> 'foot').
		                    ('geese' -> 'goose').
		                    ('criteria' -> 'criterion').
		                    ('data' -> 'datum').
		                    ('phenomena' -> 'phenomenon').
		                    ('lice' -> 'louse').
		                    ('cacti' -> 'cactus').
		                    ('nuclei' -> 'nucleus').
		                    ('fungi' -> 'fungus').
		                    ('bacteria' -> 'bacterium').
		                    ('indices' -> 'index').
		                    ('matrices' -> 'matrix').
		                    ('oxen' -> 'ox') } asDictionary.
	singularExceptions := #( 'news' 'series' 'species' 'deer' 'sheep'
	                         'fish' 'aircraft' 'information'
	                         'equipment' ).

	wordLowercase := self asLowercase.

	"Check for singular exceptions"
	(singularExceptions includes: wordLowercase) ifTrue: [ ^ self ].

	"Check for irregular plurals"
	(irregularPlurals includesKey: wordLowercase) ifTrue: [
		singularForm := irregularPlurals at: wordLowercase.
		^ singularForm capitalizedAs: self ].

	"Handle words ending with 'ies' -> 'y'"
	(self endsWith: 'ies') ifTrue: [
		singularForm := (self copyFrom: 1 to: self size - 3) , 'y'.
		^ singularForm capitalizedAs: self ].

	"Handle words ending with 'ves' -> 'f' or 'fe'"
	(self endsWith: 'ves') ifTrue: [
		singularForm := (self copyFrom: 1 to: self size - 3) , 'f'.
		^ singularForm capitalizedAs: self ].

	"Handle words ending with 'es' for certain endings"
	(self endsWith: 'es') ifTrue: [
		| stem lastTwoChars lastChar |
		stem := self copyFrom: 1 to: self size - 2.
		lastTwoChars := stem copyFrom: stem size - 1 to: stem size.
		lastChar := stem last.

		(lastTwoChars = 'ch' or: [
			 lastTwoChars = 'sh' or: [ 'sxzo' includes: lastChar ] ]) ifTrue: [
			singularForm := stem.
			^ singularForm capitalizedAs: self ] ].

	"Handle words ending with 's'"
	(self endsWith: 's') ifTrue: [
		((self endsWith: 'ss') or: [ self endsWith: 'us' ]) ifFalse: [
			singularForm := self copyFrom: 1 to: self size - 1.
			^ singularForm capitalizedAs: self ] ].

	^ self
]
