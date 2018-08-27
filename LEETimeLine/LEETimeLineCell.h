//
//  LEETimeLineCell.h
//  LEETimeLine
//
//  Created by 西瓜Team on 2018/8/24.
//  Copyright © 2018年 LEESen. All rights reserved.
//

#import <UIKit/UIKit.h>



#import "LEETimeLineModel.h"

@interface LEETimeLineCell : UITableViewCell

typedef void(^FoldingBlock)(LEETimeLineCell *cell);

typedef void(^BullBlock)(LEETimeLineCell *cell,NSString *tag);

typedef void(^BealBlock)(LEETimeLineCell *cell,NSString *tag);



@property (nonatomic,strong) UIView *lineView;

@property (nonatomic,strong) UIView *pointView;

@property (nonatomic,strong) ListModel *model;

@property (nonatomic,copy) FoldingBlock foldingBlock;

@property (nonatomic,copy) BullBlock bullBlock;

@property (nonatomic,copy) BealBlock bealBlock;

@end
