####This is a custom `Activity Indicator View`, the point is what it's look:    

![](pacMan.gif)

####Yes! It's a pac-man. And you can add to you project easily!

##How tu use?

####Drag the file `PacManIndicatorView.swift` to project, and then:

```swift 
let indicator = PacmanIndicatorView(frame: CGRectMake(100, 100, 200, 50))
indicator.startAnimating()
self.view.addSubview(indicator)
```

###if you want to stop it, then:

```swift
indicator.stopAnimating()
```

###you can also change the color at anywhere like this:

```swift
indicator.pacmanColor = UIColor.redColor()
indicator.beansColor = UIColor.greenColor()
```