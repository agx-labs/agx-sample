<!-- 双侧栏一级 -->
<template>
  <div class="guns-admin-sidebar-nav">
    <slot name="nav-top"></slot>
    <div class="guns-admin-sidebar-nav-menu">
      <LayoutMenus
        :data="data"
        :theme="theme"
        title-slot="nav-title"
        :selected-keys="active"
        :inline-indent="inlineIndent"
        :inline-collapsed="isCollapse"
        first-pop-class="guns-admin-sidebar-nav-menu-pop"
        @titleClick="onTitleClick"
      >
        <template v-for="name in Object.keys($slots)" #[name]="slotProps">
          <slot :name="name" v-bind="slotProps || {}"></slot>
        </template>
      </LayoutMenus>
    </div>
    <div v-if="showNavCollapse" class="guns-admin-sidebar-nav-tool-item" @click="toggleCollapse">
      <MenuUnfoldOutlined v-if="collapse" />
      <MenuFoldOutlined v-else />
    </div>
    <slot name="nav-bottom"></slot>
  </div>
</template>

<script>
import { defineComponent, computed } from 'vue';
import MenuFoldOutlined from '@ant-design/icons-vue/es/icons/MenuFoldOutlined';
import MenuUnfoldOutlined from '@ant-design/icons-vue/es/icons/MenuUnfoldOutlined';
import LayoutMenus from './layout-menus';

export default defineComponent({
  name: 'LayoutSidebarNav',
  components: { MenuFoldOutlined, MenuUnfoldOutlined, LayoutMenus },
  props: {
    // 菜单数据
    data: {
      type: Array,
      required: true
    },
    // 菜单选中
    active: Array,
    // 是否折叠
    collapse: Boolean,
    // 菜单主题
    theme: String,
    // 是否显示折叠按钮
    showNavCollapse: Boolean,
    // 二级侧栏是否折叠
    menuCollapse: Boolean,
    // 菜单缩进
    inlineIndent: Number
  },
  emits: ['toggle-collapse', 'title-click'],
  setup(props, { emit }) {
    // 是否折叠
    const isCollapse = computed(() => {
      return !!(props.collapse || props.menuCollapse);
    });

    /* 折叠展开菜单 */
    const toggleCollapse = () => {
      emit('toggle-collapse');
    };

    /* 父级菜单点击事件 */
    const onTitleClick = (key, item) => {
      emit('title-click', key, item);
    };

    return { isCollapse, toggleCollapse, onTitleClick };
  }
});
</script>
