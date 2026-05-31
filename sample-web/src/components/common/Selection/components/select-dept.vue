<template>
  <div class="user-select">
    <guns-split-layout :width="props.isMobileFlag ? '100%' : '50%'" :allowCollapse="false">
      <!-- 公司部门选择 -->
      <div class="user-select-item">
        <SelectionOrgTree
          @treeSelect="treeSelect"
          @checkedTree="checkedTree"
          :isRadio="props.isRadio"
          ref="selectionOrgTreeRef"
        ></SelectionOrgTree>
      </div>
      <template #content>
        <!-- 已选列表 -->
        <div class="user-select-item">
          <selected-list v-model:list="deptList" @delete="deleteUser" @deleteAll="deleteAll" />
        </div>
      </template>
    </guns-split-layout>
  </div>
</template>

<script setup name="SelectDept">
import { nextTick, ref, watch } from 'vue';
import SelectionOrgTree from './org-tree.vue';

const props = defineProps({
  // 是否单选
  isRadio: {
    type: Boolean,
    default: true
  },
  isMobileFlag: Boolean
});

const emits = defineEmits(['selectedChange']);
// 选中列表
const deptList = ref([]);

const selectionOrgTreeRef = ref(null);

// 左侧树选中
const treeSelect = (selectedKeys, { node }) => {
  let currentNode = { ...node, bizId: node.orgId, name: node.orgName, children: null };
  const existingDept = deptList.value.find(item => item.bizId === node.orgId);
  if (props.isRadio) {
    deptList.value = existingDept ? [] : [currentNode];
  } else {
    if (existingDept) {
      deleteUser(currentNode);
    } else {
      deptList.value.push(currentNode);
    }
  }
};

const checkedTree = (checked, node) => {
  node.bizId = node.orgId;
  node.name = node.orgName;
  // 选中状态
  if (checked) {
    if (!deptList.value.find(item => item.bizId == node.orgId)) {
      deptList.value.push(node);
    }
  } else {
    // 取消选中状态
    deleteUser(node);
  }
};

// 刪除已选单个
const deleteUser = record => {
  deptList.value.splice(
    deptList.value.findIndex(item => item.bizId === record.bizId),
    1
  );
};

// 删除全部已选
const deleteAll = () => {
  deptList.value = [];
};

// 监听已选数据的变化
watch(
  () => deptList.value,
  val => {
    emits('selectedChange');
    nextTick(() => {
      if (!props.isRadio && selectionOrgTreeRef.value) {
        selectionOrgTreeRef.value.checkedKeyss = deptList.value?.map(item => item.bizId);
      }
    });
  },
  { deep: true }
);

defineExpose({
  deptList
});
</script>

<style scoped lang="less">
.user-select {
  width: 100%;
  height: 100%;
  overflow: hidden;

  .user-select-item {
    width: 100%;
    height: 100%;
    border: 1px solid rgba(197, 207, 209, 0.4);
  }
}
</style>
