Class {
	#name : 'TITShowTypesMessageSendCommand',
	#superclass : 'SycSourceCodeCommand',
	#classTraits : 'TITTShowTypesCommand classTrait',
	#category : 'TypeInfoTools-Browser-Commands',
	#package : 'TypeInfoTools-Browser',
	#tag : 'Commands'
}

{ #category : 'testing' }
TITShowTypesMessageSendCommand class >> canBeExecutedInContext: aSourceCodeContext [

	^ (super canBeExecutedInContext: aSourceCodeContext) and: [
		  aSourceCodeContext isMessageSelected ]
]

{ #category : 'activation' }
TITShowTypesMessageSendCommand class >> sourceCodeMenuActivation [

	<classAnnotation>
	^ SycSourceCodeMenuActivation byRootGroupItemFor:
		  ClyMethodSourceCodeContext
]

{ #category : 'activation' }
TITShowTypesMessageSendCommand class >> sourceCodeShortcutActivation [

	<classAnnotation>
	^ CmdShortcutActivation
		  by: $t meta shift
		  for: ClyMethodSourceCodeContext
]

{ #category : 'accessing' }
TITShowTypesMessageSendCommand >> defaultMenuIconName [

	^ #hierarchy
]

{ #category : 'accessing' }
TITShowTypesMessageSendCommand >> defaultMenuItemName [

	^ 'Infer Types'
]

{ #category : 'execution' }
TITShowTypesMessageSendCommand >> execute [

	^ [ :job |
	  job title: 'Running type inference'.
	  self executeInJob: job ] asJob run
]

{ #category : 'execution' }
TITShowTypesMessageSendCommand >> executeInJob: job [

	| titMessageSend collector |
	titMessageSend := TITMessageSendNode forOCMessageNode: sourceNode.

	collector := TITAdaptorsFusionTypeCollector default
		             reportingBlock: [ :typer |
			             job currentValue: job currentValue + 1 ];
		             yourself.
	job max: collector collectors size.
	collector addTypesTo: titMessageSend.

	titMessageSend typeInfo ifEmpty: [ ^ self informNoneFound ].

	^ self showSingleItem: titMessageSend
]

{ #category : 'ui - dialogs' }
TITShowTypesMessageSendCommand >> informNoneFound [

	self inform: 'No types were found'
]

{ #category : 'execution' }
TITShowTypesMessageSendCommand >> showSingleItem: aTITNode [

	^ TITTypedNodeTreePresenter openOn: aTITNode
]
