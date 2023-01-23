//
//  Constants.swift
//  ImageFeed
//
//  Created by Dmitry Khitrin on 13/11/2022.
//

import Foundation

let baseUrl = "https://api.unsplash.com"
let accessKey = "YW3q3vdk03DvUTr26uE7jl7GEh8X95OOnV1NTcFydMI"
let secretKey = "EV86WtEkGDrrcCzBIUzm9XZC5M-f-FbE14vDnKE2k-U"
let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
let accessScope = "public+read_user+write_likes"
let defaultBaseURL = URL(string: "https://api.unsplash.com")!
let authorizeURL = "https://unsplash.com/oauth/authorize"
let nativePath = "/oauth/authorize/native"
let tokenURL = "https://unsplash.com/oauth/token"
let profileURL = "\(baseUrl)/me"
let profileImageURL = "\(baseUrl)/users"
let photoUrl = "\(baseUrl)/photos"

