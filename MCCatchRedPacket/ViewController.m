//
//  ViewController.m
//  MCCatchRedPacket
//
//  Created by MC on 16/10/29.
//  Copyright © 2016年 MC. All rights reserved.
//

#import "ViewController.h"
#import "MCCatchRedPacketController.h"
#import "RedPacketView.h"
#import "YLGIFImage.h"
@interface ViewController ()<MCCatchViewDelegate>
{
    
    UIView * view;
    
    
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 50)];
    [btn setTitle:@"捉红包" forState:0];
    [btn setTitleColor:[UIColor redColor] forState:0];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(actionBtn) forControlEvents:UIControlEventTouchUpInside];
    
    view = [[UIView alloc]initWithFrame:self.view.frame];
    view.backgroundColor = [UIColor whiteColor];
    RedPacketView * imgView = [[RedPacketView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
    imgView.image = [YLGIFImage imageNamed:@"bird.gif"];
    imgView.center = self.view.center;
    [view addSubview:imgView];
    view.hidden = YES;
    [self.view addSubview:view];

    
    
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)catchRedPacket
{
    view.hidden = NO;

    
    
}
-(void)actionBtn{
    MCCatchRedPacketController * ctl =[[MCCatchRedPacketController alloc]init];
    ctl.delegate = self;
    [self presentViewController:ctl animated:YES completion:nil];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
