## Theme
URL转换成二维码图片Category

</br>



## Url To QRCode

1.根据url生成二维码

```
self.qrCodeImgView.image = [UIImage lbQRCodeWithUrlString:self.urlStr withSize:width];
```

2.生成不是黑白色的二维码

```
self.qrCodeImgView.image = [UIImage lbSpecialColorImage:[UIImage lbQRCodeWithUrlString:self.urlStr withSize:width] withRed:red green:green blue:blue];
```

3.根据url生成中间带icon的二维码

```
self.qrCodeImgView.image = [UIImage lbQRCodeWithUrlString:self.urlStr iconImage:[UIImage imageNamed:@"cyh"] withSize:width];
```

4.根据url生成中间带圆角icon的二维码

```
self.qrCodeImgView.image = [UIImage lbQRCodeWithUrlString:_urlStr iconImage:[UIImage imageNamed:@"cyh"] withSize:width iconCornerRadius:width/2];
```

</br>

