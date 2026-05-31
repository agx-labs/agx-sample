<template>
  <div class="guns-layout">
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
                    <a-button class="border-radius" @click="clear">重置</a-button>
                    <a-button type="primary" class="border-radius" @click="reload">
                      <search-outlined />查询
                    </a-button>
                  </a-space>
                </div>
              </div>
            </div>
            <div class="content-mian-body">
              <div class="table-content">
                <common-table
                  :columns="columns"
                  :where="where"
                  rowId="taskInstId"
                  ref="tableRef"
                  :rowSelection="false"
                  url="/taskInstance/page"
                  methods="post"
                  showTableTool
                  :showToolTotal="false"
                  fieldBusinessCode="TASK_INSTANCE_TABLE"
                >
                  <template #toolLeft>
                    <a-input
                      v-model:value="where.taskName"
                      placeholder="任务名称（回车搜索）"
                      :bordered="false"
                      @pressEnter="reload"
                      class="search-input"
                    >
                      <template #prefix>
                        <icon-font iconClass="icon-opt-search"></icon-font>
                      </template>
                    </a-input>
                    <a-divider type="vertical" class="divider" />
                    <a @click="toggleSuperSearch">{{ superSearch ? '收起' : '高级筛选' }}</a>
                  </template>
                  <template #toolBottom>
                    <div v-show="superSearch" style="margin-top: 8px;">
                      <a-form :model="where" layout="inline">
                        <a-form-item label="触发类型:">
                          <a-select
                            v-model:value="where.triggerType"
                            placeholder="请选��触发类型"
                            style="width: 140px"
                            allow-clear
                            @change="reload"
                          >
                            <a-select-option value="auto">自动</a-select-option>
                            <a-select-option value="manual">手动</a-select-option>
                            <a-select-option value="retry">重试</a-select-option>
                          </a-select>
                        </a-form-item>
                        <a-form-item label="处理结果:">
                          <a-select
                            v-model:value="where.handleResult"
                            placeholder="请选择处理结果"
                            style="width: 140px"
                            allow-clear
                            @change="reload"
                          >
                            <a-select-option value="success">成功</a-select-option>
                            <a-select-option value="fail">失败</a-select-option>
                            <a-select-option value="running">运行中</a-select-option>
                          </a-select>
                        </a-form-item>
                      </a-form>
                    </div>
                  </template>
                  <template #bodyCell="{ column, record }">
                    <template v-if="column?.dataIndex === 'taskName'">
                      <a @click="openDetail(record)">{{ record.taskName }}</a>
                    </template>
                    <template v-if="column?.dataIndex === 'triggerType'">
                      <a-tag :color="triggerTypeColor(record.triggerType)">
                        {{ triggerTypeLabel(record.triggerType) }}
                      </a-tag>
                    </template>
                    <template v-if="column?.dataIndex === 'handleResult'">
                      <a-tag :color="handleResultColor(record.handleResult)">
                        {{ handleResultLabel(record.handleResult) }}
                      </a-tag>
                    </template>
                    <template v-if="column?.key === 'action'">
                      <a-space :size="16">
                        <icon-font iconClass="icon-opt-xiangqing" font-size="24px" title="详情" color="#60666b" @click="openDetail(record)"></icon-font>
                        <icon-font iconClass="icon-opt-rizhichaxun" font-size="24px" title="查看日志" color="#60666b" @click="openLog(record)"></icon-font>
                        <a-tooltip title="重试" v-if="record.handleResult === 'fail'">
                          <icon-font iconClass="icon-opt-run" font-size="24px" color="#1890ff" @click="retryInstance(record)"></icon-font>
                        </a-tooltip>
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
    <TaskInstanceDetail v-model:visible="showDetail" :data="current" />
    <TaskInstanceLog v-model:visible="showLog" :data="current" />
  </div>
</template>
<script setup name="TaskInstance">
import { ref, createVNode } from 'vue';
import { message, Modal } from 'ant-design-vue/es';
import { ExclamationCircleOutlined, SearchOutlined } from '@ant-design/icons-vue';
import { TaskInstanceApi } from './api/TaskInstanceApi';
import TaskInstanceDetail from './components/task-instance-detail.vue';
import TaskInstanceLog from './components/task-instance-log.vue';
defineOptions({ name: 'TaskInstance' });
const columns = ref([
  { key: 'index', title: '序号', width: 60, align: 'center', isShow: true, hideInSetting: true },
  { dataIndex: 'taskName', title: '任务名称', ellipsis: true, width: 180, isShow: true },
  { dataIndex: 'taskCode', title: '任务编码', ellipsis: true, width: 160, isShow: true },
  { dataIndex: 'triggerType', title: '触发类型', width: 100, isShow: true },
  { dataIndex: 'startTime', title: '处理开始时间', width: 160, isShow: true },
  { dataIndex: 'endTime', title: '处理结束时间', width: 160, isShow: true },
  { dataIndex: 'handleResult', title: '处理结果', width: 100, isShow: true },
  { dataIndex: 'handleMsg', title: '处理消息', ellipsis: true, width: 220, isShow: true },
  { key: 'action', title: '操作', width: 110, isShow: true }
]);
const tableRef = ref(null);
const where = ref({ taskName: '', triggerType: null, handleResult: null });
const current = ref(null);
const showDetail = ref(false);
const showLog = ref(false);
const superSearch = ref(false);
const reload = () => tableRef.value.reload();
const clear = () => {
  where.value = { taskName: '', triggerType: null, handleResult: null };
  reload();
};
const toggleSuperSearch = () => {
  superSearch.value = !superSearch.value;
};
const openDetail = record => {
  current.value = record;
  showDetail.value = true;
};
const openLog = record => {
  current.value = record;
  showLog.value = true;
};
const retryInstance = record => {
  Modal.confirm({
    title: '提示',
    content: '确定要重试该任务实例吗？',
    icon: createVNode(ExclamationCircleOutlined),
    maskClosable: true,
    onOk: async () => {
      const res = await TaskInstanceApi.retry({ taskInstId: record.taskInstId });
      message.success(res.message || '重试指令已发送');
      reload();
    }
  });
};
const triggerTypeLabel = type => ({ auto: '自动', manual: '手动', retry: '重试' }[type] || type);
const triggerTypeColor = type => ({ auto: 'blue', manual: 'orange', retry: 'purple' }[type] || 'default');
const handleResultLabel = result => ({ success: '成功', fail: '失败', running: '运行中' }[result] || result);
const handleResultColor = result => ({ success: 'success', fail: 'error', running: 'processing' }[result] || 'default');
</script>
<style scoped lang="less"></style>