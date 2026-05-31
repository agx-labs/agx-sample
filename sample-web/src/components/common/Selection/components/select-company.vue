<!--公司选择组件-->
<template>
  <div class="user-select">
    <guns-split-layout :width="props.isMobileFlag ? '100%' : '50%'" :allowCollapse="false">
      <!-- 公司选择 -->
      <div class="user-select-item">
        <SelectionOrgTree @treeSelect="treeSelect" :company-search-flag="true" ref="selectionOrgTreeRef"></SelectionOrgTree>
      </div>

      <!-- 已选列表 -->
      <template #content>
        <div class="user-select-item">
          <selected-list v-model:list="companyList" @delete="deleteCompany" @deleteAll="deleteAll" />
        </div>
      </template>
    </guns-split-layout>
  </div>
</template>

<script setup>
import { ref, watch } from 'vue';
import SelectedList from './selected-list.vue';
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

// 已选公司列表
const companyList = ref([]);

// ref
const selectionOrgTreeRef = ref();

// 树选择
const treeSelect = (selectedKeys, info) => {
  let bizId = info.node.orgId;
  let obj = {
    bizId: bizId,
    name: info.node.orgName
  };

  // 是否多选
  if (!props.isRadio) {
    // 如果选中的公司列表中没有该公司则push到数组中
    if (companyList.value.filter(item => item.bizId === bizId).length === 0) {
      companyList.value.push(obj);
    }
  } else {
    companyList.value = [obj];
  }
};

// 已选删除单个
const deleteCompany = record => {
  companyList.value.splice(
    companyList.value.findIndex(item => item.bizId === record.bizId),
    1
  );
};

// 删除全部已选
const deleteAll = () => {
  companyList.value = [];
};

// 监听已选列表变化
watch(
  () => companyList.value,
  val => {
    emits('selectedChange');
    if (props.isRadio && selectionOrgTreeRef.value) {
      if (val?.length) {
        selectionOrgTreeRef.value.currentSelectKeys = [val[0].bizId];
      } else {
        selectionOrgTreeRef.value.currentSelectKeys = [];
      }
    }
  },
  { deep: true }
);

defineExpose({
  companyList
});
</script>

<style scoped lang="less">
.user-select {
  width: 100%;
  height: 100%;
  display: flex;
  overflow: hidden;
  border-radius: 8px;

  .user-select-item {
    width: 100%;
    height: 100%;
    border: 1px solid rgba(197, 207, 209, 0.4);
  }
}
</style>
