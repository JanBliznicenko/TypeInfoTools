Class {
	#name : 'TITMetaLinksRealTimeTypeInferer',
	#superclass : 'TITTestsAndExamplesRunner',
	#instVars : [
		'insertionVisitor',
		'variableTypes',
		'returnTypes'
	],
	#category : 'TypeInfoTools-Dev-RealTime',
	#package : 'TypeInfoTools-Dev',
	#tag : 'RealTime'
}

{ #category : 'examples' }
TITMetaLinksRealTimeTypeInferer class >> example [

	super example
]

{ #category : 'private' }
TITMetaLinksRealTimeTypeInferer class >> prepareDirectoryForProjectNamed: projectName [

	| sourceName sourceDirectory targetName targetDirectory |
	sourceName := FileLocator image basenameWithoutExtension.
	sourceDirectory := FileLocator imageDirectory asFileReference.
	targetName := sourceName , '_' , projectName.
	targetDirectory := (sourceDirectory parent / targetName)
		                   asFileReference.
	targetDirectory ensureDeleteAllChildren.
	targetDirectory ensureCreateDirectory.
	sourceDirectory files
		select: [ :each |
				each basename endsWithAnyOf:
					#( '.version' '.sources' '.changes' '.image' ) ]
		thenDo: [ :each |
				each copyTo: targetDirectory
					/ (each basename copyReplaceAll: sourceName with: targetName) ].
	^ targetDirectory / (targetName , '.image')
]

{ #category : 'private' }
TITMetaLinksRealTimeTypeInferer class >> prepareVmForThread: anIndex [

	| sourceDirectory sourceDirectoryName targetDirectoryName targetDirectory originalTargetExe targetExeName targetExe |
	sourceDirectory := FileLocator vmDirectory asFileReference.
	sourceDirectoryName := sourceDirectory basename.
	targetDirectoryName := sourceDirectoryName , '_' , anIndex asString.
	targetDirectory := sourceDirectory parent / targetDirectoryName.
	originalTargetExe := targetDirectory / 'PharoConsole.exe'.
	targetExeName := 'PharoConsole_' , anIndex asString , '.exe'.
	targetExe := targetDirectory / targetExeName.
	targetExe exists ifTrue: [
			targetExe isWritable ifFalse: [ self notify: 'VM in use' ].
			^ targetExe ].
	targetDirectory ensureDeleteAllChildren.
	targetDirectory ensureCreateDirectory.
	sourceDirectory copyAllTo: targetDirectory.
	originalTargetExe renameTo: targetExeName.
	^ targetExe
]

{ #category : 'examples' }
TITMetaLinksRealTimeTypeInferer class >> runBaselinesInSeparateProcesses [

	<script>
	| projectNames getNextProjectName mutex threads |
	threads := 20.
	projectNames := self projectNames.
	mutex := Mutex new.
	getNextProjectName := [ mutex critical: [ projectNames removeFirst ] ].

	1 to: threads do: [ :threadIndex |
			| vm |
			vm := self prepareVmForThread: threadIndex.
			[
				[ mutex critical: [ projectNames isNotEmpty ] ] whileTrue: [
						| projectName imageFile |
						projectName := getNextProjectName value.
						imageFile := self prepareDirectoryForProjectNamed: projectName.
						self
							runProjectNamed: projectName
							image: imageFile
							vm: vm
							threadIndex: threadIndex ] ]
				forkAt: Processor userBackgroundPriority
				named: self name , '-' , threadIndex asString ]
]

{ #category : 'examples' }
TITMetaLinksRealTimeTypeInferer class >> runProjectNamed: projectName image: anImageFile vm: vm threadIndex: threadIndex [

	| process |
	Transcript crShow:
		threadIndex asString , ': Processing ' , projectName.
	process := OSWSWinProcess new.
	process
		command: vm displayString;
		workingDirectory: anImageFile parent displayString;
		arguments: {
				'--headless'.
				anImageFile displayString.
				('eval [TITMetaLinksRealTimeTypeInferer gatherBaselineNamed: '''
				 , projectName
				 ,
					 '''] on: Error do: [ :e |  ]. Smalltalk snapshot: false andQuit: true') };
		run.
	[ process isRunning ] whileTrue: [ 5 seconds wait ].
	Transcript crShow: threadIndex asString , ': Finished ' , projectName
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

{ #category : 'accessing' }
TITMetaLinksRealTimeTypeInferer >> returnTypes [

	^ returnTypes
]

{ #category : 'accessing' }
TITMetaLinksRealTimeTypeInferer >> returnTypesByNames [

	^ (((returnTypes associations collect: [ :eachPair |
		     eachPair key selector -> eachPair value ]) groupedBy: [
		    :eachPair | eachPair key ]) collect: [ :eachArray |
			   eachArray
				   inject: TITEmptyTypeHolder new
				   into: [ :acc :each | acc , each value ] ]) collect: [ :each |
		  each mergeTypes ]
]

{ #category : 'accessing' }
TITMetaLinksRealTimeTypeInferer >> returnTypesByNamesAsStrings [

	^ self returnTypesByNames
		  do: [ :eachClass | eachClass convertTypesToString ];
		  yourself
]

{ #category : 'visiting' }
TITMetaLinksRealTimeTypeInferer >> saveTypeOf: aValue in: aNode to: aDictionary [

	aNode ifNil: [ self error: 'Node cannot be nil' ].
	aDictionary
		at: aNode
		ifPresent: [ :currentHolder |
				thisContext mayBeInRecursion ifTrue: [
						^ self errorLogEntry:
							  'Did not save type because of potential recursion in '
							  , (aNode methodNode compiledMethod printString ifEmpty: [
									   aNode asString ]) ].
				aDictionary at: aNode put: (currentHolder withValue: aValue) ]
		ifAbsentPut: [ TITAbstractTypeHolder newBestForValue: aValue ]
]

{ #category : 'visiting' }
TITMetaLinksRealTimeTypeInferer >> saveTypeOf: aValue inReturnOfMethod: aMethodNode [

	self saveTypeOf: aValue in: aMethodNode to: returnTypes
]

{ #category : 'visiting' }
TITMetaLinksRealTimeTypeInferer >> saveTypeOf: aValue inVariable: aVariableNode [

	| originalVariable |
	originalVariable := aVariableNode variable definingNode ifNil: [
			                    aVariableNode variable originalVar definingNode
				                    ifNil: [ aVariableNode variable ] ].
	self saveTypeOf: aValue in: originalVariable to: variableTypes
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

	^ (((variableTypes associations collect: [ :eachPair |
		     eachPair key name -> eachPair value ]) groupedBy: [ :eachPair |
		    eachPair key ]) collect: [ :eachArray |
			   eachArray
				   inject: TITEmptyTypeHolder new
				   into: [ :acc :each | acc , each value ] ]) collect: [ :each |
		  each mergeTypes ]
]

{ #category : 'accessing' }
TITMetaLinksRealTimeTypeInferer >> variableTypesByNamesAsStrings [

	^ self variableTypesByNames
		  do: [ :eachClass | eachClass convertTypesToString ];
		  yourself
]
