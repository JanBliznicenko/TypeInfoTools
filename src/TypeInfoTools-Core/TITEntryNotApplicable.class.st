Class {
	#name : 'TITEntryNotApplicable',
	#superclass : 'Exception',
	#category : 'TypeInfoTools-Core-NameStatistics',
	#package : 'TypeInfoTools-Core',
	#tag : 'NameStatistics'
}

{ #category : 'signalling' }
TITEntryNotApplicable class >> signalClassName: aName [

	^ self new
		  name: aName;
		  signal
]
