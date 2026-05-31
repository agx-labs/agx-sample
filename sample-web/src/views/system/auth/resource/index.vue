<template>
  <div class="guns-layout">
    <div class="guns-layout-content">
      <div class="guns-layout">
        <div class="guns-layout-content-header">资源</div>
        <div class="guns-layout-content-application">
          <div class="content-mian">
            <div class="content-mian-body">
              <div class="table-content">
                <common-table
                  :columns="columns"
                  :where="where"
                  rowId="resourceId"
                  ref="tableRef"
                  :showToolTotal="false"
                  showTableTool
                  :rowSelection="false"
                  url="resource/pageList"
                  fieldBusinessCode="RESOURCE_TABLE"
                >
                  <template #toolLeft>
                    <a-input
                      v-model:value="where.searchText"
                      placeholder="资源名称、路径、类名（回车搜索）"
                      @pressEnter="reload"
                      class="search-input"
                      style="width: 300px"
                      :bordered="false"
                    >
                      <template #prefix>
                        <icon-font iconClass="icon-opt-search"></icon-font>
                      </template>
                    </a-input>
                  </template>
                  <template #bodyCell="{ column, record }">
                    <template v-if="column.dataIndex == 'requiredLoginFlag'">
                      <a-tag color="blue" v-if="record.requiredLoginFlag == 'Y'">是</a-tag>
                      <a-tag color="orange" v-if="record.requiredLoginFlag == 'N'">否</a-tag>
                    </template>
                    <template v-if="column.dataIndex == 'requiredPermissionFlag'">
                      <a-tag color="blue" v-if="record.requiredPermissionFlag == 'Y'">是</a-tag>
                      <a-tag color="orange" v-if="record.requiredPermissionFlag == 'N'">否</a-tag>
                    </template>
                  </template>
                </common-table>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup name="AuthResource">
import { ref, onMounted } from 'vue';

defineOptions({
  name: 'AuthResource'
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
    dataIndex: 'resourceName',
    title: '资源名称',
    ellipsis: true,
    width: 200,
    isShow: true
  },
  {
    dataIndex: 'url',
    title: '请求地址',
    width: 100,
    isShow: true
  },
  {
    dataIndex: 'className',
    title: '控制器类',
    width: 100,
    isShow: true
  },
  {
    dataIndex: 'httpMethod',
    title: 'HTTP请求',
    width: 100,
    isShow: true
  },
  {
    dataIndex: 'requiredLoginFlag',
    title: '需要登录',
    width: 100,
    isShow: true
  },
  {
    dataIndex: 'requiredPermissionFlag',
    title: '需要鉴权',
    width: 100,
    isShow: true
  },
  {
    dataIndex: 'ipAddress',
    title: '上次汇报IP',
    width: 100,
    isShow: true
  },
  {
    dataIndex: 'createTime',
    title: '创建时间',
    width: 150,
    isShow: true
  }
]);
// ref
const tableRef = ref(null);

// 搜索条件
const where = ref({
  searchText: ''
});

onMounted(() => {});

// 点击搜索
const reload = () => {
  tableRef.value.reload();
};
</script>

<style scoped lang="less"></style>
