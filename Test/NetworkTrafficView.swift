//
//  ContentView.swift
//  Test
//
//  Created by Denis Litvin on 7/10/23.
//

import SwiftUI

// defines OptionSet, which corners to be rounded – same as UIRectCorner
struct RectCorner: OptionSet {
    
    let rawValue: Int
        
    static let topLeft = RectCorner(rawValue: 1 << 0)
    static let topRight = RectCorner(rawValue: 1 << 1)
    static let bottomRight = RectCorner(rawValue: 1 << 2)
    static let bottomLeft = RectCorner(rawValue: 1 << 3)
    
    static let allCorners: RectCorner = [.topLeft, topRight, .bottomLeft, .bottomRight]
}


// draws shape with specified rounded corners applying corner radius
struct RoundedCornersShape: Shape {
    
    var radius: CGFloat = .zero
    var corners: RectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let p1 = CGPoint(x: rect.minX, y: corners.contains(.topLeft) ? rect.minY + radius  : rect.minY )
        let p2 = CGPoint(x: corners.contains(.topLeft) ? rect.minX + radius : rect.minX, y: rect.minY )

        let p3 = CGPoint(x: corners.contains(.topRight) ? rect.maxX - radius : rect.maxX, y: rect.minY )
        let p4 = CGPoint(x: rect.maxX, y: corners.contains(.topRight) ? rect.minY + radius  : rect.minY )

        let p5 = CGPoint(x: rect.maxX, y: corners.contains(.bottomRight) ? rect.maxY - radius : rect.maxY )
        let p6 = CGPoint(x: corners.contains(.bottomRight) ? rect.maxX - radius : rect.maxX, y: rect.maxY )

        let p7 = CGPoint(x: corners.contains(.bottomLeft) ? rect.minX + radius : rect.minX, y: rect.maxY )
        let p8 = CGPoint(x: rect.minX, y: corners.contains(.bottomLeft) ? rect.maxY - radius : rect.maxY )

        
        path.move(to: p1)
        path.addArc(tangent1End: CGPoint(x: rect.minX, y: rect.minY),
                    tangent2End: p2,
                    radius: radius)
        path.addLine(to: p3)
        path.addArc(tangent1End: CGPoint(x: rect.maxX, y: rect.minY),
                    tangent2End: p4,
                    radius: radius)
        path.addLine(to: p5)
        path.addArc(tangent1End: CGPoint(x: rect.maxX, y: rect.maxY),
                    tangent2End: p6,
                    radius: radius)
        path.addLine(to: p7)
        path.addArc(tangent1End: CGPoint(x: rect.minX, y: rect.maxY),
                    tangent2End: p8,
                    radius: radius)
        path.closeSubpath()

        return path
    }
}




let upload: [Double] = [1,3,1,4,10,40,10,3,1,13,1,3,1,20,10,8,13,19,2,1,2,0.3,1,1,0.2,0.1,3,5,0.3,0.1,1,3,1,4,10,40,20,17,18,10,3,1,13,1,3,1,20,3,1,2]
let download: [Double] = [0.1,3,5,0.3,0.1,1,3,1,4,10,0.1,3,5,0.3,0.1,1,3,1,4,10,40,20,17,18,10,3,1,13,1,3,1,20,3,1,2,40,20,17,18,10,3,1,13,1,3,1,20,3,1,2]


struct NetworkTrafficView: View {
    // Declare your data variable for the graph
    @State private var uploadData: [Double] = upload
    @State private var downloadData: [Double] = download

    let barWidth: CGFloat = 10
    let shadowRadius: CGFloat = 2
    let numberOfHLines: Int = 2

