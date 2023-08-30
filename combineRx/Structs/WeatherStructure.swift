//
//  WeatherStructure.swift
//  WeatherRxApp
//
//  Created by lera on 08.03.2023.
//

import Foundation

struct cityStruct: Codable {
    let name: String
    let lat, lon: Double
}

struct WeatherData: Codable, Equatable {
    
    static func == (lhs: WeatherData, rhs: WeatherData) -> Bool {
        return lhs.lat == rhs.lat && lhs.lon == rhs.lon && lhs.timezone == rhs.timezone && lhs.timezone_offset == rhs.timezone_offset && lhs.daily == rhs.daily
        
    }
    
    let lat: Double
    let lon: Double
    let timezone: String
    let timezone_offset: Int
    let daily: [Daily]?
    let hourly: [Hourly]?

    struct Daily: Codable,Equatable,Identifiable{
        static func == (lhs: WeatherData.Daily, rhs: WeatherData.Daily) -> Bool {
             return lhs.dt == rhs.dt && lhs.temp == rhs.temp && lhs.wind_speed == rhs.wind_speed && lhs.weather == rhs.weather && lhs.rain == rhs.rain
        }
        
        var id: Int { dt }
        let dt: Int
        let temp: Temp
        let wind_speed: Double
        let weather: [Weather]
        let rain: Double?
    }
    
    struct Hourly: Codable,Equatable,Identifiable{
        static func == (lhs: WeatherData.Hourly, rhs: WeatherData.Hourly) -> Bool {
             return lhs.dt == rhs.dt && lhs.temp == rhs.temp && lhs.wind_speed == rhs.wind_speed && lhs.weather == rhs.weather && lhs.selected == rhs.selected
        }
        
        var id: Int { dt }
        let dt: Int
        let temp: Double
        let wind_speed: Double
        let weather: [Weather]
        var selected: Bool? = false
    }

    struct Temp: Codable, Equatable {
        let day: Double
        let night: Double
    }

    struct Weather: Codable, Equatable {
        let main: String
        let icon: String
    }

}
