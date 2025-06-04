Class {
	#name : 'TITDependentBaselinesFinder',
	#superclass : 'Object',
	#instVars : [
		'baselines',
		'baselinesByPackages',
		'dependentByBaselines',
		'packages',
		'maxDistance'
	],
	#category : 'TypeInfoTools-Dev-MethodReturns',
	#package : 'TypeInfoTools-Dev',
	#tag : 'MethodReturns'
}

{ #category : 'examples' }
TITDependentBaselinesFinder class >> example [
	"Distance 0 = in the baseline itself
    Distance 1 = direct dependants
    Distance 2+ = included indirect dependants"

	^ (self new
		   baselineClasses: { BaselineOfRoassal };
		   maxDistance: 1;
		   collect;
		   packages) inspect
]

{ #category : 'accessing' }
TITDependentBaselinesFinder >> addAndReportBaseline: aBaseline [

	baselines addIfNotPresent: aBaseline ifPresentDo: [ ^ false ].
	^ true
]

{ #category : 'accessing' }
TITDependentBaselinesFinder >> baselineClasses: aCollectionOfBaselines [

	self baselines: aCollectionOfBaselines
]

{ #category : 'accessing' }
TITDependentBaselinesFinder >> baselines [

	^ baselines
]

{ #category : 'accessing' }
TITDependentBaselinesFinder >> baselines: aCollectionOfBaselines [

	baselines := aCollectionOfBaselines asSet.
	packages := nil
]

{ #category : 'as yet unclassified' }
TITDependentBaselinesFinder >> baselinesByPackages [

	| newBaselinesByPackages |
	baselinesByPackages ifNotNil: [ ^ baselinesByPackages ].
	newBaselinesByPackages := Dictionary new.

	BaselineOf allSubclasses do: [ :eachBaseline |
			eachBaseline version packages do: [ :eachPackageSpec |
					self packageOrganizer
						packageNamed: eachPackageSpec name
						ifPresent: [ :package |
								(newBaselinesByPackages at: package ifAbsentPut: Set new)
									add: eachBaseline ] ] ].

	^ baselinesByPackages := newBaselinesByPackages
]

{ #category : 'accessing' }
TITDependentBaselinesFinder >> collect [

	self collectDistance: 1 fromBaselines: baselines
]

{ #category : 'accessing' }
TITDependentBaselinesFinder >> collectDistance: aCurrentDistance fromBaselines: currentBaselines [

	| dependentBaselines newBaselines |
	aCurrentDistance > maxDistance ifTrue: [ ^ baselines ].

	dependentBaselines := currentBaselines flatCollectAsSet: [
		                      :eachBaseline |
		                      self dependentByBaselines at: eachBaseline ].
	newBaselines := dependentBaselines select: [ :eachBaseline |
		                self addAndReportBaseline: eachBaseline ].
	^ self
		  collectDistance: aCurrentDistance + 1
		  fromBaselines: newBaselines
]

{ #category : 'as yet unclassified' }
TITDependentBaselinesFinder >> dependentByBaselines [

	| newDependentByBaselines |
	dependentByBaselines ifNotNil: [ ^ dependentByBaselines ].
	newDependentByBaselines := Dictionary new.

	BaselineOf allSubclasses do: [ :eachBaseline |
			newDependentByBaselines at: eachBaseline ifAbsentPut: [ Set new ].
			(self dependingOnBaselinesBy: eachBaseline) do: [ :eachDependingOn |
					(newDependentByBaselines
						 at: eachDependingOn
						 ifAbsentPut: [ Set new ]) add: eachBaseline ] ].

	^ dependentByBaselines := newDependentByBaselines
]

{ #category : 'as yet unclassified' }
TITDependentBaselinesFinder >> dependingOnBaselinesBy: aBaseline [

	^ (self dependingOnBaselinesViaBaseline: aBaseline)
	  , (self dependingOnBaselinesViaPackageDependencyBy: aBaseline)
]

{ #category : 'as yet unclassified' }
TITDependentBaselinesFinder >> dependingOnBaselinesViaBaseline: aBaseline [

	^ (aBaseline version projects
		   collect: [ :eachProject |
				   eachProject constructClassName ifNotNil: [ :name |
					   Smalltalk at: name ifAbsent: [ nil ] ] ]
		   thenSelect: [ :eachBaselineClass |
				   eachBaselineClass ~= aBaseline and: [
					   (eachBaselineClass ifNotNil: [ eachBaselineClass version ])
						   isNotNil ] ]) asSet
]

{ #category : 'as yet unclassified' }
TITDependentBaselinesFinder >> dependingOnBaselinesViaPackageDependencyBy: aBaseline [

	^ aBaseline version packages flatCollectAsSet: [ :eachPackage |
			  self haltIf: [ eachPackage name = 'NewTools-Debugger-Fuel' ].
			  (StDependencyChecker new
				   shouldComputeMessageSendDependencies: false;
				   daPackageFor: eachPackage name) dependencies flatCollectAsSet: [
					  :each |
					  (self baselinesByPackages
						   at: each target systemPackage
						   ifAbsent: [ #(  ) ]) reject: [ :any | any = aBaseline ] ] ]
]

{ #category : 'accessing' }
TITDependentBaselinesFinder >> maxDistance: anInteger [
	"Distance 0 = in the baseline itself
    Distance 1 = direct dependants
    Distance 2+ = included indirect dependants"

	maxDistance := anInteger
]

{ #category : 'accessing' }
TITDependentBaselinesFinder >> packages [

	packages := Set new.

	baselines do: [ :eachBaseline |
			eachBaseline version packages do: [ :eachPackage |
					self packageOrganizer
						packageNamed: eachPackage name
						ifPresent: [ :package | packages add: package ] ] ].

	^ packages asSortedCollection
]
