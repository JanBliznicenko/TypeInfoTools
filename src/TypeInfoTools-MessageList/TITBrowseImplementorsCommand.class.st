Class {
	#name : 'TITBrowseImplementorsCommand',
	#superclass : 'SycSourceCodeCommand',
	#category : 'TypeInfoTools-MessageList-Commands',
	#package : 'TypeInfoTools-MessageList',
	#tag : 'Commands'
}

{ #category : 'testing' }
TITBrowseImplementorsCommand class >> canBeExecutedInContext: aSourceCodeContext [

	^ (super canBeExecutedInContext: aSourceCodeContext) and: [
		  aSourceCodeContext isMessageSelected ]
]

{ #category : 'activation' }
TITBrowseImplementorsCommand class >> sourceCodeMenuActivation [

	<classAnnotation>
	^ SycSourceCodeMenuActivation byRootGroupItemFor:
		  ClyMethodSourceCodeContext
]

{ #category : 'activation' }
TITBrowseImplementorsCommand class >> sourceCodeShortcutActivation [

	<classAnnotation>
	^ CmdShortcutActivation
		  by: $m meta shift
		  for: ClyMethodSourceCodeContext
]

{ #category : 'accessing' }
TITBrowseImplementorsCommand >> defaultMenuIconName [

	^ #hierarchy
]

{ #category : 'accessing' }
TITBrowseImplementorsCommand >> defaultMenuItemName [

	^ 'Implementors with type inference'
]

{ #category : 'execution' }
TITBrowseImplementorsCommand >> execute [

	^ [ :job |
	  job title: 'Running type inference'.
	  self executeInJob: job ] asJob run
]

{ #category : 'execution' }
TITBrowseImplementorsCommand >> executeInJob: job [

	| titNode collector |
	titNode := TITTypedNodeCreationVisitor visit: sourceNode receiver.

	collector := TITSequentialAdaptorsTypeCollector new
		             reportingBlock: [ :typer |
			             job currentValue: job currentValue + 1 ];
		             yourself.
	job max: collector collectors size.
	collector addTypesTo: titNode.

	^ TITMessageBrowser new
		  setRefreshingBlockForImplementorsOf: sourceNode selector;
		  typeInfo: titNode typeInfo;
		  title: 'Implementors of ' , sourceNode selector;
		  messages: sourceNode selector implementors;
		  open
]

{ #category : 'ui - dialogs' }
TITBrowseImplementorsCommand >> informNoneFound [

	self inform: 'No types were found'
]

{ #category : 'execution' }
TITBrowseImplementorsCommand >> showSingleItem: aTITNode [

	^ TITTypedNodePresenter openOn: aTITNode
]
