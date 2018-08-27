//
//  LEETimeLineModel.h
//  LEETimeLine
//
//  Created by 西瓜Team on 2018/8/24.
//  Copyright © 2018年 LEESen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ListModel;

@interface LEETimeLineModel : NSObject

@property (nonatomic,strong) NSArray<ListModel *> *articleList;


@end


@interface ListModel : NSObject

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *publishTime;

@property (nonatomic, assign) NSInteger bearNum;

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger bullOrBear;

@property (nonatomic, assign) NSInteger bullNum;

@property (nonatomic, assign) BOOL isFolding;


@end
