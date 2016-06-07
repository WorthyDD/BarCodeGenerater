//
//  ViewController.m
//  BarCodeGenerater
//
//  Created by 武淅 段 on 16/6/7.
//  Copyright © 2016年 武淅 段. All rights reserved.
//

#import "ViewController.h"
#import "UIView+Geometry.h"
#import "ImageViewController.h"
#import "CustomToast.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic) UIImage *currentImage;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapImage)];
    [_imageView addGestureRecognizer:tap];
}




#pragma  mark - 生成二维码图片

- (void) generateBarcodeImageWithString : (NSString *)string
{
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    [filter setValue:data forKey:@"inputMessage"];
    CIImage *outputImage = [filter outputImage];
    
    
    /*CIContext *context = [CIContext contextWithOptions:nil];
     CGAffineTransform transform = CGAffineTransformMakeScale(1, 1);
     CIImage *transformImage = [outputImage imageByApplyingTransform:transform];
     CGImageRef cgImage = [context createCGImage:outputImage fromRect:transformImage.extent];
     CGImageRelease(cgImage);
     UIImage *image = [UIImage imageWithCGImage:cgImage];*/
    
    //默认生成的图片非常模糊
    UIImage *image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:self.imageView.width];
    
    [self.imageView setImage:image];
    _currentImage = image;
    //[self.barcodeImageView setContentMode:UIViewContentModeScaleAspectFill];
}


/**
 *  根据CIImage生成指定大小的UIImage
 *
 *  @param image CIImage
 *  @param size  图片宽度
 */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}


- (IBAction)didTapOK:(id)sender {
    
    if(!_textField.text){
        [CustomToast showHudToastWithString:@"链接不能为空"];
        return;
    }
    [self generateBarcodeImageWithString:_textField.text];
}

- (void) didTapImage
{
    if(_currentImage){
        [self performSegueWithIdentifier:@"image" sender:nil];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"image"]){
        ImageViewController *vc = segue.destinationViewController;
        vc.image = _currentImage;
    }
}


@end
