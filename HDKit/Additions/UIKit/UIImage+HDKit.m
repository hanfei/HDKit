//
//  UIImage+HDKit.m
//  HDKitDemo
//
//  Created by harvey.ding on 5/20/15.
//  Copyright (c) 2015 harvey. All rights reserved.
//

#import "UIImage+HDKit.h"
#import <ImageIO/ImageIO.h>
#import <Accelerate/Accelerate.h>

@implementation UIImage (HDKit)

+ (UIImage *)renderImageFromView:(UIView *)view {
    return [self renderImageFromView:view withRect:view.bounds];
}

+ (UIImage *)renderImageFromView:(UIView *)view withRect:(CGRect)rect {
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, -rect.origin.x, -rect.origin.y);
    [view.layer renderInContext:context];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

+ (UIImage *)renderImageFromView:(UIView *)view withRect:(CGRect)rect transparentInsets:(UIEdgeInsets)insets {
    CGSize sizeWithBorder = CGSizeMake(view.frame.size.width + insets.left + insets.right,
                                       view.frame.size.height + insets.top + insets.bottom);
    UIGraphicsBeginImageContextWithOptions(sizeWithBorder, UIEdgeInsetsEqualToEdgeInsets(insets, UIEdgeInsetsZero), 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClipToRect(context, (CGRect){{insets.left, insets.top}, rect.size});
    CGContextTranslateCTM(context, -rect.origin.x + insets.left, -rect.origin.y + insets.top);
    [view.layer renderInContext:context];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

+ (UIImage *)renderImageForAntialiasing:(UIImage *)image {
    return [self renderImageForAntialiasing:image withInsets:UIEdgeInsetsMake(1, 1, 1, 1)];
}

+ (UIImage *)renderImageForAntialiasing:(UIImage *)image withInsets:(UIEdgeInsets)insets {
    CGSize sizeWithBorder = CGSizeMake(image.size.width + insets.left + insets.right,
                                       image.size.height + insets.top + insets.bottom);
    UIGraphicsBeginImageContextWithOptions(sizeWithBorder, UIEdgeInsetsEqualToEdgeInsets(insets, UIEdgeInsetsZero), 0);
    CGRect imgRect = (CGRect){{insets.left, insets.top}, image.size};
    [image drawInRect:imgRect];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

+ (UIImage *)renderImage:(UIImage *)image margin:(CGFloat)margin color:(UIColor *)color {
    CGSize sizeWithBorder = CGSizeMake(image.size.width + 2 * (margin + 1), image.size.height + 2 * (margin + 1));
    UIGraphicsBeginImageContextWithOptions(sizeWithBorder, NO, 0);
    CGRect bgRect = (CGRect){{1,1},{image.size.width + 2 * margin, image.size.height + 2 * margin}};
    [color set];
    UIRectFill(bgRect);
    [image drawInRect:(CGRect){{(margin + 1), (margin + 1)},image.size}];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

- (UIImage *)stretched
{
    CGSize size = self.size;
    
    UIEdgeInsets insets = UIEdgeInsetsMake(truncf(size.height-1)/2, truncf(size.width-1)/2, truncf(size.height-1)/2, truncf(size.width-1)/2);
    
    return [self resizableImageWithCapInsets:insets];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [image stretched];
}

- (UIImage *)resizedImageWithSize:(CGSize)size {
    if (size.width <= 0 || size.height <= 0) {
        return nil;
    }
    
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImg;
}

- (UIImage *)capturedImaeInRect:(CGRect)rect {
    
    rect.origin.x *= self.scale;
    rect.origin.y *= self.scale;
    rect.size.width *= self.scale;
    rect.size.height *= self.scale;
    
    if (CGRectIsEmpty(rect)) {
        return nil;
    }
    
    CGImageRef cutCGImage = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage *cutImage = [[UIImage alloc] initWithCGImage:cutCGImage scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(cutCGImage);
    return cutImage;
}

- (UIImage *)fixOrientation {
    if (self.imageOrientation == UIImageOrientationUp) {
        return self;
    }
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    [self drawInRect:(CGRect){0,0,self.size}];
    UIImage *normalImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalImg;
}

- (UIImage *)decompressedImage {
    if (self.images) {
        // Do not decode animated images
        return self;
    }
    
    CGImageRef imageRef = self.CGImage;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imageRef), CGImageGetHeight(imageRef));
    CGRect imageRect = (CGRect){.origin = CGPointZero, .size = imageSize};
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    
    int infoMask = (bitmapInfo & kCGBitmapAlphaInfoMask);
    BOOL anyNonAlpha = (infoMask == kCGImageAlphaNone ||
                        infoMask == kCGImageAlphaNoneSkipFirst ||
                        infoMask == kCGImageAlphaNoneSkipLast);
    
    // CGBitmapContextCreate doesn't support kCGImageAlphaNone with RGB.
    // https://developer.apple.com/library/mac/#qa/qa1037/_index.html
    if (infoMask == kCGImageAlphaNone && CGColorSpaceGetNumberOfComponents(colorSpace) > 1) {
        // Unset the old alpha info.
        bitmapInfo &= ~kCGBitmapAlphaInfoMask;
        
        // Set noneSkipFirst.
        bitmapInfo |= kCGImageAlphaNoneSkipFirst;
    }
    // Some PNGs tell us they have alpha but only 3 components. Odd.
    else if (!anyNonAlpha && CGColorSpaceGetNumberOfComponents(colorSpace) == 3) {
        // Unset the old alpha info.
        bitmapInfo &= ~kCGBitmapAlphaInfoMask;
        bitmapInfo |= kCGImageAlphaPremultipliedFirst;
    }
    
    // It calculates the bytes-per-row based on the bitsPerComponent and width arguments.
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 imageSize.width,
                                                 imageSize.height,
                                                 CGImageGetBitsPerComponent(imageRef),
                                                 0,
                                                 colorSpace,
                                                 bitmapInfo);
    CGColorSpaceRelease(colorSpace);
    
    // If failed, return undecompressed image
    if (!context) return self;
    
    CGContextDrawImage(context, imageRect, imageRef);
    CGImageRef decompressedImageRef = CGBitmapContextCreateImage(context);
    
    CGContextRelease(context);
    
    UIImage *decompressedImage = [UIImage imageWithCGImage:decompressedImageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(decompressedImageRef);
    return decompressedImage;
}


- (UIImage *)imageWithTintColor:(UIColor *)tintColor {
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeDestinationIn];
}

- (UIImage *)imageWithGradientTintColor:(UIColor *)tintColor {
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeOverlay];
}

- (UIImage *)imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    [self drawInRect:bounds blendMode:blendMode alpha:1.0];
    
    //redraw to save alpha channel
    if (blendMode != kCGBlendModeDestinationIn) {
        [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)grayImage {
    CGImageRef  imageRef;
    imageRef = self.CGImage;
    
    size_t width  = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    size_t                  bitsPerComponent;
    bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
    size_t                  bitsPerPixel;
    bitsPerPixel = CGImageGetBitsPerPixel(imageRef);
    size_t                  bytesPerRow;
    bytesPerRow = CGImageGetBytesPerRow(imageRef);
    CGColorSpaceRef         colorSpace;
    colorSpace = CGImageGetColorSpace(imageRef);
    CGBitmapInfo            bitmapInfo;
    bitmapInfo = CGImageGetBitmapInfo(imageRef);
    bool                    shouldInterpolate;
    shouldInterpolate = CGImageGetShouldInterpolate(imageRef);
    CGColorRenderingIntent  intent;
    intent = CGImageGetRenderingIntent(imageRef);
    CGDataProviderRef   dataProvider;
    dataProvider = CGImageGetDataProvider(imageRef);
    CFDataRef   data;
    UInt8*      buffer;
    data = CGDataProviderCopyData(dataProvider);
    buffer = (UInt8*)CFDataGetBytePtr(data);
    
    NSUInteger  x, y;
    for (y = 0; y < height; y++) {
        for (x = 0; x < width; x++) {
            UInt8*  tmp;
            tmp = buffer + y * bytesPerRow + x * 4;
            
            UInt8 red,green,blue;
            red = *(tmp + 0);
            green = *(tmp + 1);
            blue = *(tmp + 2);
            
            *(tmp + 0) = red*0.299 + green * 0.587 + blue * 0.114;
            *(tmp + 1) = *(tmp + 0) ;
            *(tmp + 2) = *(tmp + 0) ;
        }
    }
    
    CFDataRef   effectedData;
    effectedData = CFDataCreate(NULL, buffer, CFDataGetLength(data));
    
    CGDataProviderRef   effectedDataProvider;
    effectedDataProvider = CGDataProviderCreateWithCFData(effectedData);
    
    CGImageRef  effectedCgImage;
    UIImage*    effectedImage;
    effectedCgImage = CGImageCreate(
                                    width, height,
                                    bitsPerComponent, bitsPerPixel, bytesPerRow,
                                    colorSpace, bitmapInfo, effectedDataProvider,
                                    NULL, shouldInterpolate, intent);
    effectedImage = [[UIImage alloc] initWithCGImage:effectedCgImage];
    
    CGImageRelease(effectedCgImage);
    CFRelease(effectedDataProvider);
    CFRelease(effectedData);
    CFRelease(data);
    
    return effectedImage;
}

- (UIImage *)imageRotateByRadians:(CGFloat)radians {
    UIView *rotatedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.size.width, self.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(radians);
    rotatedView.transform = t;
    CGSize rotatedSize = rotatedView.frame.size;
    
    UIGraphicsBeginImageContextWithOptions(rotatedSize, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, rotatedSize.width / 2, rotatedSize.height / 2);
    CGContextRotateCTM(context, radians);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGRectMake(- self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), self.CGImage);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

+ (UIImageOrientation)hd_imageOrientationFromImageData:(NSData *)imageData {
    UIImageOrientation result = UIImageOrientationUp;
    CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)imageData, NULL);
    if (imageSource) {
        CFDictionaryRef properties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, NULL);
        if (properties) {
            CFTypeRef val;
            int exifOrientation;
            val = CFDictionaryGetValue(properties, kCGImagePropertyOrientation);
            if (val) {
                CFNumberGetValue(val, kCFNumberIntType, &exifOrientation);
                result = [self _hdExifOrientationToiOSOrientation:exifOrientation];
            }
            CFRelease(properties);
        }
        CFRelease(imageSource);
    }
    return result;
}

