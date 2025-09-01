Class {
	#name : 'TITMetaLinksRunTimeTypeInferer',
	#superclass : 'TITTestsAndExamplesRunner',
	#instVars : [
		'insertionVisitor',
		'variableTypes',
		'returnTypes'
	],
	#category : 'TypeInfoTools-RunTimeGatherer-Gathering',
	#package : 'TypeInfoTools-RunTimeGatherer',
	#tag : 'Gathering'
}

{ #category : 'private' }
TITMetaLinksRunTimeTypeInferer class >> baselines [

	<script: 'self baselines inspect'>
	| thisDirName imagesDir |
	thisDirName := FileLocator imageDirectory basename.
	imagesDir := FileLocator imageDirectory parent asFileReference.
	^ super baselines reject: [ :each |
			  | baselineName baselineDir |
			  baselineName := self nameOfBaseline: each.
			  baselineDir := imagesDir / (thisDirName , '_' , baselineName).
			  baselineDir exists and: [
					  ((baselineDir files select: [ :any |
						    any basename endsWith: self retTypesFilename , '.ston' ])
						   anySatisfy: [ :any | any size > 20 ]) or: [
							  (baselineDir files select: [ :any |
								   any basename endsWith: '_Log.txt' ]) anySatisfy: [ :any |
									  any readStreamDo: [ :s |
											  | log |
											  log := s upToEnd.
											  (log includesSubstring: '0 test classes') and: [
												  log includesSubstring: '0 examples' ] ] ] ] ] ]
]

{ #category : 'examples' }
TITMetaLinksRunTimeTypeInferer class >> example [

	super example
]

{ #category : 'debugging' }
TITMetaLinksRunTimeTypeInferer class >> findPackagesInMultipleBaselines [

	<script: 'self findPackagesInMultipleBaselines inspect'>
	| packageNamesOfBaselines |
	packageNamesOfBaselines := TITDependentPackagesFinder
		                           baselinesForInference collect: [ :each |
		                           each
		                           -> (each version packages collect: #name) ].
	^ ((self packageOrganizer packages
		    collect: [ :eachPackage |
				    eachPackage -> (packageNamesOfBaselines
					     select: [ :baselineWithPackageNames |
						     baselineWithPackageNames value includes: eachPackage name ]
					     thenCollect: [ :baselineWithPackageNames |
						     baselineWithPackageNames key name asString ]) sorted ]
		    thenSelect: [ :baselineWithPackageNames |
		    baselineWithPackageNames value size > 1 ]) sorted: [ :a :b |
			   a value first = b value first
				   ifTrue: [ a value second < b value second ]
				   ifFalse: [ a value first < b value first ] ])
		  asOrderedDictionary
]

{ #category : 'execution' }
TITMetaLinksRunTimeTypeInferer class >> generateSplitBaselines [

	<script>
	self splitBaselines do: [ :each |
		self generateSplitBaselinesFrom: each ]
]

{ #category : 'execution' }
TITMetaLinksRunTimeTypeInferer class >> generateSplitBaselinesFrom: originalBaseline [

	| packageNamesWithParts firstParts splitPartIndex packagesWithPartsByNames originalBaselineName commonPrefixLength |
	originalBaselineName := originalBaseline name allButFirst: 10.
	packageNamesWithParts := originalBaseline version
		                         loadedSystemPackages collect: [ :each |
		                         each name -> (each name splitOn: '-') ].
	firstParts := Set new.
	splitPartIndex := packageNamesWithParts
		                  detect: [ :eachPackageNameWithParts |
				                  firstParts add:
					                  eachPackageNameWithParts value first.
				                  firstParts size > 5 ]
		                  ifFound: [ 1 ]
		                  ifNone: [ 2 ].
	commonPrefixLength := (packageNamesWithParts allSatisfy: [ :each |
		                       each key beginsWith: originalBaselineName ])
		                      ifTrue: [ originalBaselineName size ]
		                      ifFalse: [ 0 ].
	packagesWithPartsByNames := packageNamesWithParts groupedBy: [ :each |
			                            each value size < splitPartIndex
				                            ifTrue: [ 'CoreRoot' ]
				                            ifFalse: [
						                            (String streamContents: [ :s |
							                             1 to: splitPartIndex do: [ :i |
							                             s << (each value at: i) ] ])
							                            allButFirst: commonPrefixLength ] ].
	packagesWithPartsByNames keysAndValuesDo: [
			:basename
			:eachPackageNamesWithParts |
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
						 eachPackageNamesWithParts do: [ :eachPackageNameWithParts |
								 s << '			spec package: ''' << eachPackageNameWithParts key
								 << '''.
' ].
						 s << '	]' ]) ]
]

{ #category : 'execution' }
TITMetaLinksRunTimeTypeInferer class >> loadMajorProjects [

	<script>
	TITMajorProjectsLoader loadProjects
]

{ #category : 'execution' }
TITMetaLinksRunTimeTypeInferer class >> prepareForRunning [

	<script>
	self
		loadMajorProjects;
		generateSplitBaselines
]

{ #category : 'private' }
TITMetaLinksRunTimeTypeInferer class >> projectNames [

	<script: 'self projectNames inspect'>
	^ super projectNames
]

{ #category : 'constants' }
TITMetaLinksRunTimeTypeInferer class >> retTypesFilename [

	^ '_RetTypes'
]

{ #category : 'execution' }
TITMetaLinksRunTimeTypeInferer class >> runBaselinesInSeparateProcesses [

	<script>
	super runBaselinesInSeparateProcesses
]

{ #category : 'execution' }
TITMetaLinksRunTimeTypeInferer class >> splitBaselines [

	^ {
		  BaselineOfIceberg.
		  BaselineOfNewTools.
		  BaselineOfBloc.
		  BaselineOfMonticello.
		  BaselineOfMorphic.
		  BaselineOfPharoBootstrap }
]

{ #category : 'constants' }
TITMetaLinksRunTimeTypeInferer class >> varTypesFilename [

	^ '_VarTypes'
]

{ #category : 'adding' }
TITMetaLinksRunTimeTypeInferer >> addLinksToMethod: aMethod [

	insertionVisitor visit: aMethod ast
]

{ #category : 'accessing' }
TITMetaLinksRunTimeTypeInferer >> detectRecursion [

	| checkedContext method |
	
	checkedContext := thisContext sender.
	method := checkedContext method.
	[
		checkedContext := checkedContext sender.
		checkedContext isNotNil ] whileTrue: [
			method = checkedContext method ifTrue: [
					self errorLogEntry: 'Detected recursion'.
					TITRecursionDetectedException signal.
					^ true ] ].
	^ false
]

{ #category : 'execution' }
TITMetaLinksRunTimeTypeInferer >> execute [

	[
		self installLinks.
		self runTestsAndExamples.
		self logResults ] ensure: [ self uninstallLinks ]
]

{ #category : 'initialization' }
TITMetaLinksRunTimeTypeInferer >> initialize [

	super initialize.
	self initializeTypeHolders
]

{ #category : 'initialization' }
TITMetaLinksRunTimeTypeInferer >> initializeTypeHolders [

	variableTypes := Dictionary new.
	returnTypes := Dictionary new
]

{ #category : 'adding' }
TITMetaLinksRunTimeTypeInferer >> installLinks [

	insertionVisitor ifNotNil: [ insertionVisitor uninstallAll ].
	insertionVisitor := TITMetaLinksInsertionVisitor new.
	insertionVisitor typeGatherer: self.

	[ :packageJob |
		packageJob max: gatheredPackages size.

		gatheredPackages withIndexDo: [ :eachPackage :packageIndex |
				packageJob title:
					'Installing MetaLinks in package ' , eachPackage name asString
					, ' ( ' , packageIndex asString , '/'
					, gatheredPackages size asString , ' )'.
				packageJob currentValue: packageIndex.

				(eachPackage definedClasses reject: [ :eachClass |
					 eachClass isTrait ]) do: [ :eachClass |
						self installLocallyMethodsFromTraitsIn: eachClass.
						self installLocallyMethodsFromTraitsIn: eachClass class.

						eachClass methods do: [ :eachMethod |
							insertionVisitor visit: eachMethod ast ].
						eachClass class methods do: [ :eachMethod |
							insertionVisitor visit: eachMethod ast ] ] ] ] asJob run
]

{ #category : 'adding' }
TITMetaLinksRunTimeTypeInferer >> installLocallyMethodsFromTraitsIn: aClass [

	aClass methods
		select: [ :each |
				each isFromTrait and: [
						((aClass isMeta
							  ifTrue: [
							  TraitedMetaclass selectors , TraitedClass selectors ]
							  ifFalse: [ TraitedClass selectors ]) includes: each selector)
							not ] ]
		thenDo: [ :each | aClass compile: each sourceCode ]
]

{ #category : 'logging' }
TITMetaLinksRunTimeTypeInferer >> logResults [

	self logResults: self variableTypes as: 'VarTypes'.
	self logResults: self returnTypes as: 'RetTypes'
]

{ #category : 'logging' }
TITMetaLinksRunTimeTypeInferer >> logResults: contents as: aContentTypeName [

	Smalltalk image isInteractiveGraphic ifTrue: [ contents inspect ].
	(self logFileWithContent: aContentTypeName extension: 'ston')
		ensureDelete;
		writeStreamDo: [ :s | (STON writer on: s)
	prettyPrint: true;
	referencePolicy: #ignore;
	nextPut: contents ]
]

{ #category : 'accessing' }
TITMetaLinksRunTimeTypeInferer >> returnTypes [

	^ returnTypes
]

{ #category : 'accessing' }
TITMetaLinksRunTimeTypeInferer >> returnTypesByNames [

	^ ((returnTypes associations groupedBy: [ :eachPair |
		    eachPair key value ]) collect: [ :eachArray |
			   eachArray
				   inject: TITEmptyTypeHolder new
				   into: [ :acc :each | acc , each value ] ]) collect: [ :each |
		  each mergeTypes ]
]

{ #category : 'visiting' }
TITMetaLinksRunTimeTypeInferer >> saveTypeOf: aValue in: anItem to: aDictionary [

	self detectRecursion.
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
TITMetaLinksRunTimeTypeInferer >> saveTypeOf: anObject inReturnReference: aClassItemReference [

	self saveTypeOf: anObject in: aClassItemReference to: returnTypes
]

{ #category : 'visiting' }
TITMetaLinksRunTimeTypeInferer >> saveTypeOf: anObject inVariableReference: aClassItemReference [

	self saveTypeOf: anObject in: aClassItemReference to: variableTypes
]

{ #category : 'execution' }
TITMetaLinksRunTimeTypeInferer >> uninstallLinks [

	insertionVisitor ifNil: [ ^ self ].
	insertionVisitor uninstallAll
]

{ #category : 'accessing' }
TITMetaLinksRunTimeTypeInferer >> variableTypes [

	^ variableTypes
]

{ #category : 'accessing' }
TITMetaLinksRunTimeTypeInferer >> variableTypesByNames [

	^ ((variableTypes associations groupedBy: [ :eachPair |
		    eachPair key value ]) collect: [ :eachArray |
			   eachArray
				   inject: TITEmptyTypeHolder new
				   into: [ :acc :each | acc , each value ] ]) collect: [ :each |
		  each mergeTypes ]
]
