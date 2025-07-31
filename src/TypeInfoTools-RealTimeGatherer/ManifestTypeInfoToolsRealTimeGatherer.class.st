"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : 'ManifestTypeInfoToolsRealTimeGatherer',
	#superclass : 'PackageManifest',
	#category : 'TypeInfoTools-RealTimeGatherer-Manifest',
	#package : 'TypeInfoTools-RealTimeGatherer',
	#tag : 'Manifest'
}

{ #category : 'code-critics' }
ManifestTypeInfoToolsRealTimeGatherer class >> ruleRefersToClassRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#'TITAbstractTypeHolder class' #withMoreGeneralClasses #true)) #'2025-06-28T21:26:45.683+02:00') )
]

{ #category : 'code-critics' }
ManifestTypeInfoToolsRealTimeGatherer class >> ruleStringConcatenationRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#'TITMetaLinksRealTimeTypeInferer class' #runBaselinesInSeparateProcesses #true)) #'2025-06-09T02:33:49.319+02:00') #(#(#RGMethodDefinition #(#'TITMetaLinksResultsProcessor class' #processTypes: #true)) #'2025-06-30T10:26:37.343+02:00') #(#(#RGMethodDefinition #(#'TITRealTimeInferenceResultsUnifier class' #processTypes: #true)) #'2025-07-13T10:24:00.099+02:00') )
]
