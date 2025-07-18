//
//  KeychainHelper.swift
//  Eventorias
//
//  Created by Thibault Giraudon on 17/07/2025.
//

import Foundation
import Security

/// A helper class that handles all keychains-related operations.
class KeychainHelper {
    static let shared = KeychainHelper()

    /// Saves sensitive information to the keychain.
    ///
    /// - Parameters:
    ///   - value: The value to be stored.
    ///   - key: A unique key used to identify the stored data.
    func save(_ value: String, for key: String) {
        let data = Data(value.utf8)
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }

    /// Retrieves a sensible information with a given key.
    ///
    /// - Parameter key: A unique key used to retrieve the stored data.
    /// - Returns: the associated value if found, otherwise `nil`.
    func read(for key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var dataTypeRef: AnyObject?
        if SecItemCopyMatching(query as CFDictionary, &dataTypeRef) == noErr,
           let data = dataTypeRef as? Data,
           let result = String(data: data, encoding: .utf8) {
            return result
        }
        return nil
    }
    
    /// Deletes data from the keychain for the given key.
    ///
    /// - Parameter key: The unique key associated with the data to delete.
    func delete(for key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        SecItemDelete(query as CFDictionary)
    }
}
