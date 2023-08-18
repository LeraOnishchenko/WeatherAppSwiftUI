//
//  ContentView.swift
//  combineRx
//
//  Created by lera on 05.04.2023.
//

import SwiftUI

struct ContentView: View {
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UISearchBar.appearance().setImage(searchBarImage(),for: .search, state: .normal)
        UISearchBar.appearance().setImage(searchBarImageq(),for: .clear, state: .normal)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self])
                .attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.63, green: 0.62, blue: 0.72, alpha: 1.0)])
       }
    
    @ObservedObject var vm = ViewModel()
    @State private var selectedItem: WeatherData.Daily?
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
                        
            ZStack{
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
                VStack(alignment: .leading) {
                    HStack{
                        
                        Text("Weather forecast for: \(searchText)")
                            .font(.headline)
                            .padding(.leading)
                    }
                    
                    List(vm.weather)  { weather in
                        NavigationLink(destination: DetailView(selectedItem: weather.temp.day)) {
                            WeatherCellView(dayTemp: weather.temp.day, windSpeed: weather.wind_speed, rain: weather.rain ?? 0.0, dt: weather.dt, weather: weather.weather.first?.main ?? "", weatherImage: weather.weather.first?.icon ?? "" )
                            //                            .onTapGesture {
                            //                            selectedItem = weather
                            //                        }
                        }
                        
                    }.scrollContentBackground(.hidden)
                        .background(Color.clear)
                                    .onChange(of: searchText) { newValue in
                                        vm.didChangedText.send(newValue)
                                   }
                }
                )
                }
            
            .navigationTitle("Weather App")
            .navigationBarTitleDisplayMode(.large)
        }
        .searchable(text:$searchText).foregroundColor(.white).tint(Color(red: 0.25, green: 0.8, blue: 0.85))
        .onChange(of: searchText) { newValue in
                        print(vm.weather)
                    }
    }
    private func searchBarImage() -> UIImage {
        let image = UIImage(systemName: "magnifyingglass")
        return image!.withTintColor(UIColor(red: 0.63, green: 0.62, blue: 0.72, alpha: 1.0), renderingMode: .alwaysOriginal)
    }
    
    private func searchBarImageq() -> UIImage {
        let image = UIImage(systemName: "xmark.circle.fill")
        return image!.withTintColor(UIColor(red: 0.63, green: 0.62, blue: 0.72, alpha: 1.0), renderingMode: .alwaysOriginal)
    }
}

struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }

    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        UIViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        if let nc = uiViewController.navigationController {
            self.configure(nc)
        }
    }

}

struct DetailView: View {
    var selectedItem: Double

    var body: some View {
        Text("Selected Item: \(selectedItem)")
            .navigationBarTitle("Detail")
    }
}

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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
