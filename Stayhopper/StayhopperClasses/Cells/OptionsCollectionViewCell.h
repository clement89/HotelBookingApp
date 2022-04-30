//
//  OptionsCollectionViewCell.h
//  Stayhopper
//
//  Created by Vh iROID Technologies on 24/07/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol optionsSelectingDelegate <NSObject>
-(void)numberOfRooms:(NSInteger)rooms;
-(void)numberOfAdults:(NSInteger)adults;
-(void)numberOfChildren:(NSInteger)children;

@end

@interface OptionsCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *optionName;
- (IBAction)subtractAction:(id)sender;
- (IBAction)addAction:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *optionSelected;
@property (strong, nonatomic) IBOutlet UIButton *add;
@property (strong, nonatomic) IBOutlet UIButton *subtract;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UIImageView *timebgImageView;

@property (strong, nonatomic) IBOutlet UILabel *timeLbl;

@end
