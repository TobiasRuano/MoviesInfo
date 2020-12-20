//
//  TapticEffectsService.swift
//  MoviesInfo
//
//  Created by Tobias Ruano on 07/10/2020.
//  Copyright © 2020 Tobias Ruano. All rights reserved.
//

import UIKit
import AudioToolbox.AudioServices

class TapticEffectsService {
    
    // MARK: Public type methods - Haptic Feedback
    
    /// Performs haptic feedback - selection.
    static func performFeedbackSelection() {
        let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
        selectionFeedbackGenerator.prepare()
        selectionFeedbackGenerator.selectionChanged()
    }
    
    /// Performs haptic feedback - impact.
    static func performFeedbackImpact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let mediumImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: style)
        mediumImpactFeedbackGenerator.prepare()
        mediumImpactFeedbackGenerator.impactOccurred()
    }
    
    /// Performs haptic feedback - notification.
    static func performFeedbackNotification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
        notificationFeedbackGenerator.prepare()
        notificationFeedbackGenerator.notificationOccurred(type)
    }
    
    // MARK: Public type methods - Taptic Engine
    
    /// Performs taptic feedback based on 'TapticEngineFeedbackIdentifier'.
    static func performTapticFeedback(from feedbackIdentifier: TapticEngineFeedbackIdentifier) {
            AudioServicesPlaySystemSound(feedbackIdentifier.rawValue)
    }
}

extension TapticEffectsService {
    enum TapticEngineFeedbackIdentifier: UInt32 {
        /// 'Peek' feedback (weak boom)
        case peek = 1519
        /// 'Pop' feedback (strong boom)
        case pop = 1520
        /// 'Cancelled' feedback (three sequential weak booms)
        case cancelled = 1521
        /// 'Try Again' feedback (week boom then strong boom)
        case tryAgain = 1102
        /// 'Failed' feedback (three sequential strong booms)
        case failed = 1107
    }
}
