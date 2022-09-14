# LittleSDK

This is an SDK that allows you to natively include some of the most popular Little App items right within your iOS App with minimal fuss.

For any assistance reach out at [littledevs](mailto:littledevelopers2021@gmail.com)

LittleSDK Author & Maintainer: [@littleappdevs](https://github.com/littleappdevs)

## Installation

### Swift Package Manager

1. Click File &rarr; Swift Packages &rarr; Add Package Dependency
2. Type `https://github.com/littleappdevs/littleapp.git`

Alternatively, in Xcode and search for "LittleSDK". If multiple results are found, select the one owned by [@littleappdevs](https://github.com/littleappdevs).

## Usage

### Initialize SDK

let littleFramework = LittleFramework()

let accounts = \[\[
    "AccountID": "123456",
    "AccountName": "Account Name"
\]\] \/\/ Array of Dictionary\<String, String\>

littleFramework.initializeSDKParameters(accounts: accountsArr, mobileNumber: "254700123123", packageName: "Bundle Identifier", isUAT: true)

littleFramework.initializeSDKMapKeys(googleMapsKey: Constants.MAPS_KEY, googlePlacesKey: Constants.PLACES_KEY)

### Navigate to ride request

littleFramework.initializeToRides(UIViewController)

    case food = "FOOD"
    case supermarket = "SUPERMARKET"
    case groceries = "GROCERIES"
    case gas = "GAS"
    case drinks = "DRINKS"
    case medicine = "MEDICINE"
    case cakes = "CAKES"

### Navigate to delivery
littleFramework.initializeToDeliveries(self, deliveryType: .food) \/\/ delivery types - food, supermarket, groceries, drinks, medicine or cakes


## Acknowledgements

Built at **[Little Limited](https://little.africa)**

Special thanks to: 

- [@GarbuJohnG](https://github.com/GarbuJohnG) for his valuable help on the SDK
