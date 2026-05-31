<template>
  <div class="guns-layout">
    <div class="guns-layout" v-show="!showImport">
      <guns-split-layout width="292px" cacheKey="SYSTEM_STRUCTURE_ORGANIZATION">
        <div class="guns-layout-sidebar width-100 p-t-12">
          <div class="sidebar-content">
            <org-tree
              @treeSelect="treeSelect"
              ref="orgTreeRef"
              isShowEditIcon
              @deleteOrg="reload"
              @addOrg="addOrg"
              @editOrg="editOrg"
            ></org-tree>
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
                        <a-space :size="16"> </a-space>
                      </div>
                      <div class="header-content-right">
                        <a-space :size="16">
                          <a-button type="primary" class="border-radius" @click="openAddEdit()" v-permission="['ADD_ORG']"
                            ><plus-outlined />新建</a-button
                          >
                          <a-dropdown>
                            <template #overlay>
                              <a-menu @click="moreClick">
                                <div v-permission="['DELETE_ORG']">
                                  <a-menu-item key="1">
                                    <icon-font iconClass="icon-opt-shanchu" color="#60666b"></icon-font>
                                    <span>批量删除</span>
                                  </a-menu-item>
                                </div>
                                <a-menu-item key="2">
                                  <icon-font iconClass="icon-opt-daoru" color="#60666b"></icon-font>
                                  <span>导入导出</span>
                                </a-menu-item>
                                <a-menu-item key="3">
                                  <icon-font iconClass="icon-menu-moxingliebiao" color="#60666b"></icon-font>
                                  <span>层级维护</span>
                                </a-menu-item>
                              </a-menu>
                            </template>
                            <a-button class="border-radius">
                              更多
                              <small-dash-outlined />
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
                        fieldBusinessCode="ORG_TABLE"
                        showTableTool
                        :showToolTotal="false"
                        rowId="orgId"
                        ref="tableRef"
                        url="/hrOrganization/page"
                      >
                        <template #toolLeft>
                          <a-input
                            v-model:value="where.searchText"
                            :bordered="false"
                            allowClear
                            placeholder="机构名称、编码（回车搜索）"
                            @pressEnter="reload"
                            style="width: 240px"
                            class="search-input"
                          >
                            <template #prefix>
                              <icon-font iconClass="icon-opt-search" />
                            </template>
                          </a-input>
                          <a-divider type="vertical" class="divider" />
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
                                      }}</a-select-option>
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
                          <template v-if="column.dataIndex == 'orgName'">
                            <a @click="detail(record)">{{ record.orgName }}</a>
                          </template>
                          <!-- 机构状态 -->
                          <template v-if="column.dataIndex == 'statusFlag'">
                            <a-tag color="green" v-if="record.statusFlag == 1">启用</a-tag>
                            <a-tag color="red" v-if="record.statusFlag == 2">禁用</a-tag>
                          </template>
                          <template v-if="column.dataIndex == 'orgType'">
                            <div class="org-type">
                              <a-tag color="green" v-if="record.orgType == 1">公司</a-tag>
                              <a-tag color="red" v-if="record.orgType == 2">部门</a-tag>
                            </div>
                          </template>
                          <template v-if="column.dataIndex == 'organizationLevel'">
                            <span :style="{ color: record?.organizationLevel?.levelColor }">{{ getLevelNumberName(record) }}</span>
                          </template>
                          <template v-if="column.dataIndex == 'organizationLevelName'">
                            <span>{{ record?.organizationLevel?.levelName }}</span>
                          </template>
                          <!-- 操作 -->
                          <template v-if="column.key == 'action'">
                            <a-space :size="16">
                              <icon-font
                                iconClass="icon-opt-bianji"
                                font-size="24px"
                                title="编辑"
                                color="#60666b"
                                v-permission="['EDIT_ORG']"
                                @click="openAddEdit(record)"
                              ></icon-font>
                              <icon-font
                                iconClass="icon-opt-shenpirenshezhi"
                                color="#60666b"
                                font-size="24px"
                                title="审批人设置"
                                v-permission="['ASSIGN_APPROVER']"
                                @click="setApprover(record)"
                              ></icon-font>
                              <icon-font
                                iconClass="icon-opt-shanchu"
                                font-size="24px"
                                title="删除"
                                color="#60666b"
                                v-permission="['DELETE_ORG']"
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
    <ImportExportOrg v-if="showImport" @back="showImport = false" @backReload="backReload" />

    <!-- 新增编辑弹框 -->
    <OrgAddEdit
      v-model:visible="showEdit"
      v-if="showEdit"
      :data="current"
      @done="reloadAll"
      :parentId="parentId"
      :parentName="parentName"
      :levelNumberList="levelNumberList"
    />
    <!-- 查看详情抽屉 -->
    <OrgDetail
      v-model:visible="showDetail"
      v-if="showDetail"
      :data="current"
      :isShowApprover="isShowApprover"
      :levelNumberList="levelNumberList"
    />

    <!-- 层级维护弹框 -->
    <OrgLevel v-model:visible="showLevel" v-if="showLevel" :levelNumberList="levelNumberList" @done="reload" />
  </div>
</template>

<script setup name="Organization">
import OrgTree from '@/views/system/structure/user/org-tree.vue';
import { OrgApi } from './api/OrgApi';
import { ref, createVNode, onMounted, computed, defineAsyncComponent } from 'vue';
import { message, Modal } from 'ant-design-vue/es';
import OrgDetail from './components/org-detail.vue';
import OrgAddEdit from './components/org-add-edit.vue';
import ImportExportOrg from './components/import-export-org.vue';
import { ExclamationCircleOutlined } from '@ant-design/icons-vue';
import { isMobile } from '@/utils/common/util';

