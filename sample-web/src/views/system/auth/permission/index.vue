<template>
  <div class="guns-layout">
    <div class="guns-layout-content">
      <div class="ten-height bg-white permission">
        <div class="permission-left">
          <div class="permission-left-header">
            <a-input-group compact>
              <div class="permission-left-header-left">
                <!-- 切换角色 -->
                <a-popover
                  trigger="click"
                  placement="bottomLeft"
                  v-if="superAdminFlag"
                  v-model:visible="showSelectRole"
                  overlayClassName="role-popover"
                >
                  <template #content>
                    <div class="role-list">
                      <div
                        class="role-list-item"
                        v-for="rItem in sysRoleList"
                        :key="rItem.roleId"
                        @click="changeRole(rItem)"
                        :class="[{ 'role-active': rItem.roleId == selectSystemRoleId }]"
                        :title="rItem.name"
                      >
                        <icon-font
                          v-if="rItem.roleId == 10"
                          iconClass="icon-tab-xitongjuese"
                          color="var(--primary-color)"
                          font-size="24px"
                        ></icon-font>
                        <icon-font
                          v-if="rItem.roleId == 15"
                          iconClass="icon-tab-yewujuese"
                          color="var(--primary-color)"
                          font-size="24px"
                        ></icon-font>
                        <icon-font
                          v-if="rItem.roleId == 20"
                          iconClass="icon-tab-gongsijuese"
                          color="var(--primary-color)"
                          font-size="24px"
                        ></icon-font>
                        <span style="margin-left: 5px">{{ rItem.name }}</span>
                      </div>
                    </div>
                  </template>
                  <span class="role-list-title">
                    <i class="iconfont icon-tab-xitongjuese role-list-icon" title="系统角色" v-if="selectSystemRoleId == 10"></i>
                    <i class="iconfont icon-tab-yewujuese role-list-icon" title="业务角色" v-if="selectSystemRoleId == 15"></i>
                    <i class="iconfont icon-tab-gongsijuese role-list-icon" title="公司角色" v-if="selectSystemRoleId == 20"></i>
                    <span>{{ selectSystemRoleId == 10 ? '系统' : selectSystemRoleId == 15 ? '业务' : '公司' }}</span>
                    <down-outlined class="role-list-down" v-if="superAdminFlag" />
                  </span>
                </a-popover>
                <span class="role-list-system-title" v-else>
                  <i class="iconfont icon-tab-gongsijuese role-list-icon" title="公司角色"></i>
                  <span>公司</span>
                  <down-outlined class="role-list-down" />
                </span>
              </div>
              <a-input
                v-model:value="systemName"
                :title="systemName"
                @click="changeCompany"
                :class="selectSystemRoleId == 20 && superAdminFlag ? 'role-list-input' : 'system-input'"
              >
                <template #suffix>
                  <down-outlined class="input-down" @click="changeCompany" v-if="selectSystemRoleId == 20 && superAdminFlag" />
                </template>
              </a-input>
            </a-input-group>
          </div>
          <div class="permission-left-body">
            <a-directory-tree
              :show-icon="selectSystemRoleId == 15 ? true : false"
              v-model:selectedKeys="currentSelectKeys"
              v-model:expandedKeys="expandedKeys"
              @select="leftChange"
              :tree-data="roleList"
              :fieldNames="{ children: 'children', title: 'roleName', key: 'roleId', value: 'roleId' }"
            >
              <template #icon="data">
                <icon-font v-if="data?.nodeType == 1" icon-class="icon-tree-wenjianjia" color="#43505e" fontSize="24px"></icon-font>
                <icon-font v-if="data?.nodeType == 2" icon-class="icon-menu-juese" color="#43505e" fontSize="24px"></icon-font>
              </template>
            </a-directory-tree>
            <a-empty v-show="roleList.length == 0" class="empty"></a-empty>
          </div>
        </div>
        <div class="permission-right">
          <div v-if="activeKey" class="right">
            <a-spin :spinning="authLoading" :delay="100">
              <div class="right-top">
                <a-tabs v-model:activeKey="rightActiveKey" animated class="right-tab" @change="rightChange">
                  <a-tab-pane key="use" tab="功能权限" v-if="isShow('CHANGE_ROLE_PERMISSION')"></a-tab-pane>
                  <a-tab-pane key="data" tab="数据权限" v-if="isShow('CHANGE_ROLE_DATA_SCOPE')"></a-tab-pane>
                  <a-tab-pane key="range" tab="权限范围" v-if="isShow('CHANGE_ROLE_BIND_LIMIT')"></a-tab-pane>
                </a-tabs>
              </div>
              <div class="right-bottom">
                <!-- 功能权限 -->
                <div v-if="rightActiveKey == 'use' && permissionData" class="use-content">
                  <div class="content-header">
                    <a-checkbox v-model:checked="permissionData.checked" @click="el => allPermissionChange(el, permissionData)"
                      >所有权限</a-checkbox
                    >
                  </div>
                  <div class="content-bottom">
                    <div class="bottom-item" v-for="(perItem, perIndex) in permissionData.appPermissionList" :key="perIndex">
                      <div class="bottom-item-name">
                        <span class="title">应用：{{ perItem.nodeName }}</span>
                        <a-checkbox v-model:checked="perItem.checked" @click="el => perItemChange(el, perItem)">全选</a-checkbox>
                      </div>
                      <div class="table">
                        <a-table
                          :dataSource="perItem.children"
                          :columns="columns"
                          v-model:expandedRowKeys="expandedRowKeys"
                          :pagination="false"
                          :checkStrictly="true"
                          rowKey="nodeId"
                          bordered
                          size="small"
                        >
                          <template #bodyCell="{ column, record }">
                            <template v-if="column.dataIndex === 'page'">
                              <a-checkbox
                                v-model:checked="record.checked"
                                v-if="record.leafFlag"
                                @change="pageChange($event, record, perItem)"
                              >
                                {{ record.nodeName }}
                              </a-checkbox>
                              <span v-else>{{ record.nodeName }}</span>
                            </template>
                            <template v-else-if="column.dataIndex === 'use' && record.functionList">
                              <a-checkbox
                                v-model:checked="chlItem.checked"
                                @change="useChange($event, chlItem, perItem)"
                                v-for="chlItem in record.functionList"
                                :key="chlItem.nodeId"
                              >
                                {{ chlItem.nodeName }}
                              </a-checkbox>
                            </template>
                          </template>
                        </a-table>
                      </div>
                    </div>
                  </div>
                </div>
                <!-- 数据权限 -->
                <div v-if="rightActiveKey == 'data'" class="data-power">
                  <common-table
                    :columns="dataColumns"
                    ref="tableRef"
                    :where="where"
                    rowKey="roleDataScopeId"
                    size="middle"
                    :isInit="false"
                    :rowSelection="false"
                    :showToolTotal="false"
                    url="/roleDataScope/getRoleDataScopePageList"
                  >
                    <template #toolLeft>
                      <a-input
                        v-model:value="where.searchText"
                        :bordered="false"
                        allowClear
                        size="small"
                        placeholder="请输入关键字"
                        @pressEnter="getRoleBindDataScope"
                        style="width: 220px"
                      >
                        <template #prefix>
                          <icon-font iconClass="icon-opt-search" />
                        </template>
                      </a-input>
                    </template>
                    <template #toolRight>
                      <icon-font
                        iconClass="icon-opt-tianjia"
                        font-size="24px"
                        title="新增"
                        color="#60666b"
                        @click="addEditDataPower()"
                      ></icon-font>
                    </template>
                    <template #bodyCell="{ column, record, index }">
                      <template v-if="column?.key == 'index'">{{ index + 1 }}</template>
                      <template v-if="column?.dataIndex == 'dataScopeTypeWrapper'">
                        <div class="td-item">
                          <div class="td-label">
                            {{ record.dataScopeTypeWrapper }}
                          </div>
                          <div class="td-btn">
                            <a-space>
                              <icon-font
                                iconClass="icon-opt-bianji"
                                font-size="24px"
                                title="编辑"
                                color="#60666b"
                                @click="addEditDataPower(record)"
                              />
                              <icon-font
                                iconClass="icon-opt-shanchu"
                                font-size="24px"
                                title="删除"
                                color="#60666b"
                                @click="removeDataPower(record)"
                              />
                            </a-space>
                          </div>
                        </div>
                      </template>
                      <template v-if="column?.dataIndex == 'defineOrgIdWrapper'">
                        <span v-if="record.dataScopeType == 41">{{ record.defineOrgIdWrapper }}</span>
                        <span v-if="record.dataScopeType == 40">{{ getDefineOrgList(record) }}</span>
                        <span v-if="record.dataScopeType == 32" :style="{ color: record?.organizationLevel?.levelColor }">{{
                          getLevelName(record)
                        }}</span>
                      </template>
                    </template>
                  </common-table>
                </div>
                <!-- 权限范围 -->
                <div v-if="rightActiveKey == 'range' && powerRangeData" class="use-content">
                  <div class="content-header">
                    <a-checkbox v-model:checked="powerRangeData.checked" @click="el => allPermissionChange(el, powerRangeData)"
                      >所有权限</a-checkbox
                    >
                  </div>
                  <div class="content-bottom">
                    <div class="bottom-item" v-for="(perItem, perIndex) in powerRangeData.appPermissionList" :key="perIndex">
                      <div class="bottom-item-name">
                        <span class="title">应用：{{ perItem.nodeName }}</span>
                        <a-checkbox v-model:checked="perItem.checked" @click="el => perItemChange(el, perItem)">全选</a-checkbox>
                      </div>
                      <div class="table">
                        <a-table
                          :dataSource="perItem.children"
                          :columns="columns"
                          :pagination="false"
                          rowKey="nodeId"
                          bordered
                          v-model:expandedRowKeys="expandedRowKeys"
                          :checkStrictly="true"
                          size="small"
                        >
                          <template #bodyCell="{ column, record }">
                            <template v-if="column.dataIndex === 'page'">
                              <a-checkbox
                                v-model:checked="record.checked"
                                v-if="record.leafFlag"
                                @change="pageChange($event, record, perItem)"
                              >
                                {{ record.nodeName }}
                              </a-checkbox>
                              <span v-else>{{ record.nodeName }}</span>
                            </template>
                            <template v-else-if="column.dataIndex === 'use' && record.functionList">
                              <a-checkbox
                                v-model:checked="chlItem.checked"
                                @change="useChange($event, chlItem, perItem)"
                                v-for="chlItem in record.functionList"
                                :key="chlItem.nodeId"
                              >
                                {{ chlItem.nodeName }}
                              </a-checkbox>
                            </template>
                          </template>
                        </a-table>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </a-spin>
          </div>
          <a-empty v-show="!activeKey" class="right-empty"></a-empty>
        </div>
      </div>
    </div>

    <!-- 选择组件 -->
    <Selection
      v-model:visible="showSelectCompany"
      v-if="showSelectCompany"
      title="选择公司"
      :data="selectData"
      :showTab="['company']"
      @done="closeSelectCompany"
    />

    <!-- 新增编辑数据权限 -->
    <DataScopeAddEdit
      v-model:visible="showAddEditData"
      v-if="showAddEditData"
      :data="current"
      :levelNumberList="levelNumberList"
      @done="getRoleBindDataScope"
      :roleId="activeKey"
    />
  </div>
