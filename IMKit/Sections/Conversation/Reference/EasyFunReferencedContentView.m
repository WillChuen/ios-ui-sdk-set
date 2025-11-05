//
//  EasyFunReferencedContentView.m
//  RongCloudOpenSource
//
//  Created by zhongwei on 2025/10/30.
//

#import "EasyFunReferencedContentView.h"
#import "RCKitUtility.h"
#import "EasyFunReferencedTextView.h"
#import "EasyFunReferencedImageView.h"
#import "EasyFunReferencedSightView.h"
#import "EasyFunReferencedLinkView.h"
#import "EasyFunReferencedGameView.h"
#import "RCKitCommonDefine.h"
#import "RCUserInfoCacheManager.h"
#import "RCMessageCellTool.h"
#import "RCKitConfig.h"
#import "RCIM.h"
#import "RCMessageEditUtil.h"
#import <Masonry/Masonry.h>

@interface EasyFunReferencedContentView()

@property (nonatomic, strong) RCMessageModel *referModel;
@property (nonatomic, strong) RCMessageContent *referedContent;
@property (nonatomic, copy) NSString *referedSenderId;
@property (nonatomic, assign) RCReferenceMessageStatus referMsgStatus;

@end

/// 引用内容视图
@implementation EasyFunReferencedContentView
/// 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) { }
    return self;
}

/// 设置UI
- (void)setupUI {
    //
    [self addSubview:self.backgroundContentView];
    [self.backgroundContentView addSubview:self.contentView];
    //
    [self.backgroundContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.leading.mas_greaterThanOrEqualTo(self.mas_leading);
        make.trailing.mas_lessThanOrEqualTo(self.mas_trailing);
    }];
    //
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backgroundContentView.mas_top).offset(4);
        make.bottom.mas_equalTo(self.backgroundContentView.mas_bottom).offset(-4);
        make.leading.mas_equalTo(self.backgroundContentView.mas_leading).offset(12);
        make.trailing.mas_equalTo(self.backgroundContentView.mas_trailing).offset(-12);
    }];
}

/// 设置消息内容
- (void)setMessage:(RCMessageModel *)message contentSize:(CGSize)contentSize {
    // 隐藏全部引用内容
    [self hideAllReferencedViews];
    // 重新设置UI
    [self setupUI];
    // 发送
    if (message.messageDirection == MessageDirection_SEND) {
        [self updateToRightAlignment];
    } else {
        [self updateToLeftAlignment];
    }
    // 引用消息
    self.referModel = message;
    if (![self fetchReferedContentInfo]) {
        return;
    }
    // 设置内容
    [self setContentInfo];
}

