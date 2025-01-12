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
ManifestTypeInfoToolsBrowser class >> ruleInconsistentMethodClassificationRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#TITTypedNodePresenter #update #false)) #'2025-01-12T14:39:57.645+01:00') )
]
