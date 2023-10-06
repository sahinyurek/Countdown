//
//  CountdownItemViewModel.swift
//  Countdown
//
//  Created by Şahin Yürek on 10/6/23.
//

import Foundation
import Combine

struct CountdownItem: Identifiable, Codable {
    let id = UUID()
    var countdownName: String
    var targetDate: Date
}

class CountdownItemViewModel: ObservableObject, Identifiable {
    @Published var countdownItem: CountdownItem
    @Published var targetDatePublisher = PassthroughSubject<Date, Never>()
    
    init(countdownItem: CountdownItem) {
        self.countdownItem = countdownItem
    }

    init() {
        if let savedCountdownItem = UserDefaults.standard.data(forKey: "countdownItem"),
           let loadedCountdownItem = try? JSONDecoder().decode(CountdownItem.self, from: savedCountdownItem) {
            self.countdownItem = loadedCountdownItem
        } else {
            self.countdownItem = CountdownItem(countdownName: "", targetDate: Date())
        }
    }
    
    func updateTargetDate(_ newDate: Date) {
        countdownItem.targetDate = newDate
        targetDatePublisher.send(newDate)
        saveCountdownItem()
    }

    func saveCountdownItem() {
        if let encoded = try? JSONEncoder().encode(countdownItem) {
            UserDefaults.standard.set(encoded, forKey: "countdownItem")
        }
    }
    
}



