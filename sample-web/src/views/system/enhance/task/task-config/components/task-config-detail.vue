<template>
  <a-modal
    :width="700"
    :maskClosable="true"
    :visible="props.visible"
    :footer="null"
    title="任务配置详情"
    :body-style="{ paddingBottom: '16px', maxHeight: '600px', overflowY: 'auto' }"
    @update:visible="updateVisible"
    @close="updateVisible(false)"
  >
    <a-spin :spinning="loading">
      <a-descriptions v-if="detail" :column="2" bordered size="small">
        <a-descriptions-item label="任务名称">{{ detail.taskName }}</a-descriptions-item>
        <a-descriptions-item label="任务编码">{{ detail.taskCode }}</a-descriptions-item>
        <a-descriptions-item label="调度类型">
          <a-tag :color="detail.scheduleType === 'inc' ? 'blue' : 'purple'">
            {{ detail.scheduleType === 'inc' ? '增量（Cron定时）' : '全量（手动触发）' }}
          </a-tag>
        </a-descriptions-item>
        <a-descriptions-item label="状态">
          <a-tag :color="detail.status === 1 ? 'success' : 'default'">
            {{ detail.status === 1 ? '启用' : '停用' }}
          </a-tag>
        </a-descriptions-item>
        <a-descriptions-item label="任务处理器" :span="2">{{ detail.jobHandler || '-' }}</a-descriptions-item>
        <a-descriptions-item v-if="detail.scheduleType === 'inc'" label="Cron表达式" :span="2">
          <a-tag color="cyan">{{ detail.taskCron || '-' }}</a-tag>
        </a-descriptions-item>
        <a-descriptions-item label="任务参数" :span="2">
          <pre v-if="detail.taskParams" class="params-pre">{{ formatJson(detail.taskParams) }}</pre>
          <span v-else>-</span>
        </a-descriptions-item>
        <a-descriptions-item label="描述" :span="2">{{ detail.description || '-' }}</a-descriptions-item>
      </a-descriptions>
    </a-spin>
  </a-modal>
</template>
<script setup name="TaskConfigDetail">
import { ref, watch } from 'vue';
import { TaskConfigApi } from '../api/TaskConfigApi';

const props = defineProps({
  visible: Boolean,
  data: Object
});
const emits = defineEmits(['update:visible']);
const loading = ref(false);
const detail = ref(null);

watch(
  () => props.visible,
  val => {
    if (val && props.data?.taskId) {
      loading.value = true;
      TaskConfigApi.get({ taskId: props.data.taskId })
        .then(res => {
          detail.value = res;
        })
        .finally(() => {
          loading.value = false;
        });
    } else {
      detail.value = null;
    }
  }
);

const updateVisible = value => emits('update:visible', value);

const formatJson = str => {
  if (!str) return '-';
  try {
    return JSON.stringify(JSON.parse(str), null, 2);
  } catch {
    return str;
  }
};
</script>
<style scoped lang="less">
.params-pre {
  margin: 0;
  font-family: 'Courier New', Courier, monospace;
  font-size: 12px;
  white-space: pre-wrap;
  word-break: break-all;
  background: #f5f5f5;
  padding: 8px;
  border-radius: 4px;
  max-height: 200px;
  overflow-y: auto;
}
</style>

