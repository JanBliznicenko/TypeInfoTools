"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : 'ManifestTypeInfoTools',
	#superclass : 'PackageManifest',
	#category : 'TypeInfoTools-Manifest',
	#package : 'TypeInfoTools',
	#tag : 'Manifest'
}

{ #category : 'code-critics' }
ManifestTypeInfoTools class >> ruleUsesAddRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#TITNameTyperAdaptor #checkName: #false)) #'2024-10-03T05:06:35.534+02:00') )
]
