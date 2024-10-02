Class {
	#name : 'BaselineOfDiamondSquare',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfDiamondSquare',
	#package : 'BaselineOfDiamondSquare'
}

{ #category : 'baselines' }
BaselineOfDiamondSquare >> baseline: spec [

	<baseline>
	spec for: #common do: [
		spec
			baseline: 'Camping'
			with: [ spec repository: 'github://mattonem/WildCamping:master' ].

		spec package: #DiamondSquare with: [ spec requires: #( Camping ) ] ]
]
