//
//  VTDBContext.m
//  vTeam
//
//  Created by zhang hailong on 13-6-4.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTDBContext.h"

#include <sqlite3.h>
#include <objc/runtime.h>

#include "hconfig.h"
#include "hstr.h"
#include "hbuffer.h"

@interface VTDBContext(){
    sqlite3 * _db;
}

@end

@implementation VTDBContext

-(id) initWithPath:(NSString * ) dbPath{
    if((self = [super init])){
        if(SQLITE_OK != sqlite3_open([dbPath UTF8String], & _db)){
            [self release];
            return nil;
        }
    }
    return self;
}

-(void) dealloc{
    if(_db){
        sqlite3_close(_db);
    }
    [super dealloc];
}

static const char * VTDBContextPropertyDBType(objc_property_t prop,char * stype,int length){
    
    InvokeTickBegin
    
    const char * t = property_getAttributes(prop);
    
    if(str_has_prefix(t, "Ti")){
        snprintf(stype, sizeof(stype),"INT");
    }
    else if(str_has_prefix(t, "Tl")){
        snprintf(stype, sizeof(stype),"INT");
    }
    else if(str_has_prefix(t, "Tq")){
        snprintf(stype, sizeof(stype),"BIGINT");
    }
    else if(str_has_prefix(t, "T@NSString")){
        snprintf(stype, sizeof(stype),"TEXT");
    }
    else if(str_has_prefix(t, "T@NSData")){
        snprintf(stype, sizeof(stype),"BLOB");
    }
    else if(str_has_prefix(t, "T@")){
        snprintf(stype, sizeof(stype),"BLOB");
    }
    else{
        snprintf(stype, sizeof(stype),"VARCHAR(45)");
    }
    
    return stype;
}

-(void) regDBObjectClass:(Class) dbObjectClass{
    
    InvokeTickBegin
    
    unsigned int propCount = 0;
    objc_property_t * prop =  class_copyPropertyList(dbObjectClass, &propCount);
    const char * name = class_getName(dbObjectClass);
    
    char ** result = NULL;
    int nRow = 0;
    int nColumn = 0;
    char * errorMsg = NULL;
    
    BOOL isExists = NO;
    
    hbuffer_t sbuf = buffer_alloc(1024, 128);
    char stype[64];
    
    buffer_append_format(sbuf,"SELECT [sql] FROM [sqlite_master] WHERE [type]='table' AND [name]='%s'",InvokeTickArg, name);

    if(SQLITE_OK == sqlite3_get_table(_db, buffer_to_str(sbuf), &result, &nRow, &nColumn, &errorMsg)){
        
        if(nRow >0){
            
            char * sql = result[1];
            
            for(int i=0;i<propCount;i++){
                const char * n = property_getName(prop[i]);
                buffer_clear(sbuf);
                buffer_append_format(sbuf, "[%s]", InvokeTickArg,n);
                if(!str_exist(sql, buffer_to_str(sbuf))){
                    buffer_clear(sbuf);
                    buffer_append_format(sbuf, "ALTER TABLE [%s] ADD COLUMN [%s] %s;",InvokeTickArg,name,n,VTDBContextPropertyDBType(prop[i],stype,sizeof(stype)));
                    
                    if(SQLITE_OK != sqlite3_exec(_db, buffer_to_str(sbuf), NULL, NULL, &errorMsg)){
                        NSLog(@"%s",errorMsg);
                    }
                }
            }
            
            isExists = YES;
        }
        
        sqlite3_free_table(result);
    }
    
    const char * primaryKey = "rawid";
    
    if(!isExists){
        
        buffer_clear(sbuf);
        
        buffer_append_format(sbuf, "CREATE TABLE IF NOT EXISTS [%s] ( ", InvokeTickArg,name);
        
        for(int i=0;i<propCount;i++){
            
            const char * n = property_getName(prop[i]);
            
            if(i != 0){
                buffer_append_str(sbuf, ",");
            }
            
            buffer_append_format(sbuf, "[%s] %s", InvokeTickArg,n,VTDBContextPropertyDBType(prop[i],stype,sizeof(stype)));
            
            if(primaryKey && strcmp(n, primaryKey)){
                buffer_append_str(sbuf, " PRIMARY KEY AUTOINCREMENT");
            }
        }
        
        if(SQLITE_OK != sqlite3_exec(_db, buffer_to_str(sbuf), NULL, NULL, &errorMsg)){
            NSLog(@"%s",errorMsg);
        }
    }
}


-(void) insertObject:(VTDBObject *) dbObject{

}

-(void) deleteObject:(VTDBObject *) dbObject{
    
}

-(void) updateObject:(VTDBObject *) dbObject{
    
}

@end
