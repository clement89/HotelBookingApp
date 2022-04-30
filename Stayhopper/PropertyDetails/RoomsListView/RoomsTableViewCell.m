//
//  RoomsTableViewCell.m
//  Stayhopper
//
//  Created by Bryno Baby on 22/08/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import "RoomsTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "URLConstants.h"
@implementation RoomsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _lblRoomCount.superview.layer.cornerRadius = 3.5;
   // [_selectButton addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    _plusButton.layer.cornerRadius=2;
    _minusButton.layer.cornerRadius=2;
    _bgView.layer.cornerRadius=4;
    self.timeBgImageview.clipsToBounds=YES;
    
    self.timeBgImageview.layer.cornerRadius=2;
    // Configure the view for the selected state
}
-(IBAction)plusAction:(id)sender
{
    NSInteger availAbleRooms=[self.availableRooms integerValue ];
    NSInteger selectedCount=[[[NSUserDefaults standardUserDefaults]valueForKey:[NSString stringWithFormat:@"count-%@",self.roonID]]integerValue];
    
    if(selectedCount<availAbleRooms)
    {
        selectedCount++;
        self.countTF.text=[NSString stringWithFormat:@"%ld",(long)selectedCount];
        [[NSUserDefaults standardUserDefaults]setObject:self.countTF.text forKey:[NSString stringWithFormat:@"count-%@",self.roonID]];
         [[NSUserDefaults standardUserDefaults]synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"roomSelected" object:nil];

    }
    
    
};
-(IBAction)minusAction:(id)sender
{
    NSInteger selectedCount=[[[NSUserDefaults standardUserDefaults]valueForKey:[NSString stringWithFormat:@"count-%@",self.roonID]]integerValue];
    if(selectedCount>1)
    {
        selectedCount--;
        self.countTF.text=[NSString stringWithFormat:@"%ld",(long)selectedCount];
        [[NSUserDefaults standardUserDefaults]setObject:self.countTF.text forKey:[NSString stringWithFormat:@"count-%@",self.roonID]];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"roomSelected" object:nil];

    }
   
    
};
-(IBAction)selectAction:(UIButton*)sender
{
    
//    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:[NSString stringWithFormat:@"count-%@",[dic valueForKey:@"_id"]]];
//    [[NSUserDefaults standardUserDefaults]setObject:@"NO" forKey:[NSString stringWithFormat:@"selectedRoom-%@",[dic valueForKey:@"_id"]]];
//
//    [[NSUserDefaults standardUserDefaults]synchronize];
    if(sender.isSelected)
    {
        sender.selected=NO;
        
            [[NSUserDefaults standardUserDefaults]setObject:@"NO" forKey:[NSString stringWithFormat:@"selectedRoom-%@",self.roonID]];
        
            [[NSUserDefaults standardUserDefaults]synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"roomSelected" object:nil];

    }
    else
    {
        sender.selected=YES;
        [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:[NSString stringWithFormat:@"selectedRoom-%@",self.roonID]];
        
        [[NSUserDefaults standardUserDefaults]synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"roomSelected" object:nil];

    }
    
};




- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return  MIN(self.serviceArray.count, 4);
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
        homeCell=[collectionView dequeueReusableCellWithReuseIdentifier:@"ServicesCollectionViewCell" forIndexPath:indexPath];
        if([[self.serviceArray objectAtIndex:indexPath.row] objectForKey:@"image"])
        {
        NSString*imgName=[[self.serviceArray objectAtIndex:indexPath.row] valueForKey:@"image"];
        NSURL*imgUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImageBaseUrl,imgName]];
        [homeCell.serviceImageView sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@""]];
    
        }
        
        
        return homeCell;
   
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
   
        return CGSizeMake(collectionView.frame.size.height, collectionView.frame.size.height);
    
    
}


@end
