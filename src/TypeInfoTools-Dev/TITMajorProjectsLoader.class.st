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
	load.
]

{ #category : 'as yet unclassified' }
TITMajorProjectsLoader class >> Cryptography [

	<projectLoader>
	Metacello new
		baseline: 'Cryptography';
		repository: 'github://pharo-contributions/Cryptography';
		load: #('Cryptography' 'ASN1-Tests' 'ASN1-Readers-Tests' 'X509-Tests' 'PBKDF2-Tests' 'Blowfish' 'OpenPGP' 'LayeredProtocol')
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
TITMajorProjectsLoader class >> NeoJSON [

	<projectLoader: 10>
	Metacello new
		repository: 'github://svenvc/NeoJSON';
		baseline: 'NeoJSON';
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
		onConflictUseLoaded;
		load: 'all'
]

{ #category : 'as yet unclassified' }
TITMajorProjectsLoader class >> Roassal [

	<projectLoader: 10>
	Metacello new
		baseline: 'Roassal';
		repository: 'github://pharo-graphics/Roassal';
		lock;
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
TITMajorProjectsLoader class >> Teapot [

	<projectLoader>
	Metacello new
		baseline: 'Teapot';
		repository: 'github://zeroflag/Teapot/source';
		load
]

{ #category : 'as yet unclassified' }
TITMajorProjectsLoader class >> Toplo [

	<projectLoader: 10>
	Metacello new
		baseline: 'Toplo';
		repository: 'github://pharo-graphics/Toplo:master/src';
		lock;
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
TITMajorProjectsLoader class >> XMLParser [

	<projectLoader: 10>
	Metacello new
		baseline: 'XMLParser';
		repository: 'github://pharo-contributions/XML-XMLParser/src';
		lock;
		load
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
TITMajorProjectsLoader class >> loadProjects [

	<script>
	| selectors warnings |
	selectors := self projectLoaderMethods.
	warnings := OrderedCollection new.
	IceLibgitRepository shareRepositoriesBetweenImages: false.
	[
		EpMonitor disableDuring: [
				[ :job |
					job max: selectors size.
					selectors withIndexDo: [ :each :index |
							job title: 'Loading ' , each.
							job value: index - 1.
							[ (Message selector: each) sendTo: self ]
								on: Warning
								do: [ :warning |
										warnings add: each -> warning messageText.
										warning resume ] ] ] asJob run ].
		warnings ifNotEmpty: #inspect ]
		forkAt: Processor userBackgroundPriority
		named: self name
]

{ #category : 'as yet unclassified' }
TITMajorProjectsLoader class >> projectLoaderMethods [

	^ ((self class methods
		    collect: [ :each |
				    each selector -> (each pragmas
					     detect: [ :any | any selector beginsWith: 'projectLoader' ]
					     ifFound: [ :pragma |
					     pragma argumentNamed: #projectLoader ifNone: [ 100 ] ]
					     ifNone: [ 0 ]) ]
		    thenSelect: [ :each | each value > 0 ]) sorted: [ :a :b |
			   a value = b value
				   ifTrue: [ a key < b key ]
				   ifFalse: [ a value < b value ] ]) collect: #key
]
