//
//  SearchTextView.swift
//  Stocks
//
//  Created by Scott on 3/4/21.
//

import SwiftUI

struct SearchTextView: View {
    @Binding var searchTerm: String
    @Binding var isSearching: Bool
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .imageScale(.medium)
                TextField("Search stocks", text: $searchTerm)
                    .font(.custom("Avenir", size: 18))
                    .keyboardType(.default)
                if isSearching {
                    Button(action: { searchTerm = "" }) {
                        Image(systemName: "xmark.circle")
                            .imageScale(.medium)
                            .foregroundColor(.primary)
                    }
                }
            }
            .padding(8)
            .background(Color(.systemGray5))
            .cornerRadius(10)
            .padding(.horizontal)
            .onTapGesture {
                isSearching = true
            }
            .transition(.move(edge: .trailing))
            .animation(.spring())
            
            if isSearching {
                Button(action: {
                    isSearching = false
                    searchTerm = ""
                    
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    Text("Cancel")
                        .font(.custom("Avenir", size: 18))
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .padding(.trailing)
                        .padding(.leading, 0)
                }
            }
        }
    }
}

struct SearchTextView_Previews: PreviewProvider {
    static var previews: some View {
        SearchTextView(searchTerm: .constant(""), isSearching: .constant(false))
    }
}
