//
//  Command.swift
//  MBoxDevNative
//
//  Copyright © 2019 com.bytedance. All rights reserved.
//

import Foundation
import MBoxCore
import MBoxWorkspaceCore
import MBoxDev

extension MBCommander.Plugin.Build {

    @_dynamicReplacement(for: stages)
    open class var ruby_stages: [BuildStage.Type] {
        var v = self.stages
        v.append(RubyStage.self)
        return v
    }

}
