//  ____                               _      ____               _           _       _          _
// / ___|   _ __ ___     __ _   _ __  | |_   / ___|   ___     __| |   __ _  | |__   | |   ___  | |
// \___ \  | '_ ` _ \   / _` | | '__| | __| | |      / _ \   / _` |  / _` | | '_ \  | |  / _ \ | |
//  ___) | | | | | | | | (_| | | |    | |_  | |___  | (_) | | (_| | | (_| | | |_) | | | |  __/ |_|
// |____/  |_| |_| |_|  \__,_| |_|     \__|  \____|  \___/   \__,_|  \__,_| |_.__/  |_|  \___| (_)
//


public typealias SmartCodable = SmartDecodable & SmartEncodable


// 用在泛型解析中
extension Array: SmartCodable where Element: SmartCodable { }

/** 4.3.0 哨兵模式
 
 日志等级
 日志模式：（Logging Mode）在此模式下，所有的解析尝试及其结果都会被详细记录到日志中。适用于调试阶段。
 报警模式：（Alert Mode）：在解析失败时发送通知或警报。这可能包括UI警告、控制台输出或发送到远程日志服务器。
 
 
 存储容器
 单个日志
 日志集合：日志 & 报警
 
 
 
 功能开关
 1. 设置日志收集的等级。（需要关注，可以忽略的）【分别列举场景】
 2. 是否监听未匹配的json字段。（仅debug下有效）【参考骨架屏的debug判断】
 3.
 
 
 优化项目
 1. 使用更直接的日志。直接使用throw error。
 2. 输出体中是否增加：TestViewController.swift viewDidLoad() 48
 3. 优化日志排序（根据属性key进行大小排序）。
 
 2. 支持多种配置，接口中多余字段的未匹配的提醒。
 3. 日志更细化。使用更细节的解析信息。
 4. 提供日志的输出接口，可以上传服务器。
 5. 日志类型应该是
   - 聚合日志：提供日志等级。
   - 独立日志：数据异常情况等。
 
 
 修复SmartAny修饰Model，如果json值为null时的bug。
 */

/**
 ========================  [Smart Decoding Log]  ========================
 Family 👈🏻 👀
    |- name: Expected to decode 'String' but found ’Array‘ instead.
    |> fathers: [Father]
       |> [Index 0]
          |- name: Expected to decode 'String' but found 'null' instead.
          |> dog: Dog
              |- hobby: Expected to decode 'String' but found ’Number‘ instead.
          |> dogs: [Dog]
              |> [Index 0]
                 |- [Index 0] hobby: Expected to decode 'String' but found ’Number‘ instead.
    |> sons: [Son]
       |> [Index 0]
          |- hobby: Expected to decode 'String' but found ’Number‘ instead.
 ========================================================================
 */
