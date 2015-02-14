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
@property (strong, nonatomic) UIButton *addCellButton1;
@property (strong, nonatomic) UIButton *addCellButton2;
@property (strong, nonatomic) UIButton *addCellButton3;

@end

@implementation CustomViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _angle = 0;
    _isToggle = true;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [_tableView registerNib:[UINib nibWithNibName:@"CustomTableViewCell1" bundle:nil] forCellReuseIdentifier:@"cell1"];
    [_tableView registerNib:[UINib nibWithNibName:@"CustomTableViewCell2" bundle:nil] forCellReuseIdentifier:@"cell2"];
    [_tableView registerNib:[UINib nibWithNibName:@"CustomTableViewCell3" bundle:nil] forCellReuseIdentifier:@"cell3"];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [self.view addSubview:_tableView];
    
    _button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    _button.backgroundColor = [UIColor redColor];
    [_button setTitle:@"+" forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(buttonDidTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button];
    
    _addCellButton1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    _addCellButton2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    _addCellButton3 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    
    [_addCellButton1 setTitle:@"1" forState:UIControlStateNormal];
    [_addCellButton2 setTitle:@"2" forState:UIControlStateNormal];
    [_addCellButton3 setTitle:@"3" forState:UIControlStateNormal];
    
    [_addCellButton1 setBackgroundColor:[UIColor yellowColor]];
    [_addCellButton2 setBackgroundColor:[UIColor greenColor]];
    [_addCellButton3 setBackgroundColor:[UIColor blueColor]];
    
    [_addCellButton1 addTarget:self action:@selector(addCell1:) forControlEvents:UIControlEventTouchUpInside];
    [_addCellButton2 addTarget:self action:@selector(addCell2:) forControlEvents:UIControlEventTouchUpInside];
    [_addCellButton3 addTarget:self action:@selector(addCell3:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_addCellButton1];
    [self.view addSubview:_addCellButton2];
    [self.view addSubview:_addCellButton3];
    
    _addCellButton1.hidden =YES;
    _addCellButton2.hidden =YES;
    _addCellButton3.hidden =YES;

}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    _button.frame = CGRectMake(self.view.frame.size.width - 80, self.view.frame.size.height - 70, 30, 30);
    _tableView.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-20);
    _addCellButton1.frame = CGRectMake(self.view.frame.size.width - 80, self.view.frame.size.height - 70, 30, 30);
    _addCellButton2.frame = CGRectMake(self.view.frame.size.width - 80, self.view.frame.size.height - 70, 30, 30);
    _addCellButton3.frame = CGRectMake(self.view.frame.size.width - 80, self.view.frame.size.height - 70, 30, 30);
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
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    _angle=(_angle == 45 ? 0:45);
    self.button.transform = CGAffineTransformMakeRotation((_angle*M_PI)/180);
    [self animationStart];
}

-(void)addCell1:(UIButton *)sender{
    
}

-(void)addCell2:(UIButton *)sender{
    
}

-(void)addCell3:(UIButton *)sender{
    
}

#pragma mark - Animation in method: buttonDidTouched

-(void)animationStart{
    if(_isToggle==true){
        _addCellButton1.hidden =NO;
        _addCellButton2.hidden =NO;
        _addCellButton3.hidden =NO;
        
        [_addCellButton1 setCenter : CGPointMake(self.view.frame.size.width - 270, self.view.frame.size.height - 55)];
        [_addCellButton2 setCenter : CGPointMake(self.view.frame.size.width - 210, self.view.frame.size.height - 55)];
        [_addCellButton3 setCenter : CGPointMake(self.view.frame.size.width - 150, self.view.frame.size.height - 55)];
        [UIView commitAnimations];
        
        _isToggle=false;
    }else{
        [_addCellButton1 setCenter : CGPointMake(self.view.frame.size.width - 70, self.view.frame.size.height - 55)];
        [_addCellButton2 setCenter : CGPointMake(self.view.frame.size.width - 70, self.view.frame.size.height - 55)];
        [_addCellButton3 setCenter : CGPointMake(self.view.frame.size.width - 70, self.view.frame.size.height - 55)];
        [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
        
        [UIView commitAnimations];
        
        
        _isToggle=true;
    }
}

#pragma mark - setAnimationDidStopSelector's callback method
-(void)animationFinished:(NSString *)animationID
                finished:(NSNumber *)finished
                 context:(void *)context
{
    _addCellButton1.hidden =YES;
    _addCellButton2.hidden =YES;
    _addCellButton3.hidden =YES;
}
@end
