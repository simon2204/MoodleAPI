//
//  MoodleSubmission.swift
//
//
//  Created by Simon Schöpke on 13.06.21.
//

import Foundation
import FormData

/// Die Einreichung einer Praktikumsaufgabe in Moodle.
public struct MoodleSubmission {
    /// Name der Person, die in Moodle die Praktikumsaufgabe eingereicht hat.
    public let name: String
    
    /// Lokaler Pfad an der sich der Ordner mit den Dokumenten, die eingereicht wurden befindet.
    public let path: URL
    
    /// Enthält alle eingereichten Dateien.
    public let files: [File]
}