/// 切换到左对齐
- (void)updateToLeftAlignment {
    [self.backgroundContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.leading.mas_equalTo(self.mas_leading);
        make.trailing.mas_lessThanOrEqualTo(self.mas_trailing);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
}

/// 切换到右对齐
- (void)updateToRightAlignment {
    [self.backgroundContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.trailing.mas_equalTo(self.mas_trailing);
        make.leading.mas_greaterThanOrEqualTo(self.mas_leading);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
}

- (BOOL)fetchReferedContentInfo {
    // 引用消息类
    if ([self.referModel.content isKindOfClass:[RCReferenceMessage class]]) {
        RCReferenceMessage *content = (RCReferenceMessage *)self.referModel.content;
        self.referedContent = content.referMsg;
        self.referedSenderId = content.referMsgUserId;
        self.referMsgStatus = content.referMsgStatus;
        return YES;
        // 流式消息的类型名
    } else if ([self.referModel.content isKindOfClass:[RCStreamMessage class]]) {
        RCStreamMessage *content = (RCStreamMessage *)self.referModel.content;
        self.referedContent = content.referMsg.content;
        self.referedSenderId = content.referMsg.senderId;
        return YES;
    }
    return NO;
}

/// 在Cell重用的时候调用
- (void)prepareForReuse {
    [self hideAllReferencedViews];
}

/// 隐藏所有引用视图
- (void)hideAllReferencedViews {
    // 移除全部内容
    for (UIView * sub in self.subviews) {
        [sub removeFromSuperview];
    }
    self.backgroundContentView = nil;
    self.contentView = nil;
    self.imageView = nil;
    self.sightView = nil;
    self.linkView = nil;
    self.gameView = nil;
    self.textView = nil;
}

- (NSString *)getUserDisplayName {
    NSString *name = @"";
    if ([self.referedContent.senderUserInfo.userId isEqualToString:self.referedSenderId] && [RCIM sharedRCIM].currentDataSourceType == RCDataSourceTypeInfoManagement) {
        name = [RCKitUtility getDisplayName:self.referedContent.senderUserInfo];
    } else {
        NSString *referUserId = self.referedSenderId;
        if (ConversationType_GROUP == self.referModel.conversationType) {
            RCUserInfo *userInfo =
            [[RCUserInfoCacheManager sharedManager] getUserInfo:referUserId inGroupId:self.referModel.targetId];
            self.referModel.userInfo = userInfo;
            if (userInfo) {
                name = userInfo.name;
            }
        } else {
            RCUserInfo *userInfo = [[RCUserInfoCacheManager sharedManager] getUserInfo:referUserId];
            self.referModel.userInfo = userInfo;
            if (userInfo) {
                name = userInfo.name;
            }
        }
    }
    if([RCKitUtility isRTL]) {
        name = [@":" stringByAppendingString:name ?: @""];
    } else {
        name = [name stringByAppendingString:@":"];
    }
    return name;
}

/// 设置内容
- (void)setContentInfo {
    
    if (self.referMsgStatus == RCReferenceMessageStatusDeleted) { // 引用被删除
        
        NSString * deletedText = RCLocalizedString(@"ReferencedMessageDeleted");
        [self layoutTextView:deletedText isNeedName:NO];
        
    }else if (self.referMsgStatus == RCReferenceMessageStatusRecalled) { // 引用被取消
        
        NSString * recalledText = RCLocalizedString(@"ReferencedMessageRecalled");
        [self layoutTextView:recalledText isNeedName:NO];
        
    } else if ([self.referedContent isKindOfClass:[RCFileMessage class]]) { // 引用文件消息
        
        RCFileMessage *msg = (RCFileMessage *)self.referedContent;
        NSString * messageInfo = [NSString
            stringWithFormat:@"%@ %@", RCLocalizedString(@"RC:FileMsg"), msg.name];
        [self layoutTextView:messageInfo isNeedName:YES];
        
    }  else if ([self.referedContent isKindOfClass:[RCRichContentMessage class]]) { // 图文消息被引用
        
        RCRichContentMessage *msg = (RCRichContentMessage *)self.referedContent;
        [self layoutRichContentView: msg];
        
    } else if ([self.referedContent isKindOfClass:[RCImageMessage class]]) { // 图片消息被引用
        
        RCImageMessage *msg = (RCImageMessage *)self.referedContent;
        [self layoutImageView:msg];
        
    } else if ([self.referedContent isKindOfClass:[RCSightMessage class]]) { // 小视频消息被引用
      
        RCSightMessage *msg = (RCSightMessage *)self.referedContent;
        [self layoutSightView:msg];
        
    } else if ([[[self.referedContent class] getObjectName] isEqualToString:@"LD:LinkCardMsg"]) { // 链接消息被引用
        
        [self layoutLinkView:self.referedContent];
        
    } else if ([[[self.referedContent class] getObjectName] isEqualToString:@"LD:GameCardMsg"]) { // 游戏消息被引用
        
        [self layoutGameView:self.referedContent];
        
    } else if ([self.referedContent isKindOfClass:[RCTextMessage class]] ||
               [self.referedContent isKindOfClass:[RCReferenceMessage class]]) { // 文本消息 或者 引用消息被引用
        
        // 设置 text 之前设置 textColor，textLabel 的 attributeDictionary 设置才有效
        NSString * messageInfo = [RCKitUtility formatMessage:self.referedContent
                                                 targetId:self.referModel.targetId
                                         conversationType:self.referModel.conversationType
                                             isAllMessage:YES];
        [self layoutTextView:messageInfo isNeedName:YES];
    }
}

/// 背景内容
- (UIView *)backgroundContentView {
    if (!_backgroundContentView) {
        _backgroundContentView = [[UIView alloc] initWithFrame:CGRectZero];
        _backgroundContentView.backgroundColor = RCMASKCOLOR(0xEBECED, 1.0);
        _backgroundContentView.layer.cornerRadius = 6;
        _backgroundContentView.layer.masksToBounds = YES;
    }
    return _backgroundContentView;
}

- (void)didTapContentView:(id)sender {
    if ([self.delegate respondsToSelector:@selector(easyFunDidTapReferencedContentView:)]) {
        [self.delegate easyFunDidTapReferencedContentView:self.referModel];
    }
}

/// 堆栈视图
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        UITapGestureRecognizer *messageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapContentView:)];
        messageTap.numberOfTapsRequired = 1;
        messageTap.numberOfTouchesRequired = 1;
        [_contentView addGestureRecognizer:messageTap];
    }
    return _contentView;
}

