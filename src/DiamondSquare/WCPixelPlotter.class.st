Class {
	#name : 'WCPixelPlotter',
	#superclass : 'WCComponent',
	#instVars : [
		'height',
		'width'
	],
	#category : 'DiamondSquare',
	#package : 'DiamondSquare'
}

{ #category : 'rendering' }
WCPixelPlotter >> at: coord color: color [

	| ctx pixelWidthSize pixelHeightSize |
	ctx := self context.
	pixelWidthSize := self canvasWidth / self width.
	pixelHeightSize := self canvasHeight / self height.
	ctx fillStyle: color.
	ctx
		fillRect: coord x - 1 * pixelWidthSize
		y: coord y - 1 * pixelHeightSize
		w: coord x * pixelWidthSize
		h: coord y * pixelHeightSize
]

{ #category : 'rendering' }
WCPixelPlotter >> canvasHeight [

	^ (self getElementById: #plot) height
]

{ #category : 'rendering' }
WCPixelPlotter >> canvasWidth [

	^ (self getElementById: #plot) width
]

{ #category : 'rendering' }
WCPixelPlotter >> clear [

	self context
		clearRect: 0
		y: 0
		w: self canvasWidth
		h: self canvasHeight
]

{ #category : 'rendering' }
WCPixelPlotter >> context [

	^ (self getElementById: #plot) getContext: '2d'
]

{ #category : 'rendering' }
WCPixelPlotter >> getBoundingClientRect [
	^ (self getElementById: #plot) getBoundingClientRect
]

{ #category : 'rendering' }
WCPixelPlotter >> height [

	^ height
]

{ #category : 'accessing' }
WCPixelPlotter >> height: anObject [

	height := anObject
]

{ #category : 'rendering' }
WCPixelPlotter >> onMouseMoveDo: aBlock [

	(self getElementById: #plot)
		addEventListener: #mousemove
		block: [ :e |
			| rect pos |
			rect := self getBoundingClientRect.
			pos := e clientX - rect left @ (e clientY - rect top).
			pos := (pos x * self width / rect width)  
			       @ (pos y * self height / rect height).
			pos := pos asIntegerPoint + (1 @ 1).
			aBlock cull: pos ]
]

{ #category : 'rendering' }
WCPixelPlotter >> renderHtmlOn: html [

	html canvas
		id: 'plot';
		width: 1000;
		height: 1000;
		class: 'mx-auto';
		style: 'width: 300px; height:300px;'
]

{ #category : 'rendering' }
WCPixelPlotter >> start [

	super start.
]

{ #category : 'rendering' }
WCPixelPlotter >> width [

	^ width
]

{ #category : 'accessing' }
WCPixelPlotter >> width: anObject [

	width := anObject
]
