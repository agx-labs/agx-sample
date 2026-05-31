<!-- 分割面板 -->
<template>
  <div
    ref="rootRef"
    :class="[
      'guns-split-panel',
      { 'is-reverse': reverse },
      { 'is-vertical': vertical },
      { 'is-collapse': isCollapse },
      { 'is-resizing': resizing },
      { 'is-responsive': isResponsive }
    ]"
    :style="{
      '--guns-split-size': resizedSize ?? width,
      '--guns-split-space': space
    }"
  >
    <!-- 侧边容器 -->
    <div ref="wrapRef" class="guns-split-panel-wrap">
      <div ref="sideRef" class="guns-split-panel-side" :style="leftStyle">
        <slot></slot>
      </div>
      <!-- 间距 -->
      <div class="guns-split-panel-space">
        <div v-if="resizable" class="guns-split-resize-line" @mousedown="onResize"></div>
      </div>
    </div>
    <!-- 内容 -->
    <div class="guns-split-panel-body" :style="rightStyle">
      <slot name="content" :collapse="isCollapse"></slot>
    </div>
    <!-- 折叠按钮 -->
    <div v-if="allowCollapse" :style="collapseBtnStyle" class="guns-split-collapse-button" @click="toggleCollapse()">
      <slot name="collapse" :collapse="isCollapse">
        <CaretUpOutlined v-if="vertical" class="guns-split-collapse-icon" />
        <CaretLeftOutlined v-else class="guns-split-collapse-icon" />
      </slot>
    </div>
    <!-- 小屏幕遮罩层 -->
    <div class="guns-split-panel-mask" @click="toggleCollapse()"></div>
  </div>
</template>

<script>
import { defineComponent, ref, watch, onMounted } from 'vue';
import { useResponsive } from '../../layout/util';

export default defineComponent({
  name: 'GunsSplitLayout',
  props: {
    // 左侧宽度
    width: {
      type: String,
      default: '252px'
    },
    // 最小尺寸
    minSize: Number,
    // 最大尺寸
    maxSize: Number,
    // 间距
    space: {
      type: String,
      default: '0px'
    },
    // 是否折叠
    collapse: Boolean,
    // 是否可折叠
    allowCollapse: {
      type: Boolean,
      default: true
    },
    // 左侧样式
    leftStyle: {
      type: Object,
      default: {
        height: '100%'
      }
    },
    // 右侧样式
    rightStyle: {
      type: Object,
      default: {
        height: '100%'
      }
    },
    // 折叠按钮样式
    collapseBtnStyle: Object,
    // 是否垂直方向
    vertical: Boolean,
    // 是否反向布局
    reverse: Boolean,
    // 是否可拉伸宽度
    resizable: {
      type: Boolean,
      default: true
    },
    // 是否开启响应式
    responsive: {
      type: Boolean,
      default: null
    },
    // 宽度缓存本地的 key
    cacheKey: String
  },
  emits: {
    'update:collapse': _collapse => true
  },
  setup(props, { emit }) {
    // 是否开启布局响应
    const isResponsive = useResponsive(props);

    // 根节点
    const rootRef = ref(null);

    // 侧边容器节点
    const wrapRef = ref(null);

    // 侧边节点
    const sideRef = ref(null);

    // 是否折叠
    const isCollapse = ref(false);

    // 拉伸后尺寸
    const resizedSize = ref(null);

    // 是否正在拉伸
    const resizing = ref(false);

    onMounted(() => {
      if (props.cacheKey) {
        const temp = localStorage.getItem(getCollWidthCacheKey(props.cacheKey));
        resizedSize.value = temp;
      }
    });

    /**
     * 宽度缓存的 key
     */
    const getCollWidthCacheKey = cacheKey => {
      return `${cacheKey}Coll-Width`;
    };

    /* 切换折叠状态 */
    const toggleCollapse = collapse => {
      isCollapse.value = typeof collapse === 'boolean' ? collapse : !isCollapse.value;
      emit('update:collapse', isCollapse.value);
    };

    /* 获取最大拉伸尺寸 */
    const getMaxSize = el => {
      const size = props.vertical ? el.clientHeight : el.clientWidth;
      if (!props.maxSize) {
        return size;
      }
      if (props.maxSize < 0) {
        // 负值形式
        return size + props.maxSize;
      } else if (props.maxSize < 1) {
        // 百分比形式
        return Math.floor(size * props.maxSize);
      }
      return Math.min(props.maxSize, size);
    };

    /* 拉伸 */
    const onResize = event => {
      const rootEl = rootRef.value;
      const sideEl = sideRef.value;
      if (!rootEl || !sideEl) {
        return;
      }
      resizing.value = true;
      // 获取原始位置
      const downX = event.clientX;
      const downY = event.clientY;
      const downW = sideEl.clientWidth;
      const downH = sideEl.clientHeight;
      const limitMin = props.minSize || 0;
      const limitMax = getMaxSize(rootEl);

      // 鼠标移动事件
      const mousemoveFn = e => {
        const size = props.vertical
          ? (props.reverse ? downY - e.clientY : e.clientY - downY) + downH
          : (props.reverse ? downX - e.clientX : e.clientX - downX) + downW;
        resizedSize.value = (size < limitMin ? limitMin : size > limitMax ? limitMax : size) + 'px';
        if (props.cacheKey) {
          localStorage.setItem(getCollWidthCacheKey(props.cacheKey), resizedSize.value);
        }
      };

      // 鼠标抬起事件
      const mouseupFn = () => {
        resizing.value = false;
        document.removeEventListener('mousemove', mousemoveFn);
        document.removeEventListener('mouseup', mouseupFn);
      };

      // 添加鼠标事件监听
      document.addEventListener('mousemove', mousemoveFn);
      document.addEventListener('mouseup', mouseupFn);
    };

    watch(
      [() => props.collapse, () => props.allowCollapse],
      () => {
        if (!props.allowCollapse) {
          isCollapse.value = false;
        } else {
          isCollapse.value = props.collapse;
        }
      },
      { immediate: true }
    );

    return {
      rootRef,
      wrapRef,
      sideRef,
      isResponsive,
      isCollapse,
      resizedSize,
      resizing,
      toggleCollapse,
      onResize,
      getCollWidthCacheKey
    };
  }
});
</script>

<style lang="less">
@import url('./style/index.less');
</style>
