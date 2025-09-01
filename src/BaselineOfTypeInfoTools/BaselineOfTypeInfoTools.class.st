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
				baseline: 'DependentsFinder'
				with: [
					spec repository: 'github://JanBliznicenko/DependentsFinder:main' ];
				baseline: 'OSWinSubprocess' with: [
					spec repository:
							'github://pharo-contributions/OSWinSubprocess:v1.1.1' ];
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
				package: 'TypeInfoTools-TreePresenter'
				with: [ spec requires: #( 'TypeInfoTools-Core' ) ];
				package: 'TypeInfoTools-MessageList'
				with: [ spec requires: #( 'TypeInfoTools-Core' ) ];
				package: 'TypeInfoTools-Completion'
				with: [ spec requires: #( 'TypeInfoTools-Core' ) ];
				package: 'TypeInfoTools-StatsCollector'
				with: [ spec requires: #( 'TypeInfoTools-Core'
				   'NeoCSV' ) ];
				package: 'TypeInfoTools-RunTimeGatherer' with: [
					spec requires:
						#( 'DependentsFinder' 'OSWinSubprocess' 'TypeInfoTools-Core'
						   'NeoCSV' ) ];
				group: 'ide'
				with:
				#( 'TypeInfoTools-MessageList' 'TypeInfoTools-TreePresenter' );
				group: 'ide-experimental'
				with: #( 'ide' 'TypeInfoTools-Completion' );
				group: 'runtime' with: #( 'TypeInfoTools-RunTimeGatherer' );
				group: 'returntypes' with: #( 'TypeInfoTools-StatsCollector' );
				group: 'dev'
				with: #( 'ide-experimental' 'returntypes' 'runtime' );
				group: 'all' with: #( 'dev' );
				group: 'default' with: #( 'ide' ) ]
]
