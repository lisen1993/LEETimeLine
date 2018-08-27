//
//  LEETimeLineCell.m
//  LEETimeLine
//
//  Created by 西瓜Team on 2018/8/24.
//  Copyright © 2018年 LEESen. All rights reserved.
//

#import "LEETimeLineCell.h"

static CGFloat LineSpacing = 5.0f;
static NSInteger MaxLineCount = 5;

@interface LEETimeLineCell()

@property (nonatomic,strong) UIView  *bgView;

@property (nonatomic,strong) UILabel *titleLable;

@property (nonatomic,strong) UILabel *dataLable;

@property (nonatomic,strong) UILabel *contentLable;

@property (nonatomic,strong) UIButton *foldingBtn;

@property (nonatomic,strong) UIButton *bullBtn;

@property (nonatomic,strong) UIButton *bearBtn;

@property (nonatomic,strong) UIButton *shareBtn;

@property (nonatomic,assign) BOOL isFolding;

@end

@implementation LEETimeLineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createPageUI];
        [self setUpLayout];
    }
    return self;
}


- (void)createPageUI
{
    _pointView = [[UIView alloc]init];
    _pointView.layer.cornerRadius = 3.5;
    _pointView.backgroundColor = colorWithRGB(999999);
    _pointView.layer.masksToBounds = YES;
    [self.contentView addSubview:_pointView];
    
    _lineView = [[UIView alloc]init];
    _lineView.backgroundColor = colorWithRGB(999999);
    [self.contentView addSubview:_lineView];
    
    _dataLable = [[UILabel alloc]init];
    _dataLable.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_dataLable];
    
    _titleLable = [[UILabel alloc]init];
    _titleLable.numberOfLines = 2;
    _titleLable.font = [UIFont boldSystemFontOfSize:16];
    [self.contentView addSubview:_titleLable];
    
    _contentLable = [[UILabel alloc]init];
    _contentLable.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_contentLable];
    
    _foldingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_foldingBtn setImage:GET_IMAGE(@"express_up") forState:UIControlStateNormal];
    [_foldingBtn addTarget:self action:@selector(foldingAction:) forControlEvents:UIControlEventTouchUpInside];
    _foldingBtn.hidden = YES;
    [self.contentView addSubview:_foldingBtn];
    
    _bgView = [[UIView alloc] init];
    [self.contentView addSubview:_bgView];
    
    // 利好
    _bullBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _bullBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];;
    [_bullBtn setImage:GET_IMAGE(@"express_good_normal") forState:UIControlStateNormal];
    [_bullBtn setImage:GET_IMAGE(@"express_good_selected") forState:UIControlStateSelected];
    [_bullBtn setTitleColor:colorWithRGB(999999) forState:UIControlStateNormal];
    _bullBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_bullBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [_bullBtn addTarget:self action:@selector(bullAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_bullBtn];
    
    // 利空
    _bearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _bearBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];;
    [_bearBtn setImage:GET_IMAGE(@"express_bad_normal") forState:UIControlStateNormal];
    [_bearBtn setImage:GET_IMAGE(@"express_bad_selected") forState:UIControlStateSelected];
    [_bearBtn setTitleColor:colorWithRGB(999999) forState:UIControlStateNormal];
    _bearBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_bearBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [_bearBtn addTarget:self action:@selector(bearAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_bearBtn];
    
    _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_shareBtn setImage:GET_IMAGE(@"share_dig") forState:UIControlStateNormal];
    [_shareBtn setTitle:@"分享挖矿" forState:UIControlStateNormal];
    _shareBtn.titleLabel.font = [UIFont systemFontOfSize:11.0f];;
    [_shareBtn setTitleColor:colorWithRGB(999999) forState:UIControlStateNormal];
    [_shareBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    [_shareBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [_bgView addSubview:_shareBtn];
    
}

//折叠、展开 按钮事件
- (void)foldingAction:(UIButton *)btn
{
    if (self.foldingBlock) {
        self.foldingBlock(self);
    }
}

//利好
- (void)bullAction:(UIButton *)btn
{
    if (btn.selected || self.bullBtn.selected) {
        [SVProgressHUD showInfoWithStatus:@"您已点过"];
    }else{
        if (self.bullBlock) {
            self.bullBlock(self, @"1");
        }
    }
}

//利空
- (void)bearAction:(UIButton *)btn
{
    if (btn.selected || self.bearBtn.selected) {
        [SVProgressHUD showInfoWithStatus:@"您已点过"];
    }else{
        if (self.bealBlock) {
            self.bealBlock(self, @"-1");
        }
    }
}

- (void)shareAction:(UIButton *)btn
{
    //分享的标题
    NSString *textToShare = @"分享的标题。";
    //分享的url
    NSURL *urlToShare = [NSURL URLWithString:@"http://www.baidu.com"];
    //在这里呢 如果想分享图片 就把图片添加进去  文字什么的通上
    NSArray *activityItems = @[textToShare, urlToShare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    //不出现在活动项目
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll];
    [MYGetCurrenViewController() presentViewController:activityVC animated:YES completion:nil];
    // 分享之后的回调
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (completed) {
            NSLog(@"completed");
            //分享 成功
        } else  {
            NSLog(@"cancled");
            //分享 取消
        }
    };
    
}

