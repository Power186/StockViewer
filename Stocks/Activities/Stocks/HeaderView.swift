//
//  HeaderView.swift
//  Stocks
//
//  Created by Scott on 3/4/21.
//

import SwiftUI

struct HeaderView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .imageScale(.large)
                    .shadow(radius: 1)
            }
            .padding(.leading, 10)
            .padding(12)
            Spacer()
            Button(action: {
                // TODO: Add sharing of stock data across apps
            }) {
                Image(systemName: "square.and.arrow.up")
                    .imageScale(.large)
                    .shadow(radius: 1)
            }
            .padding(.trailing, 10)
            .padding(12)
        }
        .foregroundColor(.green)
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
    }
}
