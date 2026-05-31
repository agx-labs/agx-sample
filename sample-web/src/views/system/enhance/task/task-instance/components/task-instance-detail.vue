<template>
  <a-modal
    :width="760"
    :maskClosable="true"
    :visible="props.visible"
    :footer="null"
    title="任务实例详情"
    :body-style="{ paddingBottom: '16px', maxHeight: '620px', overflowY: 'auto' }"
    @update:visible="updateVisible"
    @close="updateVisible(false)"
  >
    <!-- 任务配置信息 -->
    <div class="section-title">
      <span class="section-label">任务配置</span>
    </div>
    <a-descriptions :column="2" bordered size="small" class="section-desc">
      <a-descriptions-item label="任务名称">{{ data.taskName }}</a-descriptions-item>
      <a-descriptions-item label="任务编码">{{ data.taskCode }}</a-descriptions-item>
      <a-descriptions-item label="任务处理器" :span="2">{{ data.jobHandler || '-' }}</a-descriptions-item>
      <a-descriptions-item label="任务参数" :span="2">
        <pre v-if="data.taskParams" class="params-pre">{{ formatJson(data.taskParams) }}</pre>
        <span v-else>-</span>
      </a-descriptions-item>
    </a-descriptions>

    <!-- 实例信息 -->
    <div class="section-title" style="margin-top: 16px;">
      <span class="section-label">实例信息</span>
    </div>
    <a-descriptions :column="2" bordered size="small" class="section-desc">
      <a-descriptions-item label="实例ID" :span="2">{{ data.taskInstId }}</a-descriptions-item>
      <a-descriptions-item label="触发类型">
        <a-tag :color="triggerTypeColor(data.triggerType)">{{ triggerTypeLabel(data.triggerType) }}</a-tag>
      </a-descriptions-item>
      <a-descriptions-item label="处理结果">
        <a-tag :color="handleResultColor(data.handleResult)">{{ handleResultLabel(data.handleResult) }}</a-tag>
      </a-descriptions-item>
      <a-descriptions-item label="处理开始时间">{{ data.startTime || '-' }}</a-descriptions-item>
      <a-descriptions-item label="处理结束时间">{{ data.endTime || '-' }}</a-descriptions-item>
      <a-descriptions-item label="调度器任务ID">{{ data.schedulerJobId || '-' }}</a-descriptions-item>
      <a-descriptions-item label="调度器执行记录ID">{{ data.schedulerLogId || '-' }}</a-descriptions-item>
      <a-descriptions-item label="处理消息" :span="2">
        <pre v-if="data.handleMsg" class="msg-pre">{{ data.handleMsg }}</pre>
        <span v-else>-</span>
      </a-descriptions-item>
    </a-descriptions>
  </a-modal>
</template>
<script setup name="TaskInstanceDetail">
const props = defineProps({
  visible: Boolean,
  data: Object
});
const emits = defineEmits(['update:visible']);
const updateVisible = value => emits('update:visible', value);
const triggerTypeLabel = type => ({ auto: '自动', manual: '手动', retry: '重试' }[type] || type);
const triggerTypeColor = type => ({ auto: 'blue', manual: 'orange', retry: 'purple' }[type] || 'default');
const handleResultLabel = result => ({ success: '成功', fail: '失败', running: '运行中' }[result] || result);
const handleResultColor = result => ({ success: 'success', fail: 'error', running: 'processing' }[result] || 'default');
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
.section-title {
  display: flex;
  align-items: center;
  margin-bottom: 8px;

  .section-label {
    font-size: 13px;
    font-weight: 600;
    color: #333;
    padding-left: 8px;
    border-left: 3px solid var(--primary-color, #1890ff);
  }
}
.section-desc {
  margin-bottom: 4px;
}
.params-pre,
.msg-pre {
  margin: 0;
  font-family: 'Courier New', Courier, monospace;
  font-size: 12px;
  white-space: pre-wrap;
  word-break: break-all;
  background: #f5f5f5;
  padding: 6px 8px;
  border-radius: 4px;
  max-height: 160px;
  overflow-y: auto;
}
.msg-pre {
  color: #d32f2f;
}
</style>
