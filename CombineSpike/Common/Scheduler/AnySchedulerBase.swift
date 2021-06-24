//
//  AnySchedulerBase.swift
//  CombineSpike
//
//  Created by Piotr on 24/06/2021.
//

import Combine
import Foundation

class AnySchedulerBase<Time: Strideable, Options>: Scheduler where Time.Stride: SchedulerTimeIntervalConvertible {
    // MARK: - Properties

    typealias SchedulerTimeType = Time
    typealias SchedulerOptions = Options

    var now: Time
    var minimumTolerance: Time.Stride

    private var scheduleClosure: (_ options: Options?, _ action: @escaping () -> Void) -> Void
    private var scheduleAfterClosure: (_ date: Time, _ tolerance: Time.Stride, _ options: SchedulerOptions?, _ action: @escaping () -> Void) -> Void
    private var scheduleAfterCancellableClosure: (_ date: SchedulerTimeType, _ interval: SchedulerTimeType.Stride, _ tolerance: SchedulerTimeType.Stride, _ options: SchedulerOptions?, _ action: @escaping () -> Void) -> Cancellable

    // MARK: - Initializers

    init<S: Scheduler>(scheduler: S) where S.SchedulerTimeType == Time, S.SchedulerOptions == Options {
        now = scheduler.now
        minimumTolerance = scheduler.minimumTolerance

        scheduleClosure = { options, action in
            scheduler.schedule(options: options, action)
        }

        scheduleAfterClosure = { date, tolerance, options, action in
            scheduler.schedule(after: date, tolerance: tolerance, options: options, action)
        }

        scheduleAfterCancellableClosure = { date, interval, tolerance, options, action in
            scheduler.schedule(after: date, interval: interval, tolerance: tolerance, options: options, action)
        }
    }

    // MARK: - Functions

    func schedule(options: Options?, _ action: @escaping () -> Void) {
        scheduleClosure(options, action)
    }

    func schedule(after date: Time, tolerance: Time.Stride, options: SchedulerOptions?, _ action: @escaping () -> Void) {
        scheduleAfterClosure(date, tolerance, options, action)
    }

    func schedule(after date: SchedulerTimeType, interval: SchedulerTimeType.Stride, tolerance: SchedulerTimeType.Stride, options: SchedulerOptions?, _ action: @escaping () -> Void) -> Cancellable {
        scheduleAfterCancellableClosure(date, interval, tolerance, options, action)
    }
}
