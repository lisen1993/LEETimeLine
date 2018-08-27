//
//  LEETimeLineModel.m
//  LEETimeLine
//
//  Created by 西瓜Team on 2018/8/24.
//  Copyright © 2018年 LEESen. All rights reserved.
//

#import "LEETimeLineModel.h"

@implementation LEETimeLineModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"articleList" : [ListModel class]};

}
@end


@implementation ListModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"ID":@"id"};
}


@end

