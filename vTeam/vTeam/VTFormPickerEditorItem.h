//
//  VTFormPickerEditorItem.h
//  vTeam
//
//  Created by Zhang Hailong on 13-5-11.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VTFormPickerEditorItem : NSObject

@property(nonatomic,retain) id value;
@property(nonatomic,retain) NSString * text;
@property(nonatomic,retain) IBOutletCollection(VTFormPickerEditorItem) NSArray * items;

@end
