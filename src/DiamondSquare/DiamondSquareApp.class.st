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
						class: 'card-body';
						with: 'Diamond Square Generator'.
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
								class: 'row g-2';
								with: [
									html div
										class: 'col-auto';
										with: [
											html textInput
												class: 'form-control';
												id: #size;
												value: 9 ].
									html div
										class: 'col-auto';
										with: [
											html button
												class: 'btn btn-primary';
												id: #generate;
												with: 'generate' ] ] ] ] ]
]

{ #category : 'description' }
DiamondSquareApp class >> updateHtmlRoot: root [

	<pharoJsSkip>
	root language: 'en'.
	root stylesheet url:
		'https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css'
]

{ #category : 'initialize-release' }
DiamondSquareApp >> generateForSize: size [

	| plotter diamond |
	diamond := DiamondSquare newSize: size rand: PjCustomRandom new.
	plotter := self componentNamed: 'plotter'.
	plotter width: size.
	plotter height: size.
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
		block: [
			| size |
			size := (document getElementById: #size )value asInteger.
			self generateForSize: size ]
]
