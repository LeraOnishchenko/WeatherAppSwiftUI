//
//  WeatherCellView.swift
//  combineRx
//
//  Created by lera on 18.08.2023.
//

import Foundation
import SwiftUI

struct WeatherCellView: View {
    
    var dayTemp: Double
    var windSpeed: Double
    var rain: Double
    var dt: Int
    var weather: String
    var weatherImage: String
    
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
