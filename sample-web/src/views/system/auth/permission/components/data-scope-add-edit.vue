<template>
  <!-- 新增编辑 -->
  <a-modal
    :width="524"
    :maskClosable="false"
    :visible="props.visible"
    :confirm-loading="loading"
    :forceRender="true"
    :title="isUpdate ? '编辑数据权限' : '新建数据权限'"
    :body-style="{ paddingBottom: '8px' }"
    @update:visible="updateVisible"
    @ok="save"
    @close="updateVisible(false)"
  >
    <a-form ref="formRef" :model="form" :rules="rules" layout="vertical">
      <a-form-item label="类型:" name="dataScopeType">
        <a-select placeholder="请选择类型" style="width: 100%" v-model:value="form.dataScopeType" allow-clear>
          <a-select-option v-for="item in typeList" :key="item.key" :value="item.key">
            {{ item.name }}
          </a-select-option>
        </a-select>
      </a-form-item>
      <a-form-item label="范围:" name="defineOrgListName" v-if="form?.dataScopeType == 40">
        <a-input v-model:value="form.defineOrgListName" placeholder="请选择范围" @focus="selectDept" />
      </a-form-item>
      <a-form-item label="范围:" name="defineOrgIdWrapper" v-else-if="form?.dataScopeType == 41">
        <a-input v-model:value="form.defineOrgIdWrapper" placeholder="请选择范围" @focus="selectDept" />
      </a-form-item>
      <a-form-item label="层级:" name="orgLevelCode" v-else-if="form?.dataScopeType == 32">
        <a-select v-model:value="form.orgLevelCode" style="width: 100%" placeholder="请选择层级">
          <a-select-option :value="item.levelCode" v-for="item in levelList" :key="item.levelCode"
            ><span :style="{ color: item.levelColor }">{{ item.levelName }}({{ getLevelNumberName(item) }})</span></a-select-option
          >
        </a-select>
      </a-form-item>
      <a-form-item label="范围:" v-else>
        <a-input v-model:value="dataScopeTypeName" disabled placeholder="请选择"></a-input>
      </a-form-item>
    </a-form>

    <!-- 选择公司部门 -->
    <Selection
      v-model:visible="showSelect"
      v-if="showSelect"
      title="选择机构"
      :data="selectData"
      :isRadio="isRadio"
      :showTab="['dept']"
      @done="closeSelect"
    />
  </a-modal>
</template>

<script setup name="DataScopeAddEdit">
import { ref, onMounted, reactive, watch, computed } from 'vue';
import { message } from 'ant-design-vue';
import { PermissionApi } from '../api/PermissionApi';
import { OrgApi } from '@/views/system/structure/organization/api/OrgApi';

const props = defineProps({
  visible: Boolean,
  data: Object,
  roleId: String,
  levelNumberList: Array
});

const emits = defineEmits(['update:visible', 'done']);
// 弹框加载
const loading = ref(false);
// 是否是编辑状态
const isUpdate = ref(false);
// 类型列表
const typeList = ref([
  {
    key: 10,
    name: '仅本人数据'
  },
  {
    key: 20,
    name: '本部门数据'
  },
  {
    key: 30,
    name: '本部门及以下数据'
  },
  {
    key: 31,
    name: '本公司及以下数据'
  },
  {
    key: 32,
    name: '指定机构层级及以下'
  },
  {
    key: 40,
    name: '指定机构集合数据'
  },
  {
    key: 41,
    name: '指定机构及以下'
  },
  {
    key: 50,
    name: '全部数据'
  }
]);
// 表单数据
const form = ref({
  roleId: props.roleId,
  defineOrgListName: ''
});
// 验证规则
const rules = reactive({
  dataScopeType: [{ required: true, message: '请选择类型', type: 'number', trigger: 'change' }],
  defineOrgIdWrapper: [{ required: true, message: '请选择范围', type: 'string', trigger: 'change' }],
  defineOrgListName: [{ required: true, message: '请选择范围', type: 'string', trigger: 'blur' }],
  orgLevelCode: [{ required: true, message: '请选择层级', type: 'string', trigger: 'change' }]
});
// ref
const formRef = ref(null);

const dataScopeTypeName = ref('');

const isRadio = ref(true);

const showSelect = ref(false);

// 选择总数据
const selectData = ref({
  selectOrgList: []
});

// 层级列表
const levelList = ref([]);

const getLevelNumberName = computed(() => {
  return item => {
    let name = '';
    let numberData = props.levelNumberList.find(a => a.value == item.levelNumber);
    if (numberData) name = numberData.name;
    return name;
  };
});

onMounted(async () => {
  getLevelList();
  if (props.data) {
    isUpdate.value = true;
    form.value = Object.assign({}, props.data);
    if (form.value.dataScopeType == 40) {
      form.value.defineOrgListWrapper = form.value.defineOrgList.map((item, index) => {
        return { bizId: item, name: form.value.defineOrgListWrapper[index] };
      });
      form.value.defineOrgListName = form.value.defineOrgListWrapper.map(item => item.name).join(',');
    }
  } else {
    isUpdate.value = false;
  }
});

const getLevelList = async () => {
  levelList.value = await OrgApi.organizationLevelList();
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
  let result;
  // 执行编辑或修改
  if (isUpdate.value) {
    result = PermissionApi.editRoleDataScope(form.value);
  } else {
    result = PermissionApi.addRoleDataScope(form.value);
  }
  result
    .then(res => {
      loading.value = false;
      message.success(res.message);
      updateVisible(false);
      emits('done');
    })
    .catch(() => {
      loading.value = false;
    });
};

const selectDept = () => {
  const { dataScopeType, defineOrgIdWrapper, defineOrgId, defineOrgListWrapper } = form.value;
  isRadio.value = dataScopeType == 40 ? false : true;
  if (dataScopeType == 40 && defineOrgListWrapper) {
    selectData.value.selectOrgList = defineOrgListWrapper.map(item => {
      return { bizId: item.bizId, name: item.name };
    });
  } else if (dataScopeType == 41 && defineOrgId && defineOrgIdWrapper) {
    selectData.value.selectOrgList = [{ bizId: defineOrgId, name: defineOrgIdWrapper }];
  }
  showSelect.value = true;
};

const closeSelect = data => {
  const { dataScopeType } = form.value;
  if (dataScopeType == 40) {
    form.value.defineOrgListName = data.selectOrgList?.map(item => item.name).join(',');
    form.value.defineOrgListWrapper = data.selectOrgList?.map(item => {
      return { bizId: item.bizId, name: item.name };
    });
    form.value.defineOrgList = data.selectOrgList?.map(item => item.bizId);
    formRef.value.validateFields(['defineOrgListName']);
  } else if (dataScopeType == 41) {
    const obj = data.selectOrgList[0] || { bizId: '', name: '' };
    form.value.defineOrgId = obj.bizId;
    form.value.defineOrgIdWrapper = obj.name;
    formRef.value.validateFields(['defineOrgIdWrapper']);
  }
};

watch(
  () => form.value?.dataScopeType,
  val => {
    if (!val || (val && [40, 41].includes(val))) {
      dataScopeTypeName.value = '';
    } else {
      let data = typeList.value.find(item => item.key == val);
      dataScopeTypeName.value = data.name;
    }
  },
  { deep: true, immediate: true }
);
</script>

<style></style>
