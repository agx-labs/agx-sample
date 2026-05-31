<template>
  <div class="user-select">
    <guns-split-layout :width="props.isMobileFlag ? '100%' : '340px'" :allowCollapse="false">
      <div class="user-select-org">
        <div class="user-header">字典类型列表</div>
        <!-- 搜索 -->
        <div class="search">
          <a-input v-model:value="typeWhere.searchText" placeholder="字典类型名称（回车搜索）" @pressEnter="typeReload" style="width: 100%">
            <template #prefix>
              <icon-font iconClass="icon-opt-search"></icon-font>
            </template>
          </a-input>
        </div>
        <div class="user-table">
          <common-table
            :columns="typeColumns"
            :isSort="false"
            :where="typeWhere"
            :isPage="false"
            rowId="dictTypeId"
            :isRadio="true"
            ref="tableTypeRef"
            :showTool="false"
            url="/dictType/list"
            isShowRowSelect
            @onSelect="dictTypeSelect"
          ></common-table>
        </div>
      </div>
      <template #content>
        <div class="user-select-right">
          <!-- 字典选择 -->
          <div class="user-select-user">
            <div class="user-header">字典列表</div>
            <!-- 搜索 -->
            <div class="search">
              <a-input v-model:value="where.searchText" placeholder="字典名称（回车搜索）" @pressEnter="reload" style="width: 100%">
                <template #prefix>
                  <icon-font iconClass="icon-opt-search"></icon-font>
                </template>
              </a-input>
            </div>
            <div class="user-table">
              <common-table
                :columns="columns"
                :where="where"
                isShowRowSelect
                :isLoad="isLoad"
                :isSort="false"
                :isPage="false"
                rowId="dictId"
                ref="tableRef"
                :isRadio="props.isRadio"
                :showTool="false"
                url="/dict/list"
                @onSelect="onSelect"
                @onSelectAll="onSelectAll"
              ></common-table>
            </div>
          </div>
          <!-- 已选列表 -->
          <div class="user-select-list">
            <selected-list v-model:list="dictList" @delete="deleteRelation" @deleteAll="deleteAll"></selected-list>
          </div>
        </div>
      </template>
    </guns-split-layout>
  </div>
</template>

<script setup name="SelectDicts">
import { radioSelect, checkBox, getSelectedRowKeys } from './common';
import { ref, watch, nextTick } from 'vue';
import SelectedList from './selected-list.vue';

const props = defineProps({
  // 是否单选
  isRadio: {
    type: Boolean,
    default: true
  },
  isMobileFlag: Boolean
});
const emits = defineEmits(['selectedChange']);
//已选列表
const dictList = ref([]);
// 搜索条件
const where = ref({
  dictTypeId: ''
});
const typeWhere = ref({});
//类型数据
const typeData = ref(null);
//字典类型表格配置
const typeColumns = ref([
  {
    title: '类型',
    dataIndex: 'dictTypeName',
    isShow: true,
    width: 120,
    ellipsis: true
  },
  {
    title: '编码',
    isShow: true,
    ellipsis: true,
    width: 120,
    dataIndex: 'dictTypeCode'
  }
]);
//字典配置
const columns = ref([
  {
    title: '名称',
    isShow: true,
    ellipsis: true,
    dataIndex: 'dictName'
  },
  {
    title: '编码',
    isShow: true,
    ellipsis: true,
    dataIndex: 'dictCode'
  }
]);

const tableRef = ref(null);
const tableTypeRef = ref(null);

// 删除已选单行
const deleteRelation = record => {
  dictList.value.splice(
    dictList.value.findIndex(item => item.bizId === record.bizId),
    1
  );
};

// 删除全部已选
const deleteAll = () => {
  dictList.value = [];
};

// 字典类型点击
const dictTypeSelect = (record, selected, selectedRows) => {
  typeData.value = record;
  where.value.dictTypeId = record.dictTypeId;
  reload();
};

// 选中或取消选中某一列
const onSelect = (record, selected, selectedRows) => {
  props.isRadio ? (dictList.value = []) : '';
  radioSelect(record, selected, dictList.value, 'dictId', 'dictName');
};

// 全选反选
const onSelectAll = (selected, selectedRows, changeRows) => {
  checkBox(selected, changeRows, dictList.value, 'dictId', 'dictName');
};

// 表格数据变化
const tableListChange = (list, id) => {
  tableRef.value.selectedRowKeys = getSelectedRowKeys(list, id, dictList.value);
};

const isLoad = () => {
  return where.value?.dictTypeCode ? false : true;
};

// 监听已选列表变化
watch(
  () => dictList.value,
  val => {
    tableListChange(val, 'bizId');
    emits('selectedChange');
  },
  { deep: true }
);

// 搜索
const reload = () => {
  nextTick(() => {
    tableRef.value.reload();
  });
};
// 搜索
const typeReload = () => {
  nextTick(() => {
    tableTypeRef.value?.reload();
  });
};

defineExpose({
  dictList
});
</script>

<style scoped lang="less">
.user-select {
  width: 100%;
  height: 100%;
  display: flex;
  overflow: hidden;
  border-radius: 8px;

  .user-select-org {
    width: 100%;
    height: 100%;
    border: 1px solid rgba(197, 207, 209, 0.4);
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
    margin-top: 10px;
    height: calc(100% - 58px - 62px);
    padding: 0 16px;
  }

  .user-select-right {
    width: 100%;
    height: 100%;
    display: flex;
    flex-direction: row;

    .user-select-user {
      width: calc(100% - 292px - 16px);
      height: 100%;
      border: 1px solid rgba(197, 207, 209, 0.4);
    }
    .user-select-list {
      margin-left: 16px;
      border-radius: 8px;
      border: 1px solid rgba(197, 207, 209, 0.4);
      width: 292px;
      height: 100%;
    }
  }
}
@media screen and (max-width: 768px) {
  .user-select-right {
    display: block !important;
  }
  .user-select-user {
    width: 100% !important;
  }
  .user-select-list {
    margin-top: 16px;
    width: 100% !important;
    margin-left: 0 !important;
  }
}
</style>
