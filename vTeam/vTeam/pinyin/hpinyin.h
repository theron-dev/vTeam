//
//  hpinyin.h
//  SinaFramework
//
//  Created by 张海龙 张海龙 on 12-1-4.
//  Copyright (c) 2012年 hailong.org. All rights reserved.
//

#ifndef _HPINYIN_H
#define _HPINYIN_H

#ifdef __cplusplus
extern "C" {
#endif

HANDLER(hpinyin_t)

hpinyin_t pinyin_find(hwchar word,InvokeTickDeclare);
    
hint32 pinyin_count(hpinyin_t pinyin,InvokeTickDeclare);    
    
hcchar * pinyin_get(hpinyin_t pinyin,hint32 index,InvokeTickDeclare);

#ifdef __cplusplus
	
#endif
    
#endif
