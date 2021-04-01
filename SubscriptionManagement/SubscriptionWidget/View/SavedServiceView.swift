//
//  SavedServiceView.swift
//  SubscriptionWidgetExtension
//
//  Created by LoganBerry on 2021/02/14.

import UIKit
import SwiftUI

struct SavedServiceView: View {
    let entry: SubscriptionEntry

    var body: some View {
        VStack(alignment: .leading) {
            ForEach(0..<4) { index in
                HStack() {
                    if let image = UIImage(data: entry.list[index].icon) {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(5.0)
                            .frame(minWidth: 10,
                                   idealWidth: 24,
                                   maxWidth: 24,
                                   minHeight: 10,
                                   idealHeight: 24,
                                   maxHeight: 24,
                                   alignment: .leading)
                    }
                    
                    VStack(alignment: .leading) {
                        Text(entry.list[index].name)
                            .font(.system(size: 10))
                            .fontWeight(.light)
                            .foregroundColor(.white)

                        Text(entry.list[index].payment)
                            .font(.system(size: 10))
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                    }

                    Spacer()

                    VStack (alignment: .trailing) {
                        let calendar = Calendar.current
                        let day = calendar.dateComponents([.day],
                                                          from: calendar.startOfDay(for: Date()),
                                                          to: calendar.startOfDay(for: entry.list[index].paymentDate)).day ?? 0
                        Text("D-\(day)")
                            .font(.system(size: 13))
                            .fontWeight(.bold)
                            .foregroundColor(.white)

                        Text(entry.list[index].paymentDate.formattedString())
                            .font(.system(size: 7))
                            .fontWeight(.regular)
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .padding(.leading, 20)
        .padding(.trailing, 20)
    }
}
