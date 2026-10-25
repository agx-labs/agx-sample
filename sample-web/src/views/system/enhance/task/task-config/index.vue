<template>
  <div class="guns-layout">
    <div class="guns-layout-content">
      <div class="guns-layout">
        <div class="guns-layout-content-application">
          <div class="content-mian">
            <div class="content-mian-header">
              <div class="header-content">
                <div class="header-content-left"><a-space :size="16" /></div>
                <div class="header-content-right">
                  <a-button type="primary" class="border-radius" @click="openEdit()"><plus-outlined />新建</a-button>
                </div>
              </div>
            </div>
            <div class="content-mian-body">
              <div class="table-content">
                <common-table
                  ref="tableRef" :columns="columns" :where="where" rowId="taskId"
                  :rowSelection="false" url="/taskConfig/page" methods="post"
                  showTableTool :showToolTotal="false" fieldBusinessCode="TASK_CONFIG_TABLE_V2"
                >
                  <template #toolLeft>
                    <a-input v-model:value="where.keyword" class="search-input" :bordered="false" allow-clear placeholder="任务名称或编码（回车搜索）" @pressEnter="reload">
                      <template #prefix><icon-font iconClass="icon-opt-search" /></template>
                    </a-input>
                    <a-divider type="vertical" class="divider" />
                    <a @click="showSearch = !showSearch">{{ showSearch ? '收起' : '高级筛选' }}</a>
                  </template>
                  <template #toolBottom>
                    <div v-show="showSearch" class="super-search">
                      <a-form layout="inline">
                        <a-form-item label="任务编码">
                          <a-input v-model:value="where.taskCode" placeholder="请输入任务编码" allow-clear @pressEnter="reload" />
                        </a-form-item>
                        <a-form-item label="调度方式">
                          <a-select v-model:value="where.scheduleType" placeholder="全部" allow-clear style="width: 120px" @change="reload">
                            <a-select-option v-for="item in scheduleTypes" :key="item.value" :value="item.value">{{ item.label }}</a-select-option>
                          </a-select>
                        </a-form-item>
                        <a-form-item label="执行类型">
                          <a-select v-model:value="where.executionType" placeholder="全部" allow-clear style="width: 130px" @change="reload">
                            <a-select-option v-for="item in executionTypes" :key="item.value" :value="item.value">{{ item.label }}</a-select-option>
                          </a-select>
                        </a-form-item>
                        <a-form-item label="状态">
                          <a-select v-model:value="where.status" placeholder="全部" allow-clear style="width: 110px" @change="reload">
                            <a-select-option v-for="item in taskStatuses" :key="item.value" :value="item.value">{{ item.label }}</a-select-option>
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
                    <template v-if="column.dataIndex === 'taskName'"><a @click="openDetail(record)">{{ record.taskName }}</a></template>
                    <template v-else-if="column.dataIndex === 'executionType'">
                      {{ optionOf(executionTypes, executionTypeOf(record)).label }}
                    </template>
                    <template v-else-if="column.dataIndex === 'executionDefinition'">
                      <span :title="record.executionDefinition">{{ executionSummary(record.executionDefinition) }}</span>
                    </template>
                    <template v-else-if="column.dataIndex === 'scheduleType'">
                      {{ optionOf(scheduleTypes, record.scheduleType).label }}
                    </template>
                    <template v-else-if="column.dataIndex === 'status'">
                      <vxe-switch
                        v-model="record.status"
                        :open-value="1"
                        :close-value="2"
                        open-label="启用"
                        close-label="停用"
                        :disabled="statusUpdating.has(record.taskId)"
                        @change="updateStatus(record)"
                      />
                    </template>
                    <template v-else-if="column.key === 'action'">
                      <a-space :size="2" class="task-config-actions">
                        <a-tooltip v-if="canEdit(record)" title="编辑">
                          <a-button type="text" aria-label="编辑" @click="openEdit(record)"><edit-outlined /></a-button>
                        </a-tooltip>
                        <a-tooltip v-if="canEdit(record)" title="删除">
                          <a-button type="text" danger aria-label="删除" @click="remove(record)"><delete-outlined /></a-button>
                        </a-tooltip>
                        <a-tooltip v-if="canExecuteOnce(record)" title="执行一次">
                          <a-button type="text" aria-label="执行一次" @click="executeOnce(record)"><thunderbolt-outlined /></a-button>
                        </a-tooltip>
                        <a-tooltip title="运行日志">
                          <a-button type="text" aria-label="运行日志" @click="openHistory(record)"><file-search-outlined /></a-button>
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
    <TaskConfigAddEdit v-if="showEdit" v-model:visible="showEdit" :data="current" @done="reload" />
    <TaskConfigDetail v-if="showDetail" v-model:visible="showDetail" :data="current" />
    <a-modal v-model:visible="showHistory" :width="1120" :title="`运行日志 - ${historyTask?.taskName || ''}`" :footer="null" wrap-class-name="task-modal" destroy-on-close>
      <TaskInstanceList v-if="showHistory && historyTask" :key="historyTask.taskId" :task-id="historyTask.taskId" embedded />
    </a-modal>
  </div>
