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
        <a-input v-model:value="where.taskName" class="search-input" :bordered="false" allow-clear placeholder="任务名称（回车搜索）" @pressEnter="reload">
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
        <a-space :size="16">
          <icon-font iconClass="icon-opt-xiangqing" font-size="24px" color="#60666b" title="详情" @click="openDetail(record)" />
          <a @click="openLog(record)">运行日志</a>
          <a-tooltip :title="record.handleResult === 'fail' ? '重试' : '仅失败实例可重试'">
            <a :class="{ disabledAction: record.handleResult !== 'fail' }" @click="retry(record)">重试</a>
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
const createWhere = () => ({ taskName: '', taskCode: '', executionType: undefined, handleResult: undefined, ...(props.taskId ? { taskId: props.taskId } : {}) });
const where = ref(createWhere());
const showSearch = ref(Boolean(props.embedded));
const current = ref(null);
const logRecord = ref(null);
const showDetail = ref(false);
const showLog = ref(false);
let retryModal = null;
const reload = () => tableRef.value?.reload();
const reset = () => { where.value = createWhere(); reload(); };
const openDetail = record => { current.value = record; showDetail.value = true; };
const openLog = record => { showDetail.value = false; logRecord.value = record; showLog.value = true; };
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
onScopeDispose(() => retryModal?.destroy());
defineExpose({ reload, reset });
</script>

<style scoped>
.super-search { margin-top: 8px; }
.disabledAction { color: #bfbfbf; cursor: not-allowed; }
</style>
