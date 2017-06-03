# Little Finger iOS

This repo contains [Little Finger](http://avi.im/little-finger) iOS library.

## Usage

To install add this to your pod file:

    pod 'LittleFinger', '~> 0.1.0'

then you can import it:  

    import LittleFinger

and call it:

    LittleFinger.start(serverUrl: "https://your-heroku-app.heroku.com")

## Example

Your `AppDelegate` code can be like this:

```swift
import UIKit

import LittleFinger

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // your code
        LittleFinger.start(serverUrl: "https://your-heroku-app.heroku.com")
    }

    // rest of the code
}
```


## License

The mighty MIT license. Please check `LICENSE` for more details.