/// 显示文本引用的视图
- (EasyFunReferencedTextView *)textView {
    if (!_textView) {
        _textView = [[EasyFunReferencedTextView alloc] initWithFrame:CGRectZero];
        _textView.hidden = YES;
        _textView.textLabel.font = [UIFont systemFontOfSize:12];
        _textView.textLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }
    return _textView;
}

/// 布局文本引用视图
- (void)layoutTextView:(NSString *)messageInfo isNeedName:(BOOL)needName {
    self.textView.hidden = NO;
    [self.contentView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.leading.mas_equalTo(self.contentView.mas_leading);
        make.trailing.mas_equalTo(self.contentView.mas_trailing);
    }];
    NSString * nameText = [self getUserDisplayName];
    NSString * completedText = needName ? [NSString stringWithFormat:@"%@ %@", nameText, messageInfo] : messageInfo;
    completedText = [completedText stringByReplacingOccurrencesOfString:@"\r\n" withString:@" "];
    completedText = [completedText stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    completedText = [completedText stringByReplacingOccurrencesOfString:@"\r" withString:@" "];
    [self.textView updateLableText:completedText];
}

/// 显示图片引用的视图
- (EasyFunReferencedImageView *)imageView {
    if (!_imageView) {
        _imageView = [[EasyFunReferencedImageView alloc] initWithFrame:CGRectZero];
        _imageView.hidden = YES;
    }
    return _imageView;
}

/// 布局富文本引用视图
- (void)layoutRichContentView:(RCRichContentMessage *)message {
    self.imageView.hidden = NO;
    [self.contentView addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.leading.mas_equalTo(self.contentView.mas_leading);
        make.trailing.mas_equalTo(self.contentView.mas_trailing);
    }];
    NSString * nameText = [self getUserDisplayName];
    [self.imageView updateNameLabelText:nameText];
    [self.imageView updateRichContentMessage:message];
}

/// 布局图片引用视图
- (void)layoutImageView:(RCImageMessage *)message {
    self.imageView.hidden = NO;
    [self.contentView addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.leading.mas_equalTo(self.contentView.mas_leading);
        make.trailing.mas_equalTo(self.contentView.mas_trailing);
    }];
    NSString * nameText = [self getUserDisplayName];
    [self.imageView updateNameLabelText:nameText];
    [self.imageView updateImageMessage:message];
}

/// 显示小视频引用的视图
- (EasyFunReferencedSightView *)sightView {
    if (!_sightView) {
        _sightView = [[EasyFunReferencedSightView alloc] initWithFrame:CGRectZero];
        _sightView.hidden = YES;
    }
    return _sightView;
}

/// 布局小视频引用视图
- (void)layoutSightView:(RCSightMessage *)message {
    self.sightView.hidden = NO;
    [self.contentView addSubview:self.sightView];
    [self.sightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.leading.mas_equalTo(self.contentView.mas_leading);
        make.trailing.mas_equalTo(self.contentView.mas_trailing);
    }];
    NSString * nameText = [self getUserDisplayName];
    [self.sightView updateNameLabelText:nameText];
    [self.sightView updateSightMessage:message];
}

/// 显示链接引用的视图
- (EasyFunReferencedLinkView *)linkView {
    if (!_linkView) {
        _linkView = [[EasyFunReferencedLinkView alloc] initWithFrame:CGRectZero];
        _linkView.hidden = YES;
    }
    return _linkView;
}

/// 布局链接引用视图
- (void)layoutLinkView:(RCMessageContent *)content {
    self.linkView.hidden = NO;
    [self.contentView addSubview:self.linkView];
    [self.linkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.leading.mas_equalTo(self.contentView.mas_leading);
        make.trailing.mas_equalTo(self.contentView.mas_trailing);
    }];
    NSString * nameText = [self getUserDisplayName];
    [self.linkView updateNameLabelText:nameText];
    [self.linkView updateMessageContent:content];
}

/// 显示游戏引用的视图
- (EasyFunReferencedGameView *)gameView {
    if (!_gameView) {
        _gameView = [[EasyFunReferencedGameView alloc] initWithFrame:CGRectZero];
        _gameView.hidden = YES;
        _gameView.textLabel.font = [UIFont systemFontOfSize:12];
        _gameView.textLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }
    return _gameView;
}

/// 布局游戏引用视图
- (void)layoutGameView:(RCMessageContent *)content {
    self.gameView.hidden = NO;
    [self.contentView addSubview:self.gameView];
    [self.gameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.leading.mas_equalTo(self.contentView.mas_leading);
        make.trailing.mas_equalTo(self.contentView.mas_trailing);
    }];
    NSString * nameText = [self getUserDisplayName];
    [self.gameView updateNameLabelText:nameText];
    [self.gameView updateMessageContent:content];
}

@end
