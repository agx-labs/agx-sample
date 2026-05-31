<template>
  <div class="guns-layout">
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
                    <a-button type="primary" class="border-radius" @click="openAddEdit()" v-permission="['ADD_POSITION']"
                      ><plus-outlined />新建</a-button
                    >
                    <a-dropdown>
                      <template #overlay>
                        <a-menu @click="moreClick">
                          <div v-permission="['DELETE_POSITION']">
                            <a-menu-item key="1">
                              <icon-font iconClass="icon-opt-shanchu" color="#60666b"></icon-font>
                              <span>批量删除</span>
                            </a-menu-item>
                          </div>
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
                  showTableTool
                  :showToolTotal="false"
                  rowId="positionId"
                  ref="tableRef"
                  fieldBusinessCode="POSITION_TABLE"
                  url="/hrPosition/page"
                >
                  <template #toolLeft>
                    <a-input
                      v-model:value="where.searchText"
                      placeholder="名称、编码（回车搜索）"
                      @pressEnter="reload"
                      :bordered="false"
                      class="search-input"
                    >
                      <template #prefix>
                        <icon-font iconClass="icon-opt-search"></icon-font>
                      </template>
                    </a-input>
                  </template>
                  <template #bodyCell="{ column, record }">
                    <!-- 姓名 -->
                    <template v-if="column.dataIndex == 'positionName'">
                      <a @click="openAddEdit(record)">{{ record.positionName }}</a>
                    </template>
                    <!-- 操作 -->
                    <template v-if="column.key == 'action'">
                      <a-space :size="16">
                        <icon-font
                          iconClass="icon-opt-bianji"
                          font-size="24px"
                          title="编辑"
                          color="#60666b"
                          v-permission="['EDIT_POSITION']"
                          @click="openAddEdit(record)"
                        ></icon-font>
                        <icon-font
                          iconClass="icon-opt-shanchu"
                          font-size="24px"
                          title="删除"
                          color="#60666b"
                          v-permission="['DELETE_POSITION']"
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

    <!-- 新增编辑弹框 -->
    <PositionAddEdit v-model:visible="showEdit" v-if="showEdit" :data="current" @done="reload" />
  </div>
</template>

<script setup name="Position">
import { PositionApi } from './api/PositionApi';
import { ref, createVNode, onMounted } from 'vue';
import { message, Modal } from 'ant-design-vue/es';
import PositionAddEdit from './components/position-add-edit.vue';
import { ExclamationCircleOutlined } from '@ant-design/icons-vue';

defineOptions({
  name: 'Position'
});

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
    dataIndex: 'positionName',
    title: '职位名称',
    ellipsis: true,
    width: 200,
    isShow: true
  },
  {
    dataIndex: 'positionCode',
    title: '职位编码',
    width: 100,
    isShow: true
  },
  {
    dataIndex: 'remark',
    title: '备注',
    ellipsis: true,
    width: 200,
    isShow: true
  },
  {
    dataIndex: 'positionSort',
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
// ref
const tableRef = ref(null);

// 搜索条件
const where = ref({
  searchText: ''
});
// 当前行数据
const current = ref(null);
// 是否显示新增编辑弹框
const showEdit = ref(false);

onMounted(() => {});

// 更多点击
const moreClick = ({ key }) => {
  if (key == '1') {
    batchDelete();
  }
};

// 点击搜索
const reload = () => {
  tableRef.value.reload();
};

// 新增编辑点击
const openAddEdit = record => {
  current.value = record;
  showEdit.value = true;
};

// 删除单个
const remove = record => {
  Modal.confirm({
    title: '提示',
    content: '确定要删除选中的职位吗?',
    icon: createVNode(ExclamationCircleOutlined),
    maskClosable: true,
    onOk: async () => {
      const res = await PositionApi.delete({ positionId: record.positionId });
      message.success(res.message);
      reload();
    }
  });
};

// 批量删除
const batchDelete = () => {
  if (tableRef.value.selectedRowList && tableRef.value.selectedRowList.length == 0) {
    return message.warning('请选择需要删除的职位');
  }
  Modal.confirm({
    title: '提示',
    content: '确定要删除选中的职位吗?',
    icon: createVNode(ExclamationCircleOutlined),
    maskClosable: true,
    onOk: async () => {
      const res = await PositionApi.batchDelete({ positionIdList: tableRef.value.selectedRowList });
      message.success(res.message);
      reload();
    }
  });
};
</script>

<style scoped lang="less"></style>
