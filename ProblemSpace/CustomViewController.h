//
//  CustomTableViewController.h
//  ProblemSpace
//
//  Created by bamsae on 2015. 2. 13..
//  Copyright (c) 2015년 nomad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic) float angle;
@property(nonatomic) BOOL isToggle;
@end
