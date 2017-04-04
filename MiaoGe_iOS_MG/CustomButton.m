//
//  CustomButton.m
//  BaDian
//
//  Created by zhoupingshuang on 15/4/1.
//  Copyright (c) 2015年 Hangzhou Badian Technology Co., Ltd. All rights reserved.
//

#import "CustomButton.h"
#import "UtilClass.h"

@implementation CustomButton

-(id)initWithFrame:(CGRect)frame img:(UIImage*)img imgsize:(CGSize)size lbl:(UILabel*)lbl disdance:(CGFloat)dis{
    self = [super initWithFrame:frame];
    if (self) {
        self.imgv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        self.imgv.image = img;
        self.lbl = lbl;
        [self addSubview:self.imgv];
        [self addSubview:self.lbl];
        [self setFrameImgvLbl:frame dis:dis];
    }
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event
{
    CGRect bounds = self.bounds;
    CGFloat widthDelta;
    CGFloat heightDelta;
    //若原热区小于44x44，则放大热区，否则保持原大小不变
    widthDelta = MAX(44.0 - bounds.size.width, 0);
    heightDelta= MAX(44.0 - bounds.size.height, 0);
    if (self.isDefautSize) {
        widthDelta = MAX(self.ResponseSize.width - bounds.size.width, 0);
        heightDelta = MAX(self.ResponseSize.height - bounds.size.height, 0);
    }
    
    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
    return CGRectContainsPoint(bounds, point);
}

-(void)setFrameImgvLbl:(CGRect)frame dis:(CGFloat)dis{
    
    CGFloat x = (frame.size.width-(self.imgv.frame.size.width+dis+self.lbl.frame.size.width))/2;
    self.imgv.center = CGPointMake(x+self.imgv.frame.size.width/2, frame.size.height/2);
    self.lbl.center = CGPointMake(self.imgv.frame.origin.x+self.imgv.frame.size.width+dis+self.lbl.frame.size.width/2, frame.size.height/2);
}

-(void)setFrameImgvLbl:(CGRect)frame dis:(CGFloat)dis img:(UIImage*)img imgsize:(CGSize)imgsize text:(NSString*)ltext font:(UIFont*)lfont color:(UIColor*)lcolor{
    if (!self.imgv) {
        self.imgv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imgsize.width, imgsize.height)];
        [self addSubview:self.imgv];
    }
    
    if (!self.lbl) {
        self.lbl = [[UILabel alloc]init];
        [self addSubview:self.lbl];
    }
    
    self.imgv.image = img;
    
    [UtilClass lblatrr:self.lbl font:lfont color:lcolor alignment:NSTextAlignmentCenter text:ltext];
    CGSize size = LBL_TEXTSIZE(self.lbl.text, self.lbl.font);
    self.lbl.frame = CGRectMake(0, 0, size.width, size.height);
    
    CGFloat x = (frame.size.width-(self.imgv.frame.size.width+dis+self.lbl.frame.size.width))/2;
    self.imgv.center = CGPointMake(x+self.imgv.frame.size.width/2, frame.size.height/2);
    self.lbl.center = CGPointMake(self.imgv.frame.origin.x+self.imgv.frame.size.width+dis+self.lbl.frame.size.width/2, frame.size.height/2);
    
}

-(void)setshadow:(UIColor *)color touchcolor:(UIColor *)touchcolor{
    self.dqcolor = color;
    self.touchcolor = touchcolor;
    [self setshadow];
}

-(void)setshadow{
    [self addTarget:self action:@selector(itemTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(itemTouchedUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [self addTarget:self action:@selector(itemTouchedDown:) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(itemTouchedCancel:) forControlEvents:UIControlEventTouchCancel];
}

-(void)itemTouchedUpOutside:(id)item {

    if (self.dqcolor) {
        self.backgroundColor = self.dqcolor;
    }else{
        self.alpha = 1;
    }
}

-(void)itemTouchedDown:(id)item {
    
    if (self.touchcolor) {
        self.backgroundColor = self.touchcolor;
    }else{
        self.alpha = 0.5;
    }
}

- (void)itemTouchedUpInside:(id)item {
    if (self.dqcolor) {
        self.backgroundColor = self.dqcolor;
    }else{
        self.alpha = 1;
    }
}

- (void)itemTouchedCancel:(id)item {
    if (self.dqcolor) {
        self.backgroundColor = self.dqcolor;
    }else{
        self.alpha = 1;
    }
}

@end
