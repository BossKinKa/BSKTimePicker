//
//  ViewController.m
//  BSKTimePickerDemo
//
//  Created by jinke5 on 2018/10/16.
//  Copyright © 2018 jinke5. All rights reserved.
//

#import "BSKDemoMainTableViewController.h"
#import "BSKDemoDetailViewController.h"

@interface BSKDemoMainTableViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,copy) NSArray *listArr;
@end

@implementation BSKDemoMainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.listArr[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:[BSKDemoDetailViewController new] animated:YES];
}

-(NSArray *)listArr
{
    if (!_listArr) {
        _listArr = @[@"Common style"];
    }
    return _listArr;
}


@end
