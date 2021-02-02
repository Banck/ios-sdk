//
//  MBPersistenceStorage.swift
//  MindBox
//
//  Created by Maksim Kazachkov on 02.02.2021.
//  Copyright © 2021 Mikhail Barilov. All rights reserved.
//

import Foundation

class MBPersistenceStorage: PersistenceStorage {
    
    // MARK: - Dependency
    let defaults: UserDefaults

    // MARK: - Property
    var wasInstaled: Bool {
        deviceUUID != nil
    }
    
    var apnsTokenSaveDate: Date? {
        get {
            let dateFormater = DateFormatter()
            dateFormater.dateStyle = .full
            dateFormater.timeStyle = .full
            if let dateString = apnsTokenSaveDateString {
                return dateFormater.date(from: dateString)
            } else {
                return nil
            }
        }
        set {
            let dataFormater = DateFormatter()
            dataFormater.dateStyle = .full
            dataFormater.timeStyle = .full
            if let date = newValue {
                apnsTokenSaveDateString = dataFormater.string(from: date)
            } else {
                apnsTokenSaveDateString = nil
            }
        }
    }
    
    // MARK: - Init
    init(defaults: UserDefaults) {
        self.defaults = defaults
    }

    // MARK: - IMBMBPersistenceStorage
    @UserDefaultsWrapper(key: .deviceUUID, defaultValue: nil)
    var deviceUUID: String?

    @UserDefaultsWrapper(key: .installationId, defaultValue: nil)
    var installationId: String?

    @UserDefaultsWrapper(key: .apnsToken, defaultValue: nil)
    var apnsToken: String?

    @UserDefaultsWrapper(key: .apnsTokenSaveDate, defaultValue: nil)
    private var apnsTokenSaveDateString: String?

    func reset() {
        deviceUUID = nil
        installationId = nil
        apnsToken = nil
        apnsTokenSaveDate = nil
    }

    // MARK: - Private

}

extension MBPersistenceStorage {
    
    @propertyWrapper
    struct UserDefaultsWrapper<T> {
        
        enum Key: String {
            
            case installationId = "MBPersistenceStorage-installationId"
            case deviceUUID = "MBPersistenceStorage-deviceUUID"
            case wasInstaled = "MBPersistenceStorage-wasInstaled"
            case apnsToken = "MBPersistenceStorage-apnsToken"
            case apnsTokenSaveDate = "MBPersistenceStorage-apnsTokenSaveDate"
        }
        
        private let key: Key
        private let defaultValue: T
        private let defaults: UserDefaults
        
        init(key: Key, defaultValue: T, defaults: UserDefaults = .standard) {
            self.key = key
            self.defaultValue = defaultValue
            self.defaults = defaults
        }
        
        var wrappedValue: T {
            get {
                // Read value from UserDefaults
                return defaults.object(forKey: key.rawValue) as? T ?? defaultValue
            }
            set {
                // Set value to UserDefaults
                defaults.set(newValue, forKey: key.rawValue)
            }
        }
        
    }
    
}
