//
//  HDTextDefine.h
//  HDKitDemo
//
//  Created by ceo on 9/9/15.
//  Copyright (c) 2015 harvey. All rights reserved.
//

#ifndef HDKitDemo_HDTextDefine_h
#define HDKitDemo_HDTextDefine_h

/// The type of ligatures.
typedef NS_ENUM (NSInteger, HDTextLigature) {
    kHDTextLigatureOnlyEssential = 0, ///< Only ligatures essential for proper rendering of text should be used.
    kHDTextLigatureStandard      = 1, ///< Standard ligatures should be used (Default)
    kHDTextLigatureAll           = 2, ///< All available ligatures should be used.
};

/// The style of underlining.
typedef NS_OPTIONS (NSInteger, HDTextUnderlineStyle) {
    kHDTextUnderlineStyleNone       = 0x00, ///< (     ) (Default)
    kHDTextUnderlineStyleSingle     = 0x01, ///< (────)
    kHDTextUnderlineStyleThick      = 0x02, ///< (━━━━━)
    kHDTextUnderlineStyleDouble     = 0x09, ///< (════)
    
    kHDTextUnderlineStyleSolid      = 0x000, ///< (────────) (Default)
    kHDTextUnderlineStyleDot        = 0x100, ///< (・・・・・・)
    kHDTextUnderlineStyleDash       = 0x200, ///< (— — — —)
    kHDTextUnderlineStyleDashDot    = 0x300, ///< (—・—・—・—・)
    kHDTextUnderlineStyleDashDotDot = 0x400, ///< (—・・—・・—・・—・・)
};

/// The vertical alignment
typedef NS_ENUM(NSInteger, HDTextVerticalAlignment) {
    kHDTextVerticalAlignmentTop = -1, ///< Top alignment.
    kHDTextVerticalAlignmentCenter = 0, ///< Center alignment. Default.
    kHDTextVerticalAlignmentBottom = 1, ///< Bottom alignment.
};

#endif
