//
//  bluetooth.m
//  BitCoin
//
//  Created by LBH on 2018/8/11.
//  Copyright © 2018年 LBH. All rights reserved.
//

#import "bluetooth.h"

@interface bluetooth (){
    //系统蓝牙设备管理对象，可以把他理解为主设备，通过他，可以去扫描和链接外设
    CBCentralManager *_manager;
    UILabel *info;
    //用于保存被发现设备
    NSMutableArray *discoverPeripherals;
    CBCharacteristic *_characteristic_write;
    CBPeripheral *_peripheral_write;
    NSMutableArray *_macArray;
    NSString *_macString;
    BOOL _isSend;
    NSMutableArray *_countArray;
    NSString *_SN;
    BOOL _isCanSend;
    NSTimer *_timer;
}
@end

@implementation bluetooth

- (instancetype)initWithMac:(NSString *)string
{
    if (self) {
        _isSend = NO;
        _isCanSend = NO;
        _countArray = [NSMutableArray array];
        _SN = @"";
        [self resetBluetooth:string];
        
        [self addObserver:self forKeyPath:@"_macArray" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];

    }
    return self;
}

- (void) resetBluetooth : (NSString *)string
{
    _macString = string;
    _macArray = [NSMutableArray array];
    //初始化并设置委托和线程队列，最好一个线程的参数可以为nil，默认会就main线程
    _manager = [[CBCentralManager alloc]initWithDelegate:self queue:dispatch_get_main_queue()];
    //持有发现的设备,如果不持有设备会导致CBPeripheralDelegate方法不能正确回调
    discoverPeripherals = [[NSMutableArray alloc] init];
}

-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
    
    switch (central.state) {
        case CBCentralManagerStateUnknown:
            NSLog(@">>>CBCentralManagerStateUnknown");
            break;
        case CBCentralManagerStateResetting:
            NSLog(@">>>CBCentralManagerStateResetting");
            break;
        case CBCentralManagerStateUnsupported:
            NSLog(@">>>CBCentralManagerStateUnsupported");
            break;
        case CBCentralManagerStateUnauthorized:
            NSLog(@">>>CBCentralManagerStateUnauthorized");
            break;
        case CBCentralManagerStatePoweredOff:
            NSLog(@">>>CBCentralManagerStatePoweredOff");
            break;
        case CBCentralManagerStatePoweredOn:
            NSLog(@">>>CBCentralManagerStatePoweredOn");
            [central scanForPeripheralsWithServices:nil options:nil];
            break;
        default:
            break;
    }
    
}

//扫描到设备会进入方法
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    NSLog(@"当扫描到设备:%@",peripheral.name);
    if ([peripheral.name isEqual:@"I10"]) {
        [discoverPeripherals addObject:peripheral];
        [central connectPeripheral:peripheral options:nil];
    }
}


//连接到Peripherals-失败
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@">>>连接到名称为（%@）的设备-失败,原因:%@",[peripheral name],[error localizedDescription]);
}

//Peripherals断开连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@">>>外设连接断开连接 %@: %@\n", [peripheral name], [error localizedDescription]);
    if (peripheral == _peripheral_write) {
        [self.delegate linkOut];
    }
}
//连接到Peripherals-成功
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@">>>连接到名称为（%@）的设备-成功",peripheral.name);
    [peripheral setDelegate:self];
    [peripheral discoverServices:nil];
}

