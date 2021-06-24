//
//  TestScheduler.swift
//  CombineSpikeTests
//
//  Created by Piotr on 24/06/2021.
//

import Combine
import Foundation
@testable import CombineSpike

final class TestScheduler: Scheduler {
    // MARK: - Types
    typealias SchedulerTimeType = DispatchQueue.SchedulerTimeType
    typealias SchedulerOptions = DispatchQueue.SchedulerOptions

    // MARK: - Properties

    /// Scheduler needs to be advanced before execution for delayed actions with interval.
    var enableImmediateExecutionIfPossible = true

    var now: DispatchQueue.SchedulerTimeType = .init(.now())

    var minimumTolerance: DispatchQueue.SchedulerTimeType.Stride = .zero

    var immediateActions: [ImmediateAction] = []
    var delayedActions: [DelayedAction] = []
    var delayedIntervalActions: [DelayedIntervalAction] = []

    // MARK: - Initializers
    init() {}

    // MARK: - Functions

    func advance(by interval:  DispatchQueue.SchedulerTimeType.Stride) {
        now = now.advanced(by: interval)
    }

    func schedule(options: DispatchQueue.SchedulerOptions?, _ action: @escaping () -> Void) {
        immediateActions.append(
            ImmediateAction(options: options, action: action)
        )

        if enableImmediateExecutionIfPossible {
            action()
        }
    }

    func schedule(
        after: SchedulerTimeType,
        tolerance: SchedulerTimeType.Stride,
        options: SchedulerOptions?,
        _ action: @escaping () -> Void
    ) {
        delayedActions.append(
            DelayedAction(
                after: after,
                tolerance: tolerance,
                options: options,
                action: action
            )
        )

        if enableImmediateExecutionIfPossible {
            action()
        }
    }

    func schedule(
        after: SchedulerTimeType,
        interval: SchedulerTimeType.Stride,
        tolerance: SchedulerTimeType.Stride,
        options : SchedulerOptions?,
        _ action: @escaping () -> Void
    ) -> Cancellable {
        let delayedIntervalAction = DelayedIntervalAction(
            after: after,
            interval: interval,
            tolerance: tolerance,
            options: options,
            action: action
        )
        delayedIntervalActions.append(delayedIntervalAction)
        return AnyCancellable { [weak self] in
            self?.delayedIntervalActions.removeAll(where: { $0.uuid == delayedIntervalAction.uuid })
        }
    }
}

extension TestScheduler {
    struct ImmediateAction {
        let uuid = UUID()

        let options: DispatchQueue.SchedulerOptions?
        let action: () -> Void
    }

    struct DelayedAction {
        let uuid = UUID()

        let after: SchedulerTimeType
        let tolerance: SchedulerTimeType.Stride
        let options: SchedulerOptions?
        let action: () -> Void
    }

    struct DelayedIntervalAction {
        let uuid = UUID()

        let after: SchedulerTimeType
        let interval: SchedulerTimeType.Stride
        let tolerance: SchedulerTimeType.Stride
        let options: SchedulerOptions?
        let action: () -> Void
    }
}
