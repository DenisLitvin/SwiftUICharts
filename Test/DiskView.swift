//
//  Disk.swift
//  Test
//
//  Created by Denis Litvin on 7/12/23.
//

import SwiftUI

struct DiskView: View {
    var body: some View {
        StackChartView(lineSpacing: 1, lineHeight: 2, lineCount: 30, ratio: 0.9)
            .rotationEffect(.degrees(180)) // upside down
            .frame(width: 100, height: 100)
    }
}

struct StackChartView: View {
    let lineSpacing: CGFloat
    let lineHeight: CGFloat
    let lineCount: Int
    let ratio: Double
    
    var body: some View {
        VStack(spacing: lineSpacing) {
            ForEach(0..<lineCount, id: \.self) { index in
                LineView(color: index <= Int(ratio * Double(lineCount)) ? gradientColor(for: Double(index) / Double(lineCount - 1)) : .gray.opacity(0.3),
                         lineHeight: lineHeight)
                .frame(height: lineHeight)
            }
        }
        .padding(5)
        .addBorder(.gray.opacity(0.3), width: 0.5, cornerRadius: 5)
    }
    
    func gradientColor(for gradation: Double) -> Color {
        let startColor = Color.green
        let midColor = Color.yellow
        let endColor = Color.red
        
        let progress = min(max(gradation, 0.0), 1.0)
        
        if progress <= 0.5 {
            let normalizedProgress = progress * 2
            return Color.blend(startColor, midColor, progress: normalizedProgress)
        } else {
            let normalizedProgress = (progress - 0.5) * 2
            return Color.blend(midColor, endColor, progress: normalizedProgress)
        }
    }
}

struct LineView: View {
    let color: Color
    let lineHeight: CGFloat

    var body: some View {
        GeometryReader { geometry in
            RoundedRectangle(cornerRadius: lineHeight/2)
                .fill(color)
                .frame(width: geometry.size.width, height: lineHeight)
        }
    }
}


struct DiskView_Previews: PreviewProvider {
    static var previews: some View {
        DiskView()
            .padding()
    }
}