const OrgLevel = defineAsyncComponent(() => import('./components/org-level.vue'));

defineOptions({
  name: 'Organization'
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
    dataIndex: 'orgName',
    title: '机构名称',
    ellipsis: true,
    width: 200,
    isShow: true
  },
  {
    dataIndex: 'orgCode',
    title: '机构编码',
    width: 100,
    isShow: true
  },
  {
    dataIndex: 'statusFlag',
    title: '机构状态',
    ellipsis: true,
    width: 100,
    isShow: true
  },
  {
    dataIndex: 'orgType',
    title: '机构类型',
    ellipsis: true,
    width: 100,
    isShow: true
  },
  {
    dataIndex: 'organizationLevel',
    title: '层级',
    ellipsis: true,
    width: 100,
    isShow: true
  },
  {
    dataIndex: 'organizationLevelName',
    title: '层级名称',
    ellipsis: true,
    width: 100,
    isShow: true
  },
  {
    dataIndex: 'orgSort',
    title: '排序',
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
    width: 100,
    isShow: true
  }
]);
// 层级名称列表
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
// ref
const tableRef = ref(null);
const statusRef = ref(null);
const orgTreeRef = ref(null);

// 搜索条件
const where = ref({
  orgId: null,
  statusFlag: null,
  searchText: ''
});
// 当前行数据
const current = ref(null);
// 是否显示新增编辑弹框
const showEdit = ref(false);
// 是否显示详情抽屉
const showDetail = ref(false);
// 当前选中的组织机构id
const parentId = ref(null);
// 当前选中的组织机构名称
const parentName = ref(null);
// 是否显示设置审批人
const isShowApprover = ref(false);
// 是否显示导入导出
const showImport = ref(false);
// 是否显示层级维护
const showLevel = ref(false);

// 是否显示高级查询
const superSearch = ref(false);

const labelCol = computed(() => {
  return { xxl: 7, xl: 7, lg: 5, md: 7, sm: 4 };
});

const wrapperCol = computed(() => {
  return { xxl: 17, xl: 17, lg: 19, md: 17, sm: 20 };
});

const spanCol = computed(() => {
  if (isMobile()) {
    return { xxl: 6, xl: 8, lg: 12, md: 24, sm: 24, xs: 24 };
  }
  return { xxl: 6, xl: 8, lg: 24, md: 24, sm: 24, xs: 24 };
});

const getLevelNumberName = computed(() => {
  return record => {
    let name = '';
    if (record?.organizationLevel?.levelNumber) {
      let levelNumberData = levelNumberList.value.find(item => item.value == record?.organizationLevel?.levelNumber);
      if (levelNumberData) name = levelNumberData.name;
    }
    return name;
  };
});

onMounted(() => {});

// 切换高级查询
const changeSuperSearch = () => {
  superSearch.value = !superSearch.value;
};

// 左侧树选中
const treeSelect = (selectedKeys, metadata) => {
  where.value.orgId = selectedKeys[0];
  parentId.value = selectedKeys[0];
  parentName.value = metadata.node.orgName;
  reload();
};

// 更多点击
const moreClick = ({ key }) => {
  if (key == '1') {
    batchDelete();
  } else if (key == '2') {
    // 导入导出
    showImport.value = true;
  } else if (key == '3') {
    // 层级维护
    showLevel.value = true;
  }
};

// 刷新全部
const reloadAll = () => {
  orgTreeRef.value.reloadOrgTreeData();
  reload();
};

// 点击搜索
const reload = () => {
  tableRef.value.reload();
};

// 清除搜索条件
const clear = () => {
  where.value.searchText = '';
  where.value.statusFlag = null;
  where.value.orgId = null;
  orgTreeRef.value.currentSelectKeys = [];
  statusRef.value.changeDropname('状态');
  reload();
};

// 新增编辑点击
const openAddEdit = record => {
  if (!where.value.orgId) {
    parentName.value = '';
    parentId.value = '';
  }
  current.value = record;
  showEdit.value = true;
};

// 查看详情
const detail = record => {
  isShowApprover.value = false;
  current.value = record;
  showDetail.value = true;
};

// 设置审批人
const setApprover = record => {
  isShowApprover.value = true;
  current.value = record;
  showDetail.value = true;
};

// 删除单个
const remove = record => {
  Modal.confirm({
    title: '提示',
    content: '确定要删除选中的组织机构吗?',
    icon: createVNode(ExclamationCircleOutlined),
    maskClosable: true,
    onOk: async () => {
      const res = await OrgApi.delete({ orgId: record.orgId });
      message.success(res.message);
      reload();
    }
  });
};

// 批量删除
const batchDelete = () => {
  if (tableRef.value.selectedRowList && tableRef.value.selectedRowList.length == 0) {
    return message.warning('请选择需要删除的组织机构');
  }
  Modal.confirm({
    title: '提示',
    content: '确定要删除选中的组织机构吗?',
    icon: createVNode(ExclamationCircleOutlined),
    maskClosable: true,
    onOk: async () => {
      const res = await OrgApi.batchDelete({ orgIdList: tableRef.value.selectedRowList });
      message.success(res.message);
      reload();
    }
  });
};

// 左侧树点击新建
const addOrg = data => {
  parentId.value = data ? data.orgId : null;
  parentName.value = data ? data.orgName : null;
  current.value = null;
  showEdit.value = true;
};
// 左侧树点击编辑
const editOrg = data => {
  current.value = data;
  showEdit.value = true;
};

// 返回并加载数据
const backReload = () => {
  showImport.value = false;
  reload();
};
</script>

<style scoped lang="less"></style>
