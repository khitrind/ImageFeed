//
//  Constants.swift
//  ImageFeed
//
//  Created by Dmitry Khitrin on 13/11/2022.
//

import Foundation

let BaseURL = "https://api.unsplash.com"
let AccessKey = "YW3q3vdk03DvUTr26uE7jl7GEh8X95OOnV1NTcFydMI"
let SecretKey = "EV86WtEkGDrrcCzBIUzm9XZC5M-f-FbE14vDnKE2k-U"
let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
let AccessScope = "public+read_user+write_lik"
let DefaultBaseURL = URL(string: "https://api.unsplash.com")!
let AuthorizeURL = "https://unsplash.com/oauth/authorize"
let NativePath = "/oauth/authorize/native"
let TokenURL = "https://unsplash.com/oauth/token"
let ProfileURL = "\(BaseURL)/me"
let ProfileImageURL = "\(BaseURL)/users"
let PhotoUrl = "\(BaseURL)/photos"
