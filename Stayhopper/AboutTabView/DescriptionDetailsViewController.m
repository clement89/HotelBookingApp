//
//  DescriptionDetailsViewController.m
//  Stayhopper
//
//  Created by Bryno Baby on 28/09/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import "DescriptionDetailsViewController.h"

@interface DescriptionDetailsViewController ()

@end

@implementation DescriptionDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated
{
    NSString* policyString=@"";
    if([self.dataDIC objectForKey:@"description"])
    {
        policyString=[self.dataDIC objectForKey:@"description"];
        
            }
    if(policyString.length==0)
        policyString=@"No Description Available";
    
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 4;
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@",policyString]];
    NSInteger leng2=str2.length;
    
    [str2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"ProximaNovaA-Regular" size:16.0] range:NSMakeRange(0, leng2)];
    [str2 addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, leng2)];
    [str2 addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, leng2)];
    
    //        [str1 addAttribute:NSFontAttributeName value:[UIFont fontWithName:FontBold size:20.0] range:NSMakeRange(5, leng1-5)];NSForegroundColorAttributeName
    
    descriptionTV.attributedText =str2;
    
   // descriptionTV.text=@"";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
