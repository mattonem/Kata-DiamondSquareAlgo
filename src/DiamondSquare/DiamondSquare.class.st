Class {
	#name : 'DiamondSquare',
	#superclass : 'Object',
	#instVars : [
		'map'
	],
	#pools : [
		'PjBrowserGlobals'
	],
	#category : 'DiamondSquare',
	#package : 'DiamondSquare'
}

{ #category : 'as yet unclassified' }
DiamondSquare class >> example [
	<pharoJsSkip>
	<script>
	(self newSize: 9 rand: Random new) inspect
]

{ #category : 'as yet unclassified' }
DiamondSquare class >> newSize: anInteger rand: rand [
	^ self new initialSize: anInteger rand: rand
]

{ #category : 'as yet unclassified' }
DiamondSquare >> averageOf: aCollection [

	^ (self sumOf: aCollection) / aCollection size
]

{ #category : 'as yet unclassified' }
DiamondSquare >> initialSize: anInteger rand: rand [

	map := Dictionary new.
	1 to: anInteger do: [ :i |
		1 to: anInteger do: [ :j | map at: i @ j put: self newValueHolder ] ].
	self prepareDiamond: 1 @ 1 to: anInteger @ anInteger rand: rand.
	(map at: 1 @ 1) contents: (rand nextInteger: anInteger).
	(map at: 1 @ anInteger) contents: (rand nextInteger: anInteger).
	(map at: anInteger @ 1) contents: (rand nextInteger: anInteger).
	(map at: anInteger @ anInteger) contents:
		(rand nextInteger: anInteger).
	map := map collect: #contents.
	self normalize
]

{ #category : 'as yet unclassified' }
DiamondSquare >> map [
	^ map
]

{ #category : 'as yet unclassified' }
DiamondSquare >> mapMax [

	^ map inject: map anyOne into: [ :min :each | min max: each ]
]

{ #category : 'as yet unclassified' }
DiamondSquare >> mapMin [

	^ map inject: map anyOne into: [ :min :each | min min: each ]
]

{ #category : 'as yet unclassified' }
DiamondSquare >> morph [
	| size morph |
	<pharoJsSkip>
	size := map size sqrt.
	morph := ColorForm extent: size @ size depth: 16.
	map
		keysAndValuesDo: [ :coord :value | 
			morph
				colorAt: coord - (1 @ 1)
				put:
					(Color
						colorFromPixelValue: ((Color gray: value) basicPixelValueForDepth: 8)
						depth: 8) ].
	^ morph
]

{ #category : 'as yet unclassified' }
DiamondSquare >> newValueHolder [
	^ CustomValueHolder new
]

{ #category : 'as yet unclassified' }
DiamondSquare >> normalize [
	| minVal maxVal |
	minVal := self mapMin.
	maxVal := self mapMax - minVal.
	map
		keysAndValuesDo: [ :coord :value | map at: coord put: (value - minVal) / maxVal ]
]

{ #category : 'as yet unclassified' }
DiamondSquare >> prepareDiamond: p1 to: p4 rand: rand [

	| variation midPoint values coords |
	variation := (p4 - p1 / 2) x.
	variation < 1 ifTrue: [ ^ self ].
	midPoint := (p4 - p1 / 2 + p1) asIntegerPoint.
	map at: midPoint ifAbsent: [ ^ self ].
	midPoint = p1 ifTrue: [ ^ self ].
	values := OrderedCollection new.
	coords := OrderedCollection new.
	{
		p1.
		p4.
		(p1 x @ p4 y).
		(p4 x @ p1 y) } do: [ :coord |
		map at: coord asIntegerPoint ifPresent: [ :el |
			values add: el.
			coords add: coord ] ].
	values do: [ :el |
		el whenChangedDo: [ :ev |
			(map at: midPoint) contents ifNil: [
				(values allSatisfy: [ :el2 | el2 contents isNotNil ]) ifTrue: [
					(map at: midPoint) contents: (self averageOf: (values collect: #contents))
						+ ((rand nextInteger: variation) - (variation / 2)) ] ] ] ].
	self
		prepareSquare: p1 - (variation @ 0)
		to: p4 - (variation @ 0)
		rand: rand.
	self
		prepareSquare: p1 + (variation @ 0)
		to: p4 + (variation @ 0)
		rand: rand.
	self
		prepareSquare: p1 - (0 @ variation)
		to: p4 - (0 @ variation)
		rand: rand.
	self
		prepareSquare: p1 + (0 @ variation)
		to: p4 + (0 @ variation)
		rand: rand.
	self prepareDiamond: p1 to: p4 - (variation @ variation) rand: rand.
	self
		prepareDiamond: p1 + (variation @ 0)
		to: p4 - (0 @ variation)
		rand: rand.
	self
		prepareDiamond: p1 + (0 @ variation)
		to: p4 - (variation @ 0)
		rand: rand.
	self prepareDiamond: p1 + (variation @ variation) to: p4 rand: rand
]

{ #category : 'as yet unclassified' }
DiamondSquare >> prepareSquare: p1 to: p4 rand: rand [
	| variation midPoint values coords |
	variation := ((p4 - p1) / 2) x.
	variation < 1
		ifTrue: [ ^ self ].
	midPoint := ((p4 - p1) / 2 + p1) asIntegerPoint.
	map at: midPoint ifAbsent: [ ^ self ].
	midPoint = p1
		ifTrue: [ ^ self ].
	values := OrderedCollection new.
	coords := OrderedCollection new.
	{(midPoint x @ p1 y).
	(p1 x @ midPoint y).
	(p4 x @ midPoint y).
	(midPoint x @ p4 y)}
		do: [ :coord | 
			map
				at: coord asIntegerPoint
				ifPresent: [ :el | 
					values add: el.
					coords add: coord ] ].
	values
		do: [ :el | 
			el
				whenChangedDo: [ :ev | 
					(map at: midPoint) contents
						ifNil: [ (values allSatisfy: [ :el2 | el2 contents isNotNil ])
								ifTrue: [ (map at: midPoint)
										contents:
											(values collect: #contents) average
												+ ((rand nextInteger: variation) - (variation / 2)) ] ] ] ].
]

{ #category : 'as yet unclassified' }
DiamondSquare >> sumOf: aCollection [ 
	| sample sum |
	sample := aCollection anyOne.
	sum := aCollection inject: sample into: [ :accum :each | accum + each ].
	^ sum - sample
]
