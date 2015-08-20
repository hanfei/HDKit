//
//  NSData+HDKit.h
//  HDKitDemo
//
//  Created by ceo on 8/5/15.
//  Copyright (c) 2015 harvey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (HDKit)

+ (NSString *)hd_contentTypeForImageData:(NSData *)data;

@end

typedef NS_ENUM(NSUInteger, HDCryptoHashFunction) {
    HDCryptoHashFunctionMD5,
    HDCryptoHashFunctionSHA1,
    HDCryptoHashFunctionSHA224,
    HDCryptoHashFunctionSHA256,
    HDCryptoHashFunctionSHA384,
    HDCryptoHashFunctionSHA512
};

@interface NSData (HDKit_Hash)

- (NSData *)hd_dataUsingHashFunciton:(HDCryptoHashFunction)hashFunction;
- (NSString *)hd_stringUsingHashFunction:(HDCryptoHashFunction)hasFunction;

- (NSData *)hd_dataUsingHashFunciton:(HDCryptoHashFunction)hashFunction hmacSignedWithKey:(NSString *)key;
- (NSString *)hd_stringUsingHashFunction:(HDCryptoHashFunction)hasFunction hmacSignedWithKey:(NSString *)key;

@end

@interface NSData (HDKit_Asymmetric)

@end

@interface NSData (HDKit_Symmetric)

- (NSData *)hd_AES256EncryptedDataUsingKey:(id)key error:(NSError **)error;
- (NSData *)hd_decryptedAES256DataUsingKey:(id)key error:(NSError **)error;

- (NSData *)hd_DESEncryptedDataUsingKey:(id)key error:(NSError **)error;
- (NSData *)hd_decryptedDESDataUsingKey:(id)key error:(NSError **)error;

- (NSData *)hd_CASTEncryptedDataUsingKey:(id)key error:(NSError **)error;
- (NSData *)hd_decryptedCASTDataUsingKey:(id)key error:(NSError **)error;


@end
