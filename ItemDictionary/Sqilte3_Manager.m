//
//  Sqilte3_Manager.m
//  ItemDictionary
//
//  Created by 3014 on 16/7/21.
//  Copyright © 2016年 3014. All rights reserved.
//

#import "Sqilte3_Manager.h"

@implementation Sqilte3_Manager

- (NSArray *)sqilte3{
  
    FMDatabase *dataBase;
    NSString *string = [[NSBundle mainBundle] pathForResource:@"aaaaa2" ofType:@"sqlite"];
    NSMutableArray *array = [NSMutableArray array];
    dataBase = [FMDatabase databaseWithPath:string];
    [dataBase open];
    
    FMResultSet *result = [dataBase executeQuery:@"select * from ol_pinyins"];
    while ([result next]) {
        NSString *str =[result stringForColumn:@"pinyin"];
        
        [array addObject:str];
    }
    return array;
}
@end
