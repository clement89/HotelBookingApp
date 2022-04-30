//
//  OptionsCollectionViewCell.m
//  Stayhopper
//
//  Created by Vh iROID Technologies on 24/07/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import "OptionsCollectionViewCell.h"

@implementation OptionsCollectionViewCell{
    int rooms,adults,children;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    _containerView.layer.cornerRadius=2.5;
    _containerView.clipsToBounds=YES;
    _containerView.layer.borderWidth=1;
    
    _timebgImageView.layer.cornerRadius=2.5;
    _timebgImageView.clipsToBounds=YES;
    _timebgImageView.layer.borderWidth=1;
    _timebgImageView.layer.borderColor=[UIColor colorWithRed: 0.718 green: 0.831 blue: 0.867 alpha:1].CGColor;
    _containerView.layer.borderColor=[UIColor colorWithRed: 0.718 green: 0.831 blue: 0.867 alpha:1].CGColor;
    
    _optionSelected.layer.borderWidth=1;
    _optionSelected.layer.borderColor=[UIColor colorWithRed: 0.718 green: 0.831 blue: 0.867 alpha:1].CGColor;
    
//    _timeLbl.layer.cornerRadius=2.5;
//    _timeLbl.clipsToBounds=YES;
//    _timeLbl.layer.borderWidth=1;
//    _timeLbl.layer.borderColor=[UIColor colorWithRed: 0.718 green: 0.831 blue: 0.867 alpha:1].CGColor;
    
    rooms=0;
    children=0;
    adults=0;
}

- (IBAction)subtractAction:(id)sender {
    UIButton*btn=sender;
    rooms=[[[NSUserDefaults standardUserDefaults]objectForKey:@"selectedRooms"] intValue];
    adults=[[[NSUserDefaults standardUserDefaults]objectForKey:@"selectedAdults"] intValue];
    children=[[[NSUserDefaults standardUserDefaults]objectForKey:@"selectedChild"] intValue];
    if(btn.tag==0){
        if(rooms>1){
            rooms--;
        }
        self.optionSelected.text=[NSString stringWithFormat:@"%d",rooms];
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%d",rooms] forKey:@"selectedRooms"];
       
        
        [[NSUserDefaults standardUserDefaults]synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadRooms" object:nil];

    }
    else if(btn.tag==1)
    {
        if(adults>1)
        {
            adults--;
        }
        self.optionSelected.text=[NSString stringWithFormat:@"%d",adults];
        
        if(rooms>adults)
        {
            //[[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%d",rooms] forKey:@"selectedAdults"];
            [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%d",adults] forKey:@"selectedRooms"];
        }
        
        
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%d",adults] forKey:@"selectedAdults"];
        
        [[NSUserDefaults standardUserDefaults]synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadRooms" object:nil];

    }
    else if(btn.tag==2){
        if(children>0){
            children--;
        }
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%d",children] forKey:@"selectedChild"];
        
        
        [[NSUserDefaults standardUserDefaults]synchronize];
        self.optionSelected.text=[NSString stringWithFormat:@"%d",children];
    }
}

- (IBAction)addAction:(id)sender {
    
    rooms=[[[NSUserDefaults standardUserDefaults]objectForKey:@"selectedRooms"] intValue];
    adults=[[[NSUserDefaults standardUserDefaults]objectForKey:@"selectedAdults"] intValue];
    children=[[[NSUserDefaults standardUserDefaults]objectForKey:@"selectedChild"] intValue];
    UIButton*btn=sender;
    if(btn.tag==0){
        if(rooms<31){
            rooms++;
        }
        self.optionSelected.text=[NSString stringWithFormat:@"%d",rooms];
        if(rooms>[[[NSUserDefaults standardUserDefaults]objectForKey:@"selectedAdults"] integerValue])
            [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%d",rooms] forKey:@"selectedAdults"];
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%d",rooms] forKey:@"selectedRooms"];
        
        
        [[NSUserDefaults standardUserDefaults]synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadRooms" object:nil];

        
    }
    else if(btn.tag==1){
        if(adults<31){
        adults++;
        }
        self.optionSelected.text=[NSString stringWithFormat:@"%d",adults];
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%d",adults] forKey:@"selectedAdults"];
        
        [[NSUserDefaults standardUserDefaults]synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadRooms" object:nil];

    }
    else if(btn.tag==2){
        if(children<31){
        children++;
        }
        self.optionSelected.text=[NSString stringWithFormat:@"%d",children];
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%d",children] forKey:@"selectedChild"];
        
        
        [[NSUserDefaults standardUserDefaults]synchronize];
       // [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadRooms" object:nil];

    }
}

@end
