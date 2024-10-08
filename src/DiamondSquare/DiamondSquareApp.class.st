Class {
	#name : 'DiamondSquareApp',
	#superclass : 'PjFileBasedWebApp',
	#traits : 'StaticComponentHolder',
	#classTraits : 'StaticComponentHolder classTrait',
	#category : 'DiamondSquare',
	#package : 'DiamondSquare'
}

{ #category : 'description' }
DiamondSquareApp class >> appClasses [

	<pharoJsSkip>
	^ super appClasses , { CustomValueHolder. WCPixelPlotter }
]

{ #category : 'description' }
DiamondSquareApp class >> bridgeClientClass [
	<pharoJsSkip>
	
	^ PjZnHostedBrowserBridgeClient
]

{ #category : 'description' }
DiamondSquareApp class >> exporterClass [
	<pharoJsSkip>
	
	^ PjFileExporterWithIndexHtml
]

{ #category : 'description' }
DiamondSquareApp class >> generateHtmlUsing: html [

	<pharoJsSkip>
	html div
		class: 'container';
		with: [
			html div
				class: 'card col-10 mx-auto text-center';
				with: [
					html div
						class: 'card-header';
						with: [
							html heading
								level: 1;
								with: 'Diamond Square Generator' ].
					html div
						class: 'card-body';
						with: [
							self
								addComponent: ((WCPixelPlotter on: html)
										 width: 9;
										 height: 9;
										 yourself)
								named: #plotter.

							html div
								class: 'row g-10';
								with: [
									html div
										class: 'col-auto';
										with: [
											html div
												class: 'form-floating';
												with: [
													html textInput
														class: 'form-control';
														id: #size;
														value: 33.

													html label
														for: #size;
														class: 'floatingInput';
														with: 'Resolution'.
													html div
														class: 'invalid-feedback';
														with:
															'Resolution must be 2**n + 1. (eg. 9, 17, 33, ...)' ] ].
									html div
										class: 'col-auto';
										with: [
											html button
												class: 'btn btn-primary';
												id: #generate;
												with: 'Generate' ] ] ] ] ]
]

{ #category : 'description' }
DiamondSquareApp class >> updateHtmlRoot: root [

	<pharoJsSkip>
	root language: 'en'.
	root stylesheet url:
		'https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css'
]

{ #category : 'initialize-release' }
DiamondSquareApp >> generate [

	| size |
	size := (document getElementById: #size) value asInteger.
	size isNaN ifTrue: [
		(document getElementById: #size) classList add: 'is-invalid'.
		^ self ].
	size <= 2 ifTrue: [
		(document getElementById: #size) classList add: 'is-invalid'.
		^ self ].
	(size - 1 ~= 0 and: [ (size - 1 bitAnd: size - 2) = 0 ])
		ifFalse: [
			(document getElementById: #size) classList add: 'is-invalid'.
			^ self ]
		ifTrue: [
		(document getElementById: #size) classList remove: 'is-invalid' ].
	self generateForSize: size
]

{ #category : 'initialize-release' }
DiamondSquareApp >> generateForSize: size [

	| plotter diamond |
	diamond := DiamondSquare newSize: size rand: PjCustomRandom new.
	plotter := self componentNamed: 'plotter'.
	plotter width: size.
	plotter height: size.
	plotter clear.
	console log: diamond map size.
	^ 1 to: size do: [ :x |
		  1 to: size do: [ :y |
			  | value color |
			  value := diamond map at: x @ y.
			  value := (value * 255) asInteger toString: 16.
			  color := '#' , value , value , value.
			  plotter at: x @ y color: color ] ]
]

{ #category : 'initialize-release' }
DiamondSquareApp >> start [

	super start.
	self initializeComponentHolder.


	document getElementById: #size.
	(document getElementById: #generate)
		addEventListener: #click
		block: [ self generate ]
]