- (void)setUpLayout
{
    [_pointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(14);
        make.left.equalTo(self.contentView.mas_left).offset(14);
        make.width.height.mas_offset(7);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.width.mas_offset(0.5);
        make.centerX.equalTo(self.pointView);
    }];
    
    //时间
    [_dataLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pointView.mas_right).offset(23);
        make.width.mas_offset(100);
        make.height.mas_offset(15);
        make.centerY.equalTo(self.pointView);
    }];
    
    CGFloat maxLayoutWidth = SCREEN_WIDTH - 14 - 7 - 23 - 20;
    //标题
    [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dataLable);
        make.top.equalTo(self.dataLable.mas_bottom).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
    }];
    _titleLable.preferredMaxLayoutWidth = maxLayoutWidth;
    
    //内容
    [_contentLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLable.mas_bottom).offset(15);
        make.left.equalTo(self.dataLable);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
    }];
    
    //折叠
    [_foldingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentLable.mas_right).offset(-20);
        make.top.equalTo(self.contentLable.mas_bottom).offset(5);
        make.width.height.mas_offset(22);
    }];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.foldingBtn.mas_bottom).offset(15);
        make.left.equalTo(self.dataLable);
        make.right.equalTo(self.contentView.mas_right).offset(20);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-35).priorityHigh();
    }];
    
    [_bullBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView);
        make.centerY.equalTo(self.bgView);
        make.width.mas_offset(75);
        make.height.mas_offset(15);
    }];
    
    [_bearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView);
        make.bottom.equalTo(self.bgView);
        make.left.equalTo(self.bullBtn.mas_right).offset(15);
        make.width.mas_offset(65);
    }];
    
    [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView);
        make.bottom.equalTo(self.bgView);
        make.top.equalTo(self.bgView);
        make.width.mas_offset(75);
    }];
}

