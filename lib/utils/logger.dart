import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:intl/intl.dart';
import 'router_helper.dart';

/// 日志工具类
/// 基于 logging 包封装，实现基础的日志打印功能
/// 自动根据 debug 环境和 release 环境进行打印控制
class Log {
  // 定义日期格式
  static final DateFormat _timeFormat = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
  
  // 单例模式或静态工具类
  static final Logger _logger = Logger('App');

  /// 初始化日志配置
  /// 建议在 main.dart 的 main 函数中调用
  static void init() {
    // 只有在 debug 模式下才配置日志输出
    if (kDebugMode) {
      // 允许为每个 logger 设置不同的等级
      hierarchicalLoggingEnabled = true;
      // 设置根日志等级
      Logger.root.level = Level.ALL;
      
      // 监听日志记录并输出到控制台
      Logger.root.onRecord.listen((record) {
        final timeStr = _timeFormat.format(record.time);
        
        // 获取当前页面信息
        String pageInfo = 'Global';
        try {
          // 尝试从 RouterHelper 获取当前路由名称
          final currentRoute = RouterHelper.currentRouteName;
          if (currentRoute != null) {
            pageInfo = currentRoute;
          }
        } catch (e) {
          // 如果路由器尚未初始化，保持为 Global
        }

        // 构造带时间、等级、页面和名称的完整消息
        final logOutput = '[$timeStr] $pageInfo ${record.level.name} [${record.loggerName}]: ${record.message}';
        
        // 使用 dart:developer 的 log 函数
        developer.log(
          logOutput,
          time: record.time,
          sequenceNumber: record.sequenceNumber,
          level: record.level.value,
          name: record.loggerName,
          error: record.error,
          stackTrace: record.stackTrace,
        );
      });
      
      i('Log 模块初始化完成 (Debug 模式)');
    } else {
      // Release 模式下可以保持默认，或者设置为只记录 Severe 及以上等级但不打印
      Logger.root.level = Level.OFF;
    }
  }

  /// 详细日志 (Finest)
  static void v(String message) => _logger.finest(message);

  /// 调试日志 (Fine)
  static void d(String message) => _logger.fine(message);

  /// 信息日志 (Info)
  static void i(String message) => _logger.info(message);

  /// 警告日志 (Warning)
  static void w(String message) => _logger.warning(message);

  /// 错误日志 (Severe)
  static void e(String message, [Object? error, StackTrace? stackTrace]) =>
      _logger.severe(message, error, stackTrace);

  /// 极严日志 (Shout)
  static void shouting(String message) => _logger.shout(message);
}
