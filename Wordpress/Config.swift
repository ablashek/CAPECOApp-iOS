//
//  Config.swift
//  News
//
//  Created by Asil Arslan on 21.12.2020.
//

import Foundation
import SwiftUI

//Your wordpress address
var WORDPRESS_URL = "https://agro.gorila.com.py/"
var HEADLINE_CATEGORY_ID = 17 // Your Categories -> www.YOUR_WORDPRESS_SITE/wp-json/wp/v2/categories

///Onboard Data
var ONBOARD_DATA: [Onboard] = [
    Onboard(title: "Onboard 1", headline: "Headline", image: "logo", gradientColors: [Color("ColorBlue"), Color("ColorBlue")]),
    Onboard(title: "Onboard 2", headline: "Headline", image: "logo", gradientColors: [Color("ColorGreen"), Color("ColorGreen")]),
    Onboard(title: "Onboard 3", headline: "Headline", image: "logo", gradientColors: [Color("ColorRed"), Color("ColorRed")])
]

///In App Products. Note:  You must have extended license for in-app purchases. Contact me if you want upgrade.
var IN_APP_PRODUCTS = [
    //Use your product IDs instead
    "remove_ads",
    "donate"
]

///Category Tabs Visibilty
var IS_CATEGORIES_VISIBLE = false

///Headline Visibilty
var IS_HEADLINE_VISIBLE = false

///Headline Type
var HEADLINE_TYPE = HeadlineEnum.multiple
var EMPTY_IMAGE_URL = "https://seferihisar.com/wp-content/themes/shnews/assets/img/no-thumb.jpg"

var DATE_FORMAT = "dd MMM yyyy"

//Admob Interstital ad id
//var INTERSTITIAL_AD_ID: String = "ca-app-pub-8915706349520340/3989286675"
//var TEST_DEVICE: String = "b317b731f5490205b1f60b638837ea16"

///Settings
var DEVELOPER = "Gorillas"
var COMPABILITY = "iOS 14"
var WEBSITE_LABEL = "CAPECO App"
var WEBSITE_LINK = "gorillas.com.py"
var VERSION = "2.0.0"

enum HeadlineEnum {
    case single, multiple
}

