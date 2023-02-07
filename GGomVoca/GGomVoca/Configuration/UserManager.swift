//
//  UserManager.swift
//  GGomVoca
//
//  Created by JeongMin Ko on 2023/01/17.
//

import SwiftUI

final class UserManager {
    static var shared = UserManager()
    
    @AppStorage("pinnedVocabularyIDs")   var pinnedVocabularyIDs  : [String] = []
    @AppStorage("koreanVocabularyIDs")   var koreanVocabularyIDs  : [String] = []
    @AppStorage("englishVocabularyIDs")  var englishVocabularyIDs : [String] = []
    @AppStorage("japanishVocabularyIDs") var japanishVocabularyIDs: [String] = []
    @AppStorage("frenchVocabularyIDs")   var frenchVocabularyIDs  : [String] = []
    
    // MARK: 단어장 추가
    static func addVocabulary(id: String, nationality: Nationality) {
        switch nationality {
        case .KO:
            shared.koreanVocabularyIDs.append(id)
        case .EN:
            shared.englishVocabularyIDs.append(id)
        case .JA:
            shared.japanishVocabularyIDs.append(id)
        case .FR:
            shared.frenchVocabularyIDs.append(id)
        }
    }
    
    // MARK: 단어장 삭제
    static func deleteVocabulary(id: String) {
        if let index = shared.pinnedVocabularyIDs.firstIndex(of: id) {
            shared.pinnedVocabularyIDs.remove(at: index)
        } else if let index = shared.koreanVocabularyIDs.firstIndex(of: id) {
            shared.koreanVocabularyIDs.remove(at: index)
        } else if let index = shared.englishVocabularyIDs.firstIndex(of: id) {
            shared.englishVocabularyIDs.remove(at: index)
        } else if let index = shared.japanishVocabularyIDs.firstIndex(of: id) {
            shared.japanishVocabularyIDs.remove(at: index)
        } else if let index = shared.frenchVocabularyIDs.firstIndex(of: id) {
            shared.frenchVocabularyIDs.remove(at: index)
        }
    }
    
    var recentVocabulary : [String] {
        get {
            let defaults = UserDefaults.standard
            return defaults.array(forKey: "RecentVocabulary") as? [String] ?? []
        }
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "RecentVocabulary")
        }
    }
}