- (void)setModel:(ListModel *)model
{
    _model = model;
    
    self.dataLable.text = [self dateWithtimeStamp:model.publishTime];
    self.titleLable.text = model.title;
    self.contentLable.text = model.content;
    
    if (self.titleLable.text.length>0 && self.titleLable.text) {
        self.titleLable.attributedText = [self attributedStringWithContent:self.titleLable.text];
    }
    
    //计算行间距，计算文本高度的时候也要对应设置
    if (self.contentLable.text.length>0 && self.contentLable.text) {
        self.contentLable.attributedText = [self attributedStringWithContent:self.contentLable.text];
    }
    
    CGFloat maxLayoutWidth = SCREEN_WIDTH - 14 - 7 - 23 - 20;
    //获取文本内容宽度，计算全部文本所需高度
    CGFloat contentWidth = maxLayoutWidth;
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    //设置行间距
    [style setLineSpacing:LineSpacing];
    
    CGRect contentRect = [self.contentLable.text boundingRectWithSize:CGSizeMake(contentWidth, MAXFLOAT)
                                                              options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine
                                                           attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0f],NSParagraphStyleAttributeName : style}
                                                              context:nil];
    //判断超过5行，则隐藏多余文字，显示折叠按钮
    if (contentRect.size.height > self.contentLable.font.lineHeight*MaxLineCount + LineSpacing*(MaxLineCount-1)) {
        self.foldingBtn.hidden = NO;
        self.isFolding = model.isFolding;
        //按钮的折叠打开状态
        if (model.isFolding) {
            [_foldingBtn setImage:GET_IMAGE(@"express_up") forState:UIControlStateNormal];
            _contentLable.numberOfLines = 0;
        }else{
            [_foldingBtn setImage:GET_IMAGE(@"express_down") forState:(UIControlStateNormal)];
            _contentLable.numberOfLines = MaxLineCount ;
        }
        
        [_contentLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLable.mas_bottom).offset(10);
            make.left.equalTo(self.titleLable);
            make.right.equalTo(self.contentView.mas_right).offset(-20);
        }];
        _contentLable.preferredMaxLayoutWidth = maxLayoutWidth;
        
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.foldingBtn.mas_bottom).offset(10);
            make.left.equalTo(self.dataLable);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-36).priorityHigh();
            make.right.equalTo(self.contentView.mas_right).offset(-20);
        }];
        
    }else{
        self.foldingBtn.hidden = YES;
        _contentLable.numberOfLines = 0;
        
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentLable.mas_bottom).offset(20);
            make.left.equalTo(self.dataLable);
            make.right.equalTo(self.contentView.mas_right).offset(-20);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-36).priorityHigh();
        }];
    }
    
    [_bullBtn setTitle:[NSString stringWithFormat:@"利好 %ld",(long)model.bullNum]  forState:UIControlStateNormal];
    [_bearBtn setTitle:[NSString stringWithFormat:@"利空 %ld",(long)model.bearNum]  forState:UIControlStateNormal];
    
    if (model.bullOrBear == 1)
    {
        _bullBtn.selected = YES;
        _bearBtn.selected = NO;
        [_bullBtn setTitleColor:colorWithRGB(fa0000) forState:(UIControlStateNormal)];
    }
    else if (model.bullOrBear == -1)
    {
        _bearBtn.selected = YES;
        _bullBtn.selected = NO;
        [_bearBtn setTitleColor:colorWithRGB(239140) forState:UIControlStateSelected];
    }
    else
    {
        _bearBtn.selected = NO;
        _bullBtn.selected = NO;
        [_bullBtn setTitleColor:colorWithRGB(999999) forState:UIControlStateNormal];
        [_bearBtn setTitleColor:colorWithRGB(999999) forState:UIControlStateNormal];
    }
}

- (NSString *)dateWithtimeStamp:(NSString *)timeStamp
{
    NSDate *today = [[NSDate alloc] init];
    NSString *todayString = [[today description] substringToIndex:10];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *timeStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeStamp.doubleValue / 1000.0]];
    NSString *dateString = [timeStr substringToIndex:10];
    //如果不是今天的时间，则显示全部
    if ([dateString isEqualToString:todayString]) {
        [dateFormatter setDateFormat:@"HH:mm"];
    } else {
        [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    }
    
    NSString *newDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeStamp.doubleValue / 1000.0]];
    
    return newDateStr;
}

- (NSAttributedString *)attributedStringWithContent:(NSString *)content {
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",  content]];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:LineSpacing];
    [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
    
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, content.length)];
    return attributedStr;
}

@end
