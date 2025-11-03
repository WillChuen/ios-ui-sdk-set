//
//  RCReferenceMessageCell.m
//  RongIMKit
//
//  Created by 张改红 on 2020/2/27.
//  Copyright © 2020 RongCloud. All rights reserved.
//

#import "RCReferenceMessageCell.h"
#import "RCKitCommonDefine.h"
#import "RCKitUtility.h"
#import "RCMessageCellTool.h"
#import "RCKitConfig.h"
#import "RCAttributedLabel+Edit.h"
#import "RCMessageCell+Edit.h"

#define bubble_top_space 12
#define bubble_bottom_space 12
#define refer_and_text_space 6
#define content_space_left 12
#define content_space_right 12

@interface RCReferenceMessageCell () <RCAttributedLabelDelegate, EasyFunReferencedContentViewDelegate>
@end
@implementation RCReferenceMessageCell

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

#pragma mark - Super Methods
+ (CGSize)sizeForMessageModel:(RCMessageModel *)model
      withCollectionViewWidth:(CGFloat)collectionViewWidth
         referenceExtraHeight:(CGFloat)extraHeight {
    // 最大宽度
    float maxWidth = [RCMessageCellTool getMessageContentViewMaxWidth];
    // 引用内容[文本内容]
    RCReferenceMessage *refenceMessage = (RCReferenceMessage *)model.content;
    // 获取的是文本显示内容
    NSString *displayText = [RCMessageEditUtil displayTextForOriginalText:refenceMessage.content isEdited:model.hasChanged];
    // 计算文本大小
    CGSize textLabelSize = [[self class] getTextLabelSize:displayText
                                                 maxWidth:maxWidth - content_space_left - content_space_right
                                                     font:[[RCKitConfig defaultConfig].font fontOfSecondLevel]];
    // 计算引用内容尺寸
    CGSize contentSize = [[self class] contentInfoSizeWithContent:model maxWidth:maxWidth];
    // 计算消息内容尺寸
    
    CGFloat messageContentSizeWidth = MAX(textLabelSize.width, contentSize.width);
    
    CGSize messageContentSize =
    CGSizeMake(messageContentSizeWidth, bubble_top_space + textLabelSize.height + bubble_bottom_space + refer_and_text_space + contentSize.height);
    // 计算最终高度
    CGFloat __messagecontentview_height = messageContentSize.height;
    // 附加高度
    __messagecontentview_height += extraHeight;
    // 编辑状态栏高度
    __messagecontentview_height += [self edit_editStatusBarHeightWithModel:model];
    // 返回最终大小
    return CGSizeMake(collectionViewWidth, __messagecontentview_height);
}

- (void)setDataModel:(RCMessageModel *)model {
    [super setDataModel:model];
    [self setAutoLayout];
}

#pragma mark - RCReferencedContentViewDelegate

- (void)easyFunDidTapReferencedContentView:(RCMessageModel *)message {
    // 点击了引用内容
    if ([self.delegate respondsToSelector:@selector(didTapReferencedContentView:)]) {
        [self.delegate didTapReferencedContentView:message];
    }
}

#pragma mark - RCAttributedLabelDelegate & RCReferencedContentViewDelegate

- (void)attributedLabel:(RCAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    NSString *urlString = [url absoluteString];
    urlString = [RCKitUtility checkOrAppendHttpForUrl:urlString];
    if ([self.delegate respondsToSelector:@selector(didTapUrlInMessageCell:model:)]) {
        [self.delegate didTapUrlInMessageCell:urlString model:self.model];
        return;
    }
}

- (void)attributedLabel:(RCAttributedLabel *)label didSelectLinkWithPhoneNumber:(NSString *)phoneNumber {
    NSString *number = [@"tel://" stringByAppendingString:phoneNumber];
    if ([self.delegate respondsToSelector:@selector(didTapPhoneNumberInMessageCell:model:)]) {
        [self.delegate didTapPhoneNumberInMessageCell:number model:self.model];
        return;
    }
}

- (void)attributedLabel:(RCAttributedLabel *)label didTapLabel:(NSString *)content {
    if ([self.delegate respondsToSelector:@selector(didTapMessageCell:)]) {
        [self.delegate didTapMessageCell:self.model];
    }
}

#pragma mark - Private Methods
- (void)initialize {
    [self showBubbleBackgroundView:YES];
    [self.messageContentView addSubview:self.referencedContentView];
    [self.bubbleBackgroundView addSubview:self.contentLabel];
}

