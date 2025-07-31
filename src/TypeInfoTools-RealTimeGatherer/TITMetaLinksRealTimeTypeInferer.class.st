Class {
	#name : 'TITMetaLinksRealTimeTypeInferer',
	#superclass : 'TITTestsAndExamplesRunner',
	#instVars : [
		'insertionVisitor',
		'variableTypes',
		'returnTypes'
	],
	#category : 'TypeInfoTools-RealTimeGatherer-Gathering',
	#package : 'TypeInfoTools-RealTimeGatherer',
	#tag : 'Gathering'
}

{ #category : 'private' }
TITMetaLinksRealTimeTypeInferer class >> baselines [

	<script: 'self baselines inspect'>
	| thisDirName imagesDir |
	thisDirName := FileLocator imageDirectory basename.
	imagesDir := FileLocator imageDirectory parent asFileReference.
	^ super baselines reject: [ :each |
			  | baselineName baselineDir |
			  baselineName := self nameOfBaseline: each.
			  baselineDir := imagesDir / (thisDirName , '_' , baselineName).
			  baselineDir exists and: [
					  baselineDir files anySatisfy: [ :any |
						  any basename endsWith: '_VarTypes.ston' ] ] ]
]

{ #category : 'examples' }
TITMetaLinksRealTimeTypeInferer class >> example [

	super example
]

{ #category : 'execution' }
TITMetaLinksRealTimeTypeInferer class >> generateSplitBaselines [

	<script>
	self
		generateSplitBaselinesFrom: BaselineOfIceberg;
		generateSplitBaselinesFrom: BaselineOfNewTools;
		generateSplitBaselinesFrom: BaselineOfBloc;
		generateSplitPharoBootstrapBaselines
]

{ #category : 'execution' }
TITMetaLinksRealTimeTypeInferer class >> generateSplitBaselinesFrom: originalBaseline [

	| packagesByNames |
	packagesByNames := (originalBaseline version loadedSystemPackages
		                    collect: [ :each | each name ]) groupedBy: [
			                   :each |
			                   | parts |
			                   parts := each splitOn: '-'.
			                   parts size < 2
				                   ifTrue: [ 'CoreRoot' ]
				                   ifFalse: [ parts second ] ].
	packagesByNames keysAndValuesDo: [ :basename :packageNames |
			| baselineClass |
			baselineClass := (BaselineOf
			                  << (originalBaseline name , basename) asSymbol)
				                 package: originalBaseline name , basename;
				                 install.
			baselineClass compile: (String streamContents: [ :s |
						 s << 'baseline: spec
	<baseline>

	spec for: #common do: [
'.
						 packageNames do: [ :eachPackageName |
								 s << '			spec package: ''' << eachPackageName << '''.
' ].
						 s << '	]' ]) ]
]

{ #category : 'execution' }
TITMetaLinksRealTimeTypeInferer class >> generateSplitPharoBootstrapBaselines [

	| packagesByNames |
	packagesByNames := (BaselineOfPharoBootstrap version
		                    loadedSystemPackages
		                    collect: [ :each | each name ]
		                    thenReject: [ :each |
		                    each beginsWith: 'Reflection' ]) groupedBy: [
		                   :each | (each splitOn: $-) first asSymbol ].
	packagesByNames keysAndValuesDo: [ :basename :packageNames |
			| baselineClass |
			baselineClass := (BaselineOf
			                  <<
				                  ('BaselineOfPharoBootstrap' , basename) asSymbol)
				                 package: 'BaselineOfPharoBootstrap' , basename;
				                 install.
			baselineClass compile: (String streamContents: [ :s |
						 s << 'baseline: spec
	<baseline>

	spec for: #common do: [
'.
						 packageNames do: [ :eachPackageName |
								 s << '			spec package: ''' << eachPackageName << '''.
' ].
						 s << '	]' ]) ]
]

{ #category : 'execution' }
TITMetaLinksRealTimeTypeInferer class >> loadMajorProjects [

	<script>
	TITMajorProjectsLoader loadProjects
]

{ #category : 'execution' }
TITMetaLinksRealTimeTypeInferer class >> prepareForRunning [

	<script>
	self
		loadMajorProjects;
		generateSplitBaselines
]

{ #category : 'private' }
TITMetaLinksRealTimeTypeInferer class >> projectNames [

	<script: 'self projectNames inspect'>
	^ super projectNames
]

{ #category : 'execution' }
TITMetaLinksRealTimeTypeInferer class >> runBaselinesInSeparateProcesses [

	<script>
	super runBaselinesInSeparateProcesses
]

{ #category : 'execution' }
TITMetaLinksRealTimeTypeInferer class >> splitBaselines [

	^ {
		  BaselineOfIceberg.
		  BaselineOfNewTools.
		  BaselineOfBloc.
		  BaselineOfPharoBootstrap }
]

{ #category : 'adding' }
TITMetaLinksRealTimeTypeInferer >> addLinksToMethod: aMethod [

	insertionVisitor visit: aMethod ast
]

{ #category : 'execution' }
TITMetaLinksRealTimeTypeInferer >> execute [

	[
		self installLinks.
		self runTestsAndExamples.
		self logResults ] ensure: [ self uninstallLinks ]
]

{ #category : 'initialization' }
TITMetaLinksRealTimeTypeInferer >> initialize [

	super initialize.
	self initializeTypeHolders
]

{ #category : 'initialization' }
TITMetaLinksRealTimeTypeInferer >> initializeTypeHolders [

	variableTypes := Dictionary new.
	returnTypes := Dictionary new
]

{ #category : 'adding' }
TITMetaLinksRealTimeTypeInferer >> installLinks [

	| excludedSelectors |
	insertionVisitor ifNotNil: [ insertionVisitor uninstallAll ].
	insertionVisitor := TITMetaLinksInsertionVisitor new.
	insertionVisitor typeGatherer: self.

	excludedSelectors := TraitedMetaclass selectors asSet
	                     , TraitedClass selectors.

	[ :packageJob |
		packageJob max: gatheredPackages size.

		gatheredPackages withIndexDo: [ :eachPackage :packageIndex |
				packageJob title:
					'Installing MetaLinks in package ' , eachPackage name asString
					, ' ( ' , packageIndex asString , '/'
					, gatheredPackages size asString , ' )'.
				packageJob currentValue: packageIndex.

				eachPackage definedClasses do: [ :eachClass |
						eachClass methods , eachClass class methods
							reject: [ :any | excludedSelectors includes: any selector ]
							thenDo: [ :eachMethod | insertionVisitor visit: eachMethod ast ] ] ] ]
		asJob run
]

{ #category : 'logging' }
TITMetaLinksRealTimeTypeInferer >> logResults [

	self logResults: self variableTypes as: 'VarTypes'.
	self logResults: self returnTypes as: 'RetTypes'
]

{ #category : 'logging' }
TITMetaLinksRealTimeTypeInferer >> logResults: contents as: aContentTypeName [

	Smalltalk image isInteractiveGraphic ifTrue: [ contents inspect ].
	(self logFileWithContent: aContentTypeName extension: 'ston')
		ensureDelete;
		writeStreamDo: [ :s | STON put: contents onStreamPretty: s ]
]

{ #category : 'accessing' }
TITMetaLinksRealTimeTypeInferer >> returnTypes [

	^ returnTypes
]

{ #category : 'accessing' }
TITMetaLinksRealTimeTypeInferer >> returnTypesByNames [

	^ ((returnTypes associations groupedBy: [ :eachPair |
		    eachPair key value ]) collect: [ :eachArray |
			   eachArray
				   inject: TITEmptyTypeHolder new
				   into: [ :acc :each | acc , each value ] ]) collect: [ :each |
		  each mergeTypes ]
]

{ #category : 'visiting' }
TITMetaLinksRealTimeTypeInferer >> saveTypeOf: aValue in: anItem to: aDictionary [

	aValue class isClass ifFalse: [
			^ self errorLogEntry: 'Value "' , aValue asString
				  , '" class was not saved because it is not a class: '
				  , aValue class asString ].
	aDictionary
		at: anItem
		ifPresent: [ :currentHolder |
			aDictionary at: anItem put: (currentHolder withValue: aValue) ]
		ifAbsentPut: [ TITAbstractTypeHolder newMostPreciseForValue: aValue ]
]

{ #category : 'visiting' }
TITMetaLinksRealTimeTypeInferer >> saveTypeOf: aValue inReturnOfMethod: aMethodNode [

	| key |
	key := TITClassContentReference
		       toClass: aMethodNode compiledMethod methodClass
		       name: aMethodNode selector.
	self saveTypeOf: aValue in: key to: returnTypes
]

{ #category : 'visiting' }
TITMetaLinksRealTimeTypeInferer >> saveTypeOf: aValue inVariable: aVariableNode [

	| key |
	key := TITClassContentReference
		       toClass: aVariableNode methodNode compiledMethod methodClass
		       name: aVariableNode name.
	self saveTypeOf: aValue in: key to: variableTypes
]

{ #category : 'execution' }
TITMetaLinksRealTimeTypeInferer >> uninstallLinks [

	insertionVisitor ifNil: [ ^ self ].
	insertionVisitor uninstallAll
]

{ #category : 'accessing' }
TITMetaLinksRealTimeTypeInferer >> variableTypes [

	^ variableTypes
]

{ #category : 'accessing' }
TITMetaLinksRealTimeTypeInferer >> variableTypesByNames [

	^ ((variableTypes associations groupedBy: [ :eachPair |
		    eachPair key value ]) collect: [ :eachArray |
			   eachArray
				   inject: TITEmptyTypeHolder new
				   into: [ :acc :each | acc , each value ] ]) collect: [ :each |
		  each mergeTypes ]
]
