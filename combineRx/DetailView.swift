//
//  DetailView.swift
//  combineRx
//
//  Created by lera on 18.08.2023.
//

import Foundation
import SwiftUI

struct DetailView: View {
    var selectedItem: Double

    var body: some View {
        ZStack {
            Text("17 th Jun `23")
                .font(Font.custom("SF Pro Display", size: 34))
                .kerning(0.374)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .top) }
        .frame(width: 375, height: 812)
        .background(
          LinearGradient(
            stops: [
              Gradient.Stop(color: Color(red: 0.18, green: 0.2, blue: 0.35), location: 0.00),
              Gradient.Stop(color: Color(red: 0.11, green: 0.11, blue: 0.2), location: 1.00),
            ],
            startPoint: UnitPoint(x: 0.03, y: -0.06),
            endPoint: UnitPoint(x: 0.93, y: 0.96)
          )
        )
        
//        Text("Selected Item: \(selectedItem)")
//            .navigationBarTitle("Detail")
    }
}
