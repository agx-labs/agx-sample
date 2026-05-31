<template>
  <div class="guns-layout">
    <guns-split-layout width="292px">
      <div class="guns-layout-sidebar p-t-12 width-100">
        <div class="sidebar-content">
          <config-type @defaultSelect="defaultSelect" @treeSelect="treeSelect"></config-type>
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
                        <a-button type="primary" class="border-radius" @click="openAddEdit()"><plus-outlined />新建</a-button>
                        <a-dropdown>
                          <template #overlay>
                            <a-menu @click="moreClick">
                              <a-menu-item key="1">
                                <icon-font iconClass="icon-opt-shanchu" color="#60666b"></icon-font>
                                <span>批量删除</span>
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
                      :isInit="false"
                      rowId="configId"
                      ref="tableRef"
                      :scroll="{ y: '100%' }"
                      url="/sysConfig/page"
                      showTableTool
                      :showToolTotal="false"
                      :loading="loading"
                      :pageSize="50"
                      fieldBusinessCode="SYS_CONFIG_TABLE"
                    >
                      <template #toolLeft>
                        <a-input
                          v-model:value="where.searchText"
                          placeholder="名称、编码（回车搜索）"
                          @pressEnter="reload"
                          class="search-input"
                          :bordered="false"
                        >
                          <template #prefix>
                            <icon-font iconClass="icon-opt-search"></icon-font>
                          </template>
                        </a-input>
                      </template>
                      <template #bodyCell="{ column, record }">
                        <template v-if="column?.dataIndex == 'configName'">
                          <a @click="openAddEdit(record)">{{ record.configName }}</a>
                        </template>
                        <template v-if="column?.dataIndex == 'configValue'">
                          <template v-if="record.configCode == 'SYS_FILE_SAVE_TYPE'">
                            <a-radio-group v-model:value="record.configValue" @change="configValueBlur(record)">
                              <a-radio :style="radioStyle" :value="item.key" v-for="item in fileSaveTypeList">{{ item.name }}</a-radio>
                            </a-radio-group>
                          </template>
                          <template v-else-if="record.configValue == 'false' || record.configValue == 'true'">
                            <a-radio-group v-model:value="record.configValue" @change="configValueBlur(record)">
                              <a-radio value="true">是</a-radio>
                              <a-radio value="false">否</a-radio>
                            </a-radio-group>
                          </template>
                          <a-textarea
                            v-else
                            v-model:value="record.configValue"
                            autosize
                            placeholder="请输入"
                            @blur="configValueBlur(record)"
                          ></a-textarea>
                        </template>
                        <!-- 配置类型 -->
                        <template v-if="column?.dataIndex == 'sysFlag'">
                          <a-tag color="green" v-if="record.sysFlag == 'Y'">是</a-tag>
                          <a-tag color="red" v-if="record.sysFlag == 'N'">否</a-tag>
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
      </template>
    </guns-split-layout>

    <!-- 新增编辑弹框 -->
    <ConfigAddEdit v-model:visible="showEdit" v-if="showEdit" :data="current" @done="reload" :groupCode="where.groupCode" />
  </div>
</template>

<script setup name="SysConfig">
import { SysConfigApi } from './api/SysConfigApi';
import { ref, createVNode, onMounted, reactive } from 'vue';
import { message, Modal } from 'ant-design-vue/es';
import ConfigType from './components/config-type/config-type.vue';
import { ExclamationCircleOutlined } from '@ant-design/icons-vue';
import ConfigAddEdit from './components/config/config-add-edit.vue';

defineOptions({
  name: 'SysConfig'
});

// 表格配置
const columns = ref([
  {
    dataIndex: 'configName',
    title: '配置名称',
    ellipsis: true,
    width: 300,
    isShow: true
  },
  // {
  //   dataIndex: 'configCode',
  //   title: '配置编码',
  //   width: 100,
  //   isShow: true
  // },
  {
    dataIndex: 'configValue',
    title: '属性值',
    ellipsis: true,
    // width: 100,
    isShow: true
  },
  // {
  //   dataIndex: 'sysFlag',
  //   title: '系统类型',
  //   width: 100,
  //   isShow: true
  // },
  {
    key: 'action',
    title: '操作',
    width: 80,
    fixed: 'right',
    isShow: true
  }
]);
// ref
const tableRef = ref(null);
// 搜索条件
const where = ref({
  searchText: '',
  groupCode: ''
});
// 当前行数据
const current = ref(null);
// 是否显示新增编辑弹框
const showEdit = ref(false);

const loading = ref(false);

const fileSaveTypeList = ref([
  {
    key: '10',
    name: '本地，存储到默认路径（jar所在目录）'
  },
  {
    key: '11',
    name: '本地，存储到指定路径下（需要配置linux和windows的路径）'
  },
  {
    key: '20',
    name: '存储到MinIO'
  },
  {
    key: '30',
    name: '存储到阿里云'
  },
  {
    key: '40',
    name: '存储到腾讯云'
  },
  {
    key: '50',
    name: '存储到青云'
  }
]);

const radioStyle = reactive({
  display: 'flex',
  height: '30px',
  lineHeight: '30px'
});

onMounted(() => {});

// 默认选中分类
const defaultSelect = code => {
  where.value.groupCode = code;
  reload();
};

// 左侧树选中
const treeSelect = (selectedKeys, metadata) => {
  where.value.groupCode = selectedKeys[0];
  reload();
};

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
    content: '确定要删除选中的配置吗?',
    icon: createVNode(ExclamationCircleOutlined),
    maskClosable: true,
    onOk: async () => {
      const res = await SysConfigApi.delete({ configId: record.configId });
      message.success(res.message);
      reload();
    }
  });
};

// 批量删除
const batchDelete = () => {
  if (tableRef.value.selectedRowList && tableRef.value.selectedRowList.length == 0) {
    return message.warning('请选择需要删除的配置');
  }
  Modal.confirm({
    title: '提示',
    content: '确定要删除选中的配置吗?',
    icon: createVNode(ExclamationCircleOutlined),
    maskClosable: true,
    onOk: async () => {
      const res = await SysConfigApi.batchDelete({ configIdList: tableRef.value.selectedRowList });
      message.success(res.message);
      reload();
    }
  });
};

// 属性值失去焦点
const configValueBlur = record => {
  loading.value = true;
  SysConfigApi.edit(record)
    .then(res => {
      message.success(res.message);
    })
    .finally(() => (loading.value = false));
};
</script>

<style scoped lang="less"></style>
