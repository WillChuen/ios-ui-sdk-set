//
//  RCReferencingView.m
//  RongIMKit
//
//  Created by 张改红 on 2020/2/27.
//  Copyright © 2020 RongCloud. All rights reserved.
//

#import "RCReferencingView.h"
#import "RCKitUtility.h"
#import "RCKitCommonDefine.h"
#import "RCUserInfoCacheManager.h"
#import "RCKitConfig.h"
#import "RCIM.h"
#import "RCStreamUtilities.h"
#import "RCStreamMessage+Internal.h"

@interface RCReferencingView ()
@property (nonatomic, strong) UIView *inView;
@end

#define textlabel_left_space 12
#define textlabel_and_dismiss_space 8
#define dismiss_right_space 8
#define dismiss_width 18
#define referencingView_height 32
#define referencingView_image_height 40
#define referencingView_x 12
#define referencingImageView_width 40
#define referencingImageView_height 23
#define sightView_width 12
#define sightView_height 12

@implementation RCReferencingView

/// 初始化引用视图
- (instancetype)initWithModel:(RCMessageModel *)model inView:(UIView *)view {
    if (self = [super init]) {
        self.backgroundColor = [RCKitUtility generateDynamicColor:HEXCOLOR(0xffffff) darkColor:HEXCOLOR(0x1c1c1c)];
        self.inView = view;
        self.isReferencingImage = NO;
        self.referModel = model;
        [self addNotification];
        [self setContentInfo];
        [self setupSubviews];
    }
    return self;
}

/// 设置引用视图的Y偏移量
- (void)setOffsetY:(CGFloat)offsetY {
    [UIView animateWithDuration:0.25
                     animations:^{
        CGRect rect = self.frame;
        rect.origin.y = offsetY;
        self.frame = rect;
    }];
}

#pragma mark - Private Methods

