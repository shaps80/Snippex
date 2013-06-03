ShapsLibrary
============

My own personal library of reusable code that compiles and standardises some classes across iOS and OSX.

The project is a static library and I'll provide a pre-compiled cross platform (simulator included) binary soon.
You can however download the entire code, project, etc... and are free to use for both free and commercial use.
I would appreciate attribution if you're able to but if not that's ok too :)

The project is organized into 4 sections:

    Categories
    Graphics
    Managers 
    Views
    
All classes can be compiled for use on both iOS and OSX however there are some convenience definitions and subclasses to aide in development and simplify things where necessary.

For example:

    1. You should use SLView in place of UIView/NSView
    2. You should use SLColor in place of UIColor/NSColor
    3. You should use SLBezierPath in place of NSBezierPath/UIBezierPath
    3. You can use RCContext in place of UIGraphicsGetCurrentContext() or [[NSGraphicsContext currentGraphics] graphicsPort]
    4. RCOffset is supported on both platforms and provides convenience functions for converting to/from UIOffset
    5. NSColor (on 10.7) doesn't have CGColor as an accessor so I've added it :)
    
There's lots more you included like RCShadow and RCGradient, both of which make use of SLGeometry and SLDrawing (lower level classes you can use to do custom drawing that is supported across both platforms)

Want to hear the best part?

Everything is well documented, with full HTML documentation provided (thanks to appledoc) and there's even unit tests to ensure things work as expected as this code grows.

I hope you find this useful and if you do, drop me a line on twitter @shaps or email shaps80[@]me.com
I love to hear from fellow developers :)

P.s. if you don't like something, make sure your critism's are constructive please :)
