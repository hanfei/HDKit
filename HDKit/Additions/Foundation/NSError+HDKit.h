//
//  NSError+HDKit.h
//  HDKitDemo
//
//  Created by ceo on 8/20/15.
//  Copyright (c) 2015 harvey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>
extern NSString * const kCommonCryptoErrorDomain;

@interface NSError (HDKit)

@end
@interface NSError (HDKit_CommonCryptoErrorDomain)

+ (NSError *) errorWithCCCryptorStatus:(CCCryptorStatus)status;

@end