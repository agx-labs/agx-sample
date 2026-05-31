<template>
  <div class="box bgColor p12">
    <div class="left-header">
      <span class="left-header-title" @click="changeCompany"
        >{{ props.roleType == 15 ? '业务角色分类' : companyData?.companyName }}
        <i class="iconfont icon-opt-qiehuan" v-if="props.roleType == 20"></i
      ></span>
      <span>
        <plus-outlined class="header-add" @click="addRoleType()" />
      </span>
    </div>
    <!-- 搜索框-->
    <div class="search">
      <a-input
        v-model:value="searchText"
        placeholder="请输入关键词，回车搜索"
        allow-clear
        @pressEnter="getRoleTyoeTreeData"
        @change="searchTextChange"
      >
        <template #prefix>
          <icon-font iconClass="icon-opt-search"></icon-font>
        </template>
      </a-input>
    </div>
    <div class="tree-content">
      <a-spin tip="Loading..." :spinning="apiLoading" :delay="100">
        <div v-show="treeData && treeData.length > 0" class="left-tree">
          <a-directory-tree
            :show-icon="false"
            v-model:selectedKeys="currentSelectKeys"
            v-model:expandedKeys="expandedKeys"
            @select="selectNode"
            :tree-data="treeData"
            :fieldNames="{ children: 'children', title: 'roleCategoryName', key: 'id', value: 'id' }"
          >
            <!-- 标题 -->
            <template #title="data">
              <span class="tree-edit">
                <span class="edit-title" :title="data.roleCategoryName"> {{ data.roleCategoryName }}</span>
                <span class="edit-icon">
                  <a-space>
                    <icon-font iconClass="icon-opt-tianjia" color="var(--primary-color)" @click.stop="addRoleType(data)"></icon-font>
                    <icon-font
                      iconClass="icon-opt-bianji"
                      color="var(--primary-color)"
                      @click.stop="editRoleType(data)"
                      v-if="data.id != '-1'"
                    ></icon-font>
                    <icon-font
                      iconClass="icon-opt-shanchu"
                      color="red"
                      @click.stop="deleteRoleType(data)"
                      v-if="data.id != '-1'"
                    ></icon-font>
                  </a-space>
                </span>
              </span>
            </template>
          </a-directory-tree>
        </div>
        <a-empty v-show="treeData && treeData.length == 0" class="empty" />
      </a-spin>
    </div>

    <!-- 分类新增编辑 -->
    <RoleTypeAddEdit
      v-model:visible="showAddEdit"
      v-if="showAddEdit"
      :data="current"
      :categoryParentId="categoryParentId"
      @done="getRoleTyoeTreeData"
      :roleType="props.roleType"
      :companyData="companyData"
    />

    <!-- 选择组件 -->
    <Selection
      v-model:visible="showSelectCompany"
      v-if="showSelectCompany"
      title="选择公司"
      :data="selectData"
      :showTab="['company']"
      @done="closeSelectCompany"
    />
  </div>
</template>

<script setup name="RoleTree">
import { RoleTypeApi } from '../api/RoleTypeApi';
import { ref, createVNode, onMounted, watch, defineAsyncComponent, computed } from 'vue';
import { message, Modal } from 'ant-design-vue/es';
import { ExclamationCircleOutlined } from '@ant-design/icons-vue';
import { useUserStore } from '@/store/modules/user';

const RoleTypeAddEdit = defineAsyncComponent(() => import('./role-type-add-edit.vue'));

const props = defineProps({
  roleType: Number
});

const emits = defineEmits(['treeSelect', 'delRoleType', 'getCompanyData']);

const userStore = useUserStore();

// 组织机构名称
const searchText = ref('');
// 加载状态
const apiLoading = ref(false);
// 组织机构树
const treeData = ref([]);
// 当前选中节点
const currentSelectKeys = ref([]);
// 当前展开的节点
const expandedKeys = ref([]);
// 是否显示分类新增编辑弹框
const showAddEdit = ref(false);
// 当前行数据
const current = ref(null);
// 父级id
const categoryParentId = ref('-1');

// 是否显示选择公司
const showSelectCompany = ref(false);

// 选择的总数据
const selectData = ref({
  selectCompanyList: []
});

// 当前公司信息
const currentCompanyData = computed(() => {
  let userOrgInfoList = userStore.info.userOrgInfoList;
  let filter = userOrgInfoList.filter(item => item.currentSelectFlag);
  if (filter.length > 0) {
    return filter[0];
  }
});
// 公司信息
const companyData = ref({});

onMounted(() => {
  companyData.value = currentCompanyData.value;
  emits('getCompanyData', companyData.value);
  getRoleTyoeTreeData();
});

watch(
  () => props.roleType,
  () => {
    emits('getCompanyData', companyData.value);
    getRoleTyoeTreeData();
  }
);

// 搜索组织机构树
const getRoleTyoeTreeData = () => {
  apiLoading.value = true;
  let params = {
    searchText: searchText.value,
    categoryType: props.roleType
  };
  if (props.roleType == 20) params.companyId = companyData.value?.companyId;
  RoleTypeApi.treeList(params)
    .then(res => {
      treeData.value = res.data;
    })
    .finally(() => (apiLoading.value = false));
};

// 选中节点
const selectNode = (selectedKeys, { node }) => {
  emits('treeSelect', node);
};

// 搜索值变化
const searchTextChange = () => {
  if (!searchText.value) getRoleTyoeTreeData();
};

// 新建
const addRoleType = data => {
  current.value = null;
  categoryParentId.value = data ? data.id : '-1';
  showAddEdit.value = true;
};

// 编辑
const editRoleType = data => {
  current.value = data;
  categoryParentId.value = data.categoryParentId;
  showAddEdit.value = true;
};

// 删除
const deleteRoleType = data => {
  Modal.confirm({
    title: '提示',
    content: '确定要删除吗?',
    icon: createVNode(ExclamationCircleOutlined),
    maskClosable: true,
    onOk: () => {
      apiLoading.value = true;
      RoleTypeApi.delete({ id: data.id })
        .then(res => {
          message.success(res.message);
          getRoleTyoeTreeData();
          emits('delRoleType', data);
        })
        .finally(() => (apiLoading.value = false));
    }
  });
};

// 切换公司
const changeCompany = () => {
  if (props.roleType == 20) {
    selectData.value.selectCompanyList = [{ bizId: companyData.value.companyId, name: companyData.value.companyName }];
    showSelectCompany.value = true;
  }
};

// 关闭选择公司
const closeSelectCompany = data => {
  companyData.value = data.selectCompanyList.map(item => {
    return { companyName: item.name, companyId: item.bizId };
  })[0];
  emits('getCompanyData', companyData.value);
  getRoleTyoeTreeData();
};
</script>

<style scoped lang="less">
@import url('@/styles/commonTree.less');
.p12 {
  padding: 12px;
  border: 1px solid rgba(197, 207, 209, 0.4);
}
.box {
  border-radius: 5px 0 5px 5px;
}
:deep(.ant-tree-title) {
  width: 100% !important;
}
:deep(.ant-tree) {
  background-color: #fff !important;
}
.edit-icon {
  text-align: right;
  width: 60px !important;
}
.tree-edit:hover .edit-title {
  width: calc(100% - 70px) !important;
}
.left-header-title {
  cursor: pointer;
}
</style>
