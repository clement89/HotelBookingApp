//
//  TypeCollectionViewCell.h
//  ToMallz
//
//  Created by Vh iROID Technologies on 02/07/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TypeCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *type;
- (IBAction)typeAction:(id)sender;

@end