</template>

<script setup name="Premission">
import { message, Modal } from 'ant-design-vue/es';
import { ref, onMounted, computed, nextTick, createVNode, defineAsyncComponent } from 'vue';
import { PermissionApi } from './api/PermissionApi';
import { useUserStore } from '@/store/modules/user';
import { ExclamationCircleOutlined } from '@ant-design/icons-vue';

const DataScopeAddEdit = defineAsyncComponent(() => import('./components/data-scope-add-edit.vue'));

defineOptions({
  name: 'Premission'
});

// 角色列表
const roleList = ref([]);

// 系统角色列表
const sysRoleList = ref([
  {
    roleId: 10,
    name: '系统角色'
  },
  {
    roleId: 15,
    name: '业务角色'
  },
  {
    roleId: 20,
    name: '公司角色'
  }
]);

// 是否显示选择系统角色
const showSelectRole = ref(false);

// 默认选中系统角色
const selectSystemRoleId = ref(20);
// 是否显示选择公司
const showSelectCompany = ref(false);
// 当前选中数据
const currentSelectKeys = ref([]);
// 展开数据
const expandedKeys = ref([]);
// 当前激活tab
const activeKey = ref('');
// 右侧tab默认
const rightActiveKey = ref('use');
// 加载动画
const authLoading = ref(false);
// 功能列表数据
const permissionData = ref(null);
// 展开行
const expandedRowKeys = ref([]);
// 选择的总数据
const selectData = ref({
  selectCompanyList: []
});
// 表格配置
const columns = ref([
  {
    title: '页面',
    width: 300,
    dataIndex: 'page'
  },
  {
    title: '功能',
    dataIndex: 'use'
  }
]);

