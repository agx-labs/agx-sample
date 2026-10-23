<template>
  <a-modal :visible="visible" :width="900" title="执行记录详情" :footer="null" wrap-class-name="task-modal" @cancel="emit('update:visible', false)">
    <a-spin :spinning="loading">
      <a-alert v-if="error" :message="error" type="error" show-icon />
      <template v-else-if="detail">
        <a-descriptions class="task-descriptions" :column="{ xs: 1, sm: 2 }" bordered size="small">
          <a-descriptions-item label="任务名称">{{ detail.taskName || '—' }}</a-descriptions-item>
          <a-descriptions-item label="任务编码">{{ detail.taskCode || '—' }}</a-descriptions-item>
          <a-descriptions-item label="触发方式"><a-tag :color="optionOf(triggerTypes, detail.triggerType).color">{{ optionOf(triggerTypes, detail.triggerType).label }}</a-tag></a-descriptions-item>
          <a-descriptions-item label="执行结果"><a-tag :color="optionOf(handleResults, detail.handleResult).color">{{ optionOf(handleResults, detail.handleResult).label }}</a-tag></a-descriptions-item>
          <a-descriptions-item label="开始时间">{{ detail.startTime || '—' }}</a-descriptions-item>
          <a-descriptions-item label="结束时间">{{ detail.endTime || '—' }}</a-descriptions-item>
          <a-descriptions-item label="执行耗时">{{ durationOf(detail) }}</a-descriptions-item>
          <a-descriptions-item label="创建时间">{{ detail.createTime || '—' }}</a-descriptions-item>
          <a-descriptions-item label="实例编码" :span="2">{{ detail.taskInstId || '—' }}</a-descriptions-item>
          <a-descriptions-item label="调度器任务编码">{{ detail.schedulerJobId || '—' }}</a-descriptions-item>
          <a-descriptions-item label="调度器日志编码">{{ detail.schedulerLogId || '—' }}</a-descriptions-item>
        </a-descriptions>
        <div class="task-section-heading"><strong>处理消息</strong></div>
        <pre class="task-code task-code-light" :class="{ 'instance-failed': detail.handleResult === 'fail' }">{{ detail.handleMsg || '暂无处理消息' }}</pre>
        <task-definition :data="detail" snapshot />
      </template>
    </a-spin>
  </a-modal>
</template>

<script setup>
import { TaskInstanceApi } from '../api/TaskInstanceApi';
import TaskDefinition from '../../components/task-definition.vue';
import { durationOf, handleResults, optionOf, triggerTypes } from '../../task-model';
import { useTaskDetail } from '../../composables/use-task-detail';
const props = defineProps({ visible: Boolean, data: Object });
const emit = defineEmits(['update:visible']);
const { detail, loading, error } = useTaskDetail(
  () => props.visible, () => props.data?.taskInstId, (taskInstId) => TaskInstanceApi.get({ taskInstId })
);
</script>

<style scoped>
.instance-failed { color: #cf1322; background: #fff1f0; }
</style>
