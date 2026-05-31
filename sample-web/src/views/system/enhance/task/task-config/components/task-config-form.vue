<template>
  <a-form ref="formRef" :model="form" :rules="rules" layout="vertical">
    <a-row :gutter="20">
      <a-col :span="12">
        <a-form-item label="任务名称:" name="taskName">
          <a-input v-model:value="form.taskName" allow-clear placeholder="请输入任务名称" />
        </a-form-item>
      </a-col>
      <a-col :span="12">
        <a-form-item label="任务编码:" name="taskCode">
          <a-input v-model:value="form.taskCode" allow-clear placeholder="不填则自动生成" :disabled="isUpdate" />
        </a-form-item>
      </a-col>
      <a-col :span="12">
        <a-form-item label="抽取方式:" name="scheduleType">
          <a-select v-model:value="form.scheduleType" placeholder="请选择抽取方式" allow-clear @change="onScheduleTypeChange">
            <a-select-option value="full">全量（手动触发）</a-select-option>
            <a-select-option value="inc">增量（Cron定时触发）</a-select-option>
          </a-select>
        </a-form-item>
      </a-col>
      <a-col :span="12" v-if="form.scheduleType === 'inc'">
        <a-form-item label="时间表达式:" name="taskCron">
          <a-input v-model:value="form.taskCron" allow-clear placeholder="例：0 0/5 * * * ?" />
        </a-form-item>
      </a-col>
      <a-col :span="12">
        <a-form-item label="任务处理器:" name="jobHandler">
          <a-select v-model:value="form.jobHandler" :loading="jobHandlerLoading" showSearch placeholder="请选择任务处理器" allow-clear>
            <a-select-option v-for="item in jobHandlerList" :key="item.value" :value="item.value">
              {{ item.label }}（{{ item.value }}）
            </a-select-option>
          </a-select>
        </a-form-item>
      </a-col>
      <a-col :span="24">
        <a-form-item name="taskParams">
          <template #label>
            <span>任务参数:</span>
            <a-button size="small" type="link" style="margin-left: 8px; padding: 0; height: auto; font-size: 12px;" @click="formatParams">格式化JSON</a-button>
            <span v-if="paramsError" style="color: #ff4d4f; font-size: 12px; margin-left: 8px;">{{ paramsError }}</span>
          </template>
          <textarea
            v-model="form.taskParams"
            class="code-editor"
            placeholder='请输入任务参数，JSON格式，例：{"key": "value"}'
            rows="6"
            spellcheck="false"
            @input="validateParams"
          />
        </a-form-item>
      </a-col>
      <a-col :span="24">
        <a-form-item label="描述:" name="description">
          <a-textarea v-model:value="form.description" placeholder="请输入任务描述" :rows="3" allow-clear />
        </a-form-item>
      </a-col>
    </a-row>
  </a-form>
</template>
<script setup name="TaskConfigForm">
import { reactive, onMounted, ref } from 'vue';
import { TaskConfigApi } from '../api/TaskConfigApi';
const props = defineProps({
  form: Object,
  isUpdate: Boolean
});
const rules = reactive({
  taskName: [{ required: true, message: '请输入任务名称', type: 'string', trigger: 'blur' }],
  scheduleType: [{ required: true, message: '请选择抽取方式', type: 'string', trigger: 'change' }],
  jobHandler: [{ required: true, message: '请选择任务处理器', type: 'string', trigger: 'change' }]
});
const jobHandlerLoading = ref(false);
const jobHandlerList = ref([]);
const paramsError = ref('');

const onScheduleTypeChange = val => {
  if (val === 'full') {
    props.form.taskCron = '';
  }
};

const validateParams = () => {
  const val = props.form.taskParams;
  if (!val || !val.trim()) {
    paramsError.value = '';
    return;
  }
  try {
    JSON.parse(val);
    paramsError.value = '';
  } catch (e) {
    paramsError.value = 'JSON格式错误';
  }
};

const formatParams = () => {
  const val = props.form.taskParams;
  if (!val || !val.trim()) return;
  try {
    props.form.taskParams = JSON.stringify(JSON.parse(val), null, 2);
    paramsError.value = '';
  } catch (e) {
    paramsError.value = 'JSON格式错误，无法格式化';
  }
};

onMounted(() => {
  jobHandlerLoading.value = true;
  TaskConfigApi.getJobHandlers({})
    .then(res => {
      if (res && typeof res === 'object') {
        jobHandlerList.value = Object.entries(res).map(([key, name]) => ({
          value: key,
          label: name
        }));
      }
    })
    .finally(() => {
      jobHandlerLoading.value = false;
    });
});
</script>
<style scoped lang="less">
.code-editor {
  width: 100%;
  font-family: 'Courier New', Courier, monospace;
  font-size: 13px;
  line-height: 1.6;
  padding: 8px 12px;
  border: 1px solid #d9d9d9;
  border-radius: 6px;
  background: #1e1e1e;
  color: #d4d4d4;
  resize: vertical;
  outline: none;
  transition: border-color 0.3s;
  box-sizing: border-box;

  &::placeholder {
    color: #666;
  }

  &:focus {
    border-color: var(--primary-color, #1890ff);
    box-shadow: 0 0 0 2px rgba(24, 144, 255, 0.2);
  }
}
</style>
