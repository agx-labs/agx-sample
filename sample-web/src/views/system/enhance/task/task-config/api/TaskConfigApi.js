import Request from '@/utils/request/request-util';
/**
 * 任务配置 API
 * 对应后端 TaskConfigController /taskConfig/**
 *
 * @author gengchen
 * @since 2026/5/30
 */
export class TaskConfigApi {
  /**
   * 新增任务配置
   * POST /taskConfig/add
   */
  static add(params) {
    return Request.post('/taskConfig/add', params);
  }
  /**
   * 编辑任务配置
   * POST /taskConfig/edit
   */
  static edit(params) {
    return Request.post('/taskConfig/edit', params);
  }
  /**
   * 删除任务配置
   * POST /taskConfig/delete
   */
  static delete(params) {
    return Request.post('/taskConfig/delete', params);
  }
  /**
   * 获取任务配置详情
   * POST /taskConfig/get
   */
  static get(params) {
    return Request.postAndLoadData('/taskConfig/get', params);
  }
  /**
   * 获取任务配置列表
   * POST /taskConfig/list
   */
  static list(params) {
    return Request.postAndLoadData('/taskConfig/list', params);
  }
  /**
   * 分页查询任务配置
   * POST /taskConfig/page
   */
  static page(params) {
    return Request.post('/taskConfig/page', params);
  }
  /**
   * 立即执行一次（仅已启用任务可用）
   * POST /taskConfig/executeOnce
   */
  static executeOnce(params) {
    return Request.post('/taskConfig/executeOnce', params);
  }
  /**
   * 更新任务状态（启用 status=1 / 停用 status=2）
   * POST /taskConfig/updateStatus
   */
  static updateStatus(params) {
    return Request.post('/taskConfig/updateStatus', params);
  }
  /**
   * 获取可用的任务处理器列表（返回 {beanName: handlerName} 字典）
   * POST /taskConfig/getJobHandlers
   */
  static getJobHandlers(params) {
    return Request.postAndLoadData('/taskConfig/getJobHandlers', params);
  }
}