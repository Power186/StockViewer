//
//  StaticChartView.swift
//  Stocks
//
//  Created by Scott on 3/8/21.
//

import SwiftUI

struct LineGraph: Shape {
    var dataPoints: [CGFloat]
    var selectedIndex = 0

    func path(in rect: CGRect) -> Path {

        func point(at ix: Int) -> CGPoint {
            let point = dataPoints[ix]
            let x = rect.width * CGFloat(ix) / CGFloat(dataPoints.count - 1)
            let y = (1 - point) * rect.height
            return CGPoint(x: x, y: y)
        }

        return Path { p in
            guard dataPoints.count > 1 else { return }
            let start = dataPoints[0]
            p.move(to: CGPoint(x: 0, y: (1 - start) * rect.height))

            for idx in dataPoints.indices {
                p.addLine(to: point(at: idx))
            }
        }
    }
}

struct ChartView: View {
    let quote: Quote
    @State private var dataPoints = ChartMockData.oneMonth.normalized
    
    var body: some View {
        VStack {
            LineGraph(dataPoints: dataPoints)
                .stroke(configureColor())
                .aspectRatio(contentMode: .fit)
                .border(Color.clear)
        }
        .padding()
    }
    
    private func configureColor() -> Color {
        var result = Color.red
        if quote.open < quote.previousClose {
            result = Color.green
        }
        return result
    }
    
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(quote: Quote(symbol: "", open: "", price: "", previousClose: "", change: "", changePercent: ""))
    }
}

// can be doubles or float numbers
extension Array where Element == Double {
    // returns the elements of the sequence, normalized
    var normalized: [CGFloat] {
        if let min = self.min(), let max = self.max() {
            return self.map { CGFloat(($0 - min) / (max - min)) }
        }
        return []
    }
}
