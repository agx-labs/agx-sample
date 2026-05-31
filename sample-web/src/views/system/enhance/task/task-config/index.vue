<template>
  <div class="guns-layout">
    <div class="guns-layout-content">
      <div class="guns-layout">
        <div class="guns-layout-content-application">
          <div class="content-mian">
            <div class="content-mian-header">
              <div class="header-content">
                <div class="header-content-left">
                  <a-space :size="16" />
                </div>
                <div class="header-content-right">
                  <a-space :size="16">
                    <a-button type="primary" class="border-radius" @click="openAddEdit()">
                      <plus-outlined />新建
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
                  rowId="taskId"
                  ref="tableRef"
                  :rowSelection="false"
                  url="/taskConfig/page"
                  methods="post"
                  showTableTool
                  :showToolTotal="false"
                  fieldBusinessCode="TASK_CONFIG_TABLE"
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
                        <icon-font iconClass="icon-opt-search" />
                      </template>
                    </a-input>
                  </template>
                  <template #bodyCell="{ column, record }">
                    <template v-if="column?.dataIndex === 'taskName'">
                      <a @click="openDetail(record)">{{ record.taskName }}</a>
                    </template>
                    <template v-if="column?.dataIndex === 'scheduleType'">
                      <a-tag :color="record.scheduleType === 'inc' ? 'blue' : 'purple'">
                        {{ record.scheduleType === 'inc' ? '增量' : '全量' }}
                      </a-tag>
                    </template>
                    <template v-if="column?.dataIndex === 'taskCron'">
                      <span v-if="record.taskCron">
                        <a-tag color="cyan">{{ record.taskCron }}</a-tag>
                      </span>
                      <span v-else class="text-secondary">-</span>
                    </template>
                    <template v-if="column?.dataIndex === 'status'">
                      <a-tag :color="record.status === 1 ? 'success' : 'default'">
                        {{ record.status === 1 ? '启用' : '停用' }}
                      </a-tag>
                    </template>
                    <template v-if="column?.key === 'action'">
                      <a-space :size="16">
                        <icon-font
                          iconClass="icon-opt-bianji"
                          font-size="24px"
                          title="编辑"
                          color="#60666b"
                          @click="openAddEdit(record)"
                        />
                        <a-tooltip :title="record.status === 1 ? '停用' : '启用'">
                          <icon-font
                            :iconClass="record.status === 1 ? 'icon-opt-jinyong' : 'icon-opt-qiyong'"
                            font-size="24px"
                            :color="record.status === 1 ? '#f5222d' : '#52c41a'"
                            @click="toggleStatus(record)"
                          />
                        </a-tooltip>
                        <a-tooltip title="立即执行一次" v-if="record.status === 1">
                          <icon-font
                            iconClass="icon-opt-run"
                            font-size="24px"
                            color="#1890ff"
                            @click="executeOnce(record)"
                          />
                        </a-tooltip>
                        <icon-font
                          iconClass="icon-opt-shanchu"
                          font-size="24px"
                          title="删除"
                          color="#60666b"
                          @click="remove(record)"
                        />
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
    <TaskConfigDetail v-model:visible="showDetail" :data="current" />
    <TaskConfigAddEdit v-model:visible="showEdit" :data="current" @done="reload" />
  </div>
</template>
<script setup name="TaskConfig">
import { ref, createVNode } from 'vue';
import { message, Modal } from 'ant-design-vue/es';
import { ExclamationCircleOutlined, PlusOutlined } from '@ant-design/icons-vue';
import { TaskConfigApi } from './api/TaskConfigApi';
import TaskConfigDetail from './components/task-config-detail.vue';
import TaskConfigAddEdit from './components/task-config-add-edit.vue';
defineOptions({ name: 'TaskConfig' });
const columns = ref([
  { key: 'index', title: '序号', width: 60, align: 'center', isShow: true, hideInSetting: true },
  { dataIndex: 'taskName', title: '任务名称', ellipsis: true, width: 180, isShow: true },
  { dataIndex: 'taskCode', title: '任务编码', ellipsis: true, width: 160, isShow: true },
  { dataIndex: 'scheduleType', title: '抽取方式', width: 120, isShow: true },
  { dataIndex: 'jobHandler', title: '任务处理器', ellipsis: true, width: 200, isShow: true },
  { dataIndex: 'taskCron', title: '时间表达式', ellipsis: true, width: 160, isShow: true },
  { dataIndex: 'status', title: '状态', width: 80, isShow: true },
  { key: 'action', title: '操作', width: 130, isShow: true }
]);
const tableRef = ref(null);
const where = ref({ taskName: '' });
const current = ref(null);
const showDetail = ref(false);
const showEdit = ref(false);
const reload = () => tableRef.value.reload();
const openDetail = record => {
  current.value = record;
  showDetail.value = true;
};
const openAddEdit = record => {
  current.value = record || null;
  showEdit.value = true;
};
const remove = record => {
  Modal.confirm({
    title: '提示',
    content: '确定要删除该任务配置吗？已启用的任务无法删除。',
    icon: createVNode(ExclamationCircleOutlined),
    maskClosable: true,
    onOk: async () => {
      const res = await TaskConfigApi.delete({ taskId: record.taskId });
      message.success(res.message);
      reload();
    }
  });
};
const toggleStatus = record => {
  const toStatus = record.status === 1 ? 2 : 1;
  const actionText = toStatus === 1 ? '启用' : '停用';
  Modal.confirm({
    title: '提示',
    content: `确定要${actionText}该任务吗？`,
    icon: createVNode(ExclamationCircleOutlined),
    maskClosable: true,
    onOk: async () => {
      const res = await TaskConfigApi.updateStatus({ taskId: record.taskId, status: toStatus });
      message.success(res.message);
      reload();
    }
  });
};
const executeOnce = record => {
  Modal.confirm({
    title: '提示',
    content: `确定要立即执行一次任务【${record.taskName}】吗？`,
    icon: createVNode(ExclamationCircleOutlined),
    maskClosable: true,
    onOk: async () => {
      const res = await TaskConfigApi.executeOnce({ taskId: record.taskId });
      message.success(res.message || '执行指令已发送');
    }
  });
};
</script>
<style scoped lang="less">
.text-secondary {
  color: #999;
}
</style>
