# RSL SDK Readme

## About

This is an iOS package that can be added to your project using swift package manager. It provides functionality of create booking and to handle success and failure statuses within your application. In order to use this Package effectively, you need to provide the correct functionalities for handeling the success and failure.

## Instalation

To install this package, import `https://github.com/Kishore-iOS/SampleWebviewPackage.git` in SPM and select `Up to Next Major Version` dependency rule.

## Usage

To use this Package follow these steps:
1. Import our package in your main view controller `import SampleWebviewPackage`.
2. Initialize and navigate to **WebBookingViewController** from your main view controller.
3. Set the **WebBookingDelegate** to your main view controller for the handelling of success and failure.

 Following is a sample swift code of how you can use our package in your application:

```swift

import UIKit
import SampleWebviewPackage

class ViewController: UIViewController, WebBookingDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func moveToWebView(_ sender: UIButton) {
        let webBookingVC = WebBookingViewController() // Initialize WebBookingViewController
        webBookingVC.delegate = self // Set delegate to our view controller
        self.navigationController?.pushViewController(webBookingVC, animated: true) // Navigate to web booking controller
    }
    
    func bookingSuccess(tripId: String, message: String) {
        // Handle booking success in this function
    }
    
    func bookingFail(message: String) {
        // Handle booking failure in this function
    }
    
    func webViewError(message: String) {
        // Handle web view errors in this function
    }
}

```

## Disclaimer

This Package is provided under a single user license. You are allowed to share this Package with others, but each user must obtain their own license. The usage of this Package is subject to the terms and conditions specified in the license agreement.

For any questions or inquiries regarding licensing, please contact RSL.

We appreciate your interest in using our Package and hope it proves beneficial for your application.
