<template>
  <common-table
    ref="tableRef" :columns="columns" :where="where" rowId="taskInstId" :rowSelection="false"
    url="/taskInstance/page" methods="post" showTableTool :showToolTotal="false"
    :height100="!props.embedded"
    :tools="props.embedded ? ['reload', 'size'] : ['reload', 'size', 'columns', 'fullscreen']"
    :fieldBusinessCode="props.embedded ? '' : 'TASK_INSTANCE_TABLE_V2'"
  >
    <template #toolLeft>
      <template v-if="!props.embedded">
        <a-input v-model:value="where.keyword" class="search-input" :bordered="false" allow-clear placeholder="任务名称或编码（回车搜索）" @pressEnter="reload">
          <template #prefix><icon-font iconClass="icon-opt-search" /></template>
        </a-input>
        <a-divider type="vertical" class="divider" />
      </template>
      <a @click="showSearch = !showSearch">{{ showSearch ? '收起筛选' : '筛选' }}</a>
    </template>
    <template #toolBottom>
      <div v-show="showSearch" class="super-search">
        <a-form layout="inline">
          <a-form-item v-if="!props.embedded" label="任务编码">
            <a-input v-model:value="where.taskCode" placeholder="请输入任务编码" allow-clear @pressEnter="reload" />
          </a-form-item>
          <a-form-item v-if="!props.embedded" label="执行类型">
            <a-select v-model:value="where.executionType" placeholder="全部" allow-clear style="width: 130px" @change="reload">
              <a-select-option v-for="item in executionTypes" :key="item.value" :value="item.value">{{ item.label }}</a-select-option>
            </a-select>
          </a-form-item>
          <a-form-item label="执行结果">
            <a-select v-model:value="where.handleResult" placeholder="全部" allow-clear style="width: 120px" @change="reload">
              <a-select-option v-for="item in handleResults" :key="item.value" :value="item.value">{{ item.label }}</a-select-option>
            </a-select>
          </a-form-item>
          <a-form-item label="开始时间">
            <a-range-picker v-model:value="startTimeRange" value-format="YYYY-MM-DD" allow-clear @change="onStartTimeRangeChange" />
          </a-form-item>
          <a-form-item label="结束时间">
            <a-range-picker v-model:value="endTimeRange" value-format="YYYY-MM-DD" allow-clear @change="onEndTimeRangeChange" />
          </a-form-item>
          <a-form-item>
            <a-button type="primary" @click="reload">查询</a-button>
            <a-button style="margin-left: 8px" @click="reset">重置</a-button>
          </a-form-item>
        </a-form>
      </div>
    </template>
    <template #bodyCell="{ column, record }">
      <template v-if="column.dataIndex === 'taskName'"><a @click="openDetail(record)">{{ record.taskName || '-' }}</a></template>
      <template v-else-if="column.dataIndex === 'executionType'">{{ optionOf(executionTypes, executionTypeOf(record)).label }}</template>
      <template v-else-if="column.dataIndex === 'triggerType'">
        <a-tag :color="optionOf(triggerTypes, record.triggerType).color">{{ optionOf(triggerTypes, record.triggerType).label }}</a-tag>
      </template>
      <template v-else-if="column.dataIndex === 'handleResult'">
        <a-tag :color="optionOf(handleResults, record.handleResult).color">{{ optionOf(handleResults, record.handleResult).label }}</a-tag>
      </template>
      <template v-else-if="column.key === 'duration'">{{ durationOf(record) }}</template>
      <template v-else-if="column.key === 'action'">
        <a-space :size="2" class="instance-actions">
          <a-tooltip title="详情">
            <a-button type="text" aria-label="详情" @click="openDetail(record)"><eye-outlined /></a-button>
          </a-tooltip>
          <a-tooltip title="运行日志">
            <a-button type="text" aria-label="运行日志" @click="openLog(record)"><file-search-outlined /></a-button>
          </a-tooltip>
          <a-tooltip v-if="record.handleResult === 'running'" title="刷新状态">
            <a-button type="text" aria-label="刷新状态" @click="refreshInstance(record)"><reload-outlined /></a-button>
          </a-tooltip>
          <a-tooltip v-if="record.handleResult === 'running'" title="停止任务">
            <a-button type="text" danger aria-label="停止任务" @click="stopInstance(record)"><stop-outlined /></a-button>
          </a-tooltip>
          <a-tooltip :title="record.handleResult === 'fail' ? '重试' : '仅失败实例可重试'">
            <span class="retry-action">
              <a-button type="text" aria-label="重试" :disabled="record.handleResult !== 'fail'" @click="retry(record)"><play-circle-outlined /></a-button>
            </span>
          </a-tooltip>
        </a-space>
      </template>
    </template>
  </common-table>
  <TaskInstanceDetail v-if="showDetail" v-model:visible="showDetail" :data="current" />
  <TaskInstanceLog v-if="showLog" v-model:visible="showLog" :data="logRecord" />