// 权限范围数据
const powerRangeData = ref(null);

const userStore = useUserStore();

// 系统名称
const systemName = ref('');

// 数据权限表格配置
const dataColumns = ref([
  {
    title: '序号',
    width: 40,
    key: 'index',
    align: 'center'
  },
  {
    title: '类型',
    width: 100,
    dataIndex: 'dataScopeTypeWrapper'
  },
  {
    title: '范围',
    width: 100,
    dataIndex: 'defineOrgIdWrapper'
  },
  {
    title: '创建人',
    width: 100,
    dataIndex: 'createUserWrapper'
  },
  {
    title: '创建时间',
    width: 100,
    dataIndex: 'createTime'
  }
]);

const where = ref({
  roleId: ''
});

const tableRef = ref(null);
// 是否显示新增编辑数据权限
const showAddEditData = ref(false);

const current = ref(null);

const levelNumberList = ref([
  {
    value: 1,
    name: '一级'
  },
  {
    value: 2,
    name: '二级'
  },
  {
    value: 3,
    name: '三级'
  },
  {
    value: 4,
    name: '四级'
  },
  {
    value: 5,
    name: '五级'
  },
  {
    value: 6,
    name: '六级'
  },
  {
    value: 7,
    name: '七级'
  },
  {
    value: 8,
    name: '八级'
  },
  {
    value: 9,
    name: '九级'
  },
  {
    value: 10,
    name: '十级'
  }
]);

