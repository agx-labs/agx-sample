import Request from '@/utils/request/request-util';

/**
 * 后台管理 -角色分类api
 *
 */
export class RoleTypeApi {
  /**
   * 获取角色分类树
   * @param {*} params
   * @returns
   */
  static treeList(params) {
    return Request.get('/roleCategory/treeList', params);
  }
  /**
   * 添加
   * @param {*} params
   * @returns
   */
  static add(params) {
    return Request.post('/roleCategory/add', params);
  }
  /**
   * 编辑
   * @param {*} params
   * @returns
   */
  static edit(params) {
    return Request.post('/roleCategory/edit', params);
  }
  /**
   * 删除单个
   * @param {*} params
   * @returns
   */
  static delete(params) {
    return Request.post('/roleCategory/delete', params);
  }
  /**
   * 详情
   * @param {*} params
   * @returns
   */
  static detail(params) {
    return Request.getAndLoadData('/roleCategory/detail', params);
  }
}