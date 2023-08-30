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
    var didChangedScroolViewIndex = CurrentValueSubject<Int, Never>((0))
    @Published var weather: [WeatherData.Hourly] = []
    var selected : WeatherData.Hourly? = nil
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
                var arrToSend = array
                arrToSend = arrToSend.filter{
                    wd in
                    if formattedDate(from: wd.dt) == formattedDate(from: self.currDt){
                        return true
                    }
                    return false
                }
                if arrToSend.isEmpty {
                    self.outSubject.send(arrToSend)
                    self.objectWillChange.send()
                    return
                }
                arrToSend[0].selected = true
                self.selected = arrToSend[0]
                self.outSubject.send(arrToSend)
                self.objectWillChange.send()
            }
        }.store(in: &subscriptions)
    
        didChangedScroolViewIndex.asObservable().publisher.sink { _ in
            fatalError()
        } receiveValue: { id in
            DispatchQueue.main.async {
                var arrToSend = self.weather
                if arrToSend.isEmpty {
                    return
                }
                let idxPrevSelected = arrToSend.firstIndex{ wd in
                    return wd.selected == true
                }
                arrToSend[idxPrevSelected ?? 0].selected = false
                let idxCurrSelected = arrToSend.firstIndex{ wd in
                    return wd.id == id
                }
                arrToSend[idxCurrSelected ?? 0].selected = true
                self.selected = arrToSend[idxCurrSelected ?? 0]
                self.outSubject.send(arrToSend)
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
    
}

