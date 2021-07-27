//
//  Native.swift
//  MBoxDev
//
//  Created by 詹迟晶 on 2021/6/1.
//  Copyright © 2021 com.bytedance. All rights reserved.
//

import Foundation
import MBoxCore
import MBoxWorkspaceCore
import MBoxDev

public class RubyStage: BuildStage {

    public static func updateManifest(_ manifest: MBPluginPackage) throws {
        manifest.hasRuby = true
    }

    public static var name: String {
        return "Ruby"
    }

    required public init(outputDir: String) {
        self.outputDir = outputDir
    }

    public var outputDir: String

    public static var path: String? {
        return MBoxDevRuby.pluginPackage?.resoucePath(for: "Template")
    }

    open func build(repos: [(repo: MBWorkRepo, curVersion: String?, nextVersion: String)]) throws {
        for (repo, _, _) in repos {
            guard repo.shouldBuildRubyPackage else {
                continue
            }
            guard let name = repo.manifest?.name else { continue }
            try UI.log(verbose: "[\(repo.name)]") {
                let path = self.outputDir.appending(pathComponent: name).appending(pathComponent: "Ruby")
                UI.log(verbose: "Compile to `\(path)`.")
                try repo.buildRubyPackage(path)
            }
        }
    }

    open func test(repos: [(repo: MBWorkRepo, curVersion: String?, nextVersion: String)]) throws {
    }

    public func shouldBuild(repo: MBWorkRepo) -> Bool {
        return repo.shouldBuildRubyPackage
    }

    public func upgrade(repo: MBWorkRepo, nextVersion: String) throws {
        try repo.updateRubyVersion(nextVersion)
    }
}
