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
TITMetaLinksRealTimeTypeInferer class >> example [

	super example
]

{ #category : 'debugging' }
TITMetaLinksRealTimeTypeInferer class >> findPackagesInMultipleBaselines [

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
TITMetaLinksRealTimeTypeInferer class >> generateSplitBaselines [

	<script>
	self splitBaselines do: [ :each |
		self generateSplitBaselinesFrom: each ]
]

{ #category : 'execution' }
TITMetaLinksRealTimeTypeInferer class >> generateSplitBaselinesFrom: originalBaseline [

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

{ #category : 'constants' }
TITMetaLinksRealTimeTypeInferer class >> retTypesFilename [

	^ '_RetTypes'
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
		  BaselineOfMonticello.
		  BaselineOfMorphic.
		  BaselineOfPharoBootstrap }
]

{ #category : 'constants' }
TITMetaLinksRealTimeTypeInferer class >> varTypesFilename [

	^ '_VarTypes'
]

{ #category : 'adding' }
TITMetaLinksRealTimeTypeInferer >> addLinksToMethod: aMethod [

	insertionVisitor visit: aMethod ast
]

{ #category : 'accessing' }
TITMetaLinksRealTimeTypeInferer >> detectRecursion [

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
TITMetaLinksRealTimeTypeInferer >> installLocallyMethodsFromTraitsIn: aClass [

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
TITMetaLinksRealTimeTypeInferer >> logResults [

	self logResults: self variableTypes as: 'VarTypes'.
	self logResults: self returnTypes as: 'RetTypes'
]

{ #category : 'logging' }
TITMetaLinksRealTimeTypeInferer >> logResults: contents as: aContentTypeName [

	Smalltalk image isInteractiveGraphic ifTrue: [ contents inspect ].
	(self logFileWithContent: aContentTypeName extension: 'ston')
		ensureDelete;
		writeStreamDo: [ :s | (STON writer on: s)
	prettyPrint: true;
	referencePolicy: #ignore;
	nextPut: contents ]
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
TITMetaLinksRealTimeTypeInferer >> saveTypeOf: anObject inReturnReference: aClassItemReference [

	self saveTypeOf: anObject in: aClassItemReference to: returnTypes
]

{ #category : 'visiting' }
TITMetaLinksRealTimeTypeInferer >> saveTypeOf: anObject inVariableReference: aClassItemReference [

	self saveTypeOf: anObject in: aClassItemReference to: variableTypes
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
