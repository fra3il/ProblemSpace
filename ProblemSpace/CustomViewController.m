//
//  CustomTableViewController.m
//  ProblemSpace
//
//  Created by bamsae on 2015. 2. 13..
//  Copyright (c) 2015년 nomad. All rights reserved.
//

#import "CustomViewController.h"
#import "CustomTableViewCell1.h"
#import "CustomTableViewCell2.h"
#import "CustomTableViewCell3.h"

@interface CustomViewController ()

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *button;

@end

@implementation CustomViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [_tableView registerNib:[UINib nibWithNibName:@"CustomTableViewCell1" bundle:nil] forCellReuseIdentifier:@"cell1"];
    [_tableView registerNib:[UINib nibWithNibName:@"CustomTableViewCell2" bundle:nil] forCellReuseIdentifier:@"cell2"];
    [_tableView registerNib:[UINib nibWithNibName:@"CustomTableViewCell3" bundle:nil] forCellReuseIdentifier:@"cell3"];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [self.view addSubview:_tableView];
    
    _button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    _button.backgroundColor = [UIColor redColor];
    [_button setTitle:@"Button" forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(buttonDidTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    _button.frame = CGRectMake(self.view.frame.size.width - 100, self.view.frame.size.height - 70, 80, 50);
    _tableView.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-20);
}

#pragma mark - Table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomTableViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
    if (!cell) {
    }
    return cell;
}

#pragma mark - Events

- (void)buttonDidTouched:(UIButton *)sender
{
    NSLog(@"LOG");
}

@end
