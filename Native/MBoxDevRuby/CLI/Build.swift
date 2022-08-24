//
//  Command.swift
//  MBoxDevNative
//
//  Copyright © 2019 com.bytedance. All rights reserved.
//

import Foundation
import MBoxCore
import MBoxDev

extension MBCommander.Plugin.Build {

    @_dynamicReplacement(for: stages)
    public class var ruby_stages: [BuildStage.Type] {
        var v = self.stages
        v.append(RubyStage.self)
        return v
    }

}
