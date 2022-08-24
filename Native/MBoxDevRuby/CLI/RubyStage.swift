//
//  Native.swift
//  MBoxDev
//
//  Created by Whirlwind on 2021/6/1.
//  Copyright © 2021 com.bytedance. All rights reserved.
//

import Foundation
import MBoxCore
import MBoxDev

public class RubyStage: BuildStage {

    required public init(outputDir: String) {
        self.outputDir = outputDir
    }

    public var outputDir: String

    public func buildStep(for repo: MBWorkRepo) -> [BuildStep] {
        if !repo.shouldBuildRubyPackage { return [] }
        return [.build, .upgrade]
    }

    open func build(repo: MBWorkRepo, curVersion: String?, nextVersion: String) throws {
        try repo.buildRubyPackage(repo.productDir(self.outputDir))
    }

    public func upgrade(repo: MBWorkRepo, curVersion: String?, nextVersion: String) throws {
        try repo.updateRubyVersion(nextVersion)
    }
}

extension RubyStage: DevTemplate {

    public static func updateManifest(_ module: MBPluginModule) throws {
        module.hasRuby = true
    }

    public static var name: String {
        return "Ruby"
    }

    public static var path: String? {
        return MBoxDevRuby.pluginPackage?.resoucePath(for: "Template")
    }

}