//扫描到Services
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    if (error) {
        NSLog(@">>>Discovered services for %@ with error: %@", peripheral.name, [error localizedDescription]);
        return;
    }
    for (CBService *service in peripheral.services) {
        NSLog(@"%@",service.UUID);
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

//扫描到Characteristics
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    if (error) {
        NSLog(@"error Discovered characteristics for %@ with error: %@", service.UUID, [error localizedDescription]);
        return;
    }
    for (CBCharacteristic *characteristic in service.characteristics) {
        NSLog(@"service:%@ 的 Characteristic: %@",service.UUID,characteristic.UUID);
        if ([service.UUID.UUIDString isEqualToString:@"FFF0"]) {
            [peripheral readValueForCharacteristic:characteristic];
            
            if ([characteristic.UUID.UUIDString isEqualToString:@"FFF2"]) {
                [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            }
        }
    }
    for (CBCharacteristic *characteristic in service.characteristics) {
        NSLog(@"service:%@ 的 Characteristic: %@",service.UUID,characteristic.UUID);
        if ([service.UUID.UUIDString isEqualToString:@"FFF0"]) {
            [peripheral readValueForCharacteristic:characteristic];
            if ([characteristic.UUID.UUIDString isEqualToString:@"FFF1"]) {
                NSData *c = [self convertHexStrToData:@"08"];
                [self writeCharacteristic:peripheral characteristic:characteristic value:c];
                _characteristic_write = characteristic;
                _peripheral_write = peripheral;
            }
            
        }
    }
    for (CBCharacteristic *characteristic in service.characteristics){
        [peripheral discoverDescriptorsForCharacteristic:characteristic];
    }
}

//获取的charateristic的值
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    NSString *result = [self hexadecimalString:characteristic.value];
    //接到数据
    NSLog(@"characteristic uuid:%@  value:%@ %@---%@",characteristic.UUID,characteristic.value, result, [self stringFromHexString:result]);
    if ([result hasPrefix:@"88"]) {
        NSLog(@"=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-");
        NSString *mac = [self changeMac:[result substringWithRange:NSMakeRange(2,12)]];
        NSEnumerator *enumerator = [[mac componentsSeparatedByString:@":"] reverseObjectEnumerator];
        mac = [[[enumerator allObjects] componentsJoinedByString:@""] uppercaseString];
        if (![_macArray containsObject: mac]) {
            [[self mutableArrayValueForKey:@"_macArray"] addObject:mac];
        }
        if ([mac isEqualToString:_macString]) {
            [self.delegate linkSuccess];
            for (CBPeripheral *p in discoverPeripherals) {
                if (p!=peripheral) {
                    [self disconnectPeripheral:_manager peripheral:p];
                }
            }
            NSDate *date =[NSDate date];
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
            NSString *dateStr = [formatter stringFromDate:date];
            NSArray *array = [dateStr componentsSeparatedByString:@" "];
            NSMutableArray *dateArray = [NSMutableArray array];
            NSArray *arr = [[array objectAtIndex:0] componentsSeparatedByString:@"-"];
            NSArray *a = [[array objectAtIndex:1] componentsSeparatedByString:@":"];
            for (int i = 0; i < arr.count; i++) {
                if (i == 0) {
                    NSString *s = [[arr objectAtIndex:i] substringWithRange:NSMakeRange(0,2)];
                    [dateArray addObject:[self getHexByDecimal:[s integerValue]]];
                    s = [[arr objectAtIndex:i] substringWithRange:NSMakeRange(2,2)];
                    [dateArray addObject:[self getHexByDecimal:[s integerValue]]];
                } else {
                    [dateArray addObject:[self getHexByDecimal:[[arr objectAtIndex:i] integerValue]]];
                }
            }
            for (int i = 0; i < a.count; i++) {
                [dateArray addObject:[self getHexByDecimal:[[a objectAtIndex:i] integerValue]]];
            }
            for (int i = 0; i < dateArray.count; i++) {
                NSString *str = [dateArray objectAtIndex:i];
                if (str.length < 2) {
                    NSString *s = [NSString stringWithFormat:@"0%@",str];
                    [dateArray replaceObjectAtIndex:i withObject:s];
                }
            }
//            @"011412080B0A2C200018"
            NSString *nowDate = [NSString stringWithFormat:@"01%@0018", [dateArray componentsJoinedByString:@""]];
            NSData *c = [self convertHexStrToData:nowDate];
            [self writeCharacteristic:peripheral characteristic:_characteristic_write value:c];
            _timer = [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(sendOrder) userInfo:nil repeats:YES];
        } else {
            [_manager cancelPeripheralConnection:peripheral];
        }
    }
    if ([result hasPrefix:@"90"]) {
        _SN = [self changeMac:[result substringWithRange:NSMakeRange(2,2)]];
        if (!_isSend) {
            NSArray *array = @[[NSString stringWithFormat:@"13%@00", _SN], [NSString stringWithFormat:@"13%@06", _SN], [NSString stringWithFormat:@"13%@0C", _SN], [NSString stringWithFormat:@"13%@12", _SN]];
            for (int i = 0; i < 4; i++) {
                NSData *c = [self convertHexStrToData:[array objectAtIndex:i]];
                [self writeCharacteristic:peripheral characteristic:_characteristic_write value:c];
            }
            _isSend = YES;
        }
    }
    if ([result hasPrefix:@"93"]) {
        if (![_countArray containsObject: result]) {
            [_countArray addObject:result];
        }
    }
    if (_countArray.count == 4) {
        int sum = 0;
        for (int i = 0; i < _countArray.count; i++) {
            NSString *count = [self changeCount:[[_countArray objectAtIndex:i] substringWithRange:NSMakeRange(12,24)]];
            NSLog(@"%@", count);
            NSArray *array = [count componentsSeparatedByString:@":"];
            for (int j = 0; j < array.count; j++) {
                NSString *str = [array objectAtIndex:j];
                if (![str containsString:@"ff"]) {
                    int s = [[self to10:str] intValue];
                    NSLog(@"R%d", s);
                    sum+=s;
                }
            }
        }
        //
        [self.delegate stepNumber:sum];
    }
}

//用于检测中心向外设写数据是否成功
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        NSLog(@"APP发送数据失败:%@",error.localizedDescription);
    } else {
        NSLog(@"APP向设备发送数据成功");
    }
}

//搜索到Characteristic的Descriptors
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    //打印出Characteristic和他的Descriptors
    NSLog(@"characteristic uuid:%@",characteristic.UUID);
    for (CBDescriptor *d in characteristic.descriptors) {
        NSLog(@"Descriptor uuid:%@",d.UUID);
    }
    
}

