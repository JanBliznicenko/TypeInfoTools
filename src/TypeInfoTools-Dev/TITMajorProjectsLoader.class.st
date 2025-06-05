Class {
	#name : 'TITMajorProjectsLoader',
	#superclass : 'Object',
	#category : 'TypeInfoTools-Dev-Dependencies',
	#package : 'TypeInfoTools-Dev',
	#tag : 'Dependencies'
}

{ #category : 'as yet unclassified' }
TITMajorProjectsLoader class >> AIDataFrameInspector [

	<projectLoader>
	Metacello new
		baseline: 'AIDataFrameInspector';
		repository: 'github://pharo-ai/data-inspector/src';
		onConflictUseIncoming;
		load
]

{ #category : 'as yet unclassified' }
TITMajorProjectsLoader class >> AIEditDistances [

	<projectLoader>
	Metacello new
		repository: 'github://pharo-ai/edit-distances/src';
		baseline: 'AIEditDistances';
		load
]

{ #category : 'as yet unclassified' }
TITMajorProjectsLoader class >> AIGraphAlgorithms [

	<projectLoader>
	Metacello new
		repository: 'github://pharo-ai/graph-algorithms';
		baseline: 'AIGraphAlgorithms';
		load
]

{ #category : 'as yet unclassified' }
TITMajorProjectsLoader class >> Album [

	<projectLoader>
	Metacello new
		baseline: 'Album';
		repository: 'github://pharo-graphics/Album:master/src';
		load
]

{ #category : 'as yet unclassified' }
TITMajorProjectsLoader class >> Alexandrie [

	<projectLoader>
	Metacello new
		baseline: 'Alexandrie';
		repository: 'github://pharo-graphics/Alexandrie:master/src';
		load
]

{ #category : 'as yet unclassified' }
TITMajorProjectsLoader class >> Artefact [

	<projectLoader>
	Metacello new
		githubUser: 'pharo-contributions'
		project: 'Artefact'
		commitish: 'master'
		path: 'src';
		baseline: 'Artefact';
		load
]

{ #category : 'as yet unclassified' }
TITMajorProjectsLoader class >> Bloc [

	<projectLoader>
	Metacello new
		baseline: 'Bloc';
		repository: 'github://pharo-graphics/Bloc:master/src';
		load
]

{ #category : 'as yet unclassified' }
TITMajorProjectsLoader class >> BlocTutorials [

	<projectLoader>
	Metacello new
		baseline: 'BlocTutorials';
		repository: 'github://pharo-graphics/Tutorials:master/src';
		load
]

{ #category : 'as yet unclassified' }
TITMajorProjectsLoader class >> Clap [

	<projectLoader>
	Metacello new
		baseline: 'Clap';
		repository: 'github://pharo-contributions/clap-st/src';
		load
]

{ #category : 'as yet unclassified' }
TITMajorProjectsLoader class >> CoypuIDE [

	<projectLoader>
	Metacello new
	baseline: 'CoypuIDE';
	repository: 'github://pharo-graphics/CoypuIDE/';
	onConflict: [ :ex | ex useIncoming ];
	onUpgrade: [ :ex | ex useIncoming ];
	load.
]

{ #category : 'as yet unclassified' }
TITMajorProjectsLoader class >> Cryptography [

	<projectLoader>
	Metacello new
		baseline: 'Cryptography';
		repository: 'github://pharo-contributions/Cryptography';
		load
]

{ #category : 'as yet unclassified' }
TITMajorProjectsLoader class >> Glorp [

	<projectLoader>
	Metacello new
		repository: 'github://pharo-rdbms/glorp';
		baseline: 'Glorp';
		load
]

{ #category : 'as yet unclassified' }
TITMajorProjectsLoader class >> IconFactory [

	<projectLoader>
	Metacello new
		baseline: #IconFactory;
		repository: 'github://pharo-graphics/IconFactory/repository';
		load
]

{ #category : 'as yet unclassified' }
TITMajorProjectsLoader class >> MethodProxies [

	<projectLoader>
	Metacello new
		baseline: 'MethodProxies';
		repository: 'github://pharo-contributions/MethodProxies/src';
		load
]

{ #category : 'as yet unclassified' }
TITMajorProjectsLoader class >> MooseIDE [

	<projectLoader>
	Metacello new
		baseline: 'MooseIDE';
		repository: 'github://moosetechnology/MooseIDE:development/src';
		onConflictUseLoaded;
		load
]

{ #category : 'as yet unclassified' }
TITMajorProjectsLoader class >> MuTalk [

	<projectLoader>
	Metacello new
		baseline: 'MuTalk';
		repository: 'github://pharo-contributions/mutalk/src';
		load
]

{ #category : 'as yet unclassified' }
TITMajorProjectsLoader class >> ODBC [

	<projectLoader>
	Metacello new
	repository: 'github://pharo-rdbms/Pharo-ODBC/src';
	baseline: 'ODBC';
	load
]

{ #category : 'as yet unclassified' }
TITMajorProjectsLoader class >> OpenPonkPlugins [

	<projectLoader>
	Metacello new
		baseline: 'OpenPonkPlugins';
		repository: 'github://openponk/plugins';
		onConflictUseIncoming;
		load: 'all'
]

{ #category : 'as yet unclassified' }
TITMajorProjectsLoader class >> Roassal [

	<projectLoader>
	Metacello new
		baseline: 'Roassal';
		repository: 'github://pharo-graphics/Roassal';
		onConflictUseIncoming;
		load
]

{ #category : 'as yet unclassified' }
TITMajorProjectsLoader class >> SDLExperiments [

	<projectLoader>
	Metacello new
	baseline: 'SDLExperiments';
	repository: 'github://tinchodias/pharo-sdl-experiments:master/';
	load
]

{ #category : 'as yet unclassified' }
TITMajorProjectsLoader class >> SQLite3 [

	<projectLoader>
	Metacello new
  repository: 'github://pharo-rdbms/Pharo-SQLite3/src';
  baseline: 'SQLite3';
  load
]

{ #category : 'as yet unclassified' }
TITMajorProjectsLoader class >> Seaside3 [

	<projectLoader>
	Metacello new
		baseline: 'Seaside3';
		repository: 'github://SeasideSt/Seaside:master/repository';
		load
]

{ #category : 'as yet unclassified' }
TITMajorProjectsLoader class >> SimpleRene [

	<projectLoader>
	Metacello new
		baseline: 'SimpleRene';
		repository: 'github://pharo-contributions/SimpleRene';
		load
]

{ #category : 'as yet unclassified' }
TITMajorProjectsLoader class >> SingularizePluralize [

	<projectLoader>
	Metacello new
		baseline: 'SingularizePluralize';
		repository: 'github://pharo-contributions/SingularizePluralize/src';
		load
]

{ #category : 'as yet unclassified' }
TITMajorProjectsLoader class >> Soup [

	<projectLoader>
	Metacello new
		baseline: 'Soup';
		repository: 'github://pharo-contributions/Soup';
		load
]

{ #category : 'as yet unclassified' }
TITMajorProjectsLoader class >> Talents [

	<projectLoader>
	Metacello new
		baseline: 'Talents';
		repository: 'github://tesonep/pharo-talents/src';
		load
]

{ #category : 'as yet unclassified' }
TITMajorProjectsLoader class >> TaskIt [

	<projectLoader>
	Metacello new
		baseline: 'TaskIt';
		repository: 'github://pharo-contributions/taskit';
		load
]

{ #category : 'as yet unclassified' }
TITMajorProjectsLoader class >> Teapot [

	<projectLoader>
	Metacello new
		baseline: 'Teapot';
		repository: 'github://zeroflag/Teapot/source';
		load
]

{ #category : 'as yet unclassified' }
TITMajorProjectsLoader class >> Toplo [

	<projectLoader>
	Metacello new
		baseline: 'Toplo';
		repository: 'github://pharo-graphics/Toplo:master/src';
		load
]

{ #category : 'as yet unclassified' }
TITMajorProjectsLoader class >> Voyage [

	<projectLoader>
	Metacello new
		repository: 'github://pharo-nosql/voyage/mc';
		baseline: 'Voyage';
		load: 'mongo tests'
]

{ #category : 'as yet unclassified' }
TITMajorProjectsLoader class >> XMLParserHTML [

	<projectLoader>
	Metacello new
		baseline: 'XMLParserHTML';
		repository: 'github://pharo-contributions/XML-XMLParserHTML/src';
		load
]

{ #category : 'as yet unclassified' }
TITMajorProjectsLoader class >> XPath [

	<projectLoader>
	Metacello new
		baseline: 'XPath';
		repository: 'github://pharo-contributions/XML-XPath/src';
		load
]

{ #category : 'as yet unclassified' }
TITMajorProjectsLoader class >> loadProjects [

	<script>
	| methods |
	methods := self projectLoaderMethods.
	self halt.
	[
		EpMonitor disableDuring: [
			methods do: [ :each |
				(Message selector: each selector) sendTo: self ] ] ]
		forkAt: Processor userBackgroundPriority
		named: self name
]

{ #category : 'as yet unclassified' }
TITMajorProjectsLoader class >> projectLoaderMethods [

	^ self class methods select: [ :each |
		  each pragmas anySatisfy: [ :any | any selector = #projectLoader ] ]
]