+ (UIImageOrientation)_hdExifOrientationToiOSOrientation:(int)exifOrientation {
    UIImageOrientation orientation = UIImageOrientationUp;
    switch (exifOrientation) {
        case 1:
            orientation = UIImageOrientationUp;
            break;
        case 3:
            orientation = UIImageOrientationDown;
            break;
        case 8:
            orientation = UIImageOrientationLeft;
            break;
        case 6:
            orientation = UIImageOrientationRight;
            break;
        case 2:
            orientation = UIImageOrientationUpMirrored;
            break;
        case 4:
            orientation = UIImageOrientationDownMirrored;
            break;
        case 5:
            orientation = UIImageOrientationLeftMirrored;
            break;
        case 7:
            orientation = UIImageOrientationRightMirrored;
            break;
        default:
            break;
    }
    return orientation;
}

+ (UIImage *)hd_imageWithPDF:(id)dataOrPath {
    return [self _hd_imageWithPDF:dataOrPath resize:NO size:CGSizeZero];
}

+ (UIImage *)hd_imageWithPDF:(id)dataOrPath size:(CGSize)size {
    return [self _hd_imageWithPDF:dataOrPath resize:YES size:size];
}

+ (UIImage *)_hd_imageWithPDF:(id)dataOrPath resize:(BOOL)resize size:(CGSize)size {
    CGPDFDocumentRef pdf = NULL;
    if ([dataOrPath isKindOfClass:[NSData class]]) {
        CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)dataOrPath);
        pdf = CGPDFDocumentCreateWithProvider(provider);
    }else if ([dataOrPath isKindOfClass:[NSString class]]) {
        pdf = CGPDFDocumentCreateWithURL((__bridge CFURLRef)[NSURL URLWithString:dataOrPath]);
    }
    
    if (!pdf) {
        return nil;
    }
    
    CGPDFPageRef page = CGPDFDocumentGetPage(pdf, 1);
    if (!page) {
        CGPDFDocumentRelease(pdf);
        return nil;
    }
    
    CGRect pdfRect = CGPDFPageGetBoxRect(page, kCGPDFCropBox);
    CGSize pdfSize = resize ? size : pdfRect.size;
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(NULL, pdfSize.width * scale, pdfSize.height * scale, 8, 0, colorSpace, kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    if (!ctx) {
        CGColorSpaceRelease(colorSpace);
        CGPDFDocumentRelease(pdf);
        return nil;
    }
    
    CGContextScaleCTM(ctx, scale, scale);
    CGContextTranslateCTM(ctx, -pdfRect.origin.x, -pdfRect.origin.y);
    CGContextDrawPDFPage(ctx, page);
    CGPDFDocumentRelease(pdf);
    
    CGImageRef image = CGBitmapContextCreateImage(ctx);
    UIImage *pdfImage = [[UIImage alloc] initWithCGImage:image scale:scale orientation:UIImageOrientationUp];
    CGImageRelease(image);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(ctx);
    
    return pdfImage;
}

