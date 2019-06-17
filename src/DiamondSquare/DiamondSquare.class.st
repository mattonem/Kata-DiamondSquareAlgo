Class {
	#name : #DiamondSquare,
	#superclass : #Object,
	#instVars : [
		'map'
	],
	#category : #DiamondSquare
}

{ #category : #'as yet unclassified' }
DiamondSquare class >> newSize: anInteger rand: rand [
	^ self new initialSize: anInteger rand: rand
]

{ #category : #'as yet unclassified' }
DiamondSquare >> asBlGrid [
	<gtExample>
	| size maxVal cells minVal |
	size := map size sqrt.
	minVal := map min.
	maxVal := map max - minVal.
	cells := OrderedCollection new.
	1 to: size do: [ :i | 
		1 to: size do:
			[ :j | cells add: (self blCell: ((map at: i @ j) - minVal) / maxVal) ] ].
	^ self grid
		addChildren: cells;
		yourself
]

{ #category : #'as yet unclassified' }
DiamondSquare >> blCell: aValue [
	<gtExample>
	
	^ BlElement new
		size: 1@1;
		background: (Color gray: aValue) .
]

{ #category : #'as yet unclassified' }
DiamondSquare >> grid [
	<gtExample>
	
	^ BlElement new
		background: Color lightBlue;
		constraintsDo: [ :c |
			c horizontal fitContent.
			c vertical matchParent ];
		layout: BlGridLayout vertical;
		layoutDo: [ :l | l cellSpacing: 0; rowCount: map size sqrt ]
]

{ #category : #'as yet unclassified' }
DiamondSquare >> initialSize: anInteger rand: rand [
	map := Dictionary new. 
	1 to: anInteger do: [ :i | 1 to: anInteger do: [ :j | map at: (i@j) put: NewValueHolder new ] ].
	self prepareDiamond: 1@1 to: anInteger@anInteger rand: rand.
	(map at: 1@1) contents: (rand nextInt:anInteger).
	(map at: 1@anInteger) contents: (rand nextInt:anInteger).	
	(map at: anInteger@1) contents: (rand nextInt:anInteger).	
	(map at: anInteger@anInteger) contents: (rand nextInt:anInteger).
	map := map collect: #contents.
	self normalize
]

{ #category : #'as yet unclassified' }
DiamondSquare >> map [
	^ map
]

{ #category : #'as yet unclassified' }
DiamondSquare >> morph [
	| size morph |
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

{ #category : #'as yet unclassified' }
DiamondSquare >> normalize [
	| minVal maxVal |
	minVal := map min.
	maxVal := map max - minVal.
	map
		keysAndValuesDo: [ :coord :value | map at: coord put: (value - minVal) / maxVal ]
]

{ #category : #'as yet unclassified' }
DiamondSquare >> prepareDiamond: p1 to: p4 rand: rand [
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
	{p1.
	p4.
	(p1 x @ p4 y).
	(p4 x @ p1 y)}
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
												+ ((rand nextInt: variation) - (variation / 2)) ] ] ] ].
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

{ #category : #'as yet unclassified' }
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
												+ ((rand nextInt: variation) - (variation / 2)) ] ] ] ].
]
