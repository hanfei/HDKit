//
//  UIImage+HDKit.m
//  HDKitDemo
//
//  Created by harvey.ding on 5/20/15.
//  Copyright (c) 2015 harvey. All rights reserved.
//

#import "UIImage+HDKit.h"

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
    if (CGRectIsEmpty(rect)) {
        return nil;
    }
    
    CGImageRef cutCGImage = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage *cutImage = [[UIImage alloc] initWithCGImage:cutCGImage];
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



























@end
