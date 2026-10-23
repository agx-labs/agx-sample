<template>
  <a-modal :visible="visible" width="90vw" title="执行日志" :footer="null" wrap-class-name="task-modal" destroy-on-close @cancel="emit('update:visible', false)">
    <div class="log-toolbar">
      <a-space class="log-status" :size="8">
        <strong>执行状态</strong>
        <a-tag :color="instanceStatus.color">{{ instanceStatus.label }}</a-tag>
      </a-space>
      <div class="log-controls">
        <a-checkbox v-if="isRunning" v-model:checked="automatic" :disabled="ended">自动加载日志</a-checkbox>
        <a-space class="log-actions" :size="4">
          <a-tooltip title="重新读取">
            <a-button type="text" aria-label="重新读取" :loading="loading" @click="load(true)"><reload-outlined /></a-button>
          </a-tooltip>
          <a-tooltip title="下载日志">
            <a-button type="text" aria-label="下载日志" :disabled="!content" @click="download"><download-outlined /></a-button>
          </a-tooltip>
        </a-space>
      </div>
    </div>
    <a-alert v-if="error" :message="error" description="自动读取已暂停，可点击重新读取重试。" type="error" show-icon class="task-error" />
    <div class="log-content" role="region" aria-label="任务日志内容" :aria-busy="loading" @scroll.passive="loadAtBottom">
      <pre v-if="content">{{ content }}</pre>
      <div v-else class="log-empty">{{ loading ? '正在读取日志…' : error ? '暂时无法读取日志' : ended ? '本次执行未输出日志' : '暂无日志，等待任务输出…' }}</div>
    </div>
    <div class="task-subline">已读取至第 {{ nextLine - 1 }} 行</div>
  </a-modal>
</template>

<script setup>
import { computed } from 'vue';
import { DownloadOutlined, ReloadOutlined } from '@ant-design/icons-vue';
import { TaskInstanceApi } from '../api/TaskInstanceApi';
import { useTaskLog } from '../../composables/use-task-log';
import { handleResults, optionOf } from '../../task-model';
const props = defineProps({ visible: Boolean, data: Object });
const emit = defineEmits(['update:visible']);
const isRunning = computed(() => props.data?.handleResult === 'running');
const instanceStatus = computed(() => optionOf(handleResults, props.data?.handleResult));
const { content, loading, error, ended, automatic, nextLine, load } = useTaskLog(
  () => props.visible, () => props.data?.taskInstId, (params) => TaskInstanceApi.log(params), () => isRunning.value
);
const loadAtBottom = (event) => {
  const element = event.currentTarget;
  if (element.scrollHeight - element.scrollTop - element.clientHeight <= 24 && !ended.value && !loading.value) load();
};
const download = () => {
  const url = URL.createObjectURL(new Blob([content.value], { type: 'text/plain;charset=utf-8' }));
  const link = document.createElement('a');
  link.href = url;
  link.download = `task-${props.data.taskInstId}.log`;
  document.body.appendChild(link);
  link.click();
  link.remove();
  setTimeout(() => URL.revokeObjectURL(url), 1000);
};
</script>

<style scoped lang="less">
.log-toolbar { display: flex; align-items: center; justify-content: space-between; gap: 12px; flex-wrap: wrap; margin-bottom: 14px; }
.log-status { flex: 0 0 auto; }
.log-controls { display: flex; align-items: center; gap: 12px; margin-left: auto; }
.log-actions { margin-left: auto; }
.log-content {
  height: min(58vh, 640px); min-height: 220px; overflow: auto; background: #f5f5f5; padding: 12px;
  pre { margin: 0; font: 13px/1.7 Consolas, Monaco, monospace; white-space: pre; }
}
.log-empty { display: grid; height: 100%; place-items: center; color: #999; }
</style>
