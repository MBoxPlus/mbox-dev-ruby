//
//  MBConfig.Repo.swift
//  MBoxDev
//
//  Created by Whirlwind on 2019/11/17.
//  Copyright © 2019 com.bytedance. All rights reserved.
//

import Foundation
import MBoxCore
import MBoxWorkspaceCore
import MBoxDev

var MBWorkRepoManifest: UInt8 = 0

extension MBWorkRepo {
    // MARK: - Path
    public var rubyDir: String? {
        guard self.shouldBuildRubyPackage else { return nil }
        let dir = self.path.appending(pathComponent: "Ruby")
        guard dir.isExists else {
            return nil
        }
        return dir
    }

    // MARK: - Version
    public func updateRubyVersion(_ version: String) throws {
        guard let dir = self.rubyDir else {
            return
        }
        var versionPath: String? = nil
        var folders = [dir]
        while let p = folders.popLast() {
            let v = p.appending(pathComponent: "version.rb")
            if v.isFile {
                versionPath = v
                break
            }
            folders.insert(contentsOf: p.subDirectories, at: 0)
        }
        guard let path = versionPath else {
            UI.log(verbose: "[\(self)] Could not find `version.rb`.")
            return
        }
        var content = try String(contentsOfFile: path)
        content = content.replacingOccurrences(of: "VERSION *=.*", with: "VERSION = '\(version)'", options: .regularExpression, range: nil)
        try UI.log(verbose: "Update `\(path)`") {
            try content.write(toFile: path, atomically: true, encoding: .utf8)
            if let git = self.git {
                try? git.change(file: path.relativePath(from: git.path), track: false)
            }
        }
    }

    // MARK: - Build
    public var shouldBuildRubyPackage: Bool {
        return self.manifest?.hasRuby == true
    }

    public func buildRubyPackage(_ output: String) throws {
        if output.isExists {
            try FileManager.default.removeItem(atPath: output)
        }
        guard let dir = self.rubyDir else { return }
        let cmd = MBCMD()
        cmd.workingDirectory = dir
        guard cmd.exec("git ls-files -z") == 0 else {
            throw RuntimeError(cmd.errorString)
        }
        UI.log(verbose: "\n")
        for path in cmd.outputString.split(separator: "\0").map({ String($0) }) {
            let targetPath = output.appending(pathComponent: path)
            let targetDir = targetPath.deletingLastPathComponent
            if !targetDir.isDirectory {
                try FileManager.default.createDirectory(atPath: targetDir, withIntermediateDirectories: true)
            }
            try FileManager.default.copyItem(atPath: dir.appending(pathComponent: path), toPath: targetPath)
        }
        if let spec = output.subFiles.first(where: { $0.pathExtension == "gemspec" }),
           var content = try? String(contentsOfFile: spec) {
            content = content.replacingOccurrences(of: "`git.*`", with: "''", options: .regularExpression)
            try? content.write(toFile: spec, atomically: true, encoding: .utf8)
        }
    }

}
