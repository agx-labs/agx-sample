<template>
  <a-modal
    :width="762"
    :maskClosable="false"
    :visible="props.visible"
    :confirm-loading="loading"
    :forceRender="true"
    title="层级维护"
    :body-style="{ paddingBottom: '8px' }"
    @update:visible="updateVisible"
    @ok="save"
    @close="updateVisible(false)"
  >
    <common-table
      :columns="columns"
      ref="tableRef"
      :dataSource="levelList"
      :loading="loading"
      size="small"
      :rowSelection="false"
      :height100="false"
      :isPage="false"
    >
      <template #toolRight>
        <icon-font iconClass="icon-opt-tianjia" font-size="24px" title="新增" color="#60666b" @click="addLevel"></icon-font>
      </template>
      <template #bodyCell="{ column, record, index }">
        <template v-if="column.dataIndex == 'levelNumber'">
          <a-select v-model:value="record.levelNumber" :bordered="false" :showArrow="false" style="width: 100%" placeholder="请选择">
            <a-select-option :value="item.value" v-for="item in props.levelNumberList" :key="item.value">{{ item.name }}</a-select-option>
          </a-select>
        </template>
        <template v-if="column.dataIndex == 'levelName'">
          <a-input v-model:value="record.levelName" :bordered="false" placeholder="请输入"></a-input>
        </template>
        <template v-if="column.dataIndex == 'levelCode'">
          <a-input v-model:value="record.levelCode" :bordered="false" placeholder="请输入"></a-input>
        </template>
        <template v-if="column.dataIndex == 'levelColor'">
          <a-space>
            <color-picker v-model:value="record.levelColor" />
            <span>{{ record.levelColor }}</span>
          </a-space>
        </template>
        <template v-if="column.dataIndex == 'action'">
          <icon-font iconClass="icon-opt-shanchu" font-size="24px" title="删除" color="#60666b" @click="remove(index)"></icon-font>
        </template>
      </template>
    </common-table>
  </a-modal>
</template>

<script setup name="OrgLevel">
import { ref, onMounted } from 'vue';
import { message } from 'ant-design-vue';
import { OrgApi } from '../api/OrgApi';

const props = defineProps({
  visible: Boolean,
  levelNumberList: Array
});

const emits = defineEmits(['update:visible', 'done']);
// 弹框加载
const loading = ref(false);

const levelList = ref([]);

const columns = ref([
  {
    title: '层级级别',
    width: 100,
    dataIndex: 'levelNumber',
    customCell: record => {
      return {
        class: 'cell-hover'
      };
    }
  },
  {
    title: '层级名称',
    width: 100,
    dataIndex: 'levelName',
    customCell: record => {
      return {
        class: 'cell-hoverr'
      };
    }
  },
  {
    title: '层级编码',
    width: 100,
    dataIndex: 'levelCode',
    customCell: record => {
      return {
        class: 'cell-hoverr'
      };
    }
  },
  {
    title: '颜色',
    width: 100,
    dataIndex: 'levelColor',
    customCell: record => {
      return {
        class: 'cell-hoverr'
      };
    }
  },
  {
    title: '操作',
    width: 60,
    align: 'center',
    dataIndex: 'action'
  }
]);

onMounted(() => {
  getLevelList();
});

const getLevelList = async () => {
  levelList.value = await OrgApi.organizationLevelList();
};

const addLevel = () => {
  let obj = {
    levelNumber: undefined,
    levelName: '',
    levelCode: '',
    levelColor: 'fff'
  };
  levelList.value.push(obj);
};

const remove = index => {
  levelList.value = levelList.value.filter((item, i) => i !== index);
};

// 更改弹框状态
const updateVisible = value => {
  emits('update:visible', value);
};

// 点击保存
const save = async () => {
  if (levelList.value.length == 0) return message.warning('层级不能为空');
  const hasUndefinedOrEmpty = levelList.value.some(
    obj => obj.levelNumber === undefined || obj.levelName === '' || obj.levelCode === '' || obj.levelColor === ''
  );

  if (hasUndefinedOrEmpty) return message.warning('存在 undefined 或者空字符串');
  loading.value = true;
  OrgApi.updateTotal({ levelList: levelList.value })
    .then(res => {
      message.success(res.message);
      updateVisible(false);
      emits('done');
    })
    .finally(() => (loading.value = false));
};
</script>

<style scoped></style>
