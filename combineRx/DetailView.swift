//
//  DetailView.swift
//  combineRx
//
//  Created by lera on 18.08.2023.
//

import Foundation
import SwiftUI

struct DetailView: View {
    
    @State private var temp = 26
    @State private var wind = 4
    var weather = "Mid Rain"
    var weatherImage = "Sun"
    var searchText: String
    var dt: Int
    var rain: Double?
    @ObservedObject var vm = DetailViewModel()
    @State private var selectedItemIndex: Int? = 0

    func formattedDate(from timestamp: Int) -> String {
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "d 'th' MMM `yy"
        return dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(timestamp)))
     }
    
    func formattedTime(from timestamp: Int) -> String {
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "HH"
          let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
          return dateFormatter.string(from: date)
      }
    
    func weekdayName(from timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date)
    }
    
//    func cheakWeather() -> [WeatherData.Hourly]{
//        return
//    }
    
    var body: some View {
        NavigationView {
            LinearGradient(
            stops: [
            Gradient.Stop(color: Color(red: 0.35, green: 0.21, blue: 0.71), location: 0.00),
            Gradient.Stop(color: Color(red: 0.11, green: 0.11, blue: 0.2), location: 1.00),
            ],
            startPoint: .top,
            endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            .overlay(
                ZStack{
                    VStack {
                        HStack{
                            Text("Weather forecast for: \(searchText)")
                                .font(.headline)
                        }
                        Spacer()
                        VStack(alignment: .center){
                            Text(formattedDate(from: dt))
                                .font(Font.custom("SF Pro Display", size: 34))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .top)
                            Text(weekdayName(from: dt))
                                .font(Font.custom("SF Pro Display", size: 20)
                                        .weight(.semibold))
                                .foregroundColor(Color(red: 0.92, green: 0.92, blue: 0.96).opacity(0.6))
                        }
                        ZStack{
                            Image("rectangle")
                                .resizable()
                                .scaledToFit()
                            HStack{
                                VStack(alignment: .leading) {
                                    VStack(alignment: .leading){
                                        Text("\(self.temp)º")
                                            .font(.system(size: 46, weight: .bold))
                                            .foregroundColor(.white)
                                    }
                                    HStack() {
                                        Image("wind")
                                            .resizable()
                                            .scaledToFit()
                                        Text("Wind:")
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundColor(Color(red: 0.682353, green: 0.682353, blue: 0.682353)).scaledToFit()
                                        Text("4 m/s")
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
                                        Text("\(Int(rain?.rounded() ?? 0)) mm")
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundColor(.white)
                                    }.scaledToFit()
                                }.scaledToFill()
                                Spacer()
                                VStack{
//                                    if let image = imageNamesAndDescriptions[weatherImage] {
//                                        image
//                                            .resizable()
//                                            .scaledToFit()
//                                                } else {
                                                    Image("Sun")
                                                        .resizable()
                                                        .scaledToFit()
                                              //  }
                                    Text("Mid Rain")
                                }.scaledToFit()
                            }.scaledToFit()
                        }
                        .background(Color.clear)
                        Spacer()
                        Image("view")
                            .resizable()
                            .scaledToFit().overlay(){
                            VStack{
                                Spacer()
                                Spacer()
                                Spacer()

                                HStack{
                                    HStack{
                                        Text("Hourly Forecast")
                                            .font(
                                                Font.custom("SF Pro Display", size: 15)
                                                    .weight(.bold)
                                            )
                                            .foregroundColor(Color(red: 0.92, green: 0.92, blue: 0.96).opacity(0.6))
                                    }
                                }
                                Spacer()
                                Spacer()
                                Spacer()
                                HStack{

                                    ScrollView(.horizontal) {
                                            HStack(spacing: 0) {
                                                ForEach(vm.weather) { index in
                                                    
                                                    ZStack{
                                                       // selectedItemIndex = 0.dt
                                                        RoundedRectangle(cornerRadius: 50)
                                                            .frame(width: 70, height: 170)
                                                            .foregroundColor(selectedItemIndex == index.dt ? Color(red: 0.28, green: 0.19, blue: 0.62) : Color(red: 0.28, green: 0.19, blue: 0.62).opacity(0.2))
                                                            .id(index.dt)
                                                            .onTapGesture {
                                                                withAnimation {
                                                                    selectedItemIndex = index.dt
                                                                    //self.weatherImage = imageNamesAndDescriptions[index.weather.first?.icon ?? "01d"]
                                                                    //self.weather = index.weather.first?
                                                                    wind = Int(index.wind_speed)
                                                                    temp = Int(index.temp)
                                                                    
                                                                }
                                                            }
                                                        VStack{
                                                            Text(formattedTime(from: index.dt))
                                                                .font(
                                                                    Font.custom("SF Pro Text", size: 15)
                                                                        .weight(.semibold)
                                                                )
                                                                .foregroundColor(.white)
                                                            if let image = imageNamesAndDescriptions[index.weather.first?.icon ?? "01d"] {
                                                                image
                                                                    .resizable()
                                                                    .aspectRatio(contentMode: .fill)
                                                                    .frame(width: 32, height: 32)
                                                                    .clipped()
                                                                      }
                                                            Text("\(Int(index.temp.rounded()))º")
                                                                .font(Font.custom("SF Pro Display", size: 20))
                                                                .kerning(0.38)
                                                                .foregroundColor(.white)
                                                        }
                                                    }
                                                
                                            }
                                            .padding(5)
                                        }
                                    }
                                }
                                Spacer()
                            }
                            }
                    }
                }
            )
        }.onAppear(){
            vm.didChangedText.send((searchText,dt))
        }
    }
}
