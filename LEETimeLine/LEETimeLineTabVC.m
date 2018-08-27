//
//  LEETimeLineTabVC.m
//  LEETimeLine
//
//  Created by 西瓜Team on 2018/8/24.
//  Copyright © 2018年 LEESen. All rights reserved.
//

#import "LEETimeLineTabVC.h"
#import "LEETimeLineCell.h"
#import "LEETimeLineModel.h"
#import "MJExtension.h"
@interface LEETimeLineTabVC ()

@property (nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation LEETimeLineTabVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getDateSource];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setStatusBarBgColor];
    
    [self.tableView registerClass:[LEETimeLineCell class] forCellReuseIdentifier:@"LEETimeLineCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)setStatusBarBgColor
{
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = [UIColor whiteColor];
    }
}

- (void)getDateSource
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];

    LEETimeLineModel *listModel = [LEETimeLineModel mj_objectWithKeyValues:data];
    
    NSArray *articleList = listModel.articleList;
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i<articleList.count; i++) {
        
        ListModel *model = [ListModel mj_objectWithKeyValues:articleList[i]];
        [array addObject:model];
    }
    self.dataArray = array;
    
}

- (void)cellActionWithCell:(LEETimeLineCell *)cell
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //折叠响应事件
    cell.foldingBlock = ^(LEETimeLineCell *cell) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        ListModel *model = self.dataArray[indexPath.row];
        model.isFolding = !model.isFolding;
        
        NSIndexPath *index = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
        
        [UIView performWithoutAnimation:^{
            [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
        }];
    };
    
    //利好响应事件
    cell.bullBlock = ^(LEETimeLineCell *cell, NSString *tag) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        ListModel *model = self.dataArray[indexPath.row];
        model.bullOrBear = [tag integerValue];
        model.bullNum++;
        [self configureCell:cell atIndexPath:indexPath];
    };
    
    //利空
    cell.bealBlock = ^(LEETimeLineCell *cell, NSString *tag) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        ListModel *model = self.dataArray[indexPath.row];
        model.bullOrBear = [tag integerValue];
        model.bearNum++;
        [self configureCell:cell atIndexPath:indexPath];
    };
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LEETimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LEETimeLineCell" forIndexPath:indexPath];
    
    [self cellActionWithCell:cell];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        [cell.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.pointView.mas_bottom);
            make.bottom.equalTo(cell);
            make.width.mas_offset(0.5);
            make.centerX.equalTo(cell.pointView);
        }];
    }else{
        [cell.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell);
            make.bottom.equalTo(cell);
            make.width.mas_offset(0.5);
            make.centerX.equalTo(cell.pointView);
        }];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:@"LEETimeLineCell" cacheByIndexPath:indexPath configuration:^(id cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
}

- (void)configureCell:(LEETimeLineCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    //使用Masonry进行布局的话，这里要设置为NO
    cell.fd_enforceFrameLayout = NO;
    
    cell.model = self.dataArray[indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *view = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    view.backgroundColor = [UIColor whiteColor];
    view.textAlignment = NSTextAlignmentCenter;
    view.text = [self dayShow];
    return view;
}

#pragma mark -- lazy --
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSString *)dayShow
{
    NSDate *today = [[NSDate alloc]init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [formatter stringFromDate:today];
    NSString *newDateStr = [NSString stringWithFormat:@"今天是：%@",dateStr];
    NSString *weekStr  = [self showWeekWithDate:today];
    
    return [NSString stringWithFormat:@"%@ %@",newDateStr,weekStr];
}

//计算当天是星期几
- (NSString *)showWeekWithDate:(NSDate *)date
{
    NSArray *weekDays = [NSArray arrayWithObjects:[NSNull null],@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:date];
    NSString *weekday = [weekDays objectAtIndex:theComponents.weekday];
    return weekday;
}

@end
