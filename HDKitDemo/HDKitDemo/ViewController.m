//
//  ViewController.m
//  HDKitDemo
//
//  Created by harvey.ding on 5/20/15.
//  Copyright (c) 2015 harvey. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+HDKit.h"
#import "NSData+HDKit.h"

#define AES @"AES"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIImageView *originalImgView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.    
    HDLog(@"test...");
    [self testEncrypt];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)testEncrypt {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *key = @"harveytest";
        NSData   *data = UIImagePNGRepresentation([UIImage imageNamed:@"test"]);
        NSError *error = nil;
        NSData *chiperData = [data hd_AES256EncryptedDataUsingKey:key error:&error];
        NSMutableData *mData = [NSMutableData dataWithCapacity:[chiperData length] + 3];
        [mData appendData:[[NSData alloc] initWithBytes:[AES UTF8String] length:[AES length]]];
        [mData appendData:chiperData];
        
        NSData *orignalData = [chiperData hd_decryptedAES256DataUsingKey:key error:&error];
        UIImage *img = [[UIImage alloc] initWithData:orignalData];
        dispatch_async(dispatch_get_main_queue(), ^{
            _originalImgView.image = img;
            _imgView.image = [img imageRotateByRadians:M_PI / 180.0 * 45.0];
        });
    });
}

@end
