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
ManifestTypeInfoToolsCore class >> ruleUsesAddRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#TITNameTyperAdaptor #checkName: #false)) #'2024-10-03T05:06:35.534+02:00') )
]
