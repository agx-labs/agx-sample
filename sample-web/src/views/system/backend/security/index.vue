<template>
  <div class="guns-layout">
    <guns-split-layout :resizable="false">
      <div class="guns-layout-sidebar width-100 p-t-12">
        <div class="sidebar-content">
          <div class="sidebar-content">
            <a-menu
              v-model:selectedKeys="selectedKeys"
              class="sidebar-menu"
              mode="inline"
              :open-keys="openKeys"
              @select="selectChange"
              @openChange="openChange"
            >
              <a-sub-menu key="1">
                <template #title>策略配置</template>
                <div v-permission="['PASSWORD_STRATEGY_CONFIG']">
                  <a-menu-item key="1"> 密码策略 </a-menu-item>
                </div>
                <div v-permission="['BLACK_WHITE_LIST_UPDATE']">
                  <a-menu-item key="2"> 黑白名单 </a-menu-item>
                </div>
              </a-sub-menu>
            </a-menu>
          </div>
        </div>
      </div>
      <template #content>
        <div class="guns-layout-content">
          <Security :currentMenuSelect="currentMenuSelect" />
        </div>
      </template>
    </guns-split-layout>
  </div>
</template>

<script setup name="BackendSecurity">
import { useUserStore } from '@/store/modules/user';
import { ref, onMounted, computed } from 'vue';
import Security from './security.vue';

defineOptions({
  name: 'BackendSecurity'
});

const userStore = useUserStore();

// 左侧菜单展开列表
const openKeys = ref(['1']);
// 左侧菜单选中列表
const selectedKeys = ref([]);

// 当前菜单选中
const currentMenuSelect = ref('');

// 权限列表
const authorities = computed(() => {
  return userStore.authorities ?? [];
});

// 左侧菜单选中
const selectChange = ({ key }) => {
  currentMenuSelect.value = key;
};

// 设置展开
const openChange = () => {
  openKeys.value = ['1'];
};

onMounted(() => {
  let key = '';
  selectedKeys.value = [];
  if (authorities.value.includes('PASSWORD_STRATEGY_CONFIG')) {
    key = '1';
  } else if (authorities.value.includes('BLACK_WHITE_LIST_UPDATE')) {
    key = '2';
  }
  if (key) {
    selectedKeys.value = [key];
    selectChange({ key });
  }
});
</script>

<style scoped lang="less"></style>
