//
//  MCCatchView.m
//  MCCatchRedPacket
//
//  Created by MC on 16/10/29.
//  Copyright © 2016年 MC. All rights reserved.
//

#import "MCCatchView.h"
#import "YGGravity.h"
#define KRedPacket_w 90
#define KRedPacket_h ((90 * 515) / 607)

#define SPEED 50
@interface MCCatchView () {

    NSMutableArray *imgViewArray;
    NSInteger index;

    CGRect catchRect;
}

@end

@implementation MCCatchView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        imgViewArray = [NSMutableArray array];
        index = 100;
        [self configUI];
    }
    return self;
}

- (void)drawRect2:(CGRect)rect {
    //背景
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:0];
    CGFloat w = self.frame.size.width - 170;

    //镂空
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(85, (self.frame.size.height - w) / 2 - 100, w, w)];

    [path appendPath:circlePath];
    [path setUsesEvenOddFillRule:YES];

    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.path = path.CGPath;
    fillLayer.fillRule = kCAFillRuleEvenOdd; //中间镂空的关键点 填充规则
    fillLayer.fillColor = [UIColor blackColor].CGColor;
    fillLayer.opacity = 0.5;
    [self.layer addSublayer:fillLayer];
}

- (void)configUI {

    _myImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width * 3, self.frame.size.height * 2)];

    _myImageView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    [self addSubview:_myImageView];

    //    _myImageView.backgroundColor = [UIColor redColor];

    _flightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width * 3, self.frame.size.height)];
    _flightView.backgroundColor = [UIColor clearColor];
    [_myImageView addSubview:_flightView];

    [self drawRect2:self.frame];

    CGFloat x = 50;
    CGFloat w = self.frame.size.width - 100;
    CGFloat h = w;
    CGFloat y = (self.frame.size.height - h) / 2 - 100;

    _catchView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    _catchView.image = [UIImage imageNamed:@"ic_circle_normal"];

    //        [self addGestureRecognizer:tap];
    _catchView.userInteractionEnabled = YES;

    [self addSubview:_catchView];

    y += h + 100;
    w = 70;
    h = 70;
    x = (self.frame.size.width - w) / 2;

    _catchBtn = [[UIButton alloc] initWithFrame:CGRectMake(x, y, w, h)];
    [_catchBtn setImage:[UIImage imageNamed:@"btn_catch_normal"] forState:UIControlStateNormal];
    [_catchBtn setImage:[UIImage imageNamed:@"btn_catch"] forState:UIControlStateSelected];
    [_catchBtn addTarget:self action:@selector(actionCatchBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_catchBtn];

    //    CGFloat w2 = 320/3-80;
    //    CGFloat x2 = (self.frame.size.width-w2)/2;
    //
    //    CGFloat h2 = w2;
    //    CGFloat y2 = (self.frame.size.height - h2)/2-h2-75;
    //    UIView * view2 = [[UIView alloc]initWithFrame:CGRectMake(x2, y2, w2, h2)];
    //    view2.backgroundColor = [UIColor redColor];
    //        [self addSubview:view2];

    UIImageView *ic_arrowImgVie = [[UIImageView alloc] initWithFrame:CGRectMake(_catchView.frame.origin.x - 10 / 2, _catchView.frame.origin.y - 10 / 2, _catchView.frame.size.width + 10, _catchView.frame.size.height + 10)];

    ic_arrowImgVie.image = [UIImage imageNamed:@"ic_arrow"];
    ic_arrowImgVie.userInteractionEnabled = YES;
    [self addSubview:ic_arrowImgVie];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionRedPacket_catchViewTap:)];

    [ic_arrowImgVie addGestureRecognizer:tap];
}

- (void)actionCatchBtn {
    if (_catchBtn.selected) {
        if (_delegate) {
            [_delegate catchRedPacket];
        }
    }
}

- (void)prepareData:(NSArray *)array {
    //607*515
    CGFloat RedPacket_w = 100;
    CGFloat RedPacket_h = 100;
    RedPacket_w = 90 * 515 / 607;
    RedPacket_h = 90 * 515 / 607;

    CGFloat maxx = self.frame.size.width * 3 - RedPacket_w;

    CGFloat maxy = self.frame.size.height - RedPacket_h;

    for (NSInteger i = 0; i < 4; i++) {
        CGFloat randomx = arc4random() % ((NSInteger) maxx);

        CGFloat randomy = arc4random() % ((NSInteger) maxy);

        RedPacketView *RedPacket = [[RedPacketView alloc] initWithFrame:CGRectMake(randomx, randomy, KRedPacket_w, KRedPacket_h)];

        RedPacket.image = [YLGIFImage imageNamed:@"bird.gif"];
        //               RedPacket.backgroundColor = [UIColor blueColor];
        RedPacket.tag = 900 + i;

        //        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionRedPacketTap:)];
        //        [RedPacket addGestureRecognizer:tap];
        RedPacket.userInteractionEnabled = YES;

        [_flightView addSubview:RedPacket];

        [imgViewArray addObject:RedPacket];

        [self RedPacketFiy2:RedPacket];
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:.3 target:self selector:@selector(jianCe) userInfo:nil repeats:YES];
}

