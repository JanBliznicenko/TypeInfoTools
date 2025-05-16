Extension { #name : 'MetaLink' }

{ #category : '*TypeInfoTools-Core' }
MetaLink class >> uniqueValidArgumentsByNodes [

	<script: 'self uniqueValidArgumentsByNodes inspect'>
	^ RFReification uniqueKeysByEntities
]

{ #category : '*TypeInfoTools-Core' }
MetaLink class >> validArgumentsByNodes [

	<script: 'self validArgumentsByNodes inspect'>
	^ RFReification keysByEntities
]
