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
                    <a-button type="primary" class="border-radius" @click="openAddEdit()"><plus-outlined />新建</a-button>
                  </a-space>
                </div>
              </div>
            </div>
            <div class="content-mian-body">
              <div class="table-content">
                <common-table
                  :columns="columns"
                  :where="where"
                  rowId="fieldId"
                  ref="tableRef"
                  :rowSelection="false"
                  url="/sysThemeTemplateField/findPage"
                  showTableTool
                  :showToolTotal="false"
                  fieldBusinessCode="THMEM_ATTR_TABLE"
                >
                  <template #toolLeft>
                    <a-input
                      v-model:value="where.fieldName"
                      placeholder="主题属性名称（回车搜索）"
                      @pressEnter="reload"
                      class="search-input"
                      :bordered="false"
                      style="width: 240px"
                    >
                      <template #prefix>
                        <icon-font iconClass="icon-opt-search"></icon-font>
                      </template>
                    </a-input>
                  </template>
                  <template #bodyCell="{ column, record }">
                    <template v-if="column.dataIndex == 'fieldName'">
                      <a @click="openAddEdit(record)">{{ record.fieldName }}</a>
                    </template>

                    <template v-if="column.dataIndex == 'fieldRequired'">
                      <span v-if="record.fieldRequired == 'Y'">是</span>
                      <span v-if="record.fieldRequired == 'N'">否</span>
                    </template>

                    <!-- 操作 -->
                    <template v-if="column.key == 'action'">
                      <a-space :size="16">
                        <icon-font
                          iconClass="icon-opt-bianji"
                          font-size="24px"
                          title="编辑"
                          color="#60666b"
                          @click="openAddEdit(record)"
                        ></icon-font>
                        <icon-font
                          iconClass="icon-opt-shanchu"
                          font-size="24px"
                          title="删除"
                          color="#60666b"
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
    <AttrAddEdit v-model:visible="showEdit" v-if="showEdit" :data="current" @done="reload" />
  </div>
</template>

<script setup name="ThemeAttr">
import { ThemeTemplateFieldApi } from './api/ThemeTemplateFieldApi';
import { ref, createVNode, onMounted } from 'vue';
import { message, Modal } from 'ant-design-vue/es';
import AttrAddEdit from './components/attr-add-edit.vue';
import { ExclamationCircleOutlined } from '@ant-design/icons-vue';

// 表格配置
const columns = ref([
  {
    key: 'index',
    title: '序号',
    width: 60,
    align: 'center',
    isShow: true,
    hideInSetting: true
  },
  {
    title: '属性名称',
    isShow: true,
    dataIndex: 'fieldName'
  },
  {
    title: '属性编码',
    isShow: true,
    dataIndex: 'fieldCode'
  },
  {
    title: '属性类型',
    isShow: true,
    dataIndex: 'fieldType'
  },
  {
    title: '是否必填',
    isShow: true,
    width: 100,
    dataIndex: 'fieldRequired'
  },
  {
    title: '属性长度',
    isShow: true,
    width: 100,
    dataIndex: 'fieldLength'
  },
  {
    title: '属性描述',
    isShow: true,
    dataIndex: 'fieldDescription'
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
  fieldName: ''
});
// 当前行数据
const current = ref(null);
// 是否显示新增编辑弹框
const showEdit = ref(false);

onMounted(() => {});

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
    content: '确定要删除选中的属性吗?',
    icon: createVNode(ExclamationCircleOutlined),
    maskClosable: true,
    onOk: async () => {
      const res = await ThemeTemplateFieldApi.del({ fieldId: record.fieldId });
      message.success(res.message);
      reload();
    }
  });
};
</script>

<style scoped lang="less"></style>
