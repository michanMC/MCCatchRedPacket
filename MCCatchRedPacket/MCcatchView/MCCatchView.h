//
//  MCCatchView.h
//  MCCatchRedPacket
//
//  Created by MC on 16/10/29.
//  Copyright © 2016年 MC. All rights reserved.
//

#import "RedPacketView.h"
#import "YLGIFImage.h"
#import <UIKit/UIKit.h>

@protocol MCCatchViewDelegate <NSObject>

- (void)catchRedPacket;

@end

@interface MCCatchView : UIView <CAAnimationDelegate>

@property (nonatomic, weak) id<MCCatchViewDelegate> delegate;
@property (nonatomic, strong) NSTimer *timer;
/**
 *  显示的图片
 */
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIView *myImageView;

//飞行区域
@property (nonatomic, strong) UIView *flightView;
//捕捉区
@property (nonatomic, strong) UIImageView *catchView;

@property (nonatomic, strong) UIButton *catchBtn;
- (void)prepareData:(NSArray *)array;

/**
 *  开始重力感应
 */
- (void)startAnimate;

/**
 *  停止重力感应
 */
- (void)stopAnimate;

@end
