//
//  WeatherCellView.swift
//  combineRx
//
//  Created by lera on 18.08.2023.
//

import Foundation
import SwiftUI

struct WeatherCellView: View {
    
    let imageNamesAndDescriptions: [String: Image] = [
        "01d": Image("Sun"),
        "02d": Image("FewClouds"),
        "03d": Image("Cloud"),
        "04d": Image("brokenClouds"),
        "09d": Image("showerRain"),
        "10d": Image("rainIm"),
        "11d": Image("thunderstorm"),
        "13d": Image("snow"),
        "50d": Image("mist")
    ]
    
    var dayTemp: Double
    var windSpeed: Double
    var rain: Double
    var dt: Int
    var weather: String
    var weatherImage: String
    
    func formattedDate(from timestamp: Int) -> String {
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "d 'th' MMM `yy"
        return dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(timestamp)))
     }
    
    func weekdayName(from timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date)
    }
    
    var body: some View {
        ZStack(alignment: .center){
            Image("rectangle")
                .resizable()
                .scaledToFit()
            HStack{
                VStack(alignment: .leading) {
                    VStack(alignment: .leading){
                        Text("\(Int(dayTemp.rounded()))º")
                            .font(.system(size: 46, weight: .bold))
                            .foregroundColor(.white)
                        Text(formattedDate(from: dt))
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                        Text(weekdayName(from: dt))
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                    }
                    HStack() {
                        Image("wind")
                            .resizable()
                            .scaledToFit()
                        Text("Wind:")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Color(red: 0.682353, green: 0.682353, blue: 0.682353)).scaledToFit()
                        Text("\(Int(windSpeed.rounded())) m/s")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white).scaledToFit()
                    }.scaledToFit()
                    HStack() {
                        Image("rain")
                            .resizable()
                            .scaledToFit()
                        Text("Rain: ")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Color(red: 0.682353, green: 0.682353, blue: 0.682353))
                        Text("\(Int(rain.rounded())) mm")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                    }.scaledToFit()
                }.scaledToFill()
                Spacer()
                VStack{
                    if let image = imageNamesAndDescriptions[weatherImage] {
                        image
                            .resizable()
                            .scaledToFit()
                                } else {
                                    Image("Sun")
                                        .resizable()
                                        .scaledToFit()
                                }
                    Text(weather)
                }.scaledToFit()
            }.scaledToFit()
        }
        HStack(alignment: .center) {
            Spacer()
        }
        .background(Color.clear)
    }
}
