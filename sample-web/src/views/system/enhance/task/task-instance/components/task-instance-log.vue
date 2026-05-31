<template>
  <a-modal
    :width="900"
    :maskClosable="true"
    :visible="props.visible"
    title="任务执行日志"
    :body-style="{ padding: '0', background: '#1e1e1e' }"
    :footer="null"
    @update:visible="updateVisible"
    @close="updateVisible(false)"
  >
    <div class="log-container">
      <div class="log-toolbar">
        <a-space>
          <a-tag color="blue">实例ID: {{ data.taskInstId }}</a-tag>
          <a-tag :color="isEnd ? 'success' : 'processing'">{{ isEnd ? '已完成' : '执行中...' }}</a-tag>
          <a-button size="small" @click="loadLog(true)" :loading="loading">刷新</a-button>
          <a-button size="small" @click="loadMoreLog" :loading="loadingMore" :disabled="isEnd">加载更多</a-button>
        </a-space>
      </div>
      <div class="log-content" ref="logScrollRef">
        <pre v-if="logContent">{{ logContent }}</pre>
        <div v-else-if="loading" class="log-tip">
          <a-spin tip="加载日志中..." />
        </div>
        <div v-else class="log-tip">暂无日志内容</div>
      </div>
    </div>
  </a-modal>
</template>
<script setup name="TaskInstanceLog">
import { ref, watch, nextTick } from 'vue';
import { TaskInstanceApi } from '../api/TaskInstanceApi';

const props = defineProps({
  visible: Boolean,
  data: Object
});
const emits = defineEmits(['update:visible']);
const logContent = ref('');
const loading = ref(false);
const loadingMore = ref(false);
const isEnd = ref(false);
const fromLineNum = ref(1);
const logScrollRef = ref(null);
let pollingTimer = null;
const updateVisible = value => emits('update:visible', value);
const loadLog = async (reset = false) => {
  if (reset) {
    fromLineNum.value = 1;
    logContent.value = '';
    isEnd.value = false;
  }
  loading.value = true;
  try {
    const res = await TaskInstanceApi.log({
      taskInstId: props.data.taskInstId,
      schedulerLogId: props.data.schedulerLogId,
      fromLineNum: fromLineNum.value
    });
    if (res) {
      if (res.logContent) {
        logContent.value += res.logContent;
        fromLineNum.value = (res.toLineNum || fromLineNum.value) + 1;
      }
      isEnd.value = !!res.end;
      await nextTick();
      scrollToBottom();
    }
  } finally {
    loading.value = false;
  }
};
const loadMoreLog = async () => {
  if (isEnd.value) return;
  loadingMore.value = true;
  try {
    const res = await TaskInstanceApi.log({
      taskInstId: props.data.taskInstId,
      schedulerLogId: props.data.schedulerLogId,
      fromLineNum: fromLineNum.value
    });
    if (res) {
      if (res.logContent) {
        logContent.value += res.logContent;
        fromLineNum.value = (res.toLineNum || fromLineNum.value) + 1;
      }
      isEnd.value = !!res.end;
      await nextTick();
      scrollToBottom();
    }
  } finally {
    loadingMore.value = false;
  }
};
const scrollToBottom = () => {
  if (logScrollRef.value) {
    logScrollRef.value.scrollTop = logScrollRef.value.scrollHeight;
  }
};
const startPolling = () => {
  pollingTimer = setInterval(async () => {
    if (isEnd.value) {
      stopPolling();
      return;
    }
    await loadLog(false);
  }, 3000);
};
const stopPolling = () => {
  if (pollingTimer) {
    clearInterval(pollingTimer);
    pollingTimer = null;
  }
};
watch(
  () => props.visible,
  async val => {
    if (val) {
      await loadLog(true);
      if (!isEnd.value) {
        startPolling();
      }
    } else {
      stopPolling();
    }
  }
);</script>
<style scoped lang="less">
.log-container {
  background: #1e1e1e;
  border-radius: 4px;
  overflow: hidden;
  .log-toolbar {
    padding: 8px 16px;
    background: #2d2d2d;
    border-bottom: 1px solid #3c3c3c;
  }
  .log-content {
    height: 500px;
    overflow-y: auto;
    padding: 12px 16px;
    pre {
      color: #d4d4d4;
      font-family: 'Courier New', Courier, monospace;
      font-size: 13px;
      line-height: 1.6;
      margin: 0;
      white-space: pre-wrap;
      word-break: break-all;
    }
    .log-tip {
      display: flex;
      align-items: center;
      justify-content: center;
      height: 100%;
      color: #888;
    }
  }
}
</style>