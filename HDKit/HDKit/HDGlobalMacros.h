//
//  HDGobalMacros.h
//  HDKitDemo
//
//  Created by ceo on 7/22/15.
//  Copyright (c) 2015 harvey. All rights reserved.
//

#ifndef HDKitDemo_HDGlobalMacros_h
#define HDKitDemo_HDGlobalMacros_h

#pragma mark - DLog
#if DEBUG
#define DLog(args...)       (NSLog(@"%@", [NSString stringWithFormat:args]))
#else
#define DLog(args...)       // do nothing.
#endif


#endif
