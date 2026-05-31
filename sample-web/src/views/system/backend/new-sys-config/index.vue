<template>
  <div class="guns-layout">
    <guns-split-layout width="292px">
      <div class="guns-layout-sidebar width-100">
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
                <template #title>配置管理</template>
                <div v-permission="['SYS_CONFIG']">
                  <a-menu-item key="1"> 系统配置 </a-menu-item>
                </div>
                <div v-permission="['FILE_CONFIG']">
                  <a-menu-item key="2"> 文件配置 </a-menu-item>
                </div>
              </a-sub-menu>
            </a-menu>
          </div>
        </div>
      </div>
      <template #content>
        <div class="guns-layout-content" style="padding: 0">
          <div class="guns-layout">
            <!-- 系统配置 -->
            <SysConfig v-if="currentMenuSelect == '1'" style="flex-direction: row" />
            <!-- 文件配置 -->
            <FileConfig v-if="currentMenuSelect == '2'" />
          </div>
        </div>
      </template>
    </guns-split-layout>
  </div>
</template>

<script setup name="NewSysConfig">
import { useUserStore } from '@/store/modules/user';
import { ref, defineAsyncComponent, onMounted, computed } from 'vue';

defineOptions({
  name: 'NewSysConfig'
});

const userStore = useUserStore();

// 系统配置
const SysConfig = defineAsyncComponent(() => import('../sys-config/index.vue'));
// 文件配置
const FileConfig = defineAsyncComponent(() => import('./file-config.vue'));

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
  if (authorities.value.includes('SYS_CONFIG')) {
    key = '1';
  } else if (authorities.value.includes('FILE_CONFIG')) {
    key = '2';
  }
  if (key) {
    selectedKeys.value = [key];
    selectChange({ key });
  }
});
</script>

<style scoped lang="less">
@import url('@/styles/commonMenu.less');
</style>
