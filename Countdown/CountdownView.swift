//
//  ContentView.swift
//  Countdown
//
//  Created by Şahin Yürek on 10/6/23.
//

import SwiftUI

import SwiftUI

struct CountdownView: View {
    @ObservedObject var viewModel: CountdownItemViewModel
    @State private var remainingTime: Date

    init(viewModel: CountdownItemViewModel) {
        self.viewModel = viewModel
        _remainingTime = State(initialValue: viewModel.countdownItem.targetDate)
    }

    var body: some View {
        VStack {
            HStack {
                Text(viewModel.countdownItem.countdownName)
                Spacer()
                Text("\(Int(remainingTime.timeIntervalSinceNow/86400)) days left")
            }
            DatePicker(selection: $remainingTime, label: { Text("Date") })
                .onChange(of: remainingTime) { oldValue, newValue in
                    viewModel.updateTargetDate(newValue)
                }
        }
        .padding()
    }
}


#Preview {
    CountdownView(viewModel: CountdownItemViewModel())
}
