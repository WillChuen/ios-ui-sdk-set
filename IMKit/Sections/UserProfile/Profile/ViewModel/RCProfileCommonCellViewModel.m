//
//  RCUserProfileTextCellViewModel.m
//  RongUserProfile
//
//  Created by zgh on 2024/8/16.
//

#import "RCProfileCommonCellViewModel.h"
#import "RCProfileCommonTextCell.h"
#import "RCProfileCommonImageCell.h"
#import "RCNameEditViewController.h"

#define RCUProfileCommonCellHeight 44

@implementation RCProfileCommonCellViewModel

- (instancetype)initWithCellType:(RCUProfileCellType)type title:(NSString *)title detail:(NSString *)detail {
    self = [super init];
    if (self) {
        self.title = title;
        self.detail = detail;
        self.type = type;
        self.conversationType = ConversationType_PRIVATE;
    }
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == RCUProfileCellTypeText) {
        RCProfileCommonTextCell *cell = [tableView dequeueReusableCellWithIdentifier:RCUProfileTextCellIdentifier forIndexPath:indexPath];
        cell.titleLabel.text = self.title;
        cell.detailLabel.text = self.detail;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.arrowView.hidden = self.hiddenArrow;
        if(self.hiddenSeparatorLine) {
            cell.separatorInset = UIEdgeInsetsMake(0, CGRectGetWidth(tableView.bounds), 0, 0);
        } else {
            cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
        }
        return cell;
    }
    
    if (self.type == RCUProfileCellTypeImage) {
        RCProfileCommonImageCell *cell = [tableView dequeueReusableCellWithIdentifier:RCUProfileImageCellIdentifier forIndexPath:indexPath];
        cell.titleLabel.text = self.title;
        if (self.conversationType == ConversationType_GROUP) {
            [cell.portraitImageView setPlaceholderImage:RCResourceImage(@"default_group_portrait")];
        } else {
            [cell.portraitImageView setPlaceholderImage:RCResourceImage(@"default_portrait_msg")];
        }
        [cell.portraitImageView setImageURL:[NSURL URLWithString:self.detail]];
        [cell hiddenArrow:self.hiddenArrow];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return RCUProfileCommonCellHeight;
}

@end
