//
//  UIButton+HDKit.m
//  HDKitDemo
//
//  Created by ceo on 7/22/15.
//  Copyright (c) 2015 harvey. All rights reserved.
//

#import "UIButton+HDKit.h"

@implementation UIButton (HDKit)

+ (instancetype)createBarButtonItem:(UIBarButtonItem *__autoreleasing *)item
                          withImage:(UIImage *)image
                             target:(id)target
                             action:(SEL)action {
    return [self createBarButtonItem:item withButtonSize:CGSizeMake(32, 32) image:image target:target action:action];
}

+ (instancetype)createBarButtonItem:(UIBarButtonItem *__autoreleasing *)item
                     withButtonSize:(CGSize)size
                              image:(UIImage *)image
                             target:(id)target
                             action:(SEL)action {
    UIButton *button = [self buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, size.width, size.height);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    if (image != nil) {
        button.imageView.layer.cornerRadius = size.width / 2;
        button.imageView.layer.masksToBounds = YES;
        [button setImage:image forState:UIControlStateNormal];
    }
    
    if (item) {
        *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    
    return button;
}

#pragma mark - VerticallyLayout
- (void)centerVertically {
    const CGFloat kDefaultPadding = 8.0f;
    [self centerVerticallyWithPadding:kDefaultPadding];
}

- (void)centerVerticallyWithPadding:(float)padding {
    CGSize imageSize = CGSizeMake(CGRectGetWidth(self.imageView.bounds), CGRectGetHeight(self.imageView.bounds));
    CGSize titleSize = CGSizeMake(CGRectGetWidth(self.titleLabel.bounds), CGRectGetHeight(self.titleLabel.bounds));
    
    CGFloat totalHeight = (imageSize.height + titleSize.height + padding);
    self.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0, 0, -titleSize.width);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width, -(totalHeight - titleSize.height), 0);
}
@end
