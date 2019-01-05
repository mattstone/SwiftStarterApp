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
3. Change name of app to your name and change class prefix from SSP to yours. A Global Find and replace should be okay for this.
4. Setup for Google Firebase
5. Edit includes/SSPConfig to use your URL's
6. Review files in Models to see how Base and Child models work. SSPChildModels should be used as a basis to build your own models.
7. You may need to adjust error handling in SSPURLRouter to cater for your own server


