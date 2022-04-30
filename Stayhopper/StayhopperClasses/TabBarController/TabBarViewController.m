//
//  TabBarViewController.m
//  Stayhopper
//
//  Created by Vh iROID Technologies on 23/07/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import "TabBarViewController.h"
#import "URLConstants.h"
#import "Commons.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self tabBarImages];
    // Do any additional setup after loading the view.
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
-(void)tabBarImages
{
    
    NSArray *imageAndTitle = @[@{@"title":@"DISCOVER",
                                 @"image":@"HomeDiscoverActive",
                                 @"color":kColorDarkBlueThemeColor},
                               @{@"title":@"SAVED",
                                 @"image":@"HomeSavedActive",
                                 @"color":kColorDarkBlueThemeColor},
                               @{@"title":@"BOOKINGS",
                                 @"image":@"HomeBookingActive",
                                 @"color":kColorDarkBlueThemeColor},
                                @{@"title":@"PROFILE",
                                @"image":@"ProActive",
                                @"color":kColorDarkBlueThemeColor}];
                                
    UITabBar *tabBar = self.tabBar;
    NSArray *tabItems = tabBar.items;

    UIColor *colrNormal,*colrSelected;
    colrNormal = kColorTabNormalColor;
    colrSelected = kColorDarkBlueThemeColor;

    float offset = 6;
    
    for (int t=0; t<tabItems.count;t++)
    {
        UITabBarItem *firstTab = [tabItems objectAtIndex:t];
//        [firstTab setImage:[[UIImage imageNamed:[imageAndTitle[t] valueForKey:@"image"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//        [firstTab setSelectedImage:[[UIImage imageNamed:[imageAndTitle[t] valueForKey:@"image"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        firstTab.image =[Commons image:[[UIImage imageNamed:[imageAndTitle[t] valueForKey:@"image"]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] fromColor:colrNormal];
        firstTab.selectedImage  = [[UIImage imageNamed:[imageAndTitle[t] valueForKey:@"image"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        //[[UIImage imageNamed:[NSString stringWithFormat:@"%@-selected",[imageAndTitle[t] valueForKey:@"image"]]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] ;
        
//        firstTab.imageInsets = UIEdgeInsetsMake(offset, 0, -1*offset, 0);
       firstTab.title = [imageAndTitle[t] valueForKey:@"title"];
      
                    [firstTab setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:FontBold size:10],
                                                  NSForegroundColorAttributeName : colrSelected
                                                } forState:UIControlStateSelected];
       
   
                 // doing this results in an easier to read unselected state then the default iOS 7 one
                 [firstTab setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:FontBold size:10],
                                                NSForegroundColorAttributeName : colrNormal
                                              } forState:UIControlStateNormal];
    
          
    }

   // NSArray *vcss = self.viewControllers;

//    for (UINavigationController *nv in vcss)
//    {
//        int indx = (int)[vcss indexOfObject:nv];
//
//      //  [nv.navigationBar setBarTintColor:imageAndTitle[indx][@"color"]];
//        [nv.navigationBar setTranslucent:NO];
//    }
    
//    [[UITabBar appearance] setTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbGColor.png"]]];
//    [[UITabBar appearance] setBarTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbGColor"]]];
        [UITabBarItem.appearance setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:FontBold size:10],NSForegroundColorAttributeName : colrNormal} forState:UIControlStateNormal];
    [UITabBarItem.appearance setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:FontBold size:10],NSForegroundColorAttributeName : colrSelected} forState:UIControlStateSelected];

    ;
    
//    if([UINavigationBar conformsToProtocol:@protocol(UIAppearanceContainer)]) {
//        [UINavigationBar appearance].tintColor = [UIColor whiteColor];
//    }
}


@end
