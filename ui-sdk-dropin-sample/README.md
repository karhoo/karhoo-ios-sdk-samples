# Introduction
iOS Sample for Karhoo UI SDK

# Getting Started with the sample app
The sample app require that you add your own set of API keys:

* Add the API keys and configurations to [ui-sdk-dropin-sample/Keys.swift](ui-sdk-dropin-sample/Keys.swift). 
    * Add Guest configuration for your account in order to enable the guest checkout journey
    * Add Token Exchange configuration for your account in order to enable the token exchange journey
* Build and run

## Running SDK with Data
You can pass journey information and passenger details to UI SDK. These information will be used as part of the booking. In order to update the passenger details, you can update the [ui-sdk-dropin-sample/ViewController.swift](ui-sdk-dropin-sample/ViewController.swift)