//获取到Descriptors的值
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error{
    //打印出DescriptorsUUID 和value
    //这个descriptor都是对于characteristic的描述，一般都是字符串，所以这里我们转换成字符串去解析
    NSLog(@"characteristic uuid:%@  value:%@",[NSString stringWithFormat:@"%@",descriptor.UUID],descriptor.value);
}

//写数据
-(void)writeCharacteristic:(CBPeripheral *)peripheral
            characteristic:(CBCharacteristic *)characteristic
                     value:(NSData *)value{
    if(characteristic.properties & CBCharacteristicPropertyWrite){
        /*
         最好一个type参数可以为CBCharacteristicWriteWithResponse或type:CBCharacteristicWriteWithResponse,区别是是否会有反馈
         */
        [peripheral writeValue:value forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    }else{
        NSLog(@"该字段不可写！");
    }    
}

//设置通知
-(void)notifyCharacteristic:(CBPeripheral *)peripheral
             characteristic:(CBCharacteristic *)characteristic{
    //设置通知，数据通知会进入：didUpdateValueForCharacteristic方法
    [peripheral setNotifyValue:YES forCharacteristic:characteristic];
    
}

//取消通知
-(void)cancelNotifyCharacteristic:(CBPeripheral *)peripheral
                   characteristic:(CBCharacteristic *)characteristic{
    
    [peripheral setNotifyValue:NO forCharacteristic:characteristic];
}

//停止扫描并断开连接
-(void)disconnectPeripheral:(CBCentralManager *)centralManager
                 peripheral:(CBPeripheral *)peripheral{
    //停止扫描
    [centralManager stopScan];
    //断开连接
    [centralManager cancelPeripheralConnection:peripheral];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"_macArray"]) {
        NSLog(@"%@", _macArray);
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"MAC_ARRAY" object:_macArray]];
    }
}

- (void) sendOrder
{
    _isSend = NO;
    [_countArray removeAllObjects];
    NSData *c = [self convertHexStrToData:@"10"];
    [self writeCharacteristic:_peripheral_write characteristic:_characteristic_write value:c];
}

- (NSData *)convertHexStrToData:(NSString *)str
{
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:20];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    return hexData;
}

//将传入的NSData类型转换成NSString并返回
- (NSString*)hexadecimalString:(NSData *)data{
    NSString* result;
    const unsigned char* dataBuffer = (const unsigned char*)[data bytes];
    if(!dataBuffer){
        return nil;
    }
    NSUInteger dataLength = [data length];
    NSMutableString* hexString = [NSMutableString stringWithCapacity:(dataLength * 2)];
    for(int i = 0; i < dataLength; i++){
        [hexString appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)dataBuffer[i]]];
    }
    result = [NSString stringWithString:hexString];
    return result;
}

//将传入的NSString类型转换成NSData并返回
- (NSData*)dataWithHexstring:(NSString *)hexstring{
    NSData* aData;
    return aData = [hexstring dataUsingEncoding: NSUTF16StringEncoding];
}

// 十六进制转换为普通字符串的。
- (NSString *)stringFromHexString:(NSString *)hexString { //
    
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    NSLog(@"------字符串=======%@",unicodeString);
    return unicodeString;
}

- (NSString *) changeMac : (NSString *)string
{
    NSString *doneTitle = @"";
    for (int i = 0, count = 0; i < string.length; i++) {
        count++;
        doneTitle = [doneTitle stringByAppendingString:[string substringWithRange:NSMakeRange(i, 1)]];
        if (count == 2 && i<string.length-1) {
            doneTitle = [NSString stringWithFormat:@"%@:", doneTitle];
            count = 0;
        }
    }
    return doneTitle;
}

- (NSString *) changeCount : (NSString *)string
{
    NSString *doneTitle = @"";
    for (int i = 0, count = 0; i < string.length; i++) {
        count++;
        doneTitle = [doneTitle stringByAppendingString:[string substringWithRange:NSMakeRange(i, 1)]];
        if (count == 4 && i<string.length-1) {
            doneTitle = [NSString stringWithFormat:@"%@:", doneTitle];
            count = 0;
        }
    }
    return doneTitle;
}

- (NSString *)to10:(NSString *)num
{
    NSString *result = [NSString stringWithFormat:@"%ld", strtoul([num UTF8String],0,16)];
    return result;
}

- (NSString *)getHexByDecimal:(NSInteger)decimal {
    
    NSString *hex =@"";
    NSString *letter;
    NSInteger number;
    for (int i = 0; i<9; i++) {
        
        number = decimal % 16;
        decimal = decimal / 16;
        switch (number) {
                
            case 10:
                letter =@"A"; break;
            case 11:
                letter =@"B"; break;
            case 12:
                letter =@"C"; break;
            case 13:
                letter =@"D"; break;
            case 14:
                letter =@"E"; break;
            case 15:
                letter =@"F"; break;
            default:
                letter = [NSString stringWithFormat:@"%ld", number];
        }
        hex = [letter stringByAppendingString:hex];
        if (decimal == 0) {
            
            break;
        }
    }
    return hex;
}

@end
