//
//  Helper.swift
//  S3BankiOS
//
//  Created by Adriano Carnaroli.
//  Copyright © 2021 Adriano Carnaroli. All rights reserved.
//

import UIKit
import AVFoundation
import LocalAuthentication

class Helper {

    func convertObjectToJSONData<T:Encodable>(_ object:T) throws ->Data {
        return try JSONEncoder().encode(object)
    }

    func convertObjetcToJSON<T:Encodable>(_ object:T) throws -> Any {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(object)
        return try JSONSerialization.jsonObject(with: data, options: [])
    }

    private func getDirectoryPath(_ byFileName:String) -> String {
        return (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(byFileName)
    }

    func saveFile(_ fileData:Data, _ byFileNameWithExtension:String) {
        let fileManager = FileManager.default
        let paths = getDirectoryPath(byFileNameWithExtension)
        fileManager.createFile(atPath: paths as String, contents: fileData as Data?, attributes: nil)
    }

    func loadFile(_ byFileNameWithExtension:String)throws ->Data? {
        let fileManager = FileManager.default
        let documentoPath = self.getDirectoryPath(byFileNameWithExtension)
        if fileManager.fileExists(atPath: documentoPath) {
            return try Data(contentsOf: URL(fileURLWithPath: documentoPath, relativeTo: nil))
        } else {
            return nil
        }
    }

    class func getAppVersion() -> String {
        guard let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") else {return ""}
        guard let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") else {return ""}
        return "\(version) (\(build))"
    }

    class func getAppVersionNumber() -> String {
        guard let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") else {return ""}
        return "\(version)"
    }

    class func getAppBuildNumber() -> String {
        guard let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") else {return ""}
        return "\(build)"
    }

    class func getAppBundleName() -> String {
        guard let name = Bundle.main.infoDictionary?["CFBundleName"] else {return ""}
        return "\(name)"
    }

    class func getEnvironmentName() -> String {
        var env = ""
        let name = getAppBundleName().split(separator: " ")
        if name.count == 3 {
            env = String(name[2])
        }
        return env
    }

    class func getSystemName() -> String {
        return UIDevice.current.systemName
    }

    class func getSystemVersion() -> String {
        return UIDevice.current.systemVersion
    }

    class func randomUUID() -> String {
        return UUID().uuidString
    }

    func isBiometricAvailable() -> Bool {
        let context = LAContext()
        var error: NSError?

        if (context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error)) {
            return true
        } else {
            return false
        }
    }
}

extension UIDevice {
    static var isSimulator: Bool = {
        var isSimulator = false
        #if targetEnvironment(simulator)
        isSimulator = true
        #endif
        return isSimulator
    }()
}
