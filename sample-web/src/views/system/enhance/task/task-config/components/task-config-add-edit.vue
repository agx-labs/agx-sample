<template>
  <a-modal
    :width="760"
    :maskClosable="false"
    :visible="props.visible"
    :confirm-loading="loading"
    :title="isUpdate ? '编辑任务配置' : '新建任务配置'"
    :body-style="{ paddingBottom: '8px', maxHeight: '580px', overflowY: 'auto' }"
    @update:visible="updateVisible"
    @ok="save"
    @close="updateVisible(false)"
  >
    <task-config-form v-model:form="form" :isUpdate="isUpdate" ref="taskConfigFormRef"></task-config-form>
  </a-modal>
</template>
<script setup name="TaskConfigAddEdit">
import { ref, watch } from 'vue';
import TaskConfigForm from './task-config-form.vue';
import { message } from 'ant-design-vue';
import { TaskConfigApi } from '../api/TaskConfigApi';
const props = defineProps({
  visible: Boolean,
  data: Object
});
const emits = defineEmits(['update:visible', 'done']);
const loading = ref(false);
const isUpdate = ref(false);
const form = ref({});
const taskConfigFormRef = ref(null);
watch(
  () => props.visible,
  val => {
    if (val) {
      if (props.data) {
        isUpdate.value = true;
        form.value = Object.assign({}, props.data);
      } else {
        isUpdate.value = false;
        form.value = {};
      }
    }
  },
  { immediate: true }
);
const updateVisible = value => {
  emits('update:visible', value);
};
const save = async () => {
  taskConfigFormRef.value.$refs.formRef.validate().then(async valid => {
    if (valid) {
      loading.value = true;
      let result = null;
      if (isUpdate.value) {
        result = TaskConfigApi.edit(form.value);
      } else {
        result = TaskConfigApi.add(form.value);
      }
      result
        .then(async result => {
          loading.value = false;
          message.success(result.message);
          updateVisible(false);
          emits('done');
        })
        .catch(() => {
          loading.value = false;
        });
    }
  });
};
</script>
<style scoped lang="less"></style>