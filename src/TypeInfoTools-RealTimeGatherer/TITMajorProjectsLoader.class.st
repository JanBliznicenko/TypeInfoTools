Class {
	#name : 'TITMajorProjectsLoader',
	#superclass : 'Object',
	#category : 'TypeInfoTools-RealTimeGatherer-Gathering',
	#package : 'TypeInfoTools-RealTimeGatherer',
	#tag : 'Gathering'
}

{ #category : 'external projects' }
TITMajorProjectsLoader class >> AIEditDistances [

	<script>
	<projectLoader>
	Metacello new
		repository: 'github://pharo-ai/edit-distances/src';
		baseline: 'AIEditDistances';
		load
]

{ #category : 'external projects' }
TITMajorProjectsLoader class >> AIGraphAlgorithms [

	<script>
	<projectLoader>
	Metacello new
		repository: 'github://pharo-ai/graph-algorithms';
		baseline: 'AIGraphAlgorithms';
		load
]

{ #category : 'external projects' }
TITMajorProjectsLoader class >> Artefact [

	<script>
	<projectLoader>
	Metacello new
		githubUser: 'pharo-contributions'
		project: 'Artefact'
		commitish: 'master'
		path: 'src';
		baseline: 'Artefact';
		load
]

{ #category : 'external projects' }
TITMajorProjectsLoader class >> BTree [

	<script>
	<projectLoader>
	Metacello new
		repository: 'github://pharo-containers/BTree:5a2cc1c';
		baseline: 'BTree';
		load
]

{ #category : 'external projects' }
TITMajorProjectsLoader class >> BlocTutorials [

	<script>
	<projectLoader>
	Metacello new
		baseline: 'BlocTutorials';
		repository: 'github://pharo-graphics/Tutorials:master/src';
		load
]

{ #category : 'external projects' }
TITMajorProjectsLoader class >> Clap [

	<script>
	<projectLoader>
	Metacello new
		baseline: 'Clap';
		repository: 'github://pharo-contributions/clap-st/src';
		load
]

{ #category : 'external projects' }
TITMajorProjectsLoader class >> Cormas [

	<script>
	<projectLoader>
	Metacello new
		repository: 'github://cormas/cormas';
		baseline: 'Cormas';
		load
]

{ #category : 'external projects' }
TITMajorProjectsLoader class >> Cryptography [

	<script>
	<projectLoader>
	Metacello new
		baseline: 'Cryptography';
		repository: 'github://pharo-contributions/Cryptography';
		load: #('Cryptography' 'ASN1-Tests' 'ASN1-Readers-Tests' 'X509-Tests' 'PBKDF2-Tests' 'Blowfish' 'OpenPGP' 'LayeredProtocol')
]

{ #category : 'external projects' }
TITMajorProjectsLoader class >> Glorp [

	<script>
	<projectLoader>
	Metacello new
		repository: 'github://pharo-rdbms/glorp';
		baseline: 'Glorp';
		load
]

{ #category : 'external projects' }
TITMajorProjectsLoader class >> IconFactory [

	<script>
	<projectLoader>
	Metacello new
		baseline: #IconFactory;
		repository: 'github://pharo-graphics/IconFactory/repository';
		load
]

{ #category : 'external projects' }
TITMajorProjectsLoader class >> MethodProxies [

	<script>
	<projectLoader>
	Metacello new
		baseline: 'MethodProxies';
		repository: 'github://pharo-contributions/MethodProxies/src';
		load
]

{ #category : 'external projects' }
TITMajorProjectsLoader class >> MooseIDE [

	<script>
	<projectLoader: 7>
	Metacello new
		baseline: 'MooseIDE';
		repository: 'github://moosetechnology/MooseIDE:development/src';
		onConflictUseLoaded;
		load
]

{ #category : 'external projects' }
TITMajorProjectsLoader class >> NeoJSON [

	<script>
	<projectLoader: 10>
	Metacello new
		repository: 'github://svenvc/NeoJSON';
		baseline: 'NeoJSON';
		load
]

{ #category : 'external projects' }
TITMajorProjectsLoader class >> ODBC [

	<script>
	<projectLoader>
	Metacello new
	repository: 'github://pharo-rdbms/Pharo-ODBC/src';
	baseline: 'ODBC';
	load
]

{ #category : 'external projects' }
TITMajorProjectsLoader class >> OpenPonkPlugins [

	<script>
	<projectLoader>
	Metacello new
		baseline: 'OpenPonkPlugins';
		repository: 'github://openponk/plugins';
		onConflictUseLoaded;
		load: 'all'
]

{ #category : 'external projects' }
TITMajorProjectsLoader class >> PharoLauncher [

	<script>
	<projectLoader>
	Metacello new
		baseline: 'PharoLauncher';
		repository: 'github://pharo-project/pharo-launcher:dev/src';
		load.

	WorldState class compile: 'quitSession
	| response |
	response := MorphicUIManager new
						confirm: ''Save changes before quitting?''
						trueChoice: ''Save''
						falseChoice: ''Discard''
						cancelChoice: ''Cancel''
						default: nil.
	response ifNil: [ ^self ].
	response
		ifTrue: [Smalltalk snapshot: true andQuit: true]
		ifFalse: [Smalltalk snapshot: false andQuit: true]'.
	(Smalltalk at: #PhLStartupManager) class compile:
		'startUp: isANewSession
	isANewSession ifFalse: [ ^ self ].	
	PharoLauncherApplication reset.'
]

{ #category : 'external projects' }
TITMajorProjectsLoader class >> Roassal [

	<script>
	<projectLoader: 10>
	Metacello new
		baseline: 'Roassal';
		repository: 'github://pharo-graphics/Roassal:Pharo13';
		onConflictUseLoaded;
		lock;
		load
]

{ #category : 'external projects' }
TITMajorProjectsLoader class >> RoassalExporters [

	<script>
	<projectLoader: 10>
	Metacello new
		baseline: 'RoassalExporters';
		repository: 'github://pharo-graphics/RoassalExporters:Pharo13';
		lock;
		load
]

{ #category : 'external projects' }
TITMajorProjectsLoader class >> RoassalLayouts [

	<script>
	<projectLoader: 4>
	Metacello new
		baseline: 'RoassalLayouts';
		repository: 'github://JanBliznicenko/RoassalLayouts';
		lock;
		load
]

{ #category : 'external projects' }
TITMajorProjectsLoader class >> SDLExperiments [

	<script>
	<projectLoader>
	Metacello new
		baseline: 'SDLExperiments';
		repository: 'github://tinchodias/pharo-sdl-experiments:master/';
		load
]

{ #category : 'external projects' }
TITMajorProjectsLoader class >> SQLite3 [

	<script>
	<projectLoader>
	| repoPath dllsDir vmDir |
	repoPath := 'pharo-rdbms/Pharo-SQLite3'.

	Metacello new
		repository: 'github://' , repoPath;
		baseline: 'SQLite3';
		load.

	OSPlatform current isWindows ifFalse: [ ^ self ].

	dllsDir := IceLibgitRepository localRepositoriesLocation / repoPath
	           / 'bin/windows/64bit'.
	vmDir := FileLocator vmDirectory.
	dllsDir files do: [ :eachFile |
			eachFile copyTo: ((vmDir / eachFile basename)
					 ensureDelete;
					 yourself) ]
]

{ #category : 'external projects' }
TITMajorProjectsLoader class >> Seaside3 [

	<script>
	<projectLoader>
	Metacello new
		baseline: 'Seaside3';
		repository: 'github://SeasideSt/Seaside:master/repository';
		load
]

{ #category : 'external projects' }
TITMajorProjectsLoader class >> SimpleRene [

	<script>
	<projectLoader>
	Metacello new
		baseline: 'SimpleRene';
		repository: 'github://pharo-contributions/SimpleRene';
		load
]

{ #category : 'external projects' }
TITMajorProjectsLoader class >> SingularizePluralize [

	<script>
	<projectLoader>
	Metacello new
		baseline: 'SingularizePluralize';
		repository: 'github://pharo-contributions/SingularizePluralize/src';
		load
]

{ #category : 'external projects' }
TITMajorProjectsLoader class >> Soup [

	<script>
	<projectLoader>
	Metacello new
		baseline: 'Soup';
		repository: 'github://pharo-contributions/Soup';
		load
]

{ #category : 'external projects' }
TITMajorProjectsLoader class >> Talents [

	<script>
	<projectLoader>
	Metacello new
		baseline: 'Talents';
		repository: 'github://tesonep/pharo-talents/src';
		load
]

{ #category : 'external projects' }
TITMajorProjectsLoader class >> Teapot [

	<script>
	<projectLoader>
	Metacello new
		baseline: 'Teapot';
		repository: 'github://zeroflag/Teapot/source';
		load
]

{ #category : 'external projects' }
TITMajorProjectsLoader class >> Toplo [

	<script>
	<projectLoader: 10>
	Metacello new
		baseline: 'Toplo';
		repository: 'github://pharo-graphics/Toplo:master/src';
		lock;
		load
]

{ #category : 'external projects' }
TITMajorProjectsLoader class >> Voyage [

	<script>
	<projectLoader>
	Metacello new
		repository: 'github://pharo-nosql/voyage/mc';
		baseline: 'Voyage';
		load: 'mongo tests'
]

{ #category : 'external projects' }
TITMajorProjectsLoader class >> XMLParser [

	<script>
	<projectLoader: 10>
	Metacello new
		baseline: 'XMLParser';
		repository: 'github://pharo-contributions/XML-XMLParser';
		lock;
		load
]

{ #category : 'external projects' }
TITMajorProjectsLoader class >> XMLParserHTML [

	<script>
	<projectLoader>
	Metacello new
		baseline: 'XMLParserHTML';
		repository: 'github://pharo-contributions/XML-XMLParserHTML/src';
		onConflictUseLoaded;
		load
]

{ #category : 'actions' }
TITMajorProjectsLoader class >> loadProjects [

	<script>
	| selectors warnings |
	selectors := self projectLoaderMethods.
	warnings := OrderedCollection new.
	IceLibgitRepository shareRepositoriesBetweenImages: false.
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
	warnings ifNotEmpty: #inspect.
	Smalltalk garbageCollect
]

{ #category : 'loading' }
TITMajorProjectsLoader class >> projectLoaderMethods [

	<script: 'self projectLoaderMethods inspect'>
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