/// 设置子视图
- (void)setupSubviews {
    //
    CGFloat referencingViewHeight = referencingView_height;
    self.imageView.hidden = YES;
    if ([self.referModel.content isKindOfClass:[RCRichContentMessage class]]
        || [self.referModel.content isKindOfClass:[RCImageMessage class]]
        || [self.referModel.content isKindOfClass:[RCSightMessage class]]) { // 引用的是图文消息、 图片消息、视频消息
        self.textLabel.hidden = YES;
        self.imageView.hidden = NO;
        self.isReferencingImage = YES;
        referencingViewHeight = referencingView_image_height;
    }
    CGFloat referencingView_w = self.inView.frame.size.width - 2 * referencingView_x;
    self.frame = CGRectMake(referencingView_x, self.inView.frame.size.height, referencingView_w, referencingViewHeight);
    
    [self addSubview:self.dismissButton];
    [self addSubview:self.nameLabel];
    [self addSubview:self.textLabel];
    [self addSubview:self.imageView];
    
    self.dismissButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    CGFloat nameLabelMaxWidth = 100;
    
    if ([RCKitUtility isRTL]) {
        [NSLayoutConstraint activateConstraints:@[
            [self.dismissButton.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:dismiss_right_space],
            [self.dismissButton.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
            [self.dismissButton.widthAnchor constraintEqualToConstant:dismiss_width],
            [self.dismissButton.heightAnchor constraintEqualToConstant:dismiss_width],
            
            [self.textLabel.leadingAnchor constraintEqualToAnchor:self.dismissButton.trailingAnchor constant:textlabel_and_dismiss_space],
            [self.textLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
            
            [self.nameLabel.leadingAnchor constraintEqualToAnchor:self.textLabel.trailingAnchor constant:4],
            [self.nameLabel.trailingAnchor constraintLessThanOrEqualToAnchor:self.trailingAnchor constant:-textlabel_left_space],
            [self.nameLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
            [self.nameLabel.widthAnchor constraintLessThanOrEqualToConstant:nameLabelMaxWidth],
            
            [self.imageView.leadingAnchor constraintEqualToAnchor:self.nameLabel.trailingAnchor constant:4],
            [self.imageView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
            [self.imageView.widthAnchor constraintEqualToConstant:referencingImageView_width],
            [self.imageView.heightAnchor constraintEqualToConstant:referencingImageView_height]
        ]];
        
        [self.textLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
        [self.nameLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        
    } else {
        [NSLayoutConstraint activateConstraints:@[
            [self.dismissButton.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-dismiss_right_space],
            [self.dismissButton.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
            [self.dismissButton.widthAnchor constraintEqualToConstant:dismiss_width],
            [self.dismissButton.heightAnchor constraintEqualToConstant:dismiss_width],
            
            [self.nameLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:textlabel_left_space],
            [self.nameLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
            [self.nameLabel.widthAnchor constraintLessThanOrEqualToConstant:nameLabelMaxWidth],
            
            [self.textLabel.leadingAnchor constraintEqualToAnchor:self.nameLabel.trailingAnchor constant:4],
            [self.textLabel.trailingAnchor constraintLessThanOrEqualToAnchor:self.dismissButton.leadingAnchor constant:-textlabel_and_dismiss_space],
            [self.textLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
            
            [self.imageView.leadingAnchor constraintEqualToAnchor:self.nameLabel.trailingAnchor constant:4],
            [self.imageView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
            [self.imageView.widthAnchor constraintEqualToConstant:referencingImageView_width],
            [self.imageView.heightAnchor constraintEqualToConstant:referencingImageView_height]
        ]];
        
        [self.textLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
        [self.nameLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
}

/// 设置引用内容
- (void)setContentInfo {
    //
    NSString *messageInfo;
    
    if ([self.referModel.content isKindOfClass:[RCFileMessage class]]) { // 引用的是文件消息
        RCFileMessage *msg = (RCFileMessage *)self.referModel.content;
        messageInfo = [NSString
                       stringWithFormat:@"%@ %@", RCLocalizedString(@"RC:FileMsg"), msg.name];
    } else if ([self.referModel.content isKindOfClass:[RCRichContentMessage class]]) { // 引用的是图文消息
        NSURL *imageURL = [NSURL URLWithString:((RCRichContentMessage *)self.referModel.content).imageURL];
        [self.imageView setImageURL:imageURL];
    } else if ([self.referModel.content isKindOfClass:[RCImageMessage class]]) { // 引用的是图片消息
        self.imageView.image = ((RCImageMessage *)self.referModel.content).thumbnailImage;
    } else if ([self.referModel.content isKindOfClass:[RCSightMessage class]]) { // 引用的是视频消息
        self.imageView.image = ((RCSightMessage *)self.referModel.content).thumbnailImage;
        self.sightView.hidden = NO;
    } else if ([self.referModel.content isKindOfClass:[RCTextMessage class]] ||
               [self.referModel.content isKindOfClass:[RCReferenceMessage class]]) { // 引用的是文本消息或者引用消息
        messageInfo = [RCKitUtility formatMessage:self.referModel.content
                                         targetId:self.referModel.targetId
                                 conversationType:self.referModel.conversationType
                                     isAllMessage:YES];
    } else if ([self.referModel.content isKindOfClass:[RCStreamMessage class]]) { // 引用的是流式消息
        RCStreamMessage *msg = (RCStreamMessage *)self.referModel.content;
        if (msg.isSync) {
            messageInfo = msg.content;
        } else {
            RCStreamSummaryModel *summary = [RCStreamUtilities parserStreamSummary:self.referModel];
            if (summary.isComplete) {
                messageInfo = summary.summary;
                msg.content = summary.summary;
            }
        }
    }  else if ([self.referModel.content isKindOfClass:[RCMessageContent class]]) { // 引用其他类型消息
        messageInfo = [RCKitUtility formatMessage:self.referModel.content
                                         targetId:self.referModel.targetId
                                 conversationType:self.referModel.conversationType
                                     isAllMessage:YES];
        if (messageInfo <= 0 ||
            [messageInfo isEqualToString:[[self.referModel.content class] getObjectName]]) {
            messageInfo = RCLocalizedString(@"unknown_message_cell_tip");
        }
    }
    // 设置用户昵称
    if([RCKitUtility isRTL]){
        self.nameLabel.text = [NSString stringWithFormat:@":%@",[self getUserDisplayName]];
    }else{
        self.nameLabel.text = [NSString stringWithFormat:@"%@：",[self getUserDisplayName]];
    }
    // 替换换行符为空格
    messageInfo = [messageInfo stringByReplacingOccurrencesOfString:@"\r\n" withString:@" "];
    messageInfo = [messageInfo stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    messageInfo = [messageInfo stringByReplacingOccurrencesOfString:@"\r" withString:@" "];
    self.textLabel.text = [NSString stringWithFormat:@"%@",messageInfo];
}

/// 点击关闭按钮
- (void)didClickDismissButton:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(dismissReferencingView:)]) {
        [self.delegate dismissReferencingView:self];
    }
}

/// 获取用户显示名称
- (NSString *)getUserDisplayName {
    // 优先使用消息内的用户信息
    if ([self.referModel.content.senderUserInfo.userId isEqualToString:self.referModel.senderUserId] && [RCIM sharedRCIM].currentDataSourceType == RCDataSourceTypeInfoManagement) {
        return [RCKitUtility getDisplayName:self.referModel.content.senderUserInfo];
    }
    NSString *name;
    if (ConversationType_GROUP == self.referModel.conversationType) {
        RCUserInfo *userInfo = [[RCUserInfoCacheManager sharedManager] getUserInfo:self.referModel.senderUserId
                                                                         inGroupId:self.referModel.targetId];
        self.referModel.userInfo = userInfo;
        if (userInfo) {
            name = userInfo.name;
        }
    } else {
        RCUserInfo *userInfo = [[RCUserInfoCacheManager sharedManager] getUserInfo:self.referModel.senderUserId];
        self.referModel.userInfo = userInfo;
        if (userInfo) {
            name = userInfo.name;
        }
    }
    return name;
}

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onUserInfoUpdate:)
                                                 name:RCKitDispatchUserInfoUpdateNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onGroupUserInfoUpdate:)
                                                 name:RCKitDispatchGroupUserInfoUpdateNotification
                                               object:nil];
}

- (void)didTapContentView:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didTapReferencingView:)]) {
        [self.delegate didTapReferencingView:self.referModel];
    }
}

#pragma mark - UserInfo Update
- (void)onUserInfoUpdate:(NSNotification *)notification {
    NSDictionary *userInfoDic = notification.object;
    if ([self.referModel.senderUserId isEqualToString:userInfoDic[@"userId"]]) {
        // 重新取一下混合的用户信息
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setContentInfo];
        });
    }
}

