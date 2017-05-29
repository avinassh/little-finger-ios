// LittleFinger makes the HTTP call to the server and decides what to do next based on the
// HTTP Response code and body
//
// If the response code is `HTTP_PAYMENT_REQUIRED` (402) or `HTTP_OK` (200), then payment is
// expected to receive and let the app work as usual
//
// If the response code is `HTTP_ACCEPTED` (202), then payment has been received. Update the flag
// in preferences so that no future network calls are made
//
// If the response code is `HTTP_CONFLICT` (409), no payment has been received and there is a
// conflict. Crash the app. If there is any notification data from server, use that and display a
// notification before crashing
//
// LittleFinger class is the one which is exposed to the developer. This class is responsible for
// making HTTP calls to server and deciding what to do based on the response.


import Foundation
import UserNotifications

let USER_PREF_KEY = "lf_should_call"

enum HTTPStatusCodes: Int {
    case HTTP_ACCEPTED = 202
    case HTTP_PAYMENT_REQUIRED = 402
    case HTTP_CONFLICT = 409
}

public class LittleFinger {
    public static func start(serverUrl: String) {
        // Check whether to make call to server or not
        if shouldMakeCall() {
            makeHttpCall(serverUrl: serverUrl)
        }
    }
}

func makeHttpCall(serverUrl: String) {
    let url = URL(string: serverUrl)
    URLSession.shared.dataTask(with:url!, completionHandler: {(data, response, error) in
        guard let data = data, error == nil else {
            // HTTP call itself failed
            // crash the app
            fatalError()
            
        }
        guard let response = response as? HTTPURLResponse, error == nil else {
            // HTTP call itself failed
            // crash the app
            fatalError()
        }
        responseHandler(response: response, data: data)
    }).resume()
}

func responseHandler(response: HTTPURLResponse, data: Data) {
    if response.statusCode == HTTPStatusCodes.HTTP_PAYMENT_REQUIRED.rawValue {
        // do nothing
        // we are waiting for the payment, hence let the app work as expected
    } else if response.statusCode == HTTPStatusCodes.HTTP_ACCEPTED.rawValue {
        // received the payment
        // disable HTTP calls
        cancelCall()
    } else if response.statusCode == HTTPStatusCodes.HTTP_CONFLICT.rawValue {
        // no payment received
        // time to crash the app
        goEvil(data: data)
    }
}

// This method crashes the app. If the server has sent Notificatoin data, it uses that to
// display notification and then crash
func goEvil(data: Data) {
    do {
        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
        let title = json["NotificationTitle"] as! String
        let text = json["NotificationText"] as! String
        displayNotification(title: title, text: text)
    } catch _ as NSError {
        // umm do nothing
    }
    // crash the app
    fatalError()
}

// Checks if the the app should make HTTP call to server? If the value isn't set in User
// Preferences, True so that HTTP call can be made
func shouldMakeCall() -> Bool {
    let defaults = UserDefaults.standard
    return defaults.object(forKey: USER_PREF_KEY) == nil
}

// Once the payment is received, it is no longer required to make calls to server. This
// method updates the User Preferences
func cancelCall() {
    let defaults = UserDefaults.standard
    defaults.set("False", forKey: USER_PREF_KEY)
}


func displayNotification(title: String, text: String) {
    let center = UNUserNotificationCenter.current()
    center.getNotificationSettings { (settings) in
        if settings.authorizationStatus == .authorized {
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = text
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0, repeats: false)
            let identifier = "Little Finger Notification"
            let request = UNNotificationRequest(identifier: identifier,
                                                content: content, trigger: trigger)
            center.add(request)
        }
    }
}