- (void)jianCe {
    for (NSInteger i = 0; i < 4; i++) {
        RedPacketView *view1 = [self viewWithTag:900 + i];
        CGRect rect = [[view1.layer presentationLayer] frame]; // view指你的动画中移动的view

        if (CGRectIntersectsRect(rect, catchRect)) {
            _catchBtn.selected = YES;
            _catchView.image = [UIImage imageNamed:@"ic_circle"];

            //            NSLog(@"进来了");
            [UIView animateWithDuration:.1 animations:^{

                _catchView.transform = CGAffineTransformScale(_catchView.transform, .98, .98);

            }
                completion:^(BOOL finished) {

                    _catchView.transform = CGAffineTransformIdentity;

                }];

            break;

        } else {
            //            NSLog(@"出去了");
            _catchView.image = [UIImage imageNamed:@"ic_circle_normal"];
            _catchView.transform = CGAffineTransformIdentity;

            _catchBtn.selected = NO;
        }
    }
}

- (void)RedPacketFiy2:(RedPacketView *)RedPacket {
    CGFloat RedPacket_w = KRedPacket_w;
    CGFloat RedPacket_h = KRedPacket_h;

    CGFloat maxx = self.frame.size.width * 3 - RedPacket_w;

    CGFloat maxy = self.frame.size.height - RedPacket_h;

    CGFloat random_x = arc4random() % ((NSInteger) maxx);

    CGFloat random_y = arc4random() % ((NSInteger) maxy);

    //    CGFloat random_y = arc4random() % ((NSInteger)maxy);

    CGFloat Scalenum = [self randomBetween:0.5 And:3];

    if (RedPacket.state_size == 1 || RedPacket.state_size == 2) {

        //需要还原
        [UIView animateWithDuration:3 animations:^{

            RedPacket.frame = CGRectMake(random_x, random_y, RedPacket.frame.size.width, RedPacket.frame.size.height);
            RedPacket.transform = CGAffineTransformIdentity;
            RedPacket.state_size = 0;

        }
            completion:^(BOOL finished) {
                if (_timer) {
                    [self RedPacketFiy2:RedPacket];
                }
            }];

    }

    else {
        [UIView animateWithDuration:3 animations:^{

            RedPacket.frame = CGRectMake(random_x, random_y, RedPacket.frame.size.width, RedPacket.frame.size.height);
            RedPacket.transform = CGAffineTransformScale(RedPacket.transform, Scalenum, Scalenum);

            if (Scalenum > 1) {
                RedPacket.state_size = 2;

            } else if (Scalenum < 1) {

                RedPacket.state_size = 1;

            } else {
                RedPacket.state_size = 0;
            }

        }
            completion:^(BOOL finished) {

                if (_timer) {
                    [self RedPacketFiy2:RedPacket];
                }

            }];
    }
}

- (void)actionRedPacket_catchViewTap:(UITapGestureRecognizer *)tap {
    //    RedPacketView * RedPacket = [self viewWithTag:tap.view.tag];
    //    NSLog(@"RedPacket.tag ==%ld",RedPacket.tag);

    //    UITouch *touch = [touches anyObject];
    //
    //    CGPoint touchPoint = [touch locationInView:self];
    CGPoint point = [tap locationInView:self];
    NSLog(@"handleSingleTap!pointx:%f,y:%f", point.x, point.y);

    for (NSInteger i = 0; i < 4; i++) {
        RedPacketView *view1 = [self viewWithTag:900 + i];
        CGRect rect = [[view1.layer presentationLayer] frame]; // view指你的动画中移动的view

        if (CGRectIntersectsRect(rect, catchRect)) {
            NSLog(@"进来了");
            [self actionCatchBtn];

            //                if( CGRectIntersectsRect(rect, CGRectMake(point.x+self.frame.size.width, point.y, 30, 30)))
            //                {
            //                    NSLog(@"捉到了");
            //
            //                    }
            break;

        } else {
        }
    }
}

//-(id)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    NSArray *subViews = self.subviews;
//
//    for(UIView *subView in subViews){
//
//        if([subView isKindOfClass:[RedPacketView class]]){ //是要找的图片
//            CALayer *layer = subView.layer.presentationLayer; //图片的显示层
//            if(CGRectContainsPoint(layer.frame, point)){ //触摸点在显示层中，返回当前图片
//                return subView;
//            }
//        }
//        if([subView isKindOfClass:[UIImageView class]]){ //是要找的图片
//            CALayer *layer = subView.layer.presentationLayer; //图片的显示层
//            if(CGRectContainsPoint(layer.frame, point)){ //触摸点在显示层中，返回当前图片
//                return subView;
//            }
//        }
//
//    }
//    return [super hitTest:point withEvent:event];
//}