- (UIColor *)hd_colorAtPoint:(CGPoint)point {
    if (point.x < 0 || point.y < 0) {
        return nil;
    }
    
    CGImageRef imageRef = self.CGImage;
    if (!imageRef) {
        return nil;
    }
    
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    
    if (point.x * self.scale >= width || point.y * self.scale >= height) {
        return nil;
    }
    
    unsigned char *rawData = malloc(height * width * 4);
    if (!rawData) {
        return nil;
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    if (!context) {
        free(context);
        return nil;
    }
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    long byteIndex = (long)(point.y * self.scale * bytesPerRow) + (long)(point.x * self.scale * bytesPerPixel);
    CGFloat red = (rawData[byteIndex] * 1.0) / 255.0;
    CGFloat green = (rawData[byteIndex + 1] * 1.0) / 255.0;
    CGFloat blue = (rawData[byteIndex + 2] * 1.0) / 255.0;
    CGFloat alpha = (rawData[byteIndex + 3] * 1.0) / 255.0;
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    free(rawData);
    return color;
}

- (BOOL)hd_hasAlphaChannel {
    if (self.CGImage == NULL) {
        return NO;
    }
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(self.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}

- (void)drawInRect:(CGRect)rect withContentMode:(UIViewContentMode)contentMode{
    CGRect drawRect;
    CGSize size = self.size;
    
    switch (contentMode) {
        case UIViewContentModeRedraw:
        case UIViewContentModeScaleToFill: {
            [self drawInRect:rect];
            return;
        }
        case UIViewContentModeScaleAspectFit: {
            CGFloat factor;
            if (size.width < size.height) {
                factor = rect.size.height / size.height;
            }else {
                factor = rect.size.width / size.width;
            }
            size.width = roundf(size.width * factor);
            size.height = roundf(size.height * factor);
            drawRect = CGRectMake(roundf(CGRectGetMidX(rect) - size.width / 2.0) ,
                                  roundf(CGRectGetMidX(rect) - size.height / 2.0),
                                  size.width,
                                  size.height);
        }
            break;
        case UIViewContentModeScaleAspectFill: {
            CGFloat factor;
            if (size.width < size.height) {
                factor = rect.size.width / size.width;
            }else {
                factor = rect.size.height / size.height;
            }
            size.width = roundf(size.width * factor);
            size.height = roundf(size.height * factor);
            drawRect = CGRectMake(roundf(CGRectGetMidX(rect) - size.width / 2.0) ,
                                  roundf(CGRectGetMidX(rect) - size.height / 2.0),
                                  size.width,
                                  size.height);
        }
            break;
        case UIViewContentModeCenter: {
            drawRect = CGRectMake(roundf(CGRectGetMidX(rect) - size.width / 2.0) ,
                                  roundf(CGRectGetMidX(rect) - size.height / 2.0),
                                  size.width,
                                  size.height);
        }
            break;
        case UIViewContentModeTop: {
            drawRect = CGRectMake(roundf(CGRectGetMidX(rect) - size.width / 2.0) ,
                                  rect.origin.y,
                                  size.width,
                                  size.height);
        }
            break;
        case UIViewContentModeBottom: {
            drawRect = CGRectMake(roundf(CGRectGetMidX(rect) - size.width / 2.0) ,
                                  CGRectGetMaxY(rect) - size.height,
                                  size.width,
                                  size.height);
        }
            break;
        case UIViewContentModeLeft: {
            drawRect = CGRectMake(rect.origin.x,
                                  roundf(CGRectGetMidY(rect) - size.height / 2.0),
                                  size.width,
                                  size.height);
        }
            break;
        case UIViewContentModeRight: {
            drawRect = CGRectMake(CGRectGetMaxX(rect) - size.width,
                                  roundf(CGRectGetMidY(rect) - size.height / 2.0),
                                  size.width,
                                  size.height);
        }
            break;
        case UIViewContentModeTopLeft: {
            drawRect = CGRectMake(rect.origin.x,
                                  rect.origin.y,
                                  size.width,
                                  size.height);
        }
            break;
        case UIViewContentModeTopRight: {
            drawRect = CGRectMake(CGRectGetMaxX(rect) - size.width,
                                  rect.origin.y,
                                  size.width,
                                  size.height);
        }
            break;
        case UIViewContentModeBottomLeft: {
            drawRect = CGRectMake(rect.origin.x,
                                  CGRectGetMaxY(rect) - size.height,
                                  size.width,
                                  size.height);
        }
            break;
        case UIViewContentModeBottomRight: {
            drawRect = CGRectMake(CGRectGetMaxX(rect) - size.width,
                                  CGRectGetMaxY(rect) - size.height,
                                  size.width,
                                  size.height);
        }
            break;
        default:
            return;
    }
    
    CGContextRef contexxt = UIGraphicsGetCurrentContext();
    CGContextSaveGState(contexxt);
    CGContextAddRect(contexxt, rect);
    CGContextClip(contexxt);
    [self drawInRect:drawRect];
    CGContextRestoreGState(contexxt);
}

- (UIImage *)hd_imageByResizeToSize:(CGSize)size contentMode:(UIViewContentMode)contentMode {
    if (size.width <= 0 || size.height <= 0) {
        return nil;
    }
    UIGraphicsBeginImageContextWithOptions(size, NO, self.scale);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height) withContentMode:contentMode];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (UIImage *)hd_imageByRoundCornerRadius:(CGFloat)radius {
    return [self imageByRoundCornerRadius:radius corners:UIRectCornerAllCorners borderWith:0];
}

- (UIImage *)imageByRoundCornerRadius:(CGFloat)radius corners:(UIRectCorner)corners borderWith:(CGFloat)borderWidth {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -rect.size.height);
    CGFloat minSize = MIN(self.size.width, self.size.height);
    if (borderWidth < minSize / 2.0) {
        [[UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, borderWidth, borderWidth) byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)] addClip];
        CGContextDrawImage(context, rect, self.CGImage);
    }
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


