//
//  SearchView.swift
//  Stocks
//
//  Created by Scott on 3/2/21.
//

import SwiftUI

struct SearchView: View {
    @State private var searchTerm = ""
    @State private var isSearching = false
    @ObservedObject var searchManager = SearchManager()
    @ObservedObject var quotesVM = QuoteManager()
    @State private var stocks: [String] = []
    @State private var isDetailSheetShowing = false
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.clear
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    HStack {
                        SearchTextView(searchTerm: $searchTerm, isSearching: $isSearching)
                        
                        Button(action: {
                            searchManager.searchStocks(keyword: searchTerm)
                        }) {
                            Image(systemName: "play.circle.fill")
                                .imageScale(.large)
                                .foregroundColor(.green)
                        }
                    }
                    Text("\(searchManager.searches.count) results")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(8)
                    
                    Spacer()
                    ScrollView {
                        ForEach(searchManager.searches) { item in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(item.symbol)
                                        .font(.headline)
                                        .bold()
                                    Text(item.type)
                                        .font(.subheadline)
                                }
                                Spacer()
                                Text(item.name)
                                    .font(.subheadline)
                                Spacer()
                                Button(action: {
                                    // Detail View Here
                                    stocks.append(item.symbol)
                                    fetchData(for: stocks)
                                    isDetailSheetShowing.toggle()
                                }) {
                                    Image(systemName: "info.circle")
                                        .imageScale(.large)
                                        .padding(8)
                                }
                                .sheet(isPresented: $isDetailSheetShowing, content: {
                                    StockDetailView(quote: quotesVM.quotes.first ?? Quote(symbol: "", open: "", price: "", previousClose: "", change: "", changePercent: ""))
                                        .onDisappear(perform: {
                                            stocks.removeAll()
                                            quotesVM.quotes.removeAll()
                                        })
                                        .environment(\.managedObjectContext, viewContext)
                                })
                            }.animation(.easeIn)
                            Divider()
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(.top, 20)
                .padding(.horizontal, 16)
                .navigationBarTitle("Search")
            }
        }
    } // body
    
    private func fetchData(for symbols: [String]) {
        quotesVM.download(stocks: symbols) { _ in
            // do something with stocks
        }
    }
    
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

