<template>
  <div class="guns-layout">
    <div class="guns-layout-content">
      <div class="guns-layout">
        <div class="guns-layout-content-header">在线用户</div>
        <div class="guns-layout-content-application">
          <div class="content-mian">
            <div class="content-mian-body">
              <div class="table-content">
                <common-table
                  :columns="columns"
                  :where="where"
                  rowId="userId"
                  ref="tableRef"
                  :isPage="false"
                  :customData="customData"
                  url="/getOnlineUserList"
                  showTableTool
                  :showToolTotal="false"
                  fieldBusinessCode="ONLINE_TABLE"
                >
                  <template #toolLeft>
                    <a-input
                      v-model:value="where.searchText"
                      placeholder="用户账号（回车搜索）"
                      :bordered="false"
                      @pressEnter="reload"
                      class="search-input"
                    >
                      <template #prefix>
                        <icon-font iconClass="icon-opt-search"></icon-font>
                      </template>
                    </a-input>
                  </template>
                  <template #bodyCell="{ column, record }">
                    <!-- 操作 -->
                    <template v-if="column.key == 'action'">
                      <a-space :size="16">
                        <icon-font
                          iconClass="icon-opt-tixiaxian"
                          color="#60666b"
                          font-size="24px"
                          title="踢下线"
                          @click="kickOff(record)"
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
  </div>
</template>

<script setup name="Online">
import { OnlineApi } from './api/OnlineApi';
import { ref, onMounted } from 'vue';
import { message } from 'ant-design-vue/es';

defineOptions({
  name: 'Online'
});

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
    dataIndex: 'realName',
    title: '姓名',
    ellipsis: true,
    isShow: true
  },
  {
    dataIndex: 'account',
    title: '账号',
    isShow: true
  },
  {
    dataIndex: 'loginTime',
    title: '登录时间',
    ellipsis: true,
    isShow: true
  },
  {
    dataIndex: 'loginIp',
    title: '登录IP',
    isShow: true
  },
  {
    key: 'action',
    title: '操作',
    width: 60,
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

// 自定义数据
const customData = res => {
  res.data = res.data.onlineUserList;
  return res;
};

// 踢下线
const kickOff = record => {
  OnlineApi.offlineUser({ token: record.token }).then(res => {
    message.success(res.message);
    reload();
  });
};
</script>

<style scoped lang="less"></style>