- (UIImage *)hd_flipHorizontal:(BOOL)horizontal vertical:(BOOL)vertical {
    if (!self.CGImage) return nil;
    size_t width = (size_t)CGImageGetWidth(self.CGImage);
    size_t height = (size_t)CGImageGetHeight(self.CGImage);
    size_t bytesPerRow = width * 4;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace);
    if (!context) return nil;
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), self.CGImage);
    UInt8 *data = (UInt8 *)CGBitmapContextGetData(context);
    if (!data) {
        CGContextRelease(context);
        return nil;
    }
    vImage_Buffer src = { data, height, width, bytesPerRow };
    vImage_Buffer dest = { data, height, width, bytesPerRow };
    if (vertical) {
        vImageVerticalReflect_ARGB8888(&src, &dest, kvImageBackgroundColorFill);
    }
    if (horizontal) {
        vImageHorizontalReflect_ARGB8888(&src, &dest, kvImageBackgroundColorFill);
    }
    CGImageRef imgRef = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    UIImage *img = [UIImage imageWithCGImage:imgRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imgRef);
    return img;

}

- (UIImage *)hd_imageByGrayscale {
    return [self imageByBlurRadius:0 tintColor:nil tintMode:0 saturation:0 maskImage:nil];
}

- (UIImage *)hd_imageByBlurSoft {
    return [self imageByBlurRadius:60 tintColor:[UIColor colorWithWhite:0.84 alpha:0.36] tintMode:kCGBlendModeNormal saturation:1.8 maskImage:nil];
}

