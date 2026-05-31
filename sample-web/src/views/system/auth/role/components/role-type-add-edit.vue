<template>
  <!-- 新增编辑 -->
  <a-modal
    :width="524"
    :maskClosable="false"
    :visible="props.visible"
    :confirm-loading="loading"
    :forceRender="true"
    :title="isUpdate ? '编辑角色分类' : '新建角色分类'"
    :body-style="{ paddingBottom: '8px' }"
    @update:visible="updateVisible"
    @ok="save"
    @close="updateVisible(false)"
  >
    <a-form ref="formRef" :model="form" :rules="rules" layout="vertical">
      <a-form-item label="角色分类名称:" name="roleCategoryName">
        <a-input v-model:value="form.roleCategoryName" allow-clear placeholder="请输入角色分类名称" />
      </a-form-item>
      <a-form-item label="所属父级:" name="categoryParentId">
        <a-tree-select
          v-model:value="form.categoryParentId"
          style="width: 100%"
          showSearch
          :tree-data="roleTypeList"
          treeNodeFilterProp="roleCategoryName"
          :dropdown-style="{ maxHeight: '400px', overflow: 'auto' }"
          placeholder="请选择所属父级"
          :fieldNames="{ children: 'children', label: 'roleCategoryName', key: 'id', value: 'id' }"
          allow-clear
          tree-default-expand-all
        />
      </a-form-item>
      <a-form-item label="角色分类排序:" name="fldSort">
        <a-input-number
          v-model:value="form.fldSort"
          :min="0"
          style="width: 100%"
          placeholder="请输入角色分类排序"
          allow-clear
          autocomplete="off"
        />
      </a-form-item>
    </a-form>
  </a-modal>
</template>

<script setup name="RoleTypeAddEdit">
import { ref, onMounted, reactive } from 'vue';
import { message } from 'ant-design-vue';
import { RoleTypeApi } from '../api/RoleTypeApi';

const props = defineProps({
  visible: Boolean,
  data: Object,
  roleType: Number,
  categoryParentId: String,
  companyData: Object,
});

const emits = defineEmits(['update:visible', 'done']);
// 弹框加载
const loading = ref(false);
// 是否是编辑状态
const isUpdate = ref(false);
// 表单数据
const form = ref({
  categoryType: props.roleType,
  categoryParentId: props.categoryParentId,
  fldSort: 100
});
// 验证规则
const rules = reactive({
  roleCategoryName: [{ required: true, message: '请输入角色分类名称', type: 'string', trigger: 'blur' }],
  categoryParentId: [{ required: true, message: '请选择所属父级', type: 'string', trigger: 'blur' }],
  fldSort: [{ required: true, message: '请输入角色分类排序', type: 'number', trigger: 'blur' }]
});
// ref
const formRef = ref(null);

// 所属父级列表
const roleTypeList = ref([]);

onMounted(async () => {
  if (props.data) {
    isUpdate.value = true;
    form.value = Object.assign({}, props.data);
  } else {
    isUpdate.value = false;
    if (props.roleType == 20) {
      form.value.companyId = props.companyData?.companyId;
    }
  }
  getRoleTypeList();
});

const getRoleTypeList = async () => {
  const res = await RoleTypeApi.treeList({ categoryType: props.roleType, ignoreCategoryId: form.value?.id });
  roleTypeList.value = [{ id: '-1', roleCategoryName: '根节点', children: res.data }];
};

// 更改弹框状态
const updateVisible = value => {
  emits('update:visible', value);
};

// 点击保存
const save = async () => {
  await formRef.value.validate();
  // 修改加载框为正在加载
  loading.value = true;

  let result = null;

  // 执行编辑或修改
  if (isUpdate.value) {
    result = RoleTypeApi.edit(form.value);
  } else {
    result = RoleTypeApi.add(form.value);
  }
  result
    .then(async result => {
      // 移除加载框
      loading.value = false;

      // 提示添加成功
      message.success(result.message);
      // 关闭弹框，通过控制visible的值，传递给父组件
      updateVisible(false);

      // 触发父组件done事件
      emits('done');
    })
    .catch(() => {
      loading.value = false;
    });
};
</script>

<style></style>
