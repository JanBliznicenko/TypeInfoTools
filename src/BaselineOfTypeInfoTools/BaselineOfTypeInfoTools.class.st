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
			baseline: 'RoelTyper' with: [
				spec
					repository: 'github://JanBliznicenko/RoelTyper';
					loads: 'Tests' ];
			baseline: 'J2Inferer' with: [
			spec
				repository: 'github://JanBliznicenko/J2Inferer';
				loads: 'dev' ];
			package: 'TypeInfoTools-Core'
			with: [ spec requires: #( 'RoelTyper' 'J2Inferer' ) ];
			package: 'TypeInfoTools-MessageList'
			with: [ spec requires: #( 'TypeInfoTools-Core' ) ];
			package: 'TypeInfoTools-Browser'
			with: [ spec requires: #( 'TypeInfoTools-Core' ) ];
			group: 'default'
			with: #( 'TypeInfoTools-MessageList' 'TypeInfoTools-Browser' ) ]
]
