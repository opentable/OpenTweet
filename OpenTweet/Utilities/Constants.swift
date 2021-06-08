//
//  Constants.swift
//  OpenTweet
//
//  Created by Sherman Shi on 5/15/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//

import UIKit

struct K {
    struct Layout {
        static let screenWidth = UIScreen.main.bounds.width
        static let screenHeight = UIScreen.main.bounds.height
        
        static func defaultSidePadding(float: CGFloat = 16) -> CGFloat {
            return float
        }
    }
    struct Colors {
        static let mainAppColor = UIColor.mainRed()
        static let white = UIColor.white
        static let black = UIColor.black
        static let lightGray = UIColor.lightGray
    }
    
    struct JSON {
        static let timeline = "timeline"
        static let json = "json"
    }
    
    struct Navigation {
        static let timeline = "Timeline"
        static let search = "Search"
        static let order = "Order"
        static let profile = "Profile"
    }
    
    struct Icons {
        static let timeline = UIImage(named: "icTimeline")!
        static let search = UIImage(named: "icSearch")!
        static let order = UIImage(named: "icOrder")!
        static let profile = UIImage(named: "icProfile")!
        static let block = UIImage(named: "icBlock")!
        static let follow = UIImage(named: "icFollow")!
        static let like = UIImage(named: "icLike")!
        static let report = UIImage(named: "icReport")!
        static let saveFavorites = UIImage(named: "icSaveFavorites")!
    }
    
    struct Images {
        static let openTable = UIImage(named: "imOpenTable")!
    }
    
    struct Alert {
        static let okTitle = "OK"
        static let blockTitle = "Block"
        static let cancelTitle = "Cancel"
        static let errorTitle = "Error"
        static let invalidPathMessage = "Data path is invalid."
    }
}