</template>

<script setup>
import { computed, onScopeDispose, ref, watch } from 'vue';
import { message, Modal } from 'ant-design-vue/es';
import { EyeOutlined, FileSearchOutlined, PlayCircleOutlined, ReloadOutlined, StopOutlined } from '@ant-design/icons-vue';
import dayjs from 'dayjs';
import { TaskInstanceApi } from '../api/TaskInstanceApi';
import TaskInstanceDetail from './task-instance-detail.vue';
import TaskInstanceLog from './task-instance-log.vue';
import { durationOf, executionTypeOf, executionTypes, handleResults, optionOf, triggerTypes } from '../../task-model';

const props = defineProps({ taskId: [String, Number], embedded: Boolean });
const allColumns = [
  { key: 'index', title: '序号', width: 60, align: 'center', isShow: true, hideInSetting: true },
  { dataIndex: 'taskName', title: '任务名称', ellipsis: true, width: 180, isShow: true },
  { dataIndex: 'taskCode', title: '任务编码', ellipsis: true, width: 140, isShow: true },
  { dataIndex: 'executionType', title: '执行类型', width: 105, isShow: true },
  { dataIndex: 'triggerType', title: '触发类型', width: 100, isShow: true },
  { dataIndex: 'handleResult', title: '处理结果', width: 100, isShow: true },
  { dataIndex: 'startTime', title: '开始时间', width: 175, isShow: true },
  { dataIndex: 'endTime', title: '结束时间', width: 175, isShow: true },
  { key: 'duration', title: '耗时', width: 100, isShow: true },
  { key: 'action', title: '操作', width: 190, isShow: true }
];
const columns = computed(() => props.embedded
  ? allColumns.filter((column) => !['taskName', 'taskCode'].includes(column.dataIndex))
  : allColumns);
const tableRef = ref(null);
const createWhere = () => ({
  keyword: '',
  taskCode: '',
  executionType: undefined,
  handleResult: undefined,
  startTimeFrom: undefined,
  startTimeTo: undefined,
  endTimeFrom: undefined,
  endTimeTo: undefined,
  ...(props.taskId ? { taskId: props.taskId } : {})
});
const where = ref(createWhere());
const startTimeRange = ref([]);
const endTimeRange = ref([]);
const showSearch = ref(false);
const current = ref(null);
const logRecord = ref(null);
const showDetail = ref(false);
const showLog = ref(false);
let retryModal = null;
let stopModal = null;
const reload = () => tableRef.value?.reload();
const reset = () => {
  startTimeRange.value = [];
  endTimeRange.value = [];
  where.value = createWhere();
  reload();
};
const applyTimeRange = (range, beginKey, endKey) => {
  where.value[beginKey] = range?.[0] ? dayjs(range[0]).startOf('day').valueOf() : undefined;
  where.value[endKey] = range?.[1] ? dayjs(range[1]).add(1, 'day').startOf('day').valueOf() : undefined;
  reload();
};
const onStartTimeRangeChange = range => applyTimeRange(range, 'startTimeFrom', 'startTimeTo');
const onEndTimeRangeChange = range => applyTimeRange(range, 'endTimeFrom', 'endTimeTo');
const openDetail = record => { current.value = record; showDetail.value = true; };
const openLog = record => { showDetail.value = false; logRecord.value = record; showLog.value = true; };
const refreshInstance = async record => {
  await TaskInstanceApi.refresh({ taskInstId: record.taskInstId });
  reload();
};
const stopInstance = record => {
  if (record.handleResult !== 'running' || stopModal) return;
  stopModal = Modal.confirm({
    title: '提示', content: `确定要停止任务「${record.taskName}」吗？`,
    onCancel: () => { stopModal = null; },
    onOk: async () => {
      try {
        await TaskInstanceApi.stop({ taskInstId: record.taskInstId });
        message.success('停止请求已发送');
        reload();
      } finally {
        stopModal = null;
      }
    }
  });
};
const retry = record => {
  if (record.handleResult !== 'fail' || retryModal) return;
  retryModal = Modal.confirm({
    title: '提示', content: `确定要重试任务「${record.taskName}」吗？`,
    onCancel: () => { retryModal = null; },
    onOk: async () => {
      try {
        await TaskInstanceApi.retry({ taskInstId: record.taskInstId });
        message.success('重试请求已发送');
        reload();
      } finally {
        retryModal = null;
      }
    }
  });
};
watch(() => props.taskId, reset);
onScopeDispose(() => {
  retryModal?.destroy();
  stopModal?.destroy();
});
defineExpose({ reload, reset });
</script>

<style scoped>
.super-search { margin-top: 8px; }
.instance-actions { white-space: nowrap; }
.instance-actions :deep(.ant-btn) { width: 28px; min-width: 28px; height: 28px; padding: 0; }
</style>
