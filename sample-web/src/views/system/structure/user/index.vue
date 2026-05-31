<template>
  <div class="guns-layout">
    <div class="guns-layout" v-show="!showImport">
      <guns-split-layout width="292px" cacheKey="SYSTEM_STRUCTURE_USER">
        <div class="guns-layout-sidebar width-100 p-t-12">
          <div class="sidebar-content">
            <org-tree @treeSelect="treeSelect" ref="orgTreeRef"></org-tree>
          </div>
        </div>
        <template #content>
          <div class="guns-layout-content">
            <div class="guns-layout">
              <div class="guns-layout-content-application">
                <div class="content-mian">
                  <div class="content-mian-header">
                    <div class="header-content">
                      <div class="header-content-left">
                        <a-space :size="16"></a-space>
                      </div>
                      <div class="header-content-right">
                        <a-space :size="16">
                          <a-button type="primary" class="border-radius" @click="openAddEdit()" v-permission="['ADD_USER']"
                          >
                            <plus-outlined/>
                            新建
                          </a-button
                          >
                          <a-dropdown>
                            <template #overlay>
                              <a-menu @click="moreClick">
                                <div v-permission="['DELETE_USER']">
                                  <a-menu-item key="1">
                                    <icon-font iconClass="icon-opt-shanchu" color="#60666b"></icon-font>
                                    <span>批量删除</span>
                                  </a-menu-item>
                                </div>
                                <a-menu-item key="2">
                                  <icon-font iconClass="icon-opt-daoru" color="#60666b"></icon-font>
                                  <span>导入导出</span>
                                </a-menu-item>
                              </a-menu>
                            </template>
                            <a-button class="border-radius">
                              更多
                              <small-dash-outlined/>
                            </a-button>
                          </a-dropdown>
                        </a-space>
                      </div>
                    </div>
                  </div>
                  <div class="content-mian-body">
                    <div class="table-content">
                      <common-table
                          :columns="columns"
                          :where="where"
                          fieldBusinessCode="USER_TABLE"
                          showTableTool
                          :showToolTotal="false"
                          rowId="userId"
                          ref="tableRef"
                          url="/sysUser/page"
                      >
                        <template #toolLeft>
                          <a-input
                              v-model:value="where.searchText"
                              :bordered="false"
                              allowClear
                              placeholder="姓名、账号（回车搜索）"
                              @pressEnter="reload"
                              style="width: 240px"
                              class="search-input"
                          >
                            <template #prefix>
                              <icon-font iconClass="icon-opt-search"/>
                            </template>
                          </a-input>
                          <a-divider type="vertical" class="divider"/>
                          <a @click="changeSuperSearch">{{ superSearch ? '收起' : '高级筛选' }} </a>
                        </template>
                        <template #toolBottom>
                          <div class="super-search" style="margin-top: 8px" v-if="superSearch">
                            <a-form :model="where" :labelCol="labelCol" :wrapper-col="wrapperCol">
                              <a-row :gutter="16">
                                <a-col v-bind="spanCol">
                                  <a-form-item label="状态:">
                                    <a-select v-model:value="where.statusFlag" placeholder="请选择状态" style="width: 100%" allowClear>
                                      <a-select-option :value="item.id" v-for="item in statusList" :key="item.id">{{
                                          item.name
                                        }}
                                      </a-select-option>
                                    </a-select>
                                  </a-form-item>
                                </a-col>
                                <a-col v-bind="spanCol">
                                  <a-form-item label=" " class="not-label">
                                    <a-space :size="16">
                                      <a-button class="border-radius" @click="reload" type="primary">查询</a-button>
                                      <a-button class="border-radius" @click="clear">重置</a-button>
                                    </a-space>
                                  </a-form-item>
                                </a-col>
                              </a-row>
                            </a-form>
                          </div>
                        </template>
                        <template #bodyCell="{ column, record }">
                          <!-- 姓名 -->
                          <template v-if="column.dataIndex == 'realName'">
                            <a @click="detail(record)">{{ record.realName }}</a>
                          </template>
                          <!-- 公司 -->
                          <template v-if="column.dataIndex == 'company'">
                            {{ record?.userOrgDTO?.companyName ? record?.userOrgDTO?.companyName : '' }}
                          </template>
                          <!-- 部门 -->
                          <template v-if="column.dataIndex == 'dept'">
                            {{ record?.userOrgDTO?.deptName ? record?.userOrgDTO?.deptName : '' }}
                          </template>
                          <!-- 职务 -->
                          <template v-if="column.dataIndex == 'positionName'">
                            {{ record?.userOrgDTO?.positionName ? record?.userOrgDTO?.positionName : '' }}
                          </template>
                          <!-- 性别 -->
                          <template v-if="column.dataIndex == 'sex'">
                            <span v-if="record.sex == 'M'">男</span>
                            <span v-if="record.sex == 'F'">女</span>
                          </template>
                          <!-- 状态 -->
                          <template v-if="column.dataIndex == 'statusFlag'">
                            <vxe-switch
                                v-model="record.statusFlag"
                                :open-value="1"
                                :close-value="2"
                                @change="statusFlagChange(record)"
                                :disabled="disabled"
                            ></vxe-switch>
                          </template>
                          <!-- 操作 -->
                          <template v-if="column.key == 'action'">
                            <a-space :size="16">
                              <icon-font
                                  iconClass="icon-opt-bianji"
                                  font-size="24px"
                                  title="编辑"
                                  color="#60666b"
                                  v-permission="['EDIT_USER']"
                                  @click="openAddEdit(record)"
                              ></icon-font>
                              <icon-font
                                  iconClass="icon-opt-fenpeijuese"
                                  font-size="24px"
                                  color="#60666b"
                                  title="分配角色"
                                  v-permission="['ASSIGN_USER_ROLE']"
                                  @click="roleClick(record)"
                              ></icon-font>
                              <icon-font
                                  iconClass="icon-opt-chongzhimima"
                                  font-size="24px"
                                  color="#60666b"
                                  title="重置密码"
                                  v-permission="['RESET_PASSWORD']"
                                  @click="resetPassword(record)"
                              ></icon-font>
                              <icon-font
                                  iconClass="icon-opt-shanchu"
                                  font-size="24px"
                                  title="删除"
                                  color="#60666b"
                                  v-permission="['DELETE_USER']"
                                  @click="remove(record)"
                              ></icon-font>
                            </a-space>
                          </template>
                        </template>
                      </common-table>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </template>
      </guns-split-layout>
    </div>

    <!-- 导入导出 -->
    <ImportExportUser v-if="showImport" @back="showImport = false" @backReload="backReload"/>

    <!-- 新增编辑弹框 -->
    <UserAddEdit v-model:visible="showEdit" v-if="showEdit" :data="current" @done="reload"/>
    <!-- 查看详情抽屉 -->
    <UserDetail v-model:visible="showDetail" v-if="showDetail" :data="current"/>
    <!-- 分配角色 -->
    <AllocationRole v-model:visible="showRole" v-if="showRole" :data="current" @done="reload"/>
  </div>
