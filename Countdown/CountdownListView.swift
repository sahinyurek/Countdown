//
//  CountdownListView.swift
//  Countdown
//
//  Created by Şahin Yürek on 10/6/23.
//

import SwiftUI

struct CountdownListView: View {
    @State private var viewModels: [CountdownItemViewModel]
    @State private var name = ""

    init() {
        if let savedData = UserDefaults.standard.data(forKey: "countdownItems"),
           let loadedItems = try? JSONDecoder().decode([CountdownItem].self, from: savedData)
        {
            self._viewModels = State(initialValue: loadedItems.map { CountdownItemViewModel(countdownItem: $0) })
        } else {
            self._viewModels = State(initialValue: [])
        }
    }

    var body: some View {
        VStack {
            List {
                ForEach(viewModels) { item in
                    CountdownView(viewModel: item)
                        .onReceive(item.targetDatePublisher) { _ in
                            saveToUserDefaults()
                        }
                }
                .onDelete { indices in
                    viewModels.remove(atOffsets: indices)
                    saveToUserDefaults()
                }
            }

            Spacer()
            HStack {
                TextField("Anniversary", text: $name)
                Button("Add") {
                    let newItem = CountdownItem(countdownName: name, targetDate: Date())
                    let newViewModel = CountdownItemViewModel(countdownItem: newItem)
                    viewModels.append(newViewModel)
                    newViewModel.saveCountdownItem()
                    saveToUserDefaults()
                    name = ""
                }
            }
            .padding()
        }
    }

    private func saveToUserDefaults() {
        let encoded = try? JSONEncoder().encode(viewModels.map { $0.countdownItem })
        UserDefaults.standard.set(encoded, forKey: "countdownItems")
    }
}

#Preview {
    CountdownListView()
}
