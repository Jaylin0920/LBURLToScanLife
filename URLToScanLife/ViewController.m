//
//  ViewController.m
//  URLToScanLife
//
//  Created by JiBaoBao on 17/2/6.
//  Copyright © 2017年 JiBaoBao. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+LBUrlToQRCode.h"

@interface ViewController ()
@property (nonatomic, strong)NSString *urlStr;
@property (weak, nonatomic) IBOutlet UILabel *urlLabel;
@property (weak, nonatomic) IBOutlet UIImageView *qrCodeImgView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.urlStr = @"http://fund.sina.com.cn/competition/2016/";
    self.urlLabel.text = self.urlStr;

}

- (IBAction)btnClick:(UIButton *)sender {
    CGFloat width = self.qrCodeImgView.bounds.size.width;
    
    int red = (arc4random() % 256) ;
    int green = (arc4random() % 256) ;
    int blue = (arc4random() % 256) ;

    switch (sender.tag) {
        case 1:
            //根据url生成二维码
            self.qrCodeImgView.image = [UIImage lbQRCodeWithUrlString:self.urlStr withSize:width];
            break;
        case 2:
            //生成不是黑白色的二维码
            self.qrCodeImgView.image = [UIImage lbSpecialColorImage:[UIImage lbQRCodeWithUrlString:self.urlStr withSize:width] withRed:red green:green blue:blue];
            break;
        case 3:
            //根据url生成中间带icon的二维码
            self.qrCodeImgView.image = [UIImage lbQRCodeWithUrlString:self.urlStr iconImage:[UIImage imageNamed:@"cyh"] withSize:width];
            break;
        case 4:
            self.qrCodeImgView.image = [UIImage lbQRCodeWithUrlString:_urlStr iconImage:[UIImage imageNamed:@"cyh"] withSize:width iconCornerRadius:width/2];
            break;
        default:
            break;
    }
}


@end
