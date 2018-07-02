//
//  Runtime.swift
//  iSimulator
//
//  Created by 沈兆良 on 2018/3/2.
//  Copyright © 2018年 stszl.cn. All rights reserved.
//

import Foundation
import ObjectMapper

enum Availability: String {
    case available = "(available)"
    case unavailable = "(unavailable, runtime profile not found)"
}

class Runtime: Mappable {
    var buildversion = ""
    var availability = Availability.unavailable
    var name = ""
    var identifier = ""
    var version = ""
    var devices: [Device] = []
    var devicetypes: [DeviceType] = []
    var osType: OSType{
        if name.contains("iOS"){
            return .iOS
        }else if name.contains("tvOS"){
            return .tvOS
        }else if name.contains("watchOS"){
            return .watchOS
        }else{
            return .None
        }
    }
    enum OSType: String {
        case iOS,tvOS,watchOS,None
    }
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        buildversion <- map["buildversion"]
        availability <- (map["availability"], EnumTransform())
        name <- map["name"]
        identifier <- map["identifier"]
        version <- map["version"]
    }
}