//是否显示
const isShow = computed(() => value => {
  if (userStore.authorities.find(item => item == value)) {
    return true;
  }
  return false;
});

// 是否是超管
const superAdminFlag = computed(() => {
  return userStore.info.superAdminFlag;
});

// 当前公司信息
const currentCompanyData = computed(() => {
  let userOrgInfoList = userStore.info.userOrgInfoList;
  let filter = userOrgInfoList.filter(item => item.currentSelectFlag);
  if (filter.length > 0) {
    return filter[0];
  }
});
// 获取范围名称
const getDefineOrgList = computed(() => {
  return record => {
    let name = '';
    if (record?.defineOrgListWrapper) {
      name = record.defineOrgListWrapper.join(',');
    }
    return name;
  };
});
// 获取层级名称
const getLevelName = computed(() => {
  return record => {
    let name = '';
    if (record?.organizationLevel) {
      let levelData = levelNumberList.value.find(item => item.value == record.organizationLevel.levelNumber);
      name = `${record.organizationLevel.levelName}(${levelData.name})`;
    }
    return name;
  };
});

// 公司信息
const companyData = ref({});

onMounted(() => {
  companyData.value = currentCompanyData.value;
  systemName.value = companyData.value?.companyName;
  getAllRoleList();
});

// 获取角色列表
const getAllRoleList = () => {
  let params = {
    roleType: selectSystemRoleId.value
  };
  if (selectSystemRoleId.value == 20) {
    params.roleCompanyId = companyData.value?.companyId;
  }
  let result;
  if (selectSystemRoleId.value == 15) {
    result = PermissionApi.getRoleCategoryAndRoleTree();
  } else {
    result = PermissionApi.getRoleList(params);
  }
  result.then(res => {
    let firstChild = null;
    if (selectSystemRoleId.value == 15) {
      roleList.value = setTreeData(res);
      firstChild = findNodeType2(res);
    } else {
      roleList.value = res;
      firstChild = res?.length > 0 ? res[0] : null;
    }
    if (firstChild) {
      activeKey.value = firstChild.roleId;
      currentSelectKeys.value = [firstChild.roleId];
      if (userStore.authorities.find(item => item === 'CHANGE_ROLE_PERMISSION')) {
        rightActiveKey.value = 'use';
        rightChange('use');
      } else if (userStore.authorities.find(item => item === 'CHANGE_ROLE_DATA_SCOPE')) {
        rightActiveKey.value = 'data';
        rightChange('data');
      } else if (userStore.authorities.find(item => item === 'CHANGE_ROLE_BIND_LIMIT')) {
        rightActiveKey.value = 'range';
        rightChange('range');
      }
    } else {
      activeKey.value = '';
      currentSelectKeys.value = [];
      permissionData.value = [];
      powerRangeData.value = [];
    }
  });
};

