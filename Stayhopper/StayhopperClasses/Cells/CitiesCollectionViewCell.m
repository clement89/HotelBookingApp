//
//  CitiesCollectionViewCell.m
//  Stayhopper
//
//  Created by Bryno Baby on 04/10/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import "CitiesCollectionViewCell.h"

#import "RequestUtil.h"
@implementation CitiesCollectionViewCell

-(void)awakeFromNib{
    [super awakeFromNib];
    
//    self.layer.cornerRadius=2;
    self.clipsToBounds=YES;
    self.img.layer.cornerRadius=5.;
//    self.layer.shadowColor = [UIColor groupTableViewBackgroundColor].CGColor;
//    self.layer.shadowOffset = CGSizeMake(0.5f, 0.5f);
//    self.layer.shadowRadius = 1.0f;
//    self.layer.shadowOpacity = 0.4f;
//    self.layer.masksToBounds = NO;
    //_slotView.layer.borderWidth=1;
    //_slotView.layer.borderColor=[UIColor whiteColor].CGColor;
}

-(IBAction)favAction:(UIButton*)sender
{
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"userID"])
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"NO" forKey:@"loadStatus"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        RequestUtil* utilObj=[[RequestUtil alloc]init];
        [utilObj addOrRemoveFavorites:_propertyID userID:@""];
        
        if(sender.isSelected)
        {
            sender.selected=NO;
        }
        else
        {
            sender.selected=YES;
            
        }
    }
    
}
@end

