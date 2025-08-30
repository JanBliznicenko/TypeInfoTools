"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : 'ManifestTypeInfoToolsCore',
	#superclass : 'PackageManifest',
	#category : 'TypeInfoTools-Core-Manifest',
	#package : 'TypeInfoTools-Core',
	#tag : 'Manifest'
}

{ #category : 'code-critics' }
ManifestTypeInfoToolsCore class >> ruleCollectionProtocolRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#TITAbstractClassTreeNode #mergeIntoParentWithMyCollectors #false)) #'2025-05-18T12:57:27.866+02:00') )
]

{ #category : 'code-critics' }
ManifestTypeInfoToolsCore class >> ruleFloatReferencesRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#'TITTypesCollection class' #classReplacements #true)) #'2025-05-22T05:11:55.136+02:00') )
]

{ #category : 'code-critics' }
ManifestTypeInfoToolsCore class >> ruleStringConcatenationRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#TITMetaLinksRealTimeTypeInferer #variableTypesByNames #false)) #'2025-05-22T04:40:02.307+02:00') )
]

{ #category : 'code-critics' }
ManifestTypeInfoToolsCore class >> ruleUsesAddRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#TITNameHeuristicsTyperAdaptor #checkName: #false)) #'2024-10-03T05:06:35.534+02:00') #(#(#RGMethodDefinition #(#TITMetaLinksRealTimeTypeInferer #addLinksToMethod: #false)) #'2025-05-15T09:43:46.846+02:00') )
]

{ #category : 'code-critics' }
ManifestTypeInfoToolsCore class >> ruleUsesTrueRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#'TITTypesCollection class' #classReplacements #true)) #'2025-05-22T05:11:48.191+02:00') )
]
