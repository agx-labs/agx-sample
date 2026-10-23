<template>
  <a-modal :visible="visible" :width="860" title="任务详情" :footer="null" wrap-class-name="task-modal" @cancel="emit('update:visible', false)">
    <a-spin :spinning="loading">
      <a-alert v-if="error" :message="error" type="error" show-icon>
        <template #action><a-button size="small" @click="load">重试</a-button></template>
      </a-alert>
      <template v-else-if="detail">
        <a-descriptions class="task-descriptions" :column="{ xs: 1, sm: 2 }" bordered size="small">
          <a-descriptions-item label="任务名称">{{ detail.taskName }}</a-descriptions-item>
          <a-descriptions-item label="任务编码">{{ detail.taskCode || '—' }}</a-descriptions-item>
          <a-descriptions-item label="调度方式">{{ optionOf(scheduleTypes, detail.scheduleType).label }}</a-descriptions-item>
          <a-descriptions-item label="状态">{{ optionOf(taskStatuses, detail.status).label }}</a-descriptions-item>
          <a-descriptions-item v-if="detail.scheduleType === 'inc'" label="Cron 表达式" :span="2">{{ detail.taskCron || '—' }}</a-descriptions-item>
          <a-descriptions-item label="任务 ID">{{ detail.taskId }}</a-descriptions-item>
          <a-descriptions-item label="调度器任务 ID">{{ detail.schedulerJobId || '—' }}</a-descriptions-item>
          <a-descriptions-item label="创建时间">{{ detail.createTime || '—' }}</a-descriptions-item>
          <a-descriptions-item label="更新时间">{{ detail.updateTime || '—' }}</a-descriptions-item>
          <a-descriptions-item label="任务说明" :span="2">{{ detail.description || '未填写' }}</a-descriptions-item>
        </a-descriptions>
        <task-definition :data="detail" />
      </template>
    </a-spin>
  </a-modal>
</template>

<script setup>
import { TaskConfigApi } from '../api/TaskConfigApi';
import TaskDefinition from '../../components/task-definition.vue';
import { optionOf, scheduleTypes, taskStatuses } from '../../task-model';
import { useTaskDetail } from '../../composables/use-task-detail';
const props = defineProps({ visible: Boolean, data: Object });
const emit = defineEmits(['update:visible']);
const { detail, loading, error, load } = useTaskDetail(
  () => props.visible, () => props.data?.taskId, (taskId) => TaskConfigApi.get({ taskId })
);
</script>
