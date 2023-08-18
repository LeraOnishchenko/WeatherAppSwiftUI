//
//  ViewModel.swift
//  combineRx
//
//  Created by lera on 05.04.2023.
//

import Foundation
import Combine
import RxCombine


class ViewModel : ObservableObject {
    
    private let defaultDailyWeather = [WeatherData.Daily(dt: 0, temp: WeatherData.Temp(day: 0, night: 0), wind_speed: 0, weather: [WeatherData.Weather(main: "", icon: "")], rain: nil)]
    private let weatherApiHost = "https://api.openweathermap.org"
    var subscriptions = Set<AnyCancellable>()
    var outSubject = CurrentValueSubject<[WeatherData.Daily], Never>([])
    var didChangedText = CurrentValueSubject<String, Never>("")
    @Published var weather: [WeatherData.Daily] = []

    init() {

        didChangedText.asObservable().flatMap { city in
            return NetworkTaskFactory.getNewTask(
                url: self.createUrlForGettingCities(getFromCity: city),
                type: [cityStruct].self
            ).asObservable().catch { _ in
                DispatchQueue.main.async {
                    self.outSubject.send(self.defaultDailyWeather)
                    self.objectWillChange.send()
                }
                return Just([]).asObservable()
            }
        }.filter({ cityStructs in
            {
                let emptyResult = cityStructs.isEmpty
                if emptyResult {
                    DispatchQueue.main.async {
                        self.outSubject.send(self.defaultDailyWeather)
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
                url: self.createUrlForGettingDailyWeather(getFromCityStruct: firstCity),
                                type: WeatherData.self
            ).asObservable().catch { error in
                Just(WeatherData(lat: 0, lon: 0, timezone: "", timezone_offset: 0,
                                 daily: self.defaultDailyWeather)).asObservable()
            }
        }.map({ wd in
            wd.daily
        }).publisher.sink { _ in
            fatalError()
        } receiveValue: { array in
            DispatchQueue.main.async {
                self.outSubject.send(array)
                self.objectWillChange.send()
            }
        }.store(in: &subscriptions)
       
        
        outSubject.assign(to: &$weather)
    }


    private func createUrlForGettingCities(getFromCity city:String) -> String {
        let encCity = city.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
        return weatherApiHost + "/geo/1.0/direct?q=\(encCity)&limit=1&appid=da258afbd75f99802dfece33abd4974c"
    }

    private func createUrlForGettingDailyWeather(getFromCityStruct city:cityStruct)
                    -> String{
        return weatherApiHost + "/data/2.5/onecall?lat=\(city.lat)&lon=\(city.lon)&exclude=minutely,hourly,current,alerts&units=metric&appid=da258afbd75f99802dfece33abd4974c"
    }

}
