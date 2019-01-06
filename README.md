# SwiftStarterApp

Swift 4 starter project with most of the boiler plate code needed for a modern app.

## Includes

1. True MVC Design Pattern
2. Google Firebase for marketing and user tracking
3. REST & HTTP/S Model API for JSON Servers
4. Many helpful String, UIView, & NSDecimalNumber extensions
5. Many helpful Date extensions
6. Handy orientation routine in App Delegate
7. CryptLib and routines for AES encryption and decryption

## Does not include

1. Any UI

## Requirements

1. cocoa pods
2. Google Firebase configuration - you will need to setup your own.

## To Install

1. Clone repository
2. Setup code signing
3. Change name of app to your name => https://stackoverflow.com/questions/33370175/how-do-i-completely-rename-an-xcode-project-i-e-inclusive-of-folders
4. Change name of project in Podfile to your new name. Install pods then app should compile. 
5. Remove _StarterProject.framework from Linked Framework and Libraries
Fix any compilation errors before continuing
6. Change class prefix from SSP to yours. A Global Find and replace should be okay for this.
7. Setup for Google Firebase
8. Edit includes/SSPConfig to use your URL's
9. Review files in Models to see how Base and Child models work. SSPChildModels should be used as a basis to build your own models.
10. You may need to adjust error handling in SSPURLRouter to cater for your own server


