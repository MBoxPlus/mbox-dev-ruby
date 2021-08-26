//
//  Dev.swift
//  MBoxDevRuby
//
//  Created by Whirlwind on 2021/8/18.
//  Copyright © 2021 com.bytedance. All rights reserved.
//

import Foundation
import MBoxCore
import MBoxDev

extension MBCommander.Plugin.Dev {

    @_dynamicReplacement(for: allTemplates)
    open class var ruby_allTemplates: [DevTemplate.Type] {
        var v = self.allTemplates
        v.append(RubyStage.self)
        return v
    }

}

