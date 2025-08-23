//
//  MotionManager.swift
//  FireBug
//
//  Created by 이승진 on 8/24/25.
//

import CoreMotion
import SwiftUI

@Observable
final class MotionManager: ObservableObject {
    private let motionManager = CMMotionManager()
    private let updateInterval = 1.0 / 30.0

    var heading: Double = 0.0
    private var lastYaw: Double = 0.0

    init() {
        startUpdates()
    }

    private func smoothYaw(_ new: Double) -> Double {
        let alpha = 0.15
        lastYaw = (1 - alpha) * lastYaw + alpha * new
        return lastYaw
    }

    func startUpdates() {
        guard motionManager.isDeviceMotionAvailable else { return }

        motionManager.deviceMotionUpdateInterval = updateInterval
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] motion, _ in
            guard let motion = motion else { return }

            let yaw = motion.attitude.yaw
            let smoothed = self?.smoothYaw(yaw) ?? yaw

            DispatchQueue.main.async {
                withAnimation(.linear(duration: 0.1)) {
                    self?.heading = smoothed
                }
            }
        }
    }
}
