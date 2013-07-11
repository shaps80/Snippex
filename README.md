Snippex Library
============

My own personal library of reusable code that compiles and standardises some classes across iOS and OSX. This code is still in development and although I will always deprecate nicely to ensure you are able to update as seamlessly as possible, remember it is a work in progress.

The project is a static librar, however you can use individual source files or code as required. I would appreciate attribution if you're able to but it is not required. :)

The project is currently organized into 4 sections:

	Wrappers		- Provides convenience wrappers for classes
    Managers		- Provides managers that encapsulate common behaviour
    Views	 		- Provides additional cross-platform views
    Graphics		- Provides many useful graphics, drawing and geometry helpers
    Categories		- Provides additional functionality to existing SDK classes
    
All classes can be compiled for use on both iOS and OSX however there are also some convenience definitions and subclasses to aide in development and simplify things where necessary.

For example:

    1. You should use SPXView in place of UIView/NSView
    2. You should use SPXColor in place of UIColor/NSColor
    3. You should use SPXBezierPath in place of NSBezierPath/UIBezierPath
    3. You can use SPXGraphicsContext in place of UIGraphicsGetCurrentContext() or [[NSGraphicsContext currentGraphics] graphicsPort]
    4. SPXOffset is supported on both platforms and provides convenience functions for converting to/from UIOffset
    
There are also some OSX/iOS methods that are only available on 1 platform, so I've added this behaviour as required:

	1. NSColor (on 10.7) now supports CGColor
	2. iOS now has support for SPXShadow
	3. iOS now has support for SPXGradient
	4. SPXDrawing provides low level drawing methods that can be used in your drawRect code
	5. SPXGeometry adds SPXOffset and many additional convenience methods for rects, sizes, points, etc...
    
Want to hear the best part?

Everything is well documented, with full HTML documentation provided (thanks to appledoc) and there's even unit tests (still in progress) to ensure everything works as expected.

I hope you find this useful and if you do, drop me a line on twitter @shaps or email shaps80[@]me.com
I love to hear from fellow developers :)

Developed by 	[@shaps](http://twitter.com/shaps "Twitter")

Profile			[shaps.me](http://shaps.me "Profile")

Snippex			[Snippex](http://snippex.co.uk "Snippex")