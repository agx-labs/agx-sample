<template>
  <div class="user-select">
    <guns-split-layout :width="props.isMobileFlag ? '100%' : '50%'" :allowCollapse="false">
      <div class="user-select-item">
        <div class="user-header">职位列表</div>
        <!-- 搜索 -->
        <div class="search">
          <a-input v-model:value="where.searchText" placeholder="职位名称、编码（回车搜索）" @pressEnter="reload">
            <template #prefix>
              <icon-font iconClass="icon-opt-search"></icon-font>
            </template>
          </a-input>
        </div>
        <div class="user-table">
          <common-table
            :columns="columns"
            :where="where"
            bordered
            isShowRowSelect
            :isRadio="props.isRadio"
            rowId="positionId"
            ref="tableRef"
            :showTool="false"
            url="/hrPosition/page"
            @onSelect="onSelect"
            @onSelectAll="onSelectAll"
            @tableListChange="list => tableListChange(list, 'positionId')"
          >
            <template #bodyCell="{ column, record }">
              <!-- 状态 -->
              <template v-if="column.dataIndex == 'statusFlag'">
                <a-tag color="blue" v-if="record.statusFlag == 1">启用</a-tag>
                <a-tag color="red" v-if="record.statusFlag == 2">禁用</a-tag>
              </template>
            </template>
          </common-table>
        </div>
      </div>
      <template #content>
        <!-- 已选列表 -->
        <div class="user-select-item">
          <selected-list v-model:list="positionList" @delete="deleteUser" @deleteAll="deleteAll" />
        </div>
      </template>
    </guns-split-layout>
  </div>
</template>

<script setup name="SelectPosition">
import { ref, watch } from 'vue';
import { radioSelect, checkBox, getSelectedRowKeys } from './common';

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
const positionList = ref([]);

// 搜索条件
const where = ref({
  searchText: ''
});
// ref
const tableRef = ref(null);
// 表格配置
const columns = ref([
  {
    key: 'index',
    title: '序号',
    width: 48,
    align: 'center',
    isShow: true
  },
  {
    dataIndex: 'positionName',
    title: '职位名称',
    align: 'center',
    width: 100,
    ellipsis: true,
    isShow: true
  },
  {
    dataIndex: 'positionCode',
    title: '职位编码',
    width: 100,
    align: 'center',
    isShow: true
  },
  {
    dataIndex: 'statusFlag',
    title: '状态',
    align: 'center',
    width: 100,
    isShow: true
  }
]);

// 重新查询
const reload = () => {
  tableRef.value.reload();
};

// 选中或取消选中某一列
const onSelect = (record, selected, selectedRows) => {
  props.isRadio ? (positionList.value = []) : '';
  radioSelect(record, selected, positionList.value, 'positionId', 'positionName');
};

// 全选反选
const onSelectAll = (selected, selectedRows, changeRows) => {
  checkBox(selected, changeRows, positionList.value, 'positionId', 'positionName');
};

// 表格数据变化
const tableListChange = (list, id) => {
  if (tableRef.value?.selectedRowList) {
    tableRef.value.selectedRowList = getSelectedRowKeys(list, id, positionList.value);
  }
};

// 刪除已选单个
const deleteUser = record => {
  positionList.value.splice(
    positionList.value.findIndex(item => item.bizId === record.bizId),
    1
  );
};

// 删除全部已选
const deleteAll = () => {
  positionList.value = [];
};

// 监听已选数据的变化
watch(
  () => positionList.value,
  val => {
    if (tableRef.value) {
      tableListChange(val, 'bizId');
      emits('selectedChange');
    }
  },
  { deep: true }
);

defineExpose({
  positionList
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
.user-header {
  height: 48px;
  padding: 8px 16px;
  line-height: 32px;
  background: #f7f7f9;
  color: #43505e;
  font-size: 16px;
}
.search {
  margin-top: 10px;
  padding: 0 16px;
  height: 36px;
  border-radius: 5px;
  margin-bottom: 16px;
  .ant-input-affix-wrapper {
    height: 100%;
  }
}
.user-table {
  height: calc(100% - 48px - 62px);
  padding: 0 16px;
}
</style>
