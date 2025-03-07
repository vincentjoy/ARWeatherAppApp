//
//  ContentView.swift
//  ARWeatherApp
//
//  Created by Vincent Joy on 06/03/25.
//

import SwiftUI

struct ContentView: View {
    
    @State var cityName: String = "New York"
    @State var isSearchBarVisible: Bool = true
    @State var viewModel = WeatherAppViewModel()
    
    var body: some View {
        
        VStack {
            
            if isSearchBarVisible {
                // Search bar
                SearchBar(cityName: $cityName)
                    .transition(.scale)
            }
            
            if let weatherData = viewModel.weatherDetails?.description {
                Text(weatherData)
            }
            
            Spacer()
            
            // Search toggle
            SearchToggle(isSearchToggle: $isSearchBarVisible)
        }
        .onChange(of: cityName) { _, newValue in
            viewModel.fetchWeatherDetails(for: newValue)
        }
    }
}

#Preview {
    ContentView()
}

struct SearchBar: View {
    
    @State var searchText: String = ""
    @Binding var cityName: String

    var body: some View {
        HStack {
            
            // Search icon
            Image(systemName: "magnifyingglass")
                .font(.system(size: 30))
            
            // Search text
            TextField("Search", text: $searchText) { value in
                print("Typing in progress")
            } onCommit: {
                cityName = searchText
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.black.opacity(0.15))
    }
}

struct SearchToggle: View {
    
    @Binding var isSearchToggle: Bool
    
    var body: some View {
        Button {
            withAnimation {
                // Toggle the search bar
                isSearchToggle = !isSearchToggle
            }
        } label: {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 40))
                .foregroundStyle(Color.black)
        }

    }
}
