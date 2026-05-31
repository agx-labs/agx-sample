import Request from '@/utils/request/request-util';

/**
 * 后台管理 -人员api
 *
 */
export class UsersApi {
  /**
   * 分页
   * @param {*} params
   * @returns
   */
  static findPage(params) {
    return Request.getAndLoadData('/sysUser/page', params);
  }

  /**
   * 获取最新重置密码
   * @param {*} params
   * @returns
   */
  static getResetPassword(params) {
    return Request.getAndLoadData('/sysUser/getResetPassword', params);
  }

  /**
   * 添加
   * @param {*} params
   * @returns
   */
  static add(params) {
    return Request.post('/sysUser/add', params);
  }
  /**
   * 编辑
   * @param {*} params
   * @returns
   */
  static edit(params) {
    return Request.post('/sysUser/edit', params);
  }
  /**
   * 删除单个
   * @param {*} params
   * @returns
   */
  static delete(params) {
    return Request.post('/sysUser/delete', params);
  }
  /**
   * 删除批量
   * @param {*} params
   * @returns
   */
  static batchDelete(params) {
    return Request.post('/sysUser/batchDelete', params);
  }
  /**
   * 详情
   * @param {*} params
   * @returns
   */
  static detail(params) {
    return Request.getAndLoadData('/sysUser/detail', params);
  }
  /**
   * 列表
   * @param {*} params
   * @returns
   */
  static list(params) {
    return Request.getAndLoadData('/sysUser/list', params);
  }
  /**
   * 重置密码
   * @param {*} params
   * @returns
   */
  static resetPassword(params) {
    return Request.post('/sysUser/resetPassword', params);
  }

  /**
   * 修改用户状态
   * @param {*} params
   * @returns
   */
  static updateStatus(params) {
    return Request.post('/sysUser/updateStatus', params);
  }

  /**
   * 绑定用户角色
   * @param {*} params
   * @returns
   */
  static bindRoles(params) {
    return Request.post('/sysUser/bindRoles', params);
  }

  /**
   * 角色列表
   * @param {*} params
   * @returns
   */
  static roleList(params) {
    return Request.getAndLoadData('/sysRole/list', params);
  }

  /**
   * 用户导出业务
   * @param {*} params
   * @returns
   */
  static ExportUser(params) {
    return Request.downLoad('/user/ExportUser', params);
  }

  /**
   * 下载导入的Excel模板
   * @param {*} params
   * @returns
   */
  static getExcelTemplate(params) {
    return Request.downLoad('/userImport/getExcelTemplate', params);
  }

  /**
   * 上传excel获取导入预览数据
   * @param {*} params
   * @returns
   */
  static uploadAndGetPreviewData(params) {
    return Request.post('/userImport/uploadAndGetPreviewData', params);
  }

  /**
   * 确认导入Excel数据
   * @param {*} params
   * @returns
   */
  static ensureImport(params) {
    return Request.post('/userImport/ensureImport', params);
  }

  /**
   * 获取左侧机构列表
   * @param {*} params
   * @returns
   */
  static getUserOrgList(params) {
    return Request.getAndLoadData('/sysRoleAssign/v2/getUserOrgList', params);
  }

  /**
   * 获取用户指定机构下的业务角色树
   * @param {*} params
   * @returns
   */
  static getCompanyBusinessRoleTree(params) {
    return Request.get('/sysRoleAssign/v2/getCompanyBusinessRoleTree', params);
  }

  /**
   * 获取用户指定机构下的公司角色树
   * @param {*} params
   * @returns
   */
  static getCompanyRoleTree(params) {
    return Request.get('/sysRoleAssign/v2/getCompanyRoleTree', params);
  }

  /**
   * 绑定或取消绑定角色
   * @param {*} params
   * @returns
   */
  static changeRoleSelect(params) {
    return Request.post('/sysRoleAssign/changeRoleSelect', params);
  }
}
