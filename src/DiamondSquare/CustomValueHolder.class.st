Class {
	#name : 'CustomValueHolder',
	#superclass : 'Object',
	#instVars : [
		'contents',
		'el',
		'whenChangedDo'
	],
	#pools : [
		'PjBrowserGlobals'
	],
	#category : 'DiamondSquare',
	#package : 'DiamondSquare'
}

{ #category : 'accessing' }
CustomValueHolder >> contents [
	^ contents
]

{ #category : 'accessing' }
CustomValueHolder >> contents: anObject [

	contents := anObject.
	whenChangedDo do: [ :ablock | ablock value:self ]
]

{ #category : 'accessing' }
CustomValueHolder >> initialize [

	whenChangedDo := OrderedCollection new
]

{ #category : 'accessing' }
CustomValueHolder >> whenChangedDo: aBlock [

	whenChangedDo add: aBlock
]