</template>

<script setup name="BackEndUser">
import OrgTree from './org-tree.vue';
import {UsersApi} from './api/UsersApi';
import {useUserStore} from '@/store/modules/user';
import {ref, createVNode, onMounted, computed} from 'vue';
import {message, Modal} from 'ant-design-vue/es';
import UserDetail from './components/user-detail.vue';
import UserAddEdit from './components/user-add-edit.vue';
import AllocationRole from './components/allocation-role.vue';
import {ExclamationCircleOutlined} from '@ant-design/icons-vue';
import ImportExportUser from './components/import-export-user.vue';
import {isMobile} from '@/utils/common/util';

defineOptions({
  name: 'BackEndUser'
});

// 状态列表
const statusList = ref([
  {
    id: '',
    name: '全部状态'
  },
  {
    id: 1,
    name: '启用'
  },
  {
    id: 2,
    name: '禁用'
  }
]);
// 表格配置
const columns = ref([
  {
    key: 'index',
    title: '序号',
    width: 48,
    align: 'center',
    isShow: true,
    hideInSetting: true
  },
  {
    dataIndex: 'realName',
    title: '姓名',
    ellipsis: true,
    width: 100,
    isShow: true
  },
  {
    dataIndex: 'account',
    title: '账号',
    width: 100,
    ellipsis: true,
    isShow: true
  },
  {
    dataIndex: 'employeeNumber',
    title: '工号',
    width: 100,
    ellipsis: true,
    isShow: true
  },
  {
    dataIndex: 'company',
    title: '主要公司',
    ellipsis: true,
    width: 100,
    isShow: true
  },
  {
    dataIndex: 'dept',
    title: '主要部门',
    width: 100,
    isShow: true
  },
  {
    dataIndex: 'positionName',
    title: '职务',
    width: 100,
    isShow: true
  },
  {
    dataIndex: 'sex',
    title: '性别',
    width: 100,
    isShow: true
  },
  {
    dataIndex: 'statusFlag',
    title: '状态',
    width: 100,
    isShow: true
  },
  {
    dataIndex: 'createTime',
    title: '创建时间',
    width: 150,
    isShow: true
  },
  {
    key: 'action',
    title: '操作',
    width: 200,
    isShow: true
  }
]);
// ref
const tableRef = ref(null);
const orgTreeRef = ref(null);
const userStore = useUserStore();

