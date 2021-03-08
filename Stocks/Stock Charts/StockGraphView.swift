//
//  StockGraphView.swift
//  Stocks
//
//  Created by Scott on 3/7/21.
//

import SwiftUI

struct StockGraphView: View {
    var logs: [Double]
    @Binding var selectedIndex: Int
    @State var lineOffset: CGFloat = 8 // Vertical line offset
    @State var selectedXPos: CGFloat = 8 // User X touch location
    @State var selectedYPos: CGFloat = 0 // User Y touch location
    @State var isSelected: Bool = false // Is the user touching the graph
    
    init(logs: [Double], selectedIndex: Binding<Int>) {
        self._selectedIndex = selectedIndex
        self.logs = logs
    }
    
    var body: some View {
        drawGrid()
            .opacity(0.2)
            .overlay(drawActivityGradient(logs: logs))
            .overlay(drawActivityLine(logs: logs))
            .overlay(drawLogPoints(logs: logs))
            .overlay(addUserInteraction(logs: logs))
        
    }
    
    func drawGrid() -> some View {
        VStack(spacing: 0) {
            Color.secondary.frame(height: 1, alignment: .center)
            HStack(spacing: 0) {
                Color.clear
                    .frame(width: 8, height: 150)
                ForEach(0..<11) { i in
                    Color.secondary.frame(width: 1, height: 150, alignment: .center)
                    Spacer()
                    
                }
                Color.secondary.frame(width: 1, height: 150, alignment: .center)
                Color.clear
                    .frame(width: 8, height: 150)
            }
            Color.secondary.frame(height: 1, alignment: .center)
        }
    }
    
    func drawActivityGradient(logs: [Double]) -> some View {
        LinearGradient(gradient: Gradient(colors: [.green, .white]), startPoint: .top, endPoint: .bottom)
            .padding(.horizontal, 8)
            .padding(.bottom, 1)
            .opacity(0.8)
            .mask(
                GeometryReader { geo in
                    Path { p in
                        // Used for scaling graph data
                        let maxNum = logs.reduce(0) { (res, price) -> Double in
                            return max(res, price)
                        }
                        
                        let scale = geo.size.height / CGFloat(maxNum)
                        
                        //Index used for drawing (0-11)
                        var index: CGFloat = 0
                        
                        // Move to the starting y-point on graph
                        p.move(to: CGPoint(x: 8, y: geo.size.height - (CGFloat(logs[Int(index)]) * scale)))
                        
                        // For each day/week/month etc draw line from previous
                        for _ in logs {
                            if index != 0 {
                                p.addLine(to: CGPoint(x: 8 + ((geo.size.width - 16) / 11) * index, y: geo.size.height - (CGFloat(logs[Int(index)]) * scale)))
                            }
                            index += 1
                        }
                        
                        // Finally close the subpath off by looping around to the beginning point.
                        p.addLine(to: CGPoint(x: 8 + ((geo.size.width - 16) / 11) * (index - 1), y: geo.size.height))
                        p.addLine(to: CGPoint(x: 8, y: geo.size.height))
                        p.closeSubpath()
                    }
                }
            )
    }
    
    func drawActivityLine(logs: [Double]) -> some View {
        GeometryReader { geo in
            Path { p in
                let maxNum = logs.reduce(0) { (res, price) -> Double in
                    return max(res, price)
                }
                
                let scale = geo.size.height / CGFloat(maxNum)
                var index: CGFloat = 0
                
                p.move(to: CGPoint(x: 8, y: geo.size.height - (CGFloat(logs[0]) * scale)))
                
                for _ in logs {
                    if index != 0 {
                        p.addLine(to: CGPoint(x: 8 + ((geo.size.width - 16) / 11) * index, y: geo.size.height - (CGFloat(logs[Int(index)]) * scale)))
                    }
                    index += 1
                }
            }
            .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round, miterLimit: 80, dash: [], dashPhase: 0))
            .foregroundColor(.secondary)
        }
    }
    
    func drawLogPoints(logs: [Double]) -> some View {
        GeometryReader { geo in
            
            let maxNum = logs.reduce(0) { (res, price) -> Double in
                return max(res, price)
            }
            
            let scale = geo.size.height / CGFloat(maxNum)
            
            ForEach(logs.indices) { i in
                Circle()
                    .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round, miterLimit: 80, dash: [], dashPhase: 0))
                    .frame(width: 10, height: 10, alignment: .center)
                    .foregroundColor(.clear)
                    .background(Color.clear)
                    .cornerRadius(5)
                    .offset(x: 8 + ((geo.size.width - 16) / 11) * CGFloat(i) - 5, y: (geo.size.height - (CGFloat(logs[i]) * scale)) - 5)
            }
        }
    }
    
    func addUserInteraction(logs: [Double]) -> some View {
        GeometryReader { geo in
            
            let maxNum = logs.reduce(0) { (res, price) -> Double in
                return max(res, price)
            }
            
            let scale = geo.size.height / CGFloat(maxNum)
            
            ZStack(alignment: .leading) {
                // Line and point overlay
                Color(.white)
                    .frame(width: 2)
                    .overlay(
                        Circle()
                            .frame(width: 24, height: 24, alignment: .center)
                            .foregroundColor(.white)
                            .opacity(0.2)
                            .overlay(
                                Circle()
                                    .fill()
                                    .frame(width: 12, height: 12, alignment: .center)
                                    .foregroundColor(.white)
                            )
                            .offset(x: 0, y: isSelected ? 12 - (selectedYPos * scale) : 12 - (CGFloat(logs[selectedIndex]) * scale))
                        , alignment: .bottom)
                    
                    .offset(x: isSelected ? lineOffset : 8 + ((geo.size.width - 16) / 11) * CGFloat(selectedIndex), y: 0)
                    .animation(Animation.spring().speed(4))
                
                // Future Drag Gesture Code
                Color.white.opacity(0.1)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { touch in
                                let xPos = touch.location.x
                                self.isSelected = true
                                let index = (xPos - 8) / (((geo.size.width - 16) / 11))
                                
                                if index > 0 && index < 11 {
                                    let m = (logs[Int(index) + 1] - logs[Int(index)])
                                    self.selectedYPos = CGFloat(m) * index.truncatingRemainder(dividingBy: 1) + CGFloat(logs[Int(index)])
                                }
                                
                                if index.truncatingRemainder(dividingBy: 1) >= 0.5 && index < 11 {
                                    self.selectedIndex = Int(index) + 1
                                } else {
                                    self.selectedIndex = Int(index)
                                }
                                self.selectedXPos = min(max(8, xPos), geo.size.width - 8)
                                self.lineOffset = min(max(8, xPos), geo.size.width - 8)
                            }
                            .onEnded { touch in
                                let xPos = touch.location.x
                                self.isSelected = false
                                let index = (xPos - 8) / (((geo.size.width - 16) / 11))
                                
                                if index.truncatingRemainder(dividingBy: 1) >= 0.5 && index < 11 {
                                    self.selectedIndex = Int(index) + 1
                                } else {
                                    self.selectedIndex = Int(index)
                                }
                            }
                    )
            }
        }
    }
}
