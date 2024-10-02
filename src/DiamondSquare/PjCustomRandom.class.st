Class {
	#name : 'PjCustomRandom',
	#superclass : 'Object',
	#pools : [
		'PjUniversalGlobals'
	],
	#category : 'DiamondSquare',
	#package : 'DiamondSquare'
}

{ #category : 'accessing' }
PjCustomRandom >> nextInteger: anInteger [

	^ (Math floor: Math random * (anInteger - 1)) + 1
]
