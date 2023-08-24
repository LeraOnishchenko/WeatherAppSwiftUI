//
//  ViewModel.swift
//  combineRx
//
//  Created by lera on 05.04.2023.
//

import Foundation
import Combine
import RxCombine


class DetailViewModel : ObservableObject {
    
    private let defaultHourlyWeather = [WeatherData.Hourly(dt: 0, temp: 0, wind_speed: 0, weather: [WeatherData.Weather(main: "", icon: "")])]
    private let defaultDailyWeather = [WeatherData.Daily(dt: 0, temp: WeatherData.Temp(day: 0, night: 0), wind_speed: 0, weather: [WeatherData.Weather(main: "", icon: "")], rain: nil)]
    private let weatherApiHost = "https://api.openweathermap.org"
    var subscriptions = Set<AnyCancellable>()
    var outSubject = CurrentValueSubject<[WeatherData.Hourly], Never>([])
    var didChangedText = CurrentValueSubject<(String, Int), Never>(("",0))
    //var didChangedScroolViewIndex = CurrentValueSubject<(Int, String, String, Double), Never>((0, "", "", 0.0))
    @Published var weather: [WeatherData.Hourly] = []
    var currDt = 0

    init() {

        didChangedText.asObservable().flatMap { (city, dt) in
            self.currDt = dt
            return NetworkTaskFactory.getNewTask(
                url: self.createUrlForGettingCities(getFromCity: city),
                type: [cityStruct].self
            ).asObservable().catch { _ in
                DispatchQueue.main.async {
                    self.outSubject.send(self.defaultHourlyWeather)
                    self.objectWillChange.send()
                }
                return Just([]).asObservable()
            }
        }.filter({ cityStructs in
            {
                let emptyResult = cityStructs.isEmpty
                if emptyResult {
                    DispatchQueue.main.async {
                        self.outSubject.send(self.defaultHourlyWeather)
                        self.objectWillChange.send()
                    }
                    return false
                }
                return true
            }()
        })
        .map({ cityStructs in
            cityStructs.first!
        })
        .flatMap { firstCity in
            return NetworkTaskFactory.getNewTask(
                url: self.createUrlForGettingDailyWeatherDaily(getFromCityStruct: firstCity),
                                type: WeatherData.self
            ).asObservable().catch { error in
                return Just(WeatherData(lat: 0, lon: 0, timezone: "", timezone_offset: 0, daily: self.defaultDailyWeather,
                                        hourly: self.defaultHourlyWeather)).asObservable()
            }
        }.map({ wd in
            wd.hourly ?? self.defaultHourlyWeather
        }).publisher.sink { _ in
            fatalError()
        } receiveValue: { array in
            DispatchQueue.main.async {
                self.outSubject.send(array.filter{
                    wd in
                    if self.formattedDate(from: wd.dt) == self.formattedDate(from: self.currDt){
                        return true
                    }
                    return false
                })
                self.objectWillChange.send()
            }
        }.store(in: &subscriptions)
       
        
        outSubject.assign(to: &$weather)
    }


    private func createUrlForGettingCities(getFromCity city:String) -> String {
        let encCity = city.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
        return weatherApiHost + "/geo/1.0/direct?q=\(encCity)&limit=1&appid=da258afbd75f99802dfece33abd4974c"
    }
    
    private func createUrlForGettingDailyWeatherDaily(getFromCityStruct city:cityStruct)
                    -> String{
        return weatherApiHost + "/data/2.5/onecall?lat=\(city.lat)&lon=\(city.lon)&exclude=minutely,daily,current,alerts&units=metric&appid=da258afbd75f99802dfece33abd4974c"
    }
    
    func formattedDate(from timestamp: Int) -> String {
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "d 'th' MMM `yy"
        return dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(timestamp)))
     }
    
//    private func createUrlForGettingDailyWeatherHourly(getFromCityStruct city:cityStruct)
//                    -> String{
//        return weatherApiHost + "api.openweathermap.org/data/2.5/forecast?lat=\(city.lat)&lon=\(city.lon)&appid=da258afbd75f99802dfece33abd4974c"
//    }
}