// 设置数据
const setTreeData = arr => {
  if (arr?.length > 0) {
    arr.forEach(item => {
      item.roleName = item.roleTreeNodeName;
      item.roleId = item.roleTreeNodeId;
      if (item.nodeType == 1) {
        item.disabled = true;
      }
      if (item.children?.length > 0) {
        item.children = setTreeData(item.children);
      }
    });
  }
  return arr;
};

// 查找第一个业务角色
const findNodeType2 = nodes => {
  for (const node of nodes) {
    if (node.nodeType === 2) {
      return node;
    }
    if (node.children && node.children.length > 0) {
      const result = findNodeType2(node.children);
      if (result) {
        return result;
      }
    }
  }
  return null;
};

// 切换系统角色
const changeRole = rItem => {
  if (rItem.roleId != selectSystemRoleId.value) {
    if (rItem.roleId == 10) {
      systemName.value = '系统角色';
    } else if (rItem.roleId == 15) {
      systemName.value = '业务角色';
    } else {
      systemName.value = companyData.value.companyName;
    }
    selectSystemRoleId.value = rItem.roleId;
    getAllRoleList();
  }

  showSelectRole.value = false;
};

// 切换公司
const changeCompany = () => {
  if (superAdminFlag.value && selectSystemRoleId.value == 20) {
    selectData.value.selectCompanyList = [{ bizId: companyData.value.companyId, name: companyData.value.companyName }];
    showSelectCompany.value = true;
  }
};

// 关闭选择公司
const closeSelectCompany = data => {
  companyData.value = data.selectCompanyList.map(item => {
    return { companyName: item.name, companyId: item.bizId };
  })[0];
  systemName.value = companyData.value.companyName;
  getAllRoleList();
};

// 获取角色绑定的权限列表
const getRoleBindPermission = () => {
  expandedRowKeys.value = [];
  authLoading.value = true;
  PermissionApi.getRoleBindPermission({ roleId: activeKey.value })
    .then(res => {
      if (res) {
        setData(res.appPermissionList);
        permissionData.value = res;
      }
    })
    .finally(() => (authLoading.value = false));
};

const setData = arr => {
  if (arr?.length > 0) {
    arr.forEach(item => {
      if (item?.children?.length > 0) {
        expandedRowKeys.value.push(item.nodeId);
        setData(item.children);
      }
    });
  }
};

// 获取角色的数据权限详情
const getRoleBindDataScope = () => {
  where.value.roleId = activeKey.value;
  nextTick(() => {
    tableRef.value.reload();
  });
};

// 添加数据权限
const addEditDataPower = data => {
  current.value = data;
  showAddEditData.value = true;
};

// 删除数据权限
const removeDataPower = data => {
  Modal.confirm({
    title: '提示',
    content: '确定要删除选中的数据权限吗?',
    icon: createVNode(ExclamationCircleOutlined),
    maskClosable: true,
    onOk: async () => {
      const res = await PermissionApi.roleDataScopeDelete({ roleDataScopeId: data.roleDataScopeId });
      message.success(res.message);
      getRoleBindDataScope();
    }
  });
};

// 获取角色的权限范围详情列表
const getRoleLimit = () => {
  expandedRowKeys.value = [];
  authLoading.value = true;
  PermissionApi.getRoleLimit({ roleId: activeKey.value })
    .then(res => {
      setData(res.appPermissionList);
      powerRangeData.value = res;
    })
    .finally(() => (authLoading.value = false));
};

// 右侧内容切换
const rightChange = key => {
  if (key == 'data') {
    getRoleBindDataScope();
  } else if (key == 'range') {
    getRoleLimit();
  } else if (key == 'use') {
    getRoleBindPermission();
  }
};

// 左侧角色切换
const leftChange = (selectedKeys, { node }) => {
  if (node.roleId != activeKey.value) {
    activeKey.value = node.roleId;
    rightActiveKey.value = 'use';
    getRoleBindPermission();
  }
};

// 所有权限改变
const allPermissionChange = (el, data) => {
  setAndSaveValue(el, data, 'appPermissionList', true);
};

