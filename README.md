# SwiftBox
<<<<<<< HEAD
Collection of commonly useful Swift functions and classes

## Cross Platform
Make it easy to share code across iOS and OSX that use Colors (NSColor vs UIColor), Fonts, and Images.
## Transduce
Based on Coljure's Transducers

## Geometry
CoreGraphics operations on points, lines, rectangles, circles, and polygons

## Textyle
Create NSAttributedStrings from Swift Strings

## Health & Nutrition
[How Many Calories Should I Eat](http://www.bmrcalculator.org/how-many-calories-should-i-eat-a-day/)

[BMR Calculator](http://www.bmrcalculator.org)

[BMR Wikipedia](https://en.wikipedia.org/wiki/Basal_metabolic_rate)

http://opendata.stackexchange.com/questions/269/open-api-for-nutritional-information-and-or-food-barcodes

## Navigation

## Resource Links
AsyncDisplayKit is an iOS framework that keeps even the most complex user interfaces smooth and responsive. It was originally built to make Facebook's Paper possible, and goes hand-in-hand with pop's physics-based animations — but it's just as powerful with UIKit Dynamics and conventional app designs.

```ruby
pod 'AsyncDisplayKit'
```
=======

A Swift wrapper around Facebook's [implementation](https://github.com/facebook/css-layout) of CSS's flexbox.

## Example

```swift
let parent = Node(size: CGSize(width: 300, height: 300),
                  childAlignment: .Center,
                  direction: .Row,
                  children: [
    Node(flex: 75,
         margin: Edges(left: 10, right: 10),
         size: CGSize(width: 0, height: 100)), 
    Node(flex: 15,
         margin: Edges(right: 10),
         size: CGSize(width: 0, height: 50)),
    Node(flex: 10,
         margin: Edges(right: 10),
         size: CGSize(width: 0, height: 180)),
])

let layout = parent.layout()
println(layout)

//{origin={0.0, 0.0}, size={300.0, 300.0}}
//	{origin={10.0, 100.0}, size={195.0, 100.0}}
//	{origin={215.0, 125.0}, size={39.0, 50.0}}
//	{origin={264.0, 60.0}, size={26.0, 180.0}}
```

Alternatively, you could apply the layout to a view hierarchy (after ensuring Auto Layout is off):

```swift
layout.apply(someView)
```

See [SwiftBoxDemo](SwiftBoxDemo/SwiftBoxDemo) for a demo.
>>>>>>> d1031c975512b3194d2881e1df80a8d6a586d413