- (UIImage *)hd_imageByBlurLight {
    return [self imageByBlurRadius:60 tintColor:[UIColor colorWithWhite:1.0 alpha:0.3] tintMode:kCGBlendModeNormal saturation:1.8 maskImage:nil];
}

- (UIImage *)hd_imageByBlurExtraLight {
    return [self imageByBlurRadius:40 tintColor:[UIColor colorWithWhite:0.97 alpha:0.82] tintMode:kCGBlendModeNormal saturation:1.8 maskImage:nil];
}

- (UIImage *)hd_imageByBlurDark {
    return [self imageByBlurRadius:40 tintColor:[UIColor colorWithWhite:0.11 alpha:0.73] tintMode:kCGBlendModeNormal saturation:1.8 maskImage:nil];
}

- (UIImage *)hd_imageByBlurWithTint:(UIColor *)tintColor {
    const CGFloat EffectColorAlpha = 0.6;
    UIColor *effectColor = tintColor;
    size_t componentCount = CGColorGetNumberOfComponents(tintColor.CGColor);
    if (componentCount == 2) {
        CGFloat b;
        if ([tintColor getWhite:&b alpha:NULL]) {
            effectColor = [UIColor colorWithWhite:b alpha:EffectColorAlpha];
        }
    } else {
        CGFloat r, g, b;
        if ([tintColor getRed:&r green:&g blue:&b alpha:NULL]) {
            effectColor = [UIColor colorWithRed:r green:g blue:b alpha:EffectColorAlpha];
        }
    }
    return [self imageByBlurRadius:20 tintColor:effectColor tintMode:kCGBlendModeNormal saturation:-1.0 maskImage:nil];
}

