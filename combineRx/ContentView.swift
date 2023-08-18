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
               
                VStack(alignment: .leading) {
                    HStack{
                        
                        Text("Weather forecast for: \(searchText)")
                            .font(.headline)
                            .padding(.leading)
                    }
                    
                   // NavigationStack{
                        List(vm.weather)  { weather in
                            //NavigationLink(destination: DetailView(selectedItem: weather.temp.day)){
                                WeatherCellView(dayTemp: weather.temp.day, windSpeed: weather.wind_speed, rain: weather.rain ?? 0.0, dt: weather.dt, weather: weather.weather.first?.main ?? "", weatherImage: weather.weather.first?.icon ?? "" )
                                }.background(Color.clear)
                            //}.buttonStyle(PlainButtonStyle())
                            
                        //}.scrollContentBackground(.hidden)
                        .background(Color.clear)
                                    .onChange(of: searchText) { newValue in
                                        vm.didChangedText.send(newValue)
                                   }
                }.background(Color.clear)
             
                }
            )
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



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
