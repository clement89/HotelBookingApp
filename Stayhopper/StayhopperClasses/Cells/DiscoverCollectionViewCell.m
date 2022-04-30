//
//  DiscoverCollectionViewCell.m
//  Stayhopper
//
//  Created by Vh iROID Technologies on 24/07/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import "DiscoverCollectionViewCell.h"

@implementation DiscoverCollectionViewCell

-(void)awakeFromNib{
    _slotView.layer.cornerRadius=2;
    _slotView.clipsToBounds=YES;
    _slotView.layer.borderWidth=1;
    _slotView.layer.borderColor=[UIColor whiteColor].CGColor;
}

- (IBAction)slotAction:(id)sender {
    
}
@end
