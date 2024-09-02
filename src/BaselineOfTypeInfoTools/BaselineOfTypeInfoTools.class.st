Class {
	#name : 'BaselineOfTypeInfoTools',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfTypeInfoTools',
	#package : 'BaselineOfTypeInfoTools'
}

{ #category : 'baselines' }
BaselineOfTypeInfoTools >> baseline: spec [

	<baseline>
	spec for: #common do: [
		spec
			baseline: 'RoelTyper'
			with: [ spec repository: 'github://JanBliznicenko/RoelTyper' ];
			package: 'TypeInfoTools' with: [ spec requires: #( 'RoelTyper' ) ];
			group: 'default' with: #( 'TypeInfoTools' ) ]
]