- (UIImage *)imageByBlurRadius:(CGFloat)blurRadius
                     tintColor:(UIColor *)tintColor
                      tintMode:(CGBlendMode)tintBlendMode
                    saturation:(CGFloat)saturation
                     maskImage:(UIImage *)maskImage {
    if (self.size.width < 1 || self.size.height < 1) {
        NSLog(@"UIImage+YYAdd error: invalid size: (%.2f x %.2f). Both dimensions must be >= 1: %@", self.size.width, self.size.height, self);
        return nil;
    }
    if (!self.CGImage) {
        NSLog(@"UIImage+YYAdd error: inputImage must be backed by a CGImage: %@", self);
        return nil;
    }
    if (maskImage && !maskImage.CGImage) {
        NSLog(@"UIImage+YYAdd error: effectMaskImage must be backed by a CGImage: %@", maskImage);
        return nil;
    }
    
    // iOS7 and above can use new func.
    BOOL hasNewFunc = &vImageBuffer_InitWithCGImage != NULL && &vImageCreateCGImageFromBuffer != NULL;
    BOOL hasBlur = blurRadius > __FLT_EPSILON__;
    BOOL hasSaturation = fabs(saturation - 1.0) > __FLT_EPSILON__;
    
    CGSize size = self.size;
    CGRect rect = { CGPointZero, size };
    CGFloat scale = self.scale;
    CGImageRef imageRef = self.CGImage;
    BOOL opaque = NO;
    
    if (!hasBlur && !hasSaturation) {
        return [self _hd_mergeImageRef:imageRef tintColor:tintColor tintBlendMode:tintBlendMode maskImage:maskImage opaque:opaque];
    }
    
    vImage_Buffer effect = { 0 }, scratch = { 0 };
    vImage_Buffer *input = NULL, *output = NULL;
    
    vImage_CGImageFormat format = {
        .bitsPerComponent = 8,
        .bitsPerPixel = 32,
        .colorSpace = NULL,
        .bitmapInfo = kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little, //requests a BGRA buffer.
        .version = 0,
        .decode = NULL,
        .renderingIntent = kCGRenderingIntentDefault
    };
    
    if (hasNewFunc) {
        vImage_Error err;
        err = vImageBuffer_InitWithCGImage(&effect, &format, NULL, imageRef, kvImagePrintDiagnosticsToConsole);
        if (err != kvImageNoError) {
            NSLog(@"UIImage+YYAdd error: vImageBuffer_InitWithCGImage returned error code %zi for inputImage: %@", err, self);
            return nil;
        }
        err = vImageBuffer_Init(&scratch, effect.height, effect.width, format.bitsPerPixel, kvImageNoFlags);
        if (err != kvImageNoError) {
            NSLog(@"UIImage+YYAdd error: vImageBuffer_Init returned error code %zi for inputImage: %@", err, self);
            return nil;
        }
    } else {
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale);
        CGContextRef effectCtx = UIGraphicsGetCurrentContext();
        CGContextScaleCTM(effectCtx, 1.0, -1.0);
        CGContextTranslateCTM(effectCtx, 0, -size.height);
        CGContextDrawImage(effectCtx, rect, imageRef);
        effect.data     = CGBitmapContextGetData(effectCtx);
        effect.width    = CGBitmapContextGetWidth(effectCtx);
        effect.height   = CGBitmapContextGetHeight(effectCtx);
        effect.rowBytes = CGBitmapContextGetBytesPerRow(effectCtx);
        
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale);
        CGContextRef scratchCtx = UIGraphicsGetCurrentContext();
        scratch.data     = CGBitmapContextGetData(scratchCtx);
        scratch.width    = CGBitmapContextGetWidth(scratchCtx);
        scratch.height   = CGBitmapContextGetHeight(scratchCtx);
        scratch.rowBytes = CGBitmapContextGetBytesPerRow(scratchCtx);
    }
    
    input = &effect;
    output = &scratch;
    
    if (hasBlur) {
        // A description of how to compute the box kernel width from the Gaussian
        // radius (aka standard deviation) appears in the SVG spec:
        // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
        //
        // For larger values of 's' (s >= 2.0), an approximation can be used: Three
        // successive box-blurs build a piece-wise quadratic convolution kernel, which
        // approximates the Gaussian kernel to within roughly 3%.
        //
        // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
        //
        // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
        //
        CGFloat inputRadius = blurRadius * scale;
        if (inputRadius - 2.0 < __FLT_EPSILON__) inputRadius = 2.0;
        uint32_t radius = floor((inputRadius * 3.0 * sqrt(2 * M_PI) / 4 + 0.5) / 2);
        radius |= 1; // force radius to be odd so that the three box-blur methodology works.
        int iterations;
        if (blurRadius * scale < 0.5) iterations = 1;
        else if (blurRadius * scale < 1.5) iterations = 2;
        else iterations = 3;
        NSInteger tempSize = vImageBoxConvolve_ARGB8888(input, output, NULL, 0, 0, radius, radius, NULL, kvImageGetTempBufferSize | kvImageEdgeExtend);
        void *temp = malloc(tempSize);
        for (int i = 0; i < iterations; i++) {
            vImageBoxConvolve_ARGB8888(input, output, temp, 0, 0, radius, radius, NULL, kvImageEdgeExtend);
            vImage_Buffer *tempBuffer  = input;
            input = output;
            output = tempBuffer;
        }
        free(temp);
    }
    
    
    if (hasSaturation) {
        // These values appear in the W3C Filter Effects spec:
        // https://dvcs.w3.org/hg/FXTF/raw-file/default/filters/Publish.html#grayscaleEquivalent
        CGFloat s = saturation;
        CGFloat matrixFloat[] = {
            0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
            0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
            0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
            0,                    0,                    0,                    1,
        };
        const int32_t divisor = 256;
        NSUInteger matrixSize = sizeof(matrixFloat) / sizeof(matrixFloat[0]);
        int16_t matrix[matrixSize];
        for (NSUInteger i = 0; i < matrixSize; ++i) {
            matrix[i] = (int16_t)roundf(matrixFloat[i] * divisor);
        }
        vImageMatrixMultiply_ARGB8888(input, output, matrix, divisor, NULL, NULL, kvImageNoFlags);
        vImage_Buffer *tempBuffer  = input;
        input = output;
        output = tempBuffer;
    }
    
    UIImage *outputImage = nil;
    if (hasNewFunc) {
        CGImageRef effectCGImage = NULL;
        effectCGImage = vImageCreateCGImageFromBuffer(input, &format, &_hd_cleanupBuffer, NULL, kvImageNoAllocate, NULL);
        if (effectCGImage == NULL) {
            effectCGImage = vImageCreateCGImageFromBuffer(input, &format, NULL, NULL, kvImageNoFlags, NULL);
            free(input->data);
        }
        free(output->data);
        outputImage = [self _hd_mergeImageRef:effectCGImage tintColor:tintColor tintBlendMode:tintBlendMode maskImage:maskImage opaque:opaque];
        CGImageRelease(effectCGImage);
    } else {
        CGImageRef effectCGImage;
        UIImage *effectImage;
        if (input != &effect) effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        if (input == &effect) effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        effectCGImage = effectImage.CGImage;
        outputImage = [self _hd_mergeImageRef:effectCGImage tintColor:tintColor tintBlendMode:tintBlendMode maskImage:maskImage opaque:opaque];
    }
    return outputImage;
}