- (void)startAnimate {
    float scrollSpeed = (_myImageView.frame.size.width - self.frame.size.width) / 2 / SPEED;
    float scrollSpeedH = (_myImageView.frame.size.height - self.frame.size.height) / 2 / SPEED;

    [YGGravity sharedGravity].timeInterval = 0.03;

    __weak typeof(&*self) weakSelf = self;
    [[YGGravity sharedGravity] startDeviceMotionUpdatesBlock:^(float x, float y, float z) {

        [UIView animateKeyframesWithDuration:1 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeDiscrete | UIViewAnimationOptionAllowUserInteraction animations:^{

            if ((weakSelf.myImageView.frame.origin.x <= 0 && weakSelf.myImageView.frame.origin.x >= weakSelf.frame.size.width - weakSelf.myImageView.frame.size.width) || (weakSelf.myImageView.frame.origin.y >= 0 && weakSelf.myImageView.frame.origin.y >= weakSelf.frame.size.height - weakSelf.myImageView.frame.size.height)) {
                float invertedYRotationRate = y * 1.0;

                float interpretedXOffset = weakSelf.myImageView.frame.origin.x + invertedYRotationRate * (weakSelf.myImageView.frame.size.width / [UIScreen mainScreen].bounds.size.width) * scrollSpeed + weakSelf.myImageView.frame.size.width / 2;

                float invertedYRotationRatey = x * 1.0;

                float interpretedXOffsety = weakSelf.myImageView.frame.origin.y + invertedYRotationRatey * (weakSelf.myImageView.frame.size.height / [UIScreen mainScreen].bounds.size.height) * scrollSpeedH + weakSelf.myImageView.frame.size.height / 2;

                weakSelf.myImageView.center = CGPointMake(interpretedXOffset, interpretedXOffsety);
            }

            if (weakSelf.myImageView.frame.origin.x > 0) {
                weakSelf.myImageView.frame = CGRectMake(0, weakSelf.myImageView.frame.origin.y, weakSelf.myImageView.frame.size.width, weakSelf.myImageView.frame.size.height);
            }
            if (weakSelf.myImageView.frame.origin.y > 0) {
                weakSelf.myImageView.frame = CGRectMake(weakSelf.myImageView.frame.origin.x, 0, weakSelf.myImageView.frame.size.width, weakSelf.myImageView.frame.size.height);
            }

            if (weakSelf.myImageView.frame.origin.x < weakSelf.frame.size.width - weakSelf.myImageView.frame.size.width) {
                weakSelf.myImageView.frame = CGRectMake(weakSelf.frame.size.width - weakSelf.myImageView.frame.size.width, weakSelf.myImageView.frame.origin.y, weakSelf.myImageView.frame.size.width, weakSelf.myImageView.frame.size.height);
            }
            if (weakSelf.myImageView.frame.origin.y < weakSelf.frame.size.height - weakSelf.myImageView.frame.size.height) {
                weakSelf.myImageView.frame = CGRectMake(weakSelf.myImageView.frame.origin.x, weakSelf.frame.size.height - weakSelf.myImageView.frame.size.height, weakSelf.myImageView.frame.size.width, weakSelf.myImageView.frame.size.height);
            }
            //            NSLog(@"y ======%f",_myImageView.frame.origin.y);
            if (weakSelf.myImageView.frame.origin.y < -weakSelf.frame.size.height - weakSelf.myImageView.frame.origin.y - 100) {

                weakSelf.myImageView.center = CGPointMake(weakSelf.frame.size.width / 2, weakSelf.frame.size.height / 2);
            }

            //            NSLog(@"x=======%.2f",_myImageView.frame.origin.x);
            //            NSLog(@"y=======%.2f",_myImageView.frame.origin.y);

        }
                                  completion:nil];
        CGFloat w2 = 320 / 3 - 80;
        CGFloat x2 = (weakSelf.frame.size.width - w2) / 2;
        //self.frame.size.width - 100-100;
        CGFloat h2 = w2;
        CGFloat y2 = (weakSelf.frame.size.height - h2) / 2 - h2 - 75;

        //        NSLog(@"x=======%.2f",_myImageView.frame.origin.x);

        CGFloat x3 = 0 - weakSelf.myImageView.frame.origin.x + x2;
        CGFloat y3 = 0 - weakSelf.myImageView.frame.origin.y + y2;
        CGFloat w3 = w2;
        CGFloat h3 = y2;
        catchRect = CGRectMake(x3, y3, w3, h3);

    }];
}

- (void)stopAnimate {
    [[YGGravity sharedGravity] stop];
}

//随机返回某个区间范围内的值
- (CGFloat)randomBetween:(CGFloat)smallerNumber And:(CGFloat)largerNumber {
    //设置精确的位数
    int precision = 100;
    //先取得他们之间的差值
    float subtraction = largerNumber - smallerNumber;
    //取绝对值
    subtraction = ABS(subtraction);
    //乘以精度的位数
    subtraction *= precision;
    //在差值间随机
    float randomNumber = arc4random() % ((int) subtraction + 1);
    //随机的结果除以精度的位数
    randomNumber /= precision;
    //将随机的值加到较小的值上
    float result = MIN(smallerNumber, largerNumber) + randomNumber;
    //返回结果
    return result;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