- (void)onGroupUserInfoUpdate:(NSNotification *)notification {
    if (self.referModel.conversationType == ConversationType_GROUP) {
        NSDictionary *groupUserInfoDic = (NSDictionary *)notification.object;
        if ([self.referModel.targetId isEqualToString:groupUserInfoDic[@"inGroupId"]] &&
            [self.referModel.senderUserId isEqualToString:groupUserInfoDic[@"userId"]]) {
            // 重新取一下混合的用户信息
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setContentInfo];
            });
        }
    }
}

#pragma mark - Getters and Setters
- (RCBaseButton *)dismissButton {
    if (!_dismissButton) {
        _dismissButton = [RCBaseButton buttonWithType:UIButtonTypeCustom];
        [_dismissButton setImage:RCResourceImage(@"referencing_view_dismiss_icon") forState:UIControlStateNormal];
        [_dismissButton addTarget:self
                           action:@selector(didClickDismissButton:)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    return _dismissButton;
}

- (RCBaseLabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[RCBaseLabel alloc] init];
        _nameLabel.textColor = [RCKitUtility generateDynamicColor:HEXCOLOR(0x111f2c) darkColor:RCMASKCOLOR(0xffffff, 0.4)];
        _nameLabel.font = [[RCKitConfig defaultConfig].font fontOfGuideLevel];
    }
    return _nameLabel;
}

- (RCBaseLabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[RCBaseLabel alloc] init];
        _textLabel.numberOfLines = 1;
        [_textLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        _textLabel.font = [[RCKitConfig defaultConfig].font fontOfGuideLevel];
        _textLabel.textColor = [RCKitUtility generateDynamicColor:HEXCOLOR(0x111f2c) darkColor:RCMASKCOLOR(0xffffff, 0.4)];
        UITapGestureRecognizer *messageTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapContentView:)];
        messageTap.numberOfTapsRequired = 1;
        messageTap.numberOfTouchesRequired = 1;
        [_textLabel addGestureRecognizer:messageTap];
    }
    return _textLabel;
}

- (RCloudImageView *)imageView {
    if (!_imageView) {
        _imageView = [[RCloudImageView alloc] init];
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.layer.cornerRadius = 2;
        _imageView.layer.masksToBounds = YES;
        [_imageView addSubview:self.sightView];
        
        self.sightView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
            [self.sightView.centerYAnchor constraintEqualToAnchor:_imageView.centerYAnchor],
            [self.sightView.centerXAnchor constraintEqualToAnchor:_imageView.centerXAnchor],
            [self.sightView.widthAnchor constraintEqualToConstant:sightView_width],
            [self.sightView.heightAnchor constraintEqualToConstant:sightView_height]
        ]];
    }
    return _imageView;
}

- (UIImageView *)sightView {
    if (!_sightView) {
        _sightView = [[UIImageView alloc] initWithImage:RCResourceImage(@"chat_sight_message_play_icon")];
        _sightView.contentMode = UIViewContentModeScaleAspectFit;
        _sightView.hidden = YES;
    }
    return _sightView;
}

@end
