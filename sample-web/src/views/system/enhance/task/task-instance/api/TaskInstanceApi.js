import Request from '@/utils/request/request-util';
/**
 * 任务实例 API
 * 对应后端 TaskInstanceController /taskInstance/**
 *
 * @author gengchen
 * @since 2026/5/30
 */
export class TaskInstanceApi {
  /**
   * 获取任务实例详情
   * POST /taskInstance/get
   */
  static get(params) {
    return Request.postAndLoadData('/taskInstance/get', params);
  }
  /**
   * 从调度器刷新任务实例状态
   * POST /taskInstance/refresh
   */
  static refresh(params) {
    return Request.post('/taskInstance/refresh', params);
  }
  /**
   * 获取任务实例列表
   * POST /taskInstance/list
   */
  static list(params) {
    return Request.postAndLoadData('/taskInstance/list', params);
  }
  /**
   * 分页查询任务实例
   * POST /taskInstance/page
   */
  static page(params) {
    return Request.post('/taskInstance/page', params);
  }
  /**
   * 重试任务实例（仅失败实例可用）
   * POST /taskInstance/retry
   */
  static retry(params) {
    return Request.post('/taskInstance/retry', params);
  }
  /**
   * 停止运行中的任务实例
   * POST /taskInstance/stop
   */
  static stop(params) {
    return Request.post('/taskInstance/stop', params);
  }
  /**
   * 获取任务实例执行日志
   * POST /taskInstance/log
   * @param {Object} params - { taskInstId, schedulerLogId, fromLineNum }
   * @returns {Object} - { logContent, fromLineNum, toLineNum, end }
   */
  static log(params) {
    return Request.postAndLoadData('/taskInstance/log', params);
  }
}
