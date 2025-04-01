Class {
	#name : 'TITPartialCompiler',
	#superclass : 'Object',
	#category : 'TypeInfoTools-Core-Inference',
	#package : 'TypeInfoTools-Core',
	#tag : 'Inference'
}

{ #category : 'compiling' }
TITPartialCompiler class >> compileMethod: anOCMethod [

	^ self new compileMethod: anOCMethod
]

{ #category : 'compiling' }
TITPartialCompiler >> compileMethod: anOCMethod [
	"tries several attempts to compile the method"

	"attempt to compile as it is"
	^ self compileMethod: anOCMethod onErrorDo: [
		  self halt.
		  nil ]
]

{ #category : 'compiling' }
TITPartialCompiler >> compileMethod: anOCMethod onErrorDo: aBlock [

	^ anOCMethod compiler
		  permitFaulty: true;
		  compile
]
