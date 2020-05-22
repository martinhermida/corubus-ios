//
//  LineNumber.swift
//  Corubus
//
//  Created by Martín Hermida on 21/05/2020.
//  Copyright © 2020 Martín Hermida. All rights reserved.
//

import SwiftUI

struct LineNumber: View {
    var line: Line

    var body: some View {
        ZStack {
            Color(hex: line.color)
            Text(line.code)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(Color.white)
        }
        .frame(width: 40, height: 40, alignment: .center)
        .cornerRadius(5)
    }
}