// 搜索条件
const where = ref({
  orgIdCondition: '',
  statusFlag: null,
  searchText: ''
});
// 当前行数据
const current = ref(null);
// 是否显示新增编辑弹框
const showEdit = ref(false);
// 是否显示详情抽屉
const showDetail = ref(false);
// 是否显示分配角色弹框
const showRole = ref(false);
// 是否显示导入导出
const showImport = ref(false);
// 是否显示高级查询
const superSearch = ref(false);
// 是否禁用
const disabled = computed(() => {
  if (userStore.authorities.find(item => item == 'UPDATE_USER_STATUS')) {
    return false;
  }
  return true;
});

const labelCol = computed(() => {
  return {xxl: 7, xl: 7, lg: 5, md: 7, sm: 4};
});

const wrapperCol = computed(() => {
  return {xxl: 17, xl: 17, lg: 19, md: 17, sm: 20};
});

const spanCol = computed(() => {
  if (isMobile()) {
    return {xxl: 6, xl: 8, lg: 12, md: 24, sm: 24, xs: 24};
  }
  return {xxl: 6, xl: 8, lg: 24, md: 24, sm: 24, xs: 24};
});

onMounted(() => {
});

// 切换高级查询
const changeSuperSearch = () => {
  superSearch.value = !superSearch.value;
};

// 左侧树选中
const treeSelect = (selectedKeys, metadata) => {
  where.value.orgIdCondition = selectedKeys[0];
  reload();
};

// 更多点击
const moreClick = ({key}) => {
  if (key == '1') {
    batchDelete();
  } else if (key == '2') {
    // 导入导出
    showImport.value = true;
  }
};

// 点击搜索
const reload = () => {
  tableRef.value.reload();
};

// 清除搜索条件
const clear = () => {
  where.value.searchText = '';
  where.value.statusFlag = null;
  where.value.orgIdCondition = '';
  orgTreeRef.value.currentSelectKeys = [];
  reload();
};

// 新增编辑点击
const openAddEdit = record => {
  current.value = record;
  showEdit.value = true;
};

// 查看详情
const detail = record => {
  current.value = record;
  showDetail.value = true;
};

// 删除单个
const remove = record => {
  Modal.confirm({
    title: '提示',
    content: '确定要删除选中的用户吗?',
    icon: createVNode(ExclamationCircleOutlined),
    maskClosable: true,
    onOk: async () => {
      const res = await UsersApi.delete({userId: record.userId});
      message.success(res.message);
      reload();
    }
  });
};

// 批量删除
const batchDelete = () => {
  if (tableRef.value.selectedRowList && tableRef.value.selectedRowList.length == 0) {
    return message.warning('请选择需要删除的用户');
  }
  Modal.confirm({
    title: '提示',
    content: '确定要删除选中的用户吗?',
    icon: createVNode(ExclamationCircleOutlined),
    maskClosable: true,
    onOk: async () => {
      const res = await UsersApi.batchDelete({userIdList: tableRef.value.selectedRowList});
      message.success(res.message);
      reload();
    }
  });
};

// 点击分配角色
const roleClick = record => {
  current.value = record;
  showRole.value = true;
};

// 重置密码
const resetPassword = async record => {
  let result = '123456';
  try {
    result = await UsersApi.getResetPassword();
    Modal.confirm({
      title: '提示',
      content: `确定要重置此用户的密码为"${result}"吗?`,
      icon: createVNode(ExclamationCircleOutlined),
      maskClosable: true,
      onOk: async () => {
        let result = await UsersApi.resetPassword({userId: record.userId});
        message.success(result.message);
        reload();
      }
    });
  } catch (e) {
    message.error('获取数据异常，请联系管理员！');
  }
};

// 切换人员状态
const statusFlagChange = record => {
  UsersApi.updateStatus({userId: record.userId, statusFlag: record.statusFlag}).then(res => {
    message.success(res.message);
  });
};

// 返回并加载数据
const backReload = () => {
  showImport.value = false;
  reload();
};
</script>

<style scoped lang="less"></style>