</template>

<script setup name="TaskConfig">
import { onScopeDispose, ref } from 'vue';
import { message, Modal } from 'ant-design-vue/es';
import { DeleteOutlined, EditOutlined, FileSearchOutlined, PlusOutlined, ThunderboltOutlined } from '@ant-design/icons-vue';
import { TaskConfigApi } from './api/TaskConfigApi';
import TaskConfigAddEdit from './components/task-config-add-edit.vue';
import TaskConfigDetail from './components/task-config-detail.vue';
import TaskInstanceList from '../task-instance/components/task-instance-list.vue';
import { canEdit, canExecuteOnce, executionSummary, executionTypeOf, executionTypes, optionOf, scheduleTypes, taskStatuses } from '../task-model';
import '../task.less';

defineOptions({ name: 'TaskConfig' });
const columns = ref([
  { key: 'index', title: '序号', width: 60, align: 'center', isShow: true, hideInSetting: true },
  { dataIndex: 'taskCode', title: '任务编码', ellipsis: true, width: 150, isShow: true },
  { dataIndex: 'taskName', title: '任务名称', ellipsis: true, width: 180, isShow: true },
  { dataIndex: 'executionType', title: '执行类型', width: 105, isShow: true },
  { dataIndex: 'executionDefinition', title: '执行定义', ellipsis: true, width: 210, isShow: true },
  { dataIndex: 'scheduleType', title: '调度方式', width: 115, isShow: true },
  { dataIndex: 'status', title: '状态', width: 120, align: 'center', isShow: true },
  { dataIndex: 'createTime', title: '创建时间', width: 175, isShow: true },
  { key: 'action', title: '操作', width: 150, align: 'center', isShow: true }
]);
const tableRef = ref(null);
const where = ref({ keyword: '' });
const current = ref(null);
const historyTask = ref(null);
const showSearch = ref(false);
const showEdit = ref(false);
const showDetail = ref(false);
const showHistory = ref(false);
const statusUpdating = ref(new Set());
let actionModal = null;
const reload = () => tableRef.value?.reload();
const reset = () => { where.value = { keyword: '' }; reload(); };
const openEdit = record => {
  if (record && !canEdit(record)) return;
  current.value = record || null;
  showEdit.value = true;
};
const openDetail = record => { current.value = record; showDetail.value = true; };
const openHistory = record => { showDetail.value = false; historyTask.value = record; showHistory.value = true; };
const confirmAction = (content, action, successText, after = reload) => {
  if (actionModal) return;
  actionModal = Modal.confirm({
    title: '提示', content, okText: '确定', cancelText: '取消',
    onCancel: () => { actionModal = null; },
    onOk: async () => {
      try {
        await action();
        message.success(successText);
        await after();
      } finally {
        actionModal = null;
      }
    }
  });
};
const markStatusUpdating = (taskId, updating) => {
  const taskIds = new Set(statusUpdating.value);
  if (updating) taskIds.add(taskId);
  else taskIds.delete(taskId);
  statusUpdating.value = taskIds;
};
const updateStatus = async record => {
  if (statusUpdating.value.has(record.taskId)) return;
  const status = Number(record.status);
  markStatusUpdating(record.taskId, true);
  try {
    await TaskConfigApi.updateStatus({ taskId: record.taskId, status });
    message.success(status === 1 ? '启用成功' : '停用成功');
  } catch {
    record.status = status === 1 ? 2 : 1;
  } finally {
    markStatusUpdating(record.taskId, false);
    reload();
  }
};
const executeOnce = record => {
  if (!canExecuteOnce(record)) return;
  confirmAction(`确定要立即执行任务「${record.taskName}」吗？`,
    () => TaskConfigApi.executeOnce({ taskId: record.taskId }), '执行请求已发送');
};
const remove = record => {
  if (!canEdit(record)) return;
  confirmAction(`确定要删除任务「${record.taskName}」吗？`,
    () => TaskConfigApi.delete({ taskId: record.taskId }), '删除成功');
};
onScopeDispose(() => actionModal?.destroy());
</script>

<style scoped>
.super-search { margin-top: 8px; }
.task-config-actions { white-space: nowrap; }
.task-config-actions :deep(.ant-btn) { width: 28px; min-width: 28px; height: 28px; padding: 0; font-size: 18px; }
</style>
