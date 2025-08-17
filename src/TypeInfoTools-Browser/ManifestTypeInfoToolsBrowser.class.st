"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : 'ManifestTypeInfoToolsBrowser',
	#superclass : 'PackageManifest',
	#category : 'TypeInfoTools-Browser-Manifest',
	#package : 'TypeInfoTools-Browser',
	#tag : 'Manifest'
}

{ #category : 'code-critics' }
ManifestTypeInfoToolsBrowser class >> ruleClassNotReferencedRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGClassDefinition #(#TITShowTypesMethodReturnCommand)) #'2025-01-14T19:03:58.363+01:00') #(#(#RGClassDefinition #(#TITShowTypesMessageSendCommand)) #'2025-01-14T19:04:02.814+01:00') #(#(#RGClassDefinition #(#TITShowTypesInstVarCommand)) #'2025-01-14T19:04:06.33+01:00') #(#(#RGClassDefinition #(#TITShowTypesTempVariableCommand)) #'2025-01-14T19:04:09.877+01:00') )
]
