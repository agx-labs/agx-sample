import Request from '@/utils/request/request-util';

/**
 * 后台管理 - 权限api
 *
 */
export class PermissionApi {
  /**
   * 获取角色分类和角色组成的树
   * @param {*} params
   * @returns
   */
  static getRoleCategoryAndRoleTree(params) {
    return Request.getAndLoadData('/permission/getRoleCategoryAndRoleTree', params);
  }
  /**
   * 获取角色绑定的权限列表
   * @param {*} params
   * @returns
   */
  static getRoleBindPermission(params) {
    return Request.getAndLoadData('/permission/getRoleBindPermission', params);
  }

  /**
   * 获取所有角色列表
   * @param {*} params
   * @returns
   */
  static getRoleList(params) {
    return Request.getAndLoadData('/permission/getRoleList', params);
  }

  /**
   * 更新角色绑定权限
   * @param {*} params
   * @returns
   */
  static updateRoleBindPermission(params) {
    return Request.post('/permission/updateRoleBindPermission', params);
  }

  /**
   * 获取角色的数据范围列表
   * @param {*} params
   * @returns
   */
  static getRoleDataScopePageList(params) {
    return Request.getAndLoadData('/roleDataScope/getRoleDataScopePageList', params);
  }

  /**
   * 新增一个角色的数据权限
   * @param {*} params
   * @returns
   */
  static addRoleDataScope(params) {
    return Request.post('/roleDataScope/addRoleDataScope', params);
  }

  /**
   * 修改角色的数据权限
   * @param {*} params
   * @returns
   */
  static editRoleDataScope(params) {
    return Request.post('/roleDataScope/editRoleDataScope', params);
  }

  /**
   * 删除角色的数据权限
   * @param {*} params
   * @returns
   */
  static roleDataScopeDelete(params) {
    return Request.post('/roleDataScope/delete', params);
  }

  /**
   * 获取角色的权限限制列表
   * @param {*} params
   * @returns
   */
  static getRoleLimit(params) {
    return Request.getAndLoadData('/roleLimit/getRoleLimit', params);
  }

  /**
   * 绑定角色权限的限制列表
   * @param {*} params
   * @returns
   */
  static bindRoleLimit(params) {
    return Request.post('/roleLimit/bindRoleLimit', params);
  }
}
