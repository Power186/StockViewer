//
//  ContentView.swift
//  Stocks
//
//  Created by Scott on 3/2/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            StocksView()
                .tabItem {
                    Image(systemName: "note")
                        .imageScale(.large)
                    Text("Stocks")
                        .font(.title)
                }
                .tag(1)
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                        .imageScale(.large)
                    Text("Search")
                }
                .tag(2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