static void _hd_cleanupBuffer(void *userData, void *buf_data) {
    free(buf_data);
}


- (UIImage *)_hd_mergeImageRef:(CGImageRef)effectCGImage
                     tintColor:(UIColor *)tintColor
                 tintBlendMode:(CGBlendMode)tintBlendMode
                     maskImage:(UIImage *)maskImage
                        opaque:(BOOL)opaque {
    BOOL hasTint = tintColor != nil && CGColorGetAlpha(tintColor.CGColor) > __FLT_EPSILON__;
    BOOL hasMask = maskImage != nil;
    CGSize size = self.size;
    CGRect rect = { CGPointZero, size };
    CGFloat scale = self.scale;
    
    if (!hasTint && !hasMask) {
        return [UIImage imageWithCGImage:effectCGImage];
    }
    
    UIGraphicsBeginImageContextWithOptions(size, opaque, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextTranslateCTM(context, 0, -size.height);
    if (hasMask) {
        CGContextDrawImage(context, rect, self.CGImage);
        CGContextSaveGState(context);
        CGContextClipToMask(context, rect, maskImage.CGImage);
    }
    CGContextDrawImage(context, rect, effectCGImage);
    if (hasTint) {
        CGContextSaveGState(context);
        CGContextSetBlendMode(context, tintBlendMode);
        CGContextSetFillColorWithColor(context, tintColor.CGColor);
        CGContextFillRect(context, rect);
        CGContextRestoreGState(context);
    }
    if (hasMask) {
        CGContextRestoreGState(context);
    }
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return outputImage;
}






















@end

@implementation UIImage (HDKit_GIF)

+ (UIImage *)hd_animatedGIFWithData:(NSData *)data {
    if (!data) {
        return nil;
    }
    
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    size_t count  = CGImageSourceGetCount(source);
    
    UIImage *animatedImage;
    
    if (count <= 1) {
        animatedImage = [UIImage imageWithData:data];
    }else {
        NSMutableArray *images = [NSMutableArray arrayWithCapacity:(NSUInteger)count];
        NSTimeInterval duration = 0.0f;
        for (size_t i = 0; i < count; i++) {
            CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
            duration += [self _hd_frameDurationAtIndex:i source:source];
            [images addObject:[UIImage imageWithCGImage:image
                                                  scale:[[UIScreen mainScreen] scale]
                                            orientation:UIImageOrientationUp]];
            CGImageRelease(image);
        }
        
        if (!duration) {
            duration = (1.0 / 10.0f) * count;
        }
        
        animatedImage = [UIImage animatedImageWithImages:images duration:duration];
    }
    
    CFRelease(source);
    
    return animatedImage;
}

+ (float)_hd_frameDurationAtIndex:(NSUInteger)index source:(CGImageSourceRef)source {
    float frameDuration = 0.1f;
    CFDictionaryRef cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(source, index, NULL);
    NSDictionary *frameProperties = (__bridge NSDictionary *)cfFrameProperties;
    NSDictionary *gifProperties = frameProperties[(NSString *)kCGImagePropertyGIFDictionary];
    NSNumber *delayTimeUnclampedProp = gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
    if (delayTimeUnclampedProp) {
        frameDuration = [delayTimeUnclampedProp floatValue];
    }else {
        NSNumber *delayTimeProp = gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
        if (delayTimeProp) {
            frameDuration = [delayTimeProp floatValue];
        }
    }
    
    if (frameDuration < 0.011f) {
        frameDuration = 0.100f;
    }
    
    CFRelease(cfFrameProperties);
    return frameDuration;
}





























@end
