"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : 'ManifestTypeInfoToolsMessageList',
	#superclass : 'PackageManifest',
	#category : 'TypeInfoTools-MessageList-Manifest',
	#package : 'TypeInfoTools-MessageList',
	#tag : 'Manifest'
}

{ #category : 'code-critics' }
ManifestTypeInfoToolsMessageList class >> ruleClassNotReferencedRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGClassDefinition #(#TITBrowseImplementorsCommand)) #'2025-01-14T19:04:17.555+01:00') )
]
