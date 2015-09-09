//
//  NSData+HDKit.m
//  HDKitDemo
//
//  Created by ceo on 8/5/15.
//  Copyright (c) 2015 harvey. All rights reserved.
//

#import "NSData+HDKit.h"
#import "NSError+HDKit.h"
#import <CommonCrypto/CommonCrypto.h>
#include <zlib.h>

@implementation NSData (HDKit)

+ (NSString *)hd_contentTypeForImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return @"image/jpeg";
        case 0x89:
            return @"image/png";
        case 0x47:
            return @"image/gif";
        case 0x49:
        case 0x4D:
            return @"image/tiff";
        case 0x52:{
            if ([data length] < 12) {
                return nil;
            }
            
            NSString *testStr = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            if ([testStr hasPrefix:@"RIFF"] && [testStr hasSuffix:@"WEBP"]) {
                return @"image/webp";
            }
            return nil;
        }
    }
    
    return nil;
}

+ (NSString *)hd_deviceTokenString {
    return [[[self description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
}

@end

@implementation NSData (HDKit_Hash)

- (int)_hdDigestLenghtForFunction:(HDCryptoHashFunction)hashFunction {
    switch (hashFunction) {
        case HDCryptoHashFunctionMD5:
            return CC_MD5_DIGEST_LENGTH;
            break;
        case HDCryptoHashFunctionSHA1:
            return CC_SHA1_DIGEST_LENGTH;
            break;
        case HDCryptoHashFunctionSHA224:
            return CC_SHA224_DIGEST_LENGTH;
            break;
        case HDCryptoHashFunctionSHA256:
            return CC_SHA256_DIGEST_LENGTH;
            break;
        case HDCryptoHashFunctionSHA384:
            return CC_SHA384_DIGEST_LENGTH;
            break;
        case HDCryptoHashFunctionSHA512:
            return CC_SHA512_DIGEST_LENGTH;
            break;
        default:
            return -1;
            break;
    }
}

- (CCHmacAlgorithm)_hdHmacAlgorithmForFunction:(HDCryptoHashFunction)hashFunction {
    switch (hashFunction) {
        case HDCryptoHashFunctionMD5:
            return kCCHmacAlgMD5;
            break;
        case HDCryptoHashFunctionSHA1:
            return kCCHmacAlgSHA1;
            break;
        case HDCryptoHashFunctionSHA224:
            return kCCHmacAlgSHA224;
            break;
        case HDCryptoHashFunctionSHA256:
            return kCCHmacAlgSHA256;
            break;
        case HDCryptoHashFunctionSHA384:
            return kCCHmacAlgSHA384;
            break;
        case HDCryptoHashFunctionSHA512:
            return kCCHmacAlgSHA512;
            break;
        default:
            return UINT32_MAX;
            break;
    }

}

- (NSData *)hd_dataUsingHashFunciton:(HDCryptoHashFunction)hashFunction {
    int len = [self _hdDigestLenghtForFunction:hashFunction];
    unsigned char digest[len];
    if (len <= 0) {
        return nil;
    }
    
    switch (hashFunction) {
        case HDCryptoHashFunctionMD5:
            CC_MD5([self bytes], (CC_LONG)[self length], digest);
            break;
        case HDCryptoHashFunctionSHA1:
            CC_SHA1([self bytes], (CC_LONG)[self length], digest);
            break;
        case HDCryptoHashFunctionSHA224:
            CC_SHA224([self bytes], (CC_LONG)[self length], digest);
            break;
        case HDCryptoHashFunctionSHA256:
            CC_SHA256([self bytes], (CC_LONG)[self length], digest);
            break;
        case HDCryptoHashFunctionSHA384:
            CC_SHA384([self bytes], (CC_LONG)[self length], digest);
            break;
        case HDCryptoHashFunctionSHA512:
            CC_SHA512([self bytes], (CC_LONG)[self length], digest);
            break;
        default:
            break;
    }
    
    return [NSData dataWithBytes:digest length:len];
}


- (NSString *)hd_stringUsingHashFunction:(HDCryptoHashFunction)hasFunction {
    return [self.class _hdHexadecimalString:[self hd_dataUsingHashFunciton:hasFunction]];
}

- (NSData *)hd_dataUsingHashFunciton:(HDCryptoHashFunction)hashFunction hmacSignedWithKey:(NSString *)key {
    int len = [self _hdDigestLenghtForFunction:hashFunction];
    CCHmacAlgorithm algo = [self _hdHmacAlgorithmForFunction:hashFunction];
    unsigned char digest[len];
    
    if (len <= 0 || algo == UINT32_MAX) {
        return nil;
    }
    
    CCHmac(algo, [key UTF8String], [key length], [self bytes], [self length], digest);
    
    return [NSData dataWithBytes:digest length:len];
}

- (NSString *)hd_stringUsingHashFunction:(HDCryptoHashFunction)hasFunction hmacSignedWithKey:(NSString *)key {
    return [self.class _hdHexadecimalString:[self hd_dataUsingHashFunciton:hasFunction hmacSignedWithKey:key]];
}

+ (NSString *)_hdHexadecimalString:(NSData *)data {
    const unsigned char * buffer = [data bytes];
    NSUInteger length = [data length];
    if (!buffer || length == 0) {
        return nil;
    }
    
    NSMutableString *str = [NSMutableString stringWithCapacity:length * 2];
    for (NSUInteger i = 0; i < length; i++) {
        [str appendString:[NSString stringWithFormat:@"%02x",buffer[i]]];
    }
    
    return [NSString stringWithString:str];
}



@end

static void FixKeyLengths(CCAlgorithm algorithm, NSMutableData * keyData, NSMutableData * ivData)
{
    NSUInteger keyLength = [keyData length];
    switch ( algorithm )
    {
        case kCCAlgorithmAES128:
        {
            if ( keyLength <= 16 )
            {
                [keyData setLength: 16];
            }
            else if ( keyLength <= 24 )
            {
                [keyData setLength: 24];
            }
            else
            {
                [keyData setLength: 32];
            }
            
            break;
        }
            
        case kCCAlgorithmDES:
        {
            [keyData setLength: 8];
            break;
        }
            
        case kCCAlgorithm3DES:
        {
            [keyData setLength: 24];
            break;
        }
            
        case kCCAlgorithmCAST:
        {
            if ( keyLength <= 5 )
            {
                [keyData setLength: 5];
            }
            else if ( keyLength > 16 )
            {
                [keyData setLength: 16];
            }
            
            break;
        }
            
        case kCCAlgorithmRC4:
        {
            if ( keyLength > 512 )
                [keyData setLength: 512];
            break;
        }
            
        default:
            break;
    }
    
    [ivData setLength: [keyData length]];
}

@implementation NSData (HDKit_Symmetric)

- (NSData *)_hdRunCryptor:(CCCryptorRef)cryptor result:(CCCryptorStatus *)status {
    size_t bufSize = CCCryptorGetOutputLength(cryptor, [self length], true);
    void *buf = malloc(bufSize);
    size_t bufused = 0;
    size_t bytesTotal = 0;
    *status = CCCryptorUpdate(cryptor, [self bytes], [self length], buf, bufSize, &bufused);
    if (*status != kCCSuccess) {
        free(buf);
        return nil;
    }
    
    bytesTotal += bufused;
    *status = CCCryptorFinal(cryptor, buf + bufused, bufSize - bufused, &bufused);
    bytesTotal += bufused;
    
    return [NSData dataWithBytes:buf length:bytesTotal];
}

- (NSData *)hd_dataEncryptedUsingAlgorithm:(CCAlgorithm)algorithm
                                    key:(id)key
                   initializationVector:(id)iv
                                options:(CCOptions)options
                                  error:(CCCryptorStatus *) error {
    CCCryptorRef cryptor = NULL;
    CCCryptorStatus status = kCCSuccess;
    NSParameterAssert([key isKindOfClass: [NSData class]] || [key isKindOfClass: [NSString class]]);
    NSParameterAssert(iv == nil || [iv isKindOfClass: [NSData class]] || [iv isKindOfClass: [NSString class]]);
    
    NSMutableData *keyData, *ivData;
    if ([key isKindOfClass: [NSData class]])
        keyData = (NSMutableData *) [key mutableCopy];
    else
        keyData = [[key dataUsingEncoding: NSUTF8StringEncoding] mutableCopy];
    
    if ([iv isKindOfClass: [NSString class]])
        ivData = [[iv dataUsingEncoding: NSUTF8StringEncoding] mutableCopy];
    else
        ivData = (NSMutableData *) [iv mutableCopy];
    
    FixKeyLengths(algorithm, keyData, ivData);
    
    status = CCCryptorCreate(kCCEncrypt, algorithm, options, [keyData bytes], [keyData length], [ivData bytes], &cryptor);
    
    if (status != kCCSuccess) {
        if (error != NULL) {
            *error = status;
        }
        return nil;
    }
    
    NSData *result = [self _hdRunCryptor:cryptor result:&status];
    
    if (result == nil && error != NULL) {
        *error = status;
    }
    
    CCCryptorRelease(cryptor);
    
    return result;
}

- (NSData *)hd_decryptedDataUsingAlgorithm:(CCAlgorithm)algorithm
                                     key:(id)key
                    initializationVector:(id)iv
                                 options:(CCOptions)options
                                   error:(CCCryptorStatus *)error {
    CCCryptorRef cryptor = NULL;
    CCCryptorStatus status = kCCSuccess;
    
    NSParameterAssert([key isKindOfClass: [NSData class]] || [key isKindOfClass: [NSString class]]);
    NSParameterAssert(iv == nil || [iv isKindOfClass: [NSData class]] || [iv isKindOfClass: [NSString class]]);
    
    NSMutableData * keyData, * ivData;
    if ( [key isKindOfClass: [NSData class]] )
        keyData = (NSMutableData *) [key mutableCopy];
    else
        keyData = [[key dataUsingEncoding: NSUTF8StringEncoding] mutableCopy];
    
    if ( [iv isKindOfClass: [NSString class]] )
        ivData = [[iv dataUsingEncoding: NSUTF8StringEncoding] mutableCopy];
    else
        ivData = (NSMutableData *) [iv mutableCopy];
    
    FixKeyLengths(algorithm, keyData, ivData);
    
    status = CCCryptorCreate(kCCDecrypt, algorithm, options, [keyData bytes], [keyData length], [ivData bytes], &cryptor);
    
    if (status != kCCSuccess) {
        if (error != NULL) {
            *error = status;
        }
        return nil;
    }
    
    NSData *result = [self _hdRunCryptor:cryptor result:&status];
    
    if (result == nil && error != NULL) {
        *error = status;
    }
    
    CCCryptorRelease(cryptor);
    
    return result;
}


- (NSData *)hd_AES256EncryptedDataUsingKey:(id)key error:(NSError **)error
{
    CCCryptorStatus status = kCCSuccess;
    NSData * result = [self hd_dataEncryptedUsingAlgorithm:kCCAlgorithmAES128
                                                       key:key
                                      initializationVector:nil
                                                   options:kCCOptionPKCS7Padding
                                                     error:&status];
    
    if (result != nil)
        return result;
    
    if (error != NULL)
        *error = [NSError errorWithCCCryptorStatus:status];
    
    return nil;
}

- (NSData *)hd_decryptedAES256DataUsingKey:(id)key error:(NSError **)error
{
    CCCryptorStatus status = kCCSuccess;
    NSData * result = [self hd_decryptedDataUsingAlgorithm:kCCAlgorithmAES128
                                                       key:key
                                      initializationVector:nil
                                                   options:kCCOptionPKCS7Padding
                                                     error:&status];
    
    if (result != nil)
        return result;
    
    if (error != NULL)
        *error = [NSError errorWithCCCryptorStatus: status];
    
    return nil;
}

- (NSData *)hd_DESEncryptedDataUsingKey:(id)key error:(NSError **)error
{
    CCCryptorStatus status = kCCSuccess;
    NSData * result = [self hd_dataEncryptedUsingAlgorithm:kCCAlgorithmDES
                                                       key:key
                                      initializationVector:nil
                                                   options:kCCOptionPKCS7Padding
                                                     error:&status];
    
    if (result != nil)
        return result;
    
    if (error != NULL)
        *error = [NSError errorWithCCCryptorStatus: status];
    
    return nil;
}

- (NSData *)hd_decryptedDESDataUsingKey:(id)key error:(NSError **)error
{
    CCCryptorStatus status = kCCSuccess;
    NSData * result = [self hd_decryptedDataUsingAlgorithm:kCCAlgorithmDES
                                                       key:key
                                      initializationVector:nil
                                                   options:kCCOptionPKCS7Padding
                                                     error:&status];
    
    if ( result != nil )
        return ( result );
    
    if ( error != NULL )
        *error = [NSError errorWithCCCryptorStatus: status];
    
    return ( nil );
}

- (NSData *)hd_CASTEncryptedDataUsingKey:(id)key error:(NSError **)error
{
    CCCryptorStatus status = kCCSuccess;
    NSData * result = [self hd_dataEncryptedUsingAlgorithm:kCCAlgorithmCAST
                                                       key:key
                                      initializationVector:nil
                                                   options:kCCOptionPKCS7Padding
                                                     error:&status];
    
    if ( result != nil )
        return ( result );
    
    if ( error != NULL )
        *error = [NSError errorWithCCCryptorStatus: status];
    
    return ( nil );
}

- (NSData *)hd_decryptedCASTDataUsingKey:(id)key error:(NSError **)error
{
    CCCryptorStatus status = kCCSuccess;
    NSData * result = [self hd_decryptedDataUsingAlgorithm:kCCAlgorithmCAST
                                                       key:key
                                      initializationVector:nil
                                                   options:kCCOptionPKCS7Padding
                                                     error:&status];
    
    if ( result != nil )
        return ( result );
    
    if ( error != NULL )
        *error = [NSError errorWithCCCryptorStatus: status];
    
    return ( nil );
}

@end

@implementation NSData (HDKit_Asymmetric)

@end

@implementation NSData (HDKit_Zip)

- (NSData *)hd_gzipInflate {
    if ([self length] == 0) return self;
    
    unsigned full_length = (unsigned)[self length];
    unsigned half_length = (unsigned)[self length] / 2;
    
    NSMutableData *decompressed = [NSMutableData
                                   dataWithLength:full_length + half_length];
    BOOL done = NO;
    int status;
    
    z_stream strm;
    strm.next_in = (Bytef *)[self bytes];
    strm.avail_in = (unsigned)[self length];
    strm.total_out = 0;
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    
    if (inflateInit2(&strm, (15 + 32)) != Z_OK) return nil;
    while (!done) {
        // Make sure we have enough room and reset the lengths.
        if (strm.total_out >= [decompressed length])
            [decompressed increaseLengthBy:half_length];
        strm.next_out = [decompressed mutableBytes] + strm.total_out;
        strm.avail_out = (uInt)([decompressed length] - strm.total_out);
        
        // Inflate another chunk.
        status = inflate(&strm, Z_SYNC_FLUSH);
        if (status == Z_STREAM_END) done = YES;
        else if (status != Z_OK) break;
    }
    if (inflateEnd(&strm) != Z_OK) return nil;
    
    // Set real length.
    if (done) {
        [decompressed setLength:strm.total_out];
        return [NSData dataWithData:decompressed];
    } else return nil;
}

- (NSData *)hd_gzipDeflate {
    if ([self length] == 0) return self;
    
    z_stream strm;
    
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    strm.opaque = Z_NULL;
    strm.total_out = 0;
    strm.next_in = (Bytef *)[self bytes];
    strm.avail_in = (uInt)[self length];
    
    // Compresssion Levels:
    //   Z_NO_COMPRESSION
    //   Z_BEST_SPEED
    //   Z_BEST_COMPRESSION
    //   Z_DEFAULT_COMPRESSION
    
    if (deflateInit2(&strm, Z_DEFAULT_COMPRESSION, Z_DEFLATED, (15 + 16),
                     8, Z_DEFAULT_STRATEGY) != Z_OK)
        return nil;
    
    // 16K chunks for expansion
    NSMutableData *compressed = [NSMutableData dataWithLength:16384];
    
    do {
        if (strm.total_out >= [compressed length])
            [compressed increaseLengthBy:16384];
        
        strm.next_out = [compressed mutableBytes] + strm.total_out;
        strm.avail_out = (uInt)([compressed length] - strm.total_out);
        
        deflate(&strm, Z_FINISH);
    }
    while (strm.avail_out == 0);
    
    deflateEnd(&strm);
    
    [compressed setLength:strm.total_out];
    return [NSData dataWithData:compressed];
}

- (NSData *)hd_zlibInflate {
    if ([self length] == 0) return self;
    
    NSUInteger full_length = [self length];
    NSUInteger half_length = [self length] / 2;
    
    NSMutableData *decompressed = [NSMutableData
                                   dataWithLength:full_length + half_length];
    BOOL done = NO;
    int status;
    
    z_stream strm;
    strm.next_in = (Bytef *)[self bytes];
    strm.avail_in = (uInt)full_length;
    strm.total_out = 0;
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    
    if (inflateInit(&strm) != Z_OK) return nil;
    
    while (!done) {
        // Make sure we have enough room and reset the lengths.
        if (strm.total_out >= [decompressed length])
            [decompressed increaseLengthBy:half_length];
        strm.next_out = [decompressed mutableBytes] + strm.total_out;
        strm.avail_out = (uInt)([decompressed length] - strm.total_out);
        
        // Inflate another chunk.
        status = inflate(&strm, Z_SYNC_FLUSH);
        if (status == Z_STREAM_END) done = YES;
        else if (status != Z_OK) break;
    }
    if (inflateEnd(&strm) != Z_OK) return nil;
    
    // Set real length.
    if (done) {
        [decompressed setLength:strm.total_out];
        return [NSData dataWithData:decompressed];
    } else return nil;
}

- (NSData *)hd_zlibDeflate {
    if ([self length] == 0) return self;
    
    z_stream strm;
    
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    strm.opaque = Z_NULL;
    strm.total_out = 0;
    strm.next_in = (Bytef *)[self bytes];
    strm.avail_in = (uInt)[self length];
    
    // Compresssion Levels:
    //   Z_NO_COMPRESSION
    //   Z_BEST_SPEED
    //   Z_BEST_COMPRESSION
    //   Z_DEFAULT_COMPRESSION
    
    if (deflateInit(&strm, Z_DEFAULT_COMPRESSION) != Z_OK) return nil;
    
    // 16K chuncks for expansion
    NSMutableData *compressed = [NSMutableData dataWithLength:16384];
    
    do {
        if (strm.total_out >= [compressed length])
            [compressed increaseLengthBy:16384];
        
        strm.next_out = [compressed mutableBytes] + strm.total_out;
        strm.avail_out = (uInt)([compressed length] - strm.total_out);
        
        deflate(&strm, Z_FINISH);
    }
    while (strm.avail_out == 0);
    
    deflateEnd(&strm);
    
    [compressed setLength:strm.total_out];
    return [NSData dataWithData:compressed];
}

@end


