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
                    <a-popconfirm title="是否清空所有日志？" @confirm="cleanAllLoginLog">
                      <template #icon>
                        <question-circle-outlined />
                      </template>
                      <a-button danger>
                        <template #icon>
                          <delete-outlined />
                        </template>
                        <span>清空日志</span>
                      </a-button>
                    </a-popconfirm>
                  </a-space>
                </div>
              </div>
            </div>
            <div class="content-mian-body">
              <div class="table-content">
                <common-table
                  :columns="columns"
                  :where="where"
                  rowId="llgId"
                  size="default"
                  ref="tableRef"
                  :rowSelection="false"
                  url="/loginLog/page"
                  showTableTool
                  :showToolTotal="false"
                  fieldBusinessCode="LOGIN_LOG_TABLE"
                >
                  <template #toolLeft>
                    <a-input
                      v-model:value="where.llgName"
                      placeholder="日志名称（回车搜索）"
                      @pressEnter="reload"
                      class="search-input"
                      :bordered="false"
                    >
                      <template #prefix>
                        <icon-font iconClass="icon-opt-search"></icon-font>
                      </template>
                    </a-input>
                    <a-divider type="vertical" class="divider" />
                    <a @click="changeSuperSearch">{{ superSearch ? '收起' : '高级筛选' }} </a>
                  </template>
                  <template #bodyCell=""></template>
                  <template #toolBottom>
                    <div class="super-search" style="margin-top: 8px" v-show="superSearch">
                      <a-form :model="where" :labelCol="labelCol" :wrapper-col="wrapperCol">
                        <a-row :gutter="16">
                          <a-col v-bind="spanCol">
                            <a-form-item label="日期范围:">
                              <a-range-picker
                                v-model:value="dateRange"
                                class="search-date"
                                value-format="YYYY-MM-DD"
                                @change="reload"
                                style="width: 100%"
                              />
                            </a-form-item>
                          </a-col>
                          <a-col v-bind="spanCol">
                            <a-form-item label="用户:">
                              <a-input
                                v-model:value="where.userName"
                                placeholder="请选择用户"
                                class="search-date"
                                @focus="selectUser"
                              ></a-input>
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
                </common-table>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 选择用户 -->
    <Selection
      v-model:visible="visibleSelection"
      v-if="visibleSelection"
      :data="selectedData"
      :showTab="['user']"
      :changeHeight="true"
      title="人员选择"
      @done="closeSelection"
    ></Selection>
  </div>
</template>

<script setup name="LoginLog">
import { LoginLogApi } from './api/LoginLogApi';
import { ref, onMounted, computed } from 'vue';
import { message } from 'ant-design-vue/es';
import { isMobile } from '@/utils/common/util';

// 表格配置
const columns = ref([
  {
    key: 'index',
    title: '序号',
    width: 60,
    align: 'center',
    isShow: true
  },
  {
    dataIndex: 'userIdWrapper',
    title: '用户名',
    isShow: true,
    width: 100
  },
  {
    dataIndex: 'account',
    title: '账号',
    isShow: true,
    width: 100
  },
  {
    dataIndex: 'llgName',
    title: '日志名称',
    isShow: true
  },
  {
    dataIndex: 'llgSucceed',
    title: '执行结果',
    isShow: true
  },
  {
    dataIndex: 'createTime',
    title: '时间',
    isShow: true
  },
  {
    dataIndex: 'llgMessage',
    title: '具体消息',
    isShow: true
  },
  {
    title: 'IP',
    dataIndex: 'llgIpAddress',
    isShow: true
  }
]);
// ref
const tableRef = ref(null);
// 时间范围
const dateRange = ref(null);

// 搜索条件
const where = ref({
  beginTime: null,
  endTime: null,
  userId: '',
  userName: '',
  llgName: ''
});

// 是否显示选择人员弹框
const visibleSelection = ref(false);

// 选择弹框总数据
const selectedData = ref({
  selectUserList: []
});

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

onMounted(() => {});

// 切换高级查询
const changeSuperSearch = () => {
  superSearch.value = !superSearch.value;
};

// 点击搜索
const reload = () => {
  const [beginTime, endTime] = dateRange.value || [null, null];
  where.value.beginTime = beginTime;
  where.value.endTime = endTime;
  tableRef.value.reload();
};

// 清除搜索条件
const clear = () => {
  dateRange.value = null;
  where.value = {
    beginTime: null,
    endTime: null,
    userId: '',
    userName: '',
    llgName: ''
  };
  reload();
};

/**
 * 清空所有日志
 *
 * @author luojie
 * @date 2021/4/13 14:32
 */
const cleanAllLoginLog = async () => {
  const result = await LoginLogApi.deleteAll(where.value);
  message.success(result.message);
  reload();
};

// 选择用户
const selectUser = () => {
  const { userName, userId } = where.value;
  if (userName && userId) {
    selectedData.value.selectUserList = [{ bizId: userId, name: userName }];
  }
  visibleSelection.value = true;
};

// 关闭选择用户
const closeSelection = data => {
  const { bizId, name } = data.selectUserList[0] || { bizId: '', name: '' };
  where.value.userName = name;
  where.value.userId = bizId;
  reload();
};
</script>

<style scoped lang="less"></style>
