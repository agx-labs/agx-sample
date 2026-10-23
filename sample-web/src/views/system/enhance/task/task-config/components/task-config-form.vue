<template>
  <a-form ref="formRef" :model="form" :rules="rules" layout="vertical">
    <a-row :gutter="20">
      <a-col :xs="24" :sm="12">
        <a-form-item label="任务名称:" name="taskName">
          <a-input v-model:value="form.taskName" :maxlength="255" placeholder="请输入任务名称" allow-clear />
        </a-form-item>
      </a-col>
      <a-col :xs="24" :sm="12">
        <a-form-item label="任务编码:" name="taskCode">
          <a-input v-model:value="form.taskCode" :maxlength="100" :disabled="isUpdate" placeholder="留空则自动生成" allow-clear />
        </a-form-item>
      </a-col>
      <a-col :xs="24" :sm="12">
        <a-form-item label="调度方式:" name="scheduleType">
          <a-select v-model:value="form.scheduleType" :options="scheduleTypes" />
        </a-form-item>
      </a-col>
      <a-col :xs="24" :sm="12">
        <a-form-item label="执行类型:" name="executionType">
          <a-select :value="form.executionType" :options="executionTypes" @change="changeExecutionType" />
        </a-form-item>
      </a-col>
      <a-col v-if="form.scheduleType === 'inc'" :span="24">
        <a-form-item label="Cron 表达式:" name="taskCron">
          <a-input v-model:value="form.taskCron" :maxlength="100" placeholder="例如：0 0/5 * * * ?" allow-clear />
        </a-form-item>
      </a-col>
      <a-col :span="24">
        <a-form-item v-if="form.executionType === 'bean'" label="Bean 处理器:" name="executionDefinition">
          <div class="handler-input">
            <a-select
              v-model:value="form.executionDefinition"
              :options="handlerOptions"
              :loading="handlersLoading"
              :filter-option="filterHandler"
              show-search
              allow-clear
              placeholder="选择已注册的任务处理器"
            />
            <a-tooltip title="刷新处理器列表">
              <a-button type="text" size="small" class="handler-refresh" :loading="handlersLoading" aria-label="刷新处理器列表" @click="loadHandlers">
                <reload-outlined />
              </a-button>
            </a-tooltip>
          </div>
          <div v-if="handlersError" class="form-error">{{ handlersError }}</div>
          <div v-else-if="!handlersLoading && !handlerOptions.length" class="form-hint">暂无可用处理器</div>
          <div v-else-if="missingHandler" class="form-error">当前处理器未注册，请重新选择</div>
        </a-form-item>
        <a-form-item v-else label="脚本正文:" name="executionDefinition">
          <code-mirror-editor
            v-model="form.executionDefinition"
            :language="editorLanguageOf(form.executionType)"
            :label="optionOf(executionTypes, form.executionType).label"
            height="260px"
            placeholder="请输入完整脚本正文"
          />
        </a-form-item>
      </a-col>
      <a-col :span="24">
        <a-form-item label="任务参数:" name="taskParams">
          <code-mirror-editor
            v-model="form.taskParams"
            language="json"
            label="JSON"
            height="180px"
            show-format
            placeholder="请输入 JSON，例如：{ &quot;key&quot;: &quot;value&quot; }"
          />
        </a-form-item>
      </a-col>
      <a-col :span="24">
        <a-form-item label="描述:" name="description">
          <a-textarea v-model:value="form.description" :rows="3" :maxlength="1000" placeholder="请输入描述" />
        </a-form-item>
      </a-col>
    </a-row>
  </a-form>
</template>

<script setup>
import { computed, defineAsyncComponent, nextTick, onScopeDispose, ref, watch } from 'vue';
import { ReloadOutlined } from '@ant-design/icons-vue';
import { TaskConfigApi } from '../api/TaskConfigApi';
import { cronError, editorLanguageOf, executionTypes, jsonError, optionOf, scheduleTypes } from '../../task-model';

const CodeMirrorEditor = defineAsyncComponent(() => import('@/components/common/CodeMirrorEditor/index.vue'));
const props = defineProps({ form: { type: Object, required: true }, isUpdate: Boolean });
const formRef = ref(null);
const handlersLoading = ref(false);
const handlersError = ref('');
const handlerOptions = ref([]);
const drafts = {};
let handlerRequest = 0;
const missingHandler = computed(() => props.form.executionDefinition && !handlerOptions.value.some((item) => item.value === props.form.executionDefinition));
const rules = computed(() => ({
  taskName: [{ required: true, whitespace: true, message: '请输入任务名称', trigger: 'blur' }],
  scheduleType: [{ required: true, message: '请选择调度方式', trigger: 'change' }],
  executionType: [{ required: true, message: '请选择执行类型', trigger: 'change' }],
  executionDefinition: [{ required: true, whitespace: true, message: props.form.executionType === 'bean' ? '请选择 Bean 处理器' : '请输入脚本正文', trigger: ['blur', 'change'] }],
  taskParams: [{ validator: async (_rule, value) => {
    const error = jsonError(value);
    if (error) throw new Error(error);
  }, trigger: 'blur' }],
  taskCron: [{ validator: async (_rule, value) => {
    const error = props.form.scheduleType === 'inc' ? cronError(value) : '';
    if (error) throw new Error(error);
  }, trigger: 'blur' }]
}));

const loadHandlers = async () => {
  const id = ++handlerRequest;
  handlersLoading.value = true;
  handlersError.value = '';
  try {
    const result = await TaskConfigApi.getJobHandlers({});
    if (id === handlerRequest) handlerOptions.value = Object.entries(result || {}).map(([value, name]) => ({ value, label: `${value}-${name}` }));
  } catch (cause) {
    if (id === handlerRequest) handlersError.value = cause?.message || '处理器加载失败，请点击刷新重试';
  } finally {
    if (id === handlerRequest) handlersLoading.value = false;
  }
};
const filterHandler = (input, option) => option.label.toLowerCase().includes(input.toLowerCase());
const changeExecutionType = async (type) => {
  drafts[props.form.executionType] = props.form.executionDefinition;
  props.form.executionType = type;
  props.form.executionDefinition = drafts[type] ?? '';
  await nextTick();
  formRef.value?.clearValidate('executionDefinition');
};
watch(() => props.form.executionType, (type) => {
  if (type === 'bean' && !handlerOptions.value.length && !handlersLoading.value) loadHandlers();
}, { immediate: true });
onScopeDispose(() => handlerRequest++);
defineExpose({ validate: () => formRef.value.validate() });
</script>

<style scoped lang="less">
.handler-input { display: flex; align-items: center; gap: 4px; .ant-select { flex: 1; min-width: 0; } }
.handler-refresh { flex: 0 0 32px; width: 32px; height: 32px; padding: 0; }
.form-hint { margin-top: 6px; color: #999; }
.form-error { margin-top: 6px; color: #ff4d4f; }
</style>
