<template>
  <div class="selected">
    <!-- 已选列表 -->
    <div class="selected-top">
      <span>已选</span>
      <span class="selected-del">
        <a @click="deleteAll">清空</a>
      </span>
    </div>
    <!-- 搜索框-->
    <div class="selected-search">
      <a-input v-model:value="searchText" placeholder="请输入名称（回车搜索）" allow-clear>
        <template #prefix>
          <icon-font iconClass="icon-opt-search"></icon-font>
        </template>
      </a-input>
    </div>
    <div class="selected-bottom">
      <div class="bottom-list" v-if="props.list">
        <!-- 空数据 -->
        <a-empty :image="state.simpleImage" v-if="list && list.length == 0" />
        <!-- 已选列表 -->
        <div v-else>
          <div class="list" v-for="(item, index) in props.list?.filter(item => item.name.includes(searchText))" :key="item.id">
            <div class="selected-name">{{ index + 1 }}. {{ item.subValueName ? item.subValueName + '#' : '' }}{{ item.name }}</div>
            <div class="selected-del">
              <icon-font iconClass="icon-opt-shanchu" title="删除" color="#000" @click="deleteClick(item)"></icon-font>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup name="SelectedList">
import { reactive, ref } from 'vue';
import { Empty } from 'ant-design-vue';

const props = defineProps({
  // 已选列表
  list: Array
});

const emits = defineEmits(['delete', 'deleteAll']);

const state = reactive({
  //空数据的图片
  simpleImage: Empty.PRESENTED_IMAGE_SIMPLE
});

const searchText = ref('');

// 点击删除单个
const deleteClick = item => {
  emits('delete', item);
};

// 删除全部已选
const deleteAll = () => {
  emits('deleteAll');
};
</script>

<style scoped lang="less">
.selected {
  width: 100%;
  height: 100%;
  overflow-y: auto;
  .selected-top {
    width: 100%;
    padding: 8px 16px;
    height: 48px;
    line-height: 32px;
    position: relative;
    font-size: 16px;
    background: #f7f7f9;
    color: #43505e;
    .selected-del {
      position: absolute;
      right: 12px;
      cursor: pointer;
      &:hover {
        color: red;
      }
    }
  }
  .selected-search {
    margin-top: 10px;
    padding: 0 16px;
    height: 36px;
    border-radius: 5px;
    margin-bottom: 16px;
    .ant-input-affix-wrapper {
      height: 100%;
    }
  }
  .selected-bottom {
    padding: 0 16px 16px 16px;
    height: calc(100% - 48px - 62px);
    .bottom-list {
      width: 100%;
      height: 100%;
      overflow-y: auto;
      position: relative;
      .ant-empty {
        position: absolute;
        left: 50%;
        top: 50%;
        margin-left: -32px;
        margin-top: -42px;
      }
    }
    .list {
      display: flex;
      width: 100%;
      padding: 0 12px;
      height: 100%;
      .selected-name {
        width: 80%;
        padding: 12px 0;
      }
      .selected-del {
        width: 20%;
        cursor: pointer;
        padding: 12px 0;
        display: flex;
        align-items: center;
        justify-content: right;
        &:hover {
          color: red;
        }
      }
    }
  }
}
</style>