/**
 * 设置和保存值
 * @param {*} el 当前dom，获取选中状态
 * @param {*} data 当前行数据
 * @param {*} setName 子菜单的名称
 * @param {*} flag 是否改变子级的选中状态
 * @param {*} isPermissionData 是否改变所有数据的选中状态
 * @param {*} perItem 是否改变全选的状态
 */
const setAndSaveValue = (el, data, setName, flag, isPermissionData, perItem) => {
  data.checked = el.target.checked;
  const recordSelectList = flattenTree([perItem]);
  if (flag) {
    setCheckout(el.target.checked, setName ? data[setName] : [data]);
  }

  //全选
  if (perItem) {
    if (recordSelectList.find(item => item.checked == false)) {
      perItem.checked = false;
    } else {
      perItem.checked = true;
    }
  }

  //所有
  if (isPermissionData) {
    if (rightActiveKey.value == 'use') {
      if (permissionData.value.appPermissionList.find(item => item.checked == false)) {
        permissionData.value.checked = false;
      } else {
        permissionData.value.checked = true;
      }
    } else if (rightActiveKey.value == 'range') {
      if (powerRangeData.value.appPermissionList.find(item => item.checked == false)) {
        powerRangeData.value.checked = false;
      } else {
        powerRangeData.value.checked = true;
      }
    }
  }
  //保存
  savePermission(data);
};

const flattenTree = tree => {
  const result = [];
  function traverse(node) {
    if (node?.leafFlag) {
      result.push(node);
      if (node?.functionList && Array.isArray(node.functionList)) {
        result.push(...node.functionList);
      }
    }
    if (node?.children && Array.isArray(node.children)) {
      node.children.forEach(traverse);
    }
  }
  tree.forEach(traverse);
  return result;
};

// 全选改变
const perItemChange = (el, data) => {
  setAndSaveValue(el, data, '', true, true);
};

// 页面选中改变
const pageChange = (el, data, perItem) => {
  setAndSaveValue(el, data, '', true, true, perItem);
};

// 功能改变
const useChange = (el, data, perItem) => {
  setAndSaveValue(el, data, '', false, true, perItem);
};

// 保存功能权限
const savePermission = data => {
  authLoading.value = true;
  let params = {
    checked: data.checked,
    nodeId: data.nodeId ? data.nodeId : '',
    permissionNodeType: data.permissionNodeType,
    roleId: activeKey.value
  };
  let result;
  if (rightActiveKey.value == 'use') {
    result = PermissionApi.updateRoleBindPermission(params);
  } else if (rightActiveKey.value == 'range') {
    result = PermissionApi.bindRoleLimit(params);
  }
  result
    .then(res => {
      message.success(res.message);
    })
    .finally(() => (authLoading.value = false));
};

// 设置选中
const setCheckout = (checked, list) => {
  if (list && list.length > 0) {
    list.forEach(item => {
      item.checked = checked;
      if (item.functionList && item.functionList.length > 0) {
        setCheckout(checked, item.functionList);
      }
      if (item.children && item.children.length > 0) {
        setCheckout(checked, item.children);
      }
    });
  }
};
</script>

<style scoped lang="less">
@import url('@/styles/commonTree.less');
:deep(.ant-tree .ant-tree-treenode-disabled .ant-tree-node-content-wrapper) {
  color: #000 !important;
}
.left-tab {
  height: 100%;
}
.permission {
  display: flex;
}
.permission-left {
  width: 252px;
  height: 100%;
  display: flex;
  flex-direction: column;
  .permission-left-header {
    width: 100%;
    height: 40px;
    display: flex;
    align-items: center;
    justify-content: center;
    border-bottom: 1px solid #eee;
    text-align: center;
    .permission-left-header-left {
      width: 80px;
      height: 31px;
      line-height: 31px;
      margin-right: 3px;
      cursor: pointer;
    }
    .icon-menu-yingyong {
      font-size: 20px;
      cursor: pointer;
      color: var(--primary-color);
      margin-right: 10px;
    }
    .company-name {
      cursor: pointer;
      max-width: 130px;
      display: inline-block;
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
    }
    .icon-shangxiazhankai {
      font-size: 18px;
      cursor: pointer;
      margin-left: 5px;
    }
  }
  .permission-left-body {
    padding: 10px 10px 0 0;
    flex: auto;
    width: 100%;
    overflow-y: auto;
    border-right: 1px solid #eee;
  }
}
.permission-right {
  width: calc(100% - 252px);
  height: 100%;
  padding: 5px 0 0 16px;
}
.empty {
  margin-top: 300px;
}
.right-empty {
  margin-top: 350px;
}

