//
//  VTStatusView.m
//  vTeam
//
//  Created by Zhang Hailong on 13-6-22.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTStatusView.h"

@implementation VTStatusViewItem

@synthesize status = _status;
@synthesize views = _views;

-(void) dealloc{
    [_status release];
    [_views release];
    [super dealloc];
}

@end

@implementation VTStatusView

@synthesize statusItems = _statusItems;
@synthesize status = _status;

- (void) dealloc{
    [_status release];
    [_statusItems release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void) changedStatus {
    for(VTStatusViewItem * item in _statusItems){
        if([_status isEqualToString:[item status]]){
            for(UIView * v in [item views]){
                [v setHidden:NO];
                if([v isKindOfClass:[UIActivityIndicatorView class]]){
                    [(UIActivityIndicatorView *)v startAnimating];
                }
            }
        }
        else{
            for(UIView * v in [item views]){
                if([v isKindOfClass:[UIActivityIndicatorView class]]){
                    [(UIActivityIndicatorView *)v stopAnimating];
                }
                [v setHidden:YES];
            }
        }
    }
}

-(void) awakeFromNib{
    [super awakeFromNib];
    
    [self changedStatus];
}

-(void) setStatus:(NSString *)status{
    if(_status != status){
        
        [status retain];
        [_status release];
        _status = status;
        
        [self changedStatus];
    }
}

-(void) setStatusItems:(NSArray *)statusItems{
    if(_statusItems != statusItems){
        [statusItems retain];
        [_statusItems release];
        _statusItems = statusItems;
        
        [self changedStatus];
    }
}
@end
