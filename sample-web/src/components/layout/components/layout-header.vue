<!-- 顶栏 -->
<template>
  <div :class="['guns-admin-header', { 'guns-admin-header-primary': isPrimary }]">
    <!-- logo -->
    <div class="guns-admin-logo" @click="onLogoClick">
      <slot name="logo"></slot>
      <span v-if="projectName">{{ projectName }}</span>
    </div>
    <!-- 左侧功能区 -->
    <div class="guns-admin-header-tool" v-if="showLeftTool">
      <div v-if="showCollapse" class="guns-admin-header-tool-item" @click="toggleCollapse">
        <MenuUnfoldOutlined v-if="collapse" />
        <MenuFoldOutlined v-else />
      </div>
      <div v-if="showRefresh" class="guns-admin-header-tool-item" @click="reloadPage">
        <ReloadOutlined />
      </div>
      <!-- 自定义左侧功能 -->
      <slot name="left" v-if="!isMobile"></slot>
    </div>
    <!-- 面包屑导航 -->
    <div v-if="showBreadcrumb" class="guns-admin-breadcrumb">
      <ABreadcrumb :separator="breadcrumbSeparator">
        <ABreadcrumbItem v-for="d in levels" :key="d.fullPath">
          <RouterLink v-if="d.home" :to="d.fullPath">
            <HomeOutlined :title="d.title" />
          </RouterLink>
          <span v-else>{{ d.title }}</span>
        </ABreadcrumbItem>
      </ABreadcrumb>
    </div>
    <!-- 自定义中间区域 -->
    <slot name="center"></slot>
    <!-- 顶部菜单区 -->
    <div class="guns-admin-header-nav">
      <LayoutMenus
        :data="headerMenus"
        :theme="theme"
        mode="horizontal"
        v-if="headerMenus"
        title-slot="top-title"
        :showIcon="showIcon"
        :selected-keys="currentActive"
        :is-app="applicationStyle"
        @titleClick="onTitleClick"
        @appChange="appChange"
      >
        <template v-for="name in Object.keys($slots)" #[name]="slotProps">
          <slot :name="name" v-bind="slotProps || {}"></slot>
        </template>
      </LayoutMenus>
    </div>
    <!-- 右侧功能区 -->
    <slot name="right" :isMobile="isMobile"></slot>
  </div>
</template>

<script>
import { defineComponent, computed, ref } from 'vue';
import { Breadcrumb as ABreadcrumb, BreadcrumbItem as ABreadcrumbItem } from 'ant-design-vue/es';
import LayoutMenus from './layout-menus';
import { useRouter } from 'vue-router';
import { useUserStore } from '@/store/modules/user';
import { isExternalLink } from '@/utils/common/menu-util';
import props from '../props';

export default defineComponent({
  name: 'LayoutHeader',
  components: {
    ABreadcrumb,
    ABreadcrumbItem,
    LayoutMenus
  },
  props: {
    // 项目名
    projectName: String,
    // 面包屑导航数据
    levels: {
      type: Array,
      required: true
    },
    // 顶栏菜单数据
    menus: {
      type: Array,
      required: true
    },
    // 顶栏菜单选中
    active: {
      type: Array,
      required: true
    },
    // 顶栏风格
    headStyle: String,
    // 是否折叠侧栏
    collapse: Boolean,
    // 是否显示左边功能区
    showLeftTool: Boolean,
    // 是否显示折叠按钮
    showCollapse: Boolean,
    // 是否显示刷新按钮
    showRefresh: Boolean,
    // 是否显示面包屑导航
    showBreadcrumb: Boolean,
    // 面包屑导航分隔符
    breadcrumbSeparator: String,
    isMobile: Boolean,
    // 顶部应用配置
    applicationStyle: String,
  },
  emits: ['logo-click', 'reload-page', 'toggle-collapse', 'title-click'],
  setup(props, { emit }) {
    // 路由
    const router = useRouter();
    // store
    const userStore = useUserStore();

    const path = ref('');

    // 是否是主色顶栏
    const isPrimary = computed(() => props.headStyle === 'primary');

    // 顶栏菜单主题
    const theme = computed(() => {
      return isPrimary.value ? 'light' : props.headStyle;
    });

    // 应用列表
    const appList = computed(() => {
      return userStore.appList;
    });

    // 当前激活应用
    const activeApp = computed(() => {
      return userStore.activeApp;
    });

    const headerMenus = computed(() => {
      if (props.applicationStyle == 'top') {
        return appList.value?.map(item => {
          return {
            ...item,
            meta: {
              hide: false,
              title: item.appName,
              icon: item.appIconWrapper
            },
            component: '',
            path: item.appId
          };
        });
      } else {
        return props.menus;
      }
    });

    const currentActive = computed(() => {
      if (props.applicationStyle == 'top') {
        const appId = activeApp.value?.appId;
        return appId ? [appId] : [];
      } else {
        return props.active;
      }
    });

    const showIcon = computed(() => {
      if (props.applicationStyle == 'top') {
        return true;
      } else {
        return false;
      }
    });

    /* 折叠展开侧栏 */
    const toggleCollapse = () => {
      emit('toggle-collapse');
    };

    /* 刷新页面 */
    const reloadPage = () => {
      emit('reload-page');
    };

    /* logo 点击事件 */
    const onLogoClick = () => {
      emit('logo-click');
    };

    /* 菜单父级点击事件 */
    const onTitleClick = (key, item) => {
      emit('title-click', key, item);
    };

    // 应用切换
    const appChange = e => {
      if (props.applicationStyle != 'top') return;
      const item = appList.value.find(a => a.appId == e.key);
      let isNewTab = false;
      if (e.domEvent?.key == 'Control' || e.domEvent?.keyCode == 17 || e.domEvent?.ctrlKey) {
        isNewTab = true;
      }

      if (item.appId != activeApp.value.appId) {
        if (item.menuList && item.menuList.length) {
          setPath(item.menuList);
          if (isNewTab) {
            const { href } = router.resolve({
              path: path.value
            });
            window.open(href, '_blank');
          } else {
            if (isExternalLink(path.value)) {
              const { href } = router.resolve({
                path: path.value
              });
              window.open(href, '_blank');
            } else {
              router.push(path.value);
            }
          }
        }
      }
    };

    // 设置path
    const setPath = arr => {
      if (!arr[0].children || arr[0].children.length == 0) {
        path.value = arr[0].path;
        if (arr[0].appDesignBusinessId) {
          path.value = path.value + '?businessId=' + arr[0].appDesignBusinessId;
        }
      } else {
        setPath(arr[0].children);
      }
    };

    return {
      isPrimary,
      theme,
      headerMenus,
      appList,
      activeApp,
      currentActive,
      showIcon,
      path,
      appChange,
      setPath,
      toggleCollapse,
      reloadPage,
      onLogoClick,
      onTitleClick,
    };
  }
});
</script>

<style scoped lang="less"></style>
