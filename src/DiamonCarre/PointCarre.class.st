Class {
	#name : #PointCarre,
	#superclass : #Object,
	#instVars : [
		'map'
	],
	#category : #DiamonCarre
}

{ #category : #'as yet unclassified' }
PointCarre class >> carreOn: aCollection from: p1 to: p4 rand: rand [
	| variation midPoint values |
	variation := ((p4 - p1) / 2) x.
	variation < 1
		ifTrue: [ ^ self ].
	midPoint := ((p4 - p1) / 2 + p1) asIntegerPoint.
	aCollection at: midPoint ifAbsent: [ ^ self ].
	midPoint = p1
		ifTrue: [ ^ self ].
	values := OrderedCollection new.
	{(midPoint x @ p1 y).
	(p1 x @ midPoint y).
	(p4 x @ midPoint y).
	(midPoint x @ p4 y)}
		do: [ :coord | 
			aCollection
				at: coord asIntegerPoint
				ifPresent: [ :el | values add: el ] ].
	aCollection
		at: midPoint
		put: values average + (rand nextInt: variation).
	Transcript
		show: 'populated: ' , midPoint asString;
		cr
]

{ #category : #'as yet unclassified' }
PointCarre class >> diamondOn: aCollection by: anInteger size: anInteger3 [
	anInteger < 1
		ifTrue: [ ^ self ].
	1 to: anInteger3 by: anInteger do: [ :x | 1 to: anInteger3 by: anInteger do: [ :y | 1halt ] ]
]

{ #category : #'as yet unclassified' }
PointCarre class >> diamondOn: aCollection from: p1 to: p4 [  
	| midPoint values variation|
	variation := ((p4 - p1)/ 2 ) x.
	midPoint := ((p4 - p1) / 2 + p1) asIntegerPoint.
	midPoint = p1
		ifTrue: [ ^ self ].
	values := OrderedCollection new.
	{  p1.
	p4.
	p1 x @ p4 y.
	p4 x @ p1 y }
		do:
			[ :coord | aCollection at: coord ifPresent: [ :el | values add: el ] ].
	aCollection at: midPoint put: values average.
	1 halt
]

{ #category : #'as yet unclassified' }
PointCarre class >> diamondOn: aCollection from: p1 to: p4 rand: rand [
	| midPoint values variation size |
	size := p4 - p1.
	variation := ((p4 - p1) / 2) x.
	variation < 1
		ifTrue: [ ^ self ].
	midPoint := ((p4 - p1) / 2 + p1) asIntegerPoint.
	aCollection at: midPoint ifAbsent: [ ^ self ].
	midPoint = p1
		ifTrue: [ ^ self ].
	values := OrderedCollection new.
	{p1.
	p4.
	(p1 x @ p4 y).
	(p4 x @ p1 y)}
		do: [ :coord | 
			aCollection
				at: coord asIntegerPoint
				ifPresent: [ :el | values add: el ] ].
	aCollection
		at: midPoint
		put: values average + (rand nextInt: variation).
	Transcript
		show: 'populated: ' , midPoint asString;
		cr.
	self
		carreOn: aCollection
		from: p1 - (variation @ 0)
		to: p4 - (variation @ 0)
		rand: rand.
	self
		carreOn: aCollection
		from: p1 + (variation @ 0)
		to: p4 + (variation @ 0)
		rand: rand.
	self
		carreOn: aCollection
		from: p1 - (0 @ variation)
		to: p4 - (0 @ variation)
		rand: rand.
	self
		carreOn: aCollection
		from: p1 + (0 @ variation)
		to: p4 + (0 @ variation)
		rand: rand.
	self
		diamondOn: aCollection
		from: p1
		to: p4 - (variation @ variation)
		rand: rand.
	self
		diamondOn: aCollection
		from: p1 + (variation @ 0)
		to: p4 - (0 @ variation)
		rand: rand.
	self
		diamondOn: aCollection
		from: p1 + (0 @ variation)
		to: p4 - (variation @ 0)
		rand: rand.
	self
		diamondOn: aCollection
		from: p1 + (variation @ variation)
		to: p4
		rand: rand
]

{ #category : #'as yet unclassified' }
PointCarre class >> newSize: anInteger [ 
	| rand |
	self new initialSize: 100 rand: rand
]

{ #category : #'as yet unclassified' }
PointCarre class >> newSize: anInteger rand: rand [
	^ self new initialSize: anInteger rand: rand
]

{ #category : #'as yet unclassified' }
PointCarre class >> on: aCollection by: anInteger [ 
	self shouldBeImplemented.
]

{ #category : #'as yet unclassified' }
PointCarre class >> on: aCollection by: anInteger size: anInteger3 [ 
	self shouldBeImplemented.
]

{ #category : #'as yet unclassified' }
PointCarre >> initialSize: anInteger [ 
	map := Dictionary new. 
	1 to: anInteger do: [ :i | 1 to:100 do: [ :j | map at: (i@j) put: ValueHolder new ] ].
	
]

{ #category : #'as yet unclassified' }
PointCarre >> initialSize: anInteger rand: rand [
	map := Dictionary new. 
	1 to: anInteger do: [ :i | 1 to: anInteger do: [ :j | map at: (i@j) put: NewValueHolder new ] ].
	self prepareDiamond: 1@1 to: anInteger@anInteger rand: rand.
	(map at: 1@1) contents: (rand nextInt:anInteger).
	(map at: 1@anInteger) contents: (rand nextInt:anInteger).	
	(map at: anInteger@1) contents: (rand nextInt:anInteger).	
	(map at: anInteger@anInteger) contents: (rand nextInt:anInteger).	
]

{ #category : #'as yet unclassified' }
PointCarre >> prepareCarre: p1 to: p4 rand: rand [ 
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
				ifPresent: [ :el | values add: el. coords add: coord ] ].
values
		do: [ :el | 
			el
				whenChangedDo:
				 [ :ev | 
					(map at: midPoint) contents
						ifNil: [ (values allSatisfy: [ :el2 | el2 contents isNotNil ])
								ifTrue: [ (map at: midPoint)
										contents: (values collect: #contents) average + (rand nextInt: variation) ] ] ] ].
	Transcript
		show: 'populatedCarreon: ' , midPoint asString,  'with:' , coords asString ;
		cr
]

{ #category : #'as yet unclassified' }
PointCarre >> prepareDiamond: p1 to: p4 rand: rand [
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
		do:
			[ :coord | map at: coord asIntegerPoint ifPresent: [ :el | values add: el. coords add: coord ] ].
	values
		do: [ :el | 
			el
				whenChangedDo: [ :ev | 
					(map at: midPoint) contents
						ifNil: [ (values allSatisfy: [ :el2 | el2 contents isNotNil ])
								ifTrue: [ (map at: midPoint)
										contents: (values collect: #contents) average + (rand nextInt: variation) ] ] ] ].
	Transcript
		
		show: 'populatedDiamondon: ' , midPoint asString, 'with:' , coords asString ;
		cr.
	self
		prepareCarre: p1 - (variation @ 0)
		to: p4 - (variation @ 0)
		rand: rand.
	self
		prepareCarre: p1 + (variation @ 0)
		to: p4 + (variation @ 0)
		rand: rand.
	self
		prepareCarre: p1 - (0 @ variation)
		to: p4 - (0 @ variation)
		rand: rand.
	self
		prepareCarre: p1 + (0 @ variation)
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
