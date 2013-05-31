//
//  IVTFormEditor.h
//  vTeam
//
//  Created by Zhang Hailong on 13-5-11.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <vTeam/VTFormItem.h>

@protocol IVTFormEditor <NSObject>

@property(nonatomic,retain) NSString * editorType;
@property(nonatomic,retain) VTFormItem * formItem;

@end
