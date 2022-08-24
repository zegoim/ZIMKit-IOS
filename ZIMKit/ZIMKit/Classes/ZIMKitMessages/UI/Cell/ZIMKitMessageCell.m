//
//  ZIMKitMessageCell.m
//  ZIMKit
//
//  Created by zego on 2022/5/25.
//

#import "ZIMKitMessageCell.h"
#import "NSString+ZIMKitUtil.h"
#import "ZIMKitDefine.h"
#import <SDWebImage/SDWebImage.h>

@interface ZIMKitMessageCell ()

@property (nonatomic, strong) ZIMKitMessage *message;
@end

@implementation ZIMKitMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubViews];
    }
    
    return self;
}

- (void)setupSubViews {
    self.backgroundColor = [UIColor clearColor];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.textColor = [UIColor dynamicColor:ZIMKitHexColor(0xB8B8B8) lightColor:ZIMKitHexColor(0xB8B8B8)];
    [self.contentView addSubview:_timeLabel];
    
    _avatarImageView = [[UIImageView alloc] init];
    _avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
    _avatarImageView.image = [UIImage zegoImageNamed:@"avatar_default"];
    _avatarImageView.layer.cornerRadius = 8.0;
    _avatarImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_avatarImageView];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [UIFont systemFontOfSize:11];
    _nameLabel.textColor = [UIColor dynamicColor:ZIMKitHexColor(0x666666) lightColor:ZIMKitHexColor(0x666666)];
    [self.contentView addSubview:_nameLabel];
    
    _containerView = [[UIView alloc] init];
    _containerView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_containerView];
    
    _indicator = [[UIActivityIndicatorView alloc] init];
    _indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.contentView addSubview:_indicator];
    
    _retryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_retryButton setImage:[UIImage zegoImageNamed:@"message_send_fail"] forState:UIControlStateNormal];
    [self.contentView addSubview:_retryButton];
    
    _selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_selectedButton];
}

- (void)fillWithMessage:(ZIMKitMessage *)message {
    _message = message;
    
    if (message.direction == ZIMMessageDirectionReceive) {
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:message.senderUserAvatar] placeholderImage:[UIImage zegoImageNamed:@"avatar_default"]];
    } else {
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[ZIMKitManager shared].userfullinfo.userAvatarUrl] placeholderImage:[UIImage zegoImageNamed:@"avatar_default"]];
    }
    
    if (message.sentStatus == ZIMMessageSentStatusSending) {
        [self.indicator startAnimating];
    } else {
        [self.indicator stopAnimating];
    }
    
    if (message.needShowTime) {
        _timeLabel.text = [NSString convertDateToStr:message.timestamp];
        _timeLabel.hidden = NO;
    } else {
        _timeLabel.hidden = YES;
    }

    if (message.needShowName) {
        _nameLabel.hidden = NO;
        if (message.senderUsername.length) {
            _nameLabel.text = message.senderUsername;
        } else {
            _nameLabel.text = message.senderUserID;
        }
        
    } else {
        _nameLabel.hidden = YES;
    }
    
    if (message.sentStatus == ZIMMessageSentStatusSending && message.direction == ZIMMessageDirectionSend) {
        _indicator.hidden = NO;
    } else {
        _indicator.hidden = YES;
    }
    
    if (message.sentStatus == ZIMMessageSentStatusSendFailed && message.direction == ZIMMessageDirectionSend) {
        _retryButton.hidden = NO;
    } else {
        _retryButton.hidden = YES;
    }
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.message.needShowTime) {
        _timeLabel.hidden = NO;
        _timeLabel.x = 0;
        _timeLabel.width = Screen_Width - 2*ZIMKitMessageCell_Avatar_Screen_Margin;
        _timeLabel.height = ZIMKitMessageCell_Time_H;
        if (self.message.isLastTop) {
            _timeLabel.y = ZIMKitMessageCell_Top_Time_H;
            _avatarImageView.y =  ZIMKitMessageCell_Top_Time_H + _timeLabel.height + ZIMKitMessageCell_Time_Avatar_Margin;
        } else {
            _timeLabel.y = ZIMKitMessageCell_Bottom_Time_H;
            _avatarImageView.y = ZIMKitMessageCell_Bottom_Time_H + _timeLabel.height + ZIMKitMessageCell_Time_Avatar_Margin;
        }
       
    } else {
        _timeLabel.hidden = YES;
        _timeLabel.height = 0;
        _avatarImageView.y = _timeLabel.height;
    }
    
    _avatarImageView.width = ZIMKitMessageCell_Avatar_WH;
    _avatarImageView.height = ZIMKitMessageCell_Avatar_WH;
    
    if (self.message.needShowName) {
        [_nameLabel sizeToFit];
        _nameLabel.hidden = NO;
        if (_nameLabel.width > ZIMKitMessageCell_Name_MaxW) {
            _nameLabel.width = ZIMKitMessageCell_Name_MaxW;
        }
        
        if (_nameLabel.height < ZIMKitMessageCell_Name_H) {
            _nameLabel.height = ZIMKitMessageCell_Name_H;
        }
        _nameLabel.height += ZIMKitMessageCell_Name_TO_CON_Margin;
        
    } else {
        _nameLabel.hidden = YES;
        _nameLabel.height = 0;
    }
    
    CGSize contentSize = [self.message contentSize];
    if (_message.direction == ZIMMessageDirectionReceive) {
        _avatarImageView.x = ZIMKitMessageCell_Avatar_Screen_Margin;
        
        _nameLabel.y = _avatarImageView.y;
        
        _containerView.x = _avatarImageView.maxX + ZIMKitMessageCell_Avatar_Con_Margin;
        _containerView.y = _nameLabel.y + _nameLabel.height ;
        _containerView.width = contentSize.width + [self.message.cellConfig contentViewInsets].left *2;
        _containerView.height = contentSize.height + [self.message.cellConfig contentViewInsets].top *2;
        _nameLabel.x = _containerView.x;
        
    } else {
        _avatarImageView.right = ZIMKitMessageCell_Avatar_Screen_Margin;
        _nameLabel.y = _avatarImageView.y;
        
        _containerView.y = _nameLabel.y + _nameLabel.height ;
        _containerView.width = contentSize.width + [self.message.cellConfig contentViewInsets].left *2;
        _containerView.height = contentSize.height + [self.message.cellConfig contentViewInsets].top *2;
        _containerView.x = self.contentView.width - ZIMKitMessageCell_Avatar_Screen_Margin - _avatarImageView.width - ZIMKitMessageCell_Avatar_Con_Margin - _containerView.width;
        [_indicator sizeToFit];
        _indicator.centerY = _containerView.centerY;
        _indicator.x = _containerView.x - 8 - _indicator.width;
        
        _retryButton.width = ZIMKitMessageCell_Retry_W;
        _retryButton.height = ZIMKitMessageCell_Retry_W;
        _retryButton.x = _containerView.x - 8 - _retryButton.width;
        _retryButton.centerY = _containerView.centerY;
    }
    
}

- (void)prepareForReuse{
    [super prepareForReuse];
    
}
@end
