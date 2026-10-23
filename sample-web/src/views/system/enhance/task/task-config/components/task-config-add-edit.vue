<template>
  <a-modal
    :visible="visible" :width="760" :mask-closable="false" :keyboard="!saving" :closable="!saving"
    :title="isUpdate ? '编辑任务' : '新建任务'" wrap-class-name="task-modal"
    :confirm-loading="saving" :ok-button-props="{ disabled: loading || !!loadError || locked }"
    :cancel-button-props="{ disabled: saving }" ok-text="确定" cancel-text="取消"
    destroy-on-close @cancel="close" @ok="save"
  >
    <a-spin :spinning="loading">
      <a-alert v-if="loadError" type="error" :message="loadError" show-icon class="task-error">
        <template #action><a-button size="small" @click="load">重试</a-button></template>
      </a-alert>
      <a-alert v-else-if="locked" type="warning" message="请先停用任务后再编辑" show-icon />
      <template v-else-if="!loading">
        <a-alert v-if="saveError" :message="saveError" type="error" show-icon class="task-error" />
        <task-config-form :key="formKey" ref="formRef" :form="form" :is-update="isUpdate" />
      </template>
    </a-spin>
  </a-modal>
</template>

<script setup>
import { computed, ref, watch } from 'vue';
import { message } from 'ant-design-vue';
import TaskConfigForm from './task-config-form.vue';
import { TaskConfigApi } from '../api/TaskConfigApi';
import { createTaskForm, isEnabled, taskPayload } from '../../task-model';
import { useTaskDetail } from '../../composables/use-task-detail';

const props = defineProps({ visible: Boolean, data: Object });
const emit = defineEmits(['update:visible', 'done']);
const isUpdate = computed(() => !!props.data?.taskId);
const { detail, loading, error: loadError, load } = useTaskDetail(
  () => props.visible, () => props.data?.taskId, (taskId) => TaskConfigApi.get({ taskId })
);
const locked = computed(() => isEnabled(detail.value));
const form = ref(createTaskForm());
const formKey = ref(0);
const formRef = ref(null);
const saving = ref(false);
const saveError = ref('');
watch([() => props.visible, detail], () => {
  form.value = createTaskForm(detail.value || {});
  formKey.value++;
  saveError.value = '';
}, { immediate: true });
const close = () => { if (!saving.value) emit('update:visible', false); };
const save = async () => {
  if (saving.value || loading.value || loadError.value || locked.value || !formRef.value) return;
  saving.value = true;
  saveError.value = '';
  try {
    await formRef.value.validate();
    const payload = taskPayload(form.value);
    await (isUpdate.value ? TaskConfigApi.edit(payload) : TaskConfigApi.add(payload));
    message.success(isUpdate.value ? '编辑成功' : '新增成功');
    emit('done');
    emit('update:visible', false);
  } catch (cause) {
    if (!cause?.errorFields) saveError.value = cause?.message || '保存失败，请重试';
  } finally {
    saving.value = false;
  }
};
</script>
