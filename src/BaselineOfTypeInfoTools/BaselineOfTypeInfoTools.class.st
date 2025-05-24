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
				baseline: 'NeoCSV'
				with: [ spec repository: 'github://svenvc/NeoCSV' ];
				package: 'TypeInfoTools-Core'
				with: [ spec requires: #( 'RoelTyper' 'J2Inferer' ) ];
				package: 'TypeInfoTools-Browser'
				with: [ spec requires: #( 'TypeInfoTools-Core' ) ];
				package: 'TypeInfoTools-MessageList'
				with: [ spec requires: #( 'TypeInfoTools-Core' ) ];
				package: 'TypeInfoTools-Completion'
				with: [ spec requires: #( 'TypeInfoTools-Core' ) ];
				package: 'TypeInfoTools-ReturnTypesGatherer'
				with: [ spec requires: #( 'TypeInfoTools-Core'
				   'NeoCSV' ) ];
				group: 'all'
				with: #( 'TypeInfoTools-MessageList' 'TypeInfoTools-Browser'
					   'TypeInfoTools-Completion' 'TypeInfoTools-ReturnTypesGatherer' );
				group: 'default' with: #( 'all' ) ]
]
