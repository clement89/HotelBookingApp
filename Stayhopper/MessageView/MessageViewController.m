//
//  MessageViewController.m
//  Stayhopper
//
//  Created by Bryno Baby on 26/09/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import "MessageViewController.h"

@interface MessageViewController ()

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   // self.bgView.layer.cornerRadius=4;
    
    
    
  _messageLBL.text =self.messageString;
    
    _smileyImageView.image=[UIImage imageNamed:self.imageName];
    
    if([self.imageName isEqualToString:@"Failed"])
    {
        
        _bgView.backgroundColor=[UIColor redColor];
        _bgView1.backgroundColor=[UIColor redColor];

    }
    else  if([self.imageName isEqualToString:@"Succses"])
    {
        
        _bgView.backgroundColor=[UIColor colorWithRed:0.40 green:0.68 blue:0.20 alpha:1.0];
        _bgView1.backgroundColor=[UIColor colorWithRed:0.40 green:0.68 blue:0.20 alpha:1.0];

    }else
    {
        
        _bgView.backgroundColor=[UIColor orangeColor];
        _bgView1.backgroundColor=[UIColor orangeColor];


    }
    [NSTimer scheduledTimerWithTimeInterval:3.5 repeats:NO block:^(NSTimer * _Nonnull timer) {
        [self.view removeFromSuperview];
    }];
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated
{
  
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

    [self.view removeFromSuperview];
 }
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
