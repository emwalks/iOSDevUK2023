import UIKit

// putting in playground until watchOS downloaded

// Project > WatchApp Target >

// HeartRateFetcher

final class HeartRateFetcher: ObservableObject {
    @Published var heartRate: Double = 0.0
    
    //private let healthStore = /

}


@AppStorage private var highestVlaue
@AppStorage private var lowestValue

@StateObject private var HeartRateFetcher()
private let timer = Timer.publish(every: 1, on: .main, in: .common)

@State private var selecton: Int 0

Text("\(sensor.heartrate)", specifier:"%.0f")

    .task {
        awat senseor.startSensor()
    }
    .onReceive(timer, perform: { _ in
        sensor.heartRate = Int.random(in: 90...100)
    })
    .tag(0)
