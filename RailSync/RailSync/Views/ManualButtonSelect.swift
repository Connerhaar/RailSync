//
//  ManualButtonSelect.swift
//  RailSync
//
//  Created by Conner Haar on 4/7/25.
//

import SwiftUI

struct ManualButtonSelect: View {
    let isSelected: Bool
    let buttonName: String
    let onTap: () -> Void
    
    var body: some View {
        Text(buttonName)
            .foregroundStyle(isSelected ? .white : .t400)
            .padding(.vertical, 5)
            .padding(.horizontal, 10)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .strokeBorder(isSelected ? .clear : Color.t400, lineWidth: 1)
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .fill(isSelected ? Color.b600 : .clear)
                    )
            )
            .onTapGesture {
                onTap()
            }
    }
}

#Preview {
    HStack {
        ManualButtonSelect( isSelected: true, buttonName: "S-60"){}
        ManualButtonSelect( isSelected: false, buttonName: "FRA Manual"){}
    }
}