- (void)setAutoLayout {
    // 文本颜色
    if(self.model.messageDirection == MessageDirection_RECEIVE){
        [self.contentLabel setTextColor:[RCKitUtility generateDynamicColor:HEXCOLOR(0x262626) darkColor:RCMASKCOLOR(0xffffff, 0.8)]];
    }else{
        [self.contentLabel setTextColor:RCDYCOLOR(0x262626, 0x040A0F)];
    }
    // 回复消息[文本的内容]
    RCReferenceMessage *refenceMessage = (RCReferenceMessage *)self.model.content;
    if (refenceMessage) {
        [self.contentLabel edit_setTextWithEditedState:refenceMessage.content isEdited:self.model.hasChanged];
    }
    // 计算文本大小
    float maxWidth = [RCMessageCellTool getMessageContentViewMaxWidth];
    CGSize textLabelSize = [[self class] getTextLabelSize:self.contentLabel.text
                                                 maxWidth:maxWidth - content_space_left - content_space_right
                                                     font:[[RCKitConfig defaultConfig].font fontOfSecondLevel]];
    self.contentLabel.frame = CGRectMake(content_space_left, bubble_top_space,
                                         textLabelSize.width, textLabelSize.height);
    // 引用内容尺寸
    CGSize contentSize = [[self class] contentInfoSizeWithContent:self.model maxWidth:maxWidth];
    // 设置引用内容
    [self.referencedContentView setMessage:self.model contentSize:contentSize];
    // 引用内容位置
    self.referencedContentView.frame = CGRectMake(0, CGRectGetMaxY(self.contentLabel.frame) + bubble_bottom_space + refer_and_text_space, contentSize.width, contentSize.height);
    
    CGFloat messageContentSizeWidth = MAX(textLabelSize.width, contentSize.width);
    // 消息内容尺寸
    CGSize messageContentSize =
    CGSizeMake(messageContentSizeWidth, textLabelSize.height + contentSize.height + bubble_top_space +
               bubble_bottom_space + refer_and_text_space);
    //
    self.messageContentView.contentSize = CGSizeMake(messageContentSize.width, messageContentSize.height);
}

///
- (void)updateBubbleBackgroundViewFrame {
    // 这里的气泡只包含文本内容
    CGSize textLabelSize = self.contentLabel.frame.size;
    CGFloat bubbleBackgroundFrameX = 0;
    CGFloat bubbleBackgroundFrameY = 0;
    CGFloat bubbleBackgroundFrameW = content_space_left + textLabelSize.width + content_space_right;
    CGFloat bubbleBackgroundFrameH = bubble_top_space + textLabelSize.height + bubble_bottom_space;
    if (self.model.messageDirection == MessageDirection_SEND) {
        bubbleBackgroundFrameX = self.messageContentView.frame.size.width - bubbleBackgroundFrameW;
    }
    CGRect bubbleBackgroundFrame = CGRectMake(bubbleBackgroundFrameX, bubbleBackgroundFrameY, bubbleBackgroundFrameW, bubbleBackgroundFrameH);
    self.bubbleBackgroundView.frame = bubbleBackgroundFrame;
}

- (NSDictionary *)attributeDictionary {
    return [RCMessageCellTool getTextLinkOrPhoneNumberAttributeDictionary:self.model.messageDirection];
}

+ (CGSize)contentInfoSizeWithContent:(RCMessageModel *)model maxWidth:(CGFloat)maxWidth {
//    RCReferenceMessage *refenceMessage = (RCReferenceMessage *)model.content;
//    RCMessageContent *content = refenceMessage.referMsg;
//    CGFloat height = 17;//名字显示高度
//    BOOL isDeletedOrRecalled = (refenceMessage.referMsgStatus == RCReferenceMessageStatusRecalled
//                                || refenceMessage.referMsgStatus == RCReferenceMessageStatusDeleted);
//    if ([content isKindOfClass:[RCImageMessage class]] && !isDeletedOrRecalled) {
//        RCImageMessage *msg = (RCImageMessage *)content;
//        height = [RCMessageCellTool getThumbnailImageSize:msg.thumbnailImage].height + height + name_and_image_view_space;
//    } else {
//        height = 34;//两行文本高度
//    }
    return CGSizeMake(maxWidth, 32);
}

+ (CGSize)getTextLabelSize:(NSString *)message maxWidth:(CGFloat)maxWidth font:(UIFont *)font {
    if ([message length] > 0) {
        CGSize textSize = [RCKitUtility getTextDrawingSize:message font:font constrainedSize:CGSizeMake(maxWidth, MAXFLOAT)];
        textSize.height = ceilf(textSize.height);
        textSize.width = ceilf(textSize.width);
        return CGSizeMake(textSize.width, textSize.height);
    } else {
        return CGSizeZero;
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.referencedContentView prepareForReuse];
}

#pragma mark - Getter
- (RCAttributedLabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[RCAttributedLabel alloc] initWithFrame:CGRectZero];
        _contentLabel.attributeDictionary = [self attributeDictionary];
        _contentLabel.highlightedAttributeDictionary = [self attributeDictionary];
        [_contentLabel setFont:[[RCKitConfig defaultConfig].font fontOfSecondLevel]];
        _contentLabel.numberOfLines = 0;
        [_contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
        _contentLabel.delegate = self;
        _contentLabel.userInteractionEnabled = YES;
    }
    return _contentLabel;
}

- (EasyFunReferencedContentView *)referencedContentView{
    if (!_referencedContentView) {
        _referencedContentView = [[EasyFunReferencedContentView alloc] init];
        _referencedContentView.delegate = self;
    }
    return _referencedContentView;
}

@end
