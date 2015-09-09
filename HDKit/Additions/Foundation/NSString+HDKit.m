//
//  NSString+HDKit.m
//  HDKitDemo
//
//  Created by harvey.ding on 5/20/15.
//  Copyright (c) 2015 harvey. All rights reserved.
//

#import "NSString+HDKit.h"

@implementation NSString (HDKit)

- (BOOL)hasString:(NSString *)str {
    return [self rangeOfString:str].location != NSNotFound;
}

- (BOOL)isEmail {
    NSString *pattern =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern] evaluateWithObject:self];
}

+ (BOOL)isEmpty:(NSString *)str {
    NSString *trimedStr = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    BOOL ret = trimedStr.length > 0;
    return !ret;
}


- (NSString *)trimHead {
    NSInteger i;
    NSCharacterSet *wnSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    for (i = 0; i < self.length; i++) {
        if (![wnSet characterIsMember:[self characterAtIndex:i]]) {
            break;
        }
    }
    return [self substringFromIndex:i];
}

- (NSString *)trimTail {
    NSInteger i;
    NSCharacterSet *wnSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    for (i = self.length - 1; i >= 0; i--) {
        if (![wnSet characterIsMember:[self characterAtIndex:i]]) {
            break;
        }
    }
    return [self substringToIndex:(i+1)];
}

- (NSString *)trimBoth {
    return [[self trimHead] trimTail];
}


- (NSString *)encodeToBase64 {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

- (NSString *)decodeBase64 {
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:0];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

//- (NSString *)urlEncode {
//    NSMutableString *output = [NSMutableString string];
//    const unsigned char *source = (const unsigned char *)[self UTF8String];
//    int sourceLen = (int)strlen((const char *)source);
//    for (int i = 0; i < sourceLen; i++) {
//        const unsigned char thisChar = source[i];
//        if (thisChar == ' ') {
//            [output appendString:@"+"];
//        }else if (thisChar == '.' || thisChar == '_' || thisChar == '-' || thisChar == '~' ||
//                  (thisChar >= 'a' && thisChar <= 'z') || (thisChar >= 'A' && thisChar <= 'Z') ||
//                  (thisChar >= 0 && thisChar <= 9)) {
//            [output appendFormat:@"%c",thisChar];
//        }else{
//            [output appendFormat:@"%%%02X",thisChar];
//        }
//    }
//    
//    return [output copy];
//}

- (NSString *)URLEncodingUTF8String {
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)self, NULL, CFSTR("!@#$%&*()+'\";:=,/?[] "), kCFStringEncodingUTF8));
    return result;
}

- (NSString *)URLDecodingUTF8String {
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (__bridge CFStringRef)self, CFSTR(""), kCFStringEncodingUTF8));
    return result;
}

- (NSString *)stringByEscapingHTML {
    NSUInteger len = self.length;
    if (!len) {
        return self;
    }
    
    unichar *buf = malloc(sizeof(unichar) * len);
    if (!buf) {
        return nil;
    }
    
    [self getCharacters:buf range:NSMakeRange(0, len)];
    NSMutableString *result = [NSMutableString string];
    for (NSUInteger i = 0; i < len; i++) {
        unichar c = buf[i];
        NSString *esc = nil;
        switch (c) {
            case 34:
                esc = @"&quot;";
                break;
            case 38:
                esc = @"&amp;";
                break;
            case 39:
                esc = @"&apos;";
                break;
            case 60:
                esc = @"&lt;";
                break;
            case 62:
                esc = @"&gt;";
                break;
            default:
                break;
        }
        
        if (esc) {
            [result appendString:esc];
        }else {
            CFStringAppendCharacters((__bridge CFMutableStringRef)result, &c, 1);
        }
    }
    free(buf);
    
    return result;
}

- (CGSize)sizeByFont:(UIFont *)font width:(CGFloat)width mode:(NSLineBreakMode)lineBreakMode {
    CGSize result;
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:context:)]) {
        NSMutableDictionary *attr = @{}.mutableCopy;
        attr[NSFontAttributeName] = font;
        if (lineBreakMode != NSLineBreakByWordWrapping) {
            NSMutableParagraphStyle *pStyle = [NSMutableParagraphStyle new];
            pStyle.lineBreakMode = lineBreakMode;
            attr[NSParagraphStyleAttributeName] = pStyle;
        }
        CGRect rect = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes:@{NSFontAttributeName : font}
                                         context:NULL];
        result = rect.size;
    }else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        result = [self sizeWithFont:font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
    }
   
    return CGSizeMake(ceil(result.width), ceil(result.height));
}

- (CGSize)sizeByFont:(NSFont *)font {
    CGSize size = [self sizeWithAttributes:@{NSFontAttributeName : font}];
    return CGSizeMake(ceil(size.width), ceil(size.height));
}


































@end
