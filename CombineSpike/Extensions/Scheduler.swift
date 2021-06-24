//
//  Scheduler.swift
//  CombineSpike
//
//  Created by Piotr on 24/06/2021.
//

import Combine
import Foundation

extension Scheduler {
    func eraseToAnyScheduler<S: Scheduler>() -> AnyScheduler<S> where S.SchedulerOptions == SchedulerOptions, S.SchedulerTimeType == SchedulerTimeType {
            AnyScheduler(scheduler: self)
        }
}