    var body: some View {
        VStack(spacing: 0) {
            // Top chart
            HStack {
                ChartView(data: downloadData,
                          barWidth: barWidth,
                          shadowRadius: shadowRadius,
                          gradientColors: [.blue, Color(red: 0/255, green: 169/255, blue: 249/255)],
                          numberOfHLines: numberOfHLines)
                VStack() {
                    Text("\(Int(downloadData.max() ?? 0)) Mb/s")
                        .foregroundColor(.gray)
                        .frame(height: 40)
                    Spacer()
                    Text("\(Int(downloadData.max() ?? 0) / 2) Mb/s")
                        .foregroundColor(.gray)
                    Spacer()
                }
            }
            
            // Zero line between the charts
//            Rectangle()
//                .frame(height: 2)
//                .foregroundColor(.gray)
            
            // Bottom chart (mirrored)
            HStack {
                ChartView(data: upload.reversed(),
                          barWidth: barWidth,
                          shadowRadius: shadowRadius,
                          gradientColors: [.red, Color(red: 255/255, green: 126/255, blue: 0)],
                          numberOfHLines: numberOfHLines)
                    .rotationEffect(.degrees(180)) // Mirror upside down
                VStack() {
                    Spacer()
                    Text("\(Int(uploadData.max() ?? 0) / 2) Mb/s")
                        .foregroundColor(.gray)
                    Spacer()
                    Text("\(Int(downloadData.max() ?? 0)) Mb/s")
                        .foregroundColor(.gray)
                        .frame(height: 40)
                }
            }
        }
    }
}

struct ChartView: View {
    var data: [Double]
    
    let barWidth: CGFloat
    let shadowRadius: CGFloat
    let gradientColors: [Color]
    let numberOfHLines: Int

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Horizontal grid lines
                ForEach(0..<numberOfHLines, id: \.self) { index in
                    let y = geometry.size.height / CGFloat(numberOfHLines) * CGFloat(index) + 20
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: geometry.size.width, y: y))
                    }
                    .stroke(Color.gray.opacity(0.3), style: StrokeStyle(lineWidth: 1))
                }
                
                // Vertical grid lines
//                ForEach(0..<data.count) { index in
//                    let x = geometry.size.width / CGFloat(data.count - 1) * CGFloat(index)
//                    Path { path in
//                        path.move(to: CGPoint(x: x, y: 0))
//                        path.addLine(to: CGPoint(x: x, y: geometry.size.height))
//                    }
//                    .stroke(Color.gray, style: StrokeStyle(lineWidth: 0.5, dash: [5]))
//                }
                
                // Data points as vertical bars with rounded top corners
                let maxValue = data.max() ?? 0
                ForEach(Array(zip(data.indices, data)), id: \.0) { index, item in
                    let x = (geometry.size.width / CGFloat(data.count - 1)) * CGFloat(index)
                    let barHeight = max(5, (geometry.size.height / CGFloat(maxValue)) * CGFloat(data[index]))
                    //background
//                    VStack {
//                        Spacer()
//                        RoundedCornersShape(radius: barWidth/2, corners: [RectCorner.topLeft, RectCorner.topRight])
//                            .foregroundColor(.gray.opacity(0.1))
//                            .frame(width: barWidth, height: (geometry.size.height / CGFloat(maxValue)) * maxValue)
//                        Spacer()
//                    }
//                    .position(x: x, y: geometry.size.height - ((geometry.size.height / CGFloat(maxValue)) * maxValue) / 2)
                    //bar
                    VStack {
                        RoundedCornersShape(radius: barWidth*0.4, corners: [RectCorner.topLeft, RectCorner.topRight])
                            .fill(gradientColor(for: data[index], maxValue: maxValue))
                            .frame(width: barWidth, height: barHeight)
                            .shadow(color: .gray, radius: shadowRadius, x: 0, y: 0)
                    }
                    .position(x: x, y: geometry.size.height - barHeight / 2)
                }
            }
        }
    }
    func gradientColor(for value: Double, maxValue: Double) -> LinearGradient {
        let startColor = gradientColors[0]
        let endColor = gradientColors[1]
        let progress = value / maxValue
        return LinearGradient(gradient: Gradient(colors: [startColor, endColor]), startPoint: .top, endPoint: .bottom)
//            .rotationEffect(.degrees(180 * progress))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NetworkTrafficView()
    }
}
