//
//  SourceBuShouViewController.m
//  ItemDictionary
//
//  Created by 3014 on 16/7/23.
//  Copyright © 2016年 3014. All rights reserved.
//

#import "SourceBuShouViewController.h"
#import "BuShouTableViewCell.h"
@interface SourceBuShouViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) UITableView *myTableView;
@property(nonatomic,strong) NSMutableArray *dataSource;
@end

@implementation SourceBuShouViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    [self.view addSubview:_myTableView];
    self.dataSource = [NSMutableArray array];
    [self initData];
    [self.myTableView registerNib:[UINib nibWithNibName:@"BuShouTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([BuShouTableViewCell class])];
}

- (void)initData{
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BuShouTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BuShouTableViewCell class])];
    return cell;
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

@end
