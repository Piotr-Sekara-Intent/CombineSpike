//
//  AnyScheduler.swift
//  CombineSpike
//
//  Created by Piotr on 24/06/2021.
//

import Combine
import Foundation

final class AnyScheduler<S: Scheduler>: AnySchedulerBase<S.SchedulerTimeType, S.SchedulerOptions> { }

extension AnyScheduler {
    static var main: AnyScheduler<DispatchQueue> {
        DispatchQueue.main.eraseToAnyScheduler()
    }

    static func global(qos: DispatchQoS.QoSClass = .default) -> AnyScheduler<DispatchQueue> {
        DispatchQueue.global(qos: qos).eraseToAnyScheduler()
    }
}