.role-list {
  width: 200px;
  max-height: 200px;
  overflow-y: auto;
}
.role-list-title {
  display: flex;
  align-items: center;
  &:hover {
    background: #eee;
    color: #000;
    border-radius: 5px;
  }
}
.role-list-system-title {
  display: flex;
  align-items: center;
}
.role-list-icon {
  margin-left: 10px;
  color: var(--primary-color);
  font-size: 20px;
}
.role-list-down {
  color: #d9d3d3;
  font-size: 12px;
  margin-left: 10px;
}
.input-down {
  color: #d9d3d3;
  font-size: 12px;
}
.role-list-input {
  border: 0px;
  width: 50%;
}
.system-input {
  border: 0px;
  width: 50%;
}
.role-list-input:hover {
  cursor: pointer;
  border-radius: 5px;
  background: #eee;
  color: #000;
  :deep(.ant-input) {
    background: #eee;
    color: #000;
    cursor: pointer;
  }
}
.role-list-item {
  width: 100%;
  padding: 10px 13px;
  cursor: pointer;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  font-size: 14px;
  display: flex;
  align-items: center;
  &:hover {
    background: #f3f3f3;
  }
  .role-image {
    width: 20px;
    height: 20px;
    margin-top: -5px;
    margin-right: 5px;
  }
}
.role-active {
  background: #eff4ff;
  &:hover {
    background: #eff4ff;
  }
}
.search-input {
  margin: 10px 0;
  border-radius: 5px;
}

:deep(.ant-popover .ant-popover-arrow) {
  display: none !important;
}
:deep(.ant-popover-placement-bottomLeft) {
  padding-top: 20px !important;
}
:deep(.ant-popover-inner-content) {
  padding: 12px 0 !important;
}

:deep(.right-tab .ant-tabs-tab-active) {
  background: #fff;
}
.right {
  width: 100%;
  height: 100%;
  overflow: hidden;
}
:deep(.ant-tabs-content) {
  height: 100%;
}
.right-top {
  margin-top: -10px;
  height: 62px;
}
.right-bottom {
  width: 100%;
  height: calc(100% - 62px);
  overflow: hidden;
}
.use-content {
  width: 100%;
  height: 100%;
  .content-header {
    height: 22px;
  }
  .content-bottom {
    width: 100%;
    margin-top: 20px;
    overflow-y: auto;
    height: calc(100% - 32px);
    .bottom-item {
      margin-bottom: 20px;
      .bottom-item-name {
        .title {
          font-size: 16px;
          font-weight: bold;
          margin-right: 10px;
        }
      }
    }
  }
}
.use-content {
  :deep(.ant-table-thead th) {
    text-align: center;
  }
  :deep(.ant-table-tbody .ant-table-cell) {
    padding: 8px 8px 8px 20px !important;
  }
}
.data-power {
  width: 100%;
  height: 100%;
}
.select {
  margin-top: 8px;
  margin-bottom: 10px;
  .add-icon {
    font-size: 20px;
    font-weight: bold;
    color: var(--primary-color);
    cursor: pointer;
  }
}
.ant-input-affix-wrapper-focused {
  box-shadow: 0 0 0 0px var(--primary-color-outline);
}

.td-item {
  flex: auto;
  display: flex;
  align-items: center;

  .td-label {
    width: 100%;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }
  .title-img {
    width: 18px;
    height: 18px;
    margin-bottom: 3px;
    margin-right: 8px;
  }

  .td-btn {
    position: absolute;
    display: none;
  }
}
:deep(.td-item:hover) {
  .td-label {
    width: calc(100% - 100px);
    overflow: hidden;
    white-space: nowrap;
    text-overflow: ellipsis;
  }

  .td-btn {
    right: 0;
    display: inline-block;
  }
}

@media screen and (max-width: 768px) {
  .permission {
    flex-direction: column;
  }
  .permission-left {
    margin-bottom: 10px;
  }
  .permission-left,
  .permission-right {
    width: 100%;
  }
  .ant-checkbox-wrapper + .ant-checkbox-wrapper {
    margin-left: 0px;
  }
}
</style>
