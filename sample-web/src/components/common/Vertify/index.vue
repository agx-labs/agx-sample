<template>
  <a-modal
    :width="400"
    :maskClosable="false"
    :visible="props.visible"
    :confirm-loading="loading"
    :forceRender="true"
    :body-style="{ padding: '0' }"
    @update:visible="updateVisible"
    :footer="null"
    style="top: 50%; margin-top: -231px"
    :closable="false"
    @close="updateVisible(false)"
  >
    <Transition name="ym-anim-scale" :appear="true">
      <!-- 内容 -->
      <div
        class="ym-captcha-modal-content"
        ref="contentRef"
        :style="{
          borderColor: props.themeColor ?? null,
          background: props.bgColor ?? null,
          boxShadow:
            props.boxShadow && (props.boxShadowColor || props.themeColor)
              ? `0 0 ${$tools.convert2Rem(props.boxShadowBlur)} ${props.boxShadowColor || props.themeColor}`
              : null
        }"
      >
        <div class="ym-captcha-modal-wrap">
          <!-- 图片 -->
          <div class="ym-captcha-modal-embed">
            <!-- 加载动画 -->
            <div v-if="params.loading" class="ym-captcha-modal-loading">
              <div class="ym-captcha-modal-loading-spinner">
                <div class="load">
                  <div>
                    <div>
                      <div :style="{ borderColor: props.themeColor ?? null }"></div>
                      <div :style="{ background: props.themeColor ?? null }"></div>
                    </div>
                  </div>
                </div>
              </div>
              <div class="ym-captcha-modal-loading-tip">正在加载验证码 ···</div>
            </div>

            <!-- canvas 验证图形 -->
            <div class="ym-captcha-modal-info">
              <img
                :src="vertifySrc"
                alt=""
                class="base-img"
                :style="{ width: `${params.size.width}px`, height: `${params.size.height}px` }"
              />
              <canvas :width="params.size.width" :height="params.size.height" ref="imageRef"></canvas>
              <canvas :width="params.size.width" :height="params.size.height" ref="blockRef"></canvas>
            </div>

            <!-- 验证结果 -->
            <div
              :class="`ym-captcha-modal-result ${
                params.check.correct ? `ym-captcha-modal-result-success` : `ym-captcha-modal-result-error`
              }`"
              ref="resultRef"
              :innerHTML="params.check.tip"
            ></div>
          </div>
          <!-- 提示 -->
          <div ref="sliderRef" :class="`ym-captcha-modal-slider${params.drag.moving ? ` ym-captcha-modal-slider-moving` : ''}`">
            <div class="ym-captcha-modal-slider-track" :style="{ borderColor: props.themeColor ?? null }">
              <span :class="`ym-captcha-modal-slider-track-tip${params.drag.moving ? ' hide' : ''}`">拖动左边滑块完成上方拼图</span>
            </div>
            <!-- 拖动图形 -->
            <div class="ym-captcha-modal-slider-btn" :style="{ borderColor: props.themeColor ?? null }" ref="sliderBtnRef">
              <div class="ym-captcha-modal-slider-btn-icon" :style="{ borderColor: props.themeColor ?? null }">
                <div class="ym-captcha-modal-slider-btn-vertical"></div>
                <div class="ym-captcha-modal-slider-btn-horizontal" :style="{ borderColor: props.themeColor ?? null }"></div>
              </div>
            </div>
          </div>
        </div>
        <!-- 操作按钮 -->
        <div class="ym-captcha-modal-panel">
          <div class="ym-captcha-modal-panel-action">
            <a-tooltip overlayClassName="ym-captcha-modal-tooltip" :color="props.themeColor">
              <template #title>关闭验证</template>
              <CloseCircleOutlined @click="updateVisible(false)" />
            </a-tooltip>
            <a-tooltip overlayClassName="ym-captcha-modal-tooltip" :color="props.themeColor">
              <template #title>刷新验证</template>
              <ReloadOutlined @click="getVertifyData" />
            </a-tooltip>
          </div>
        </div>
      </div>
    </Transition>
  </a-modal>
</template>

<script setup name="Vertify">
import { ref, onMounted, Transition, reactive, onBeforeUnmount } from 'vue';
import { $tools } from './tools';
import { background } from './images';
import { message } from 'ant-design-vue/es';
import { VertifyApi } from './api/VertifyApi';
import { LoginApi } from '@/views/login/login/api/LoginApi';
import { IS_NEED_RSA, SSO_FLAG, SSO_CLIENT_ID } from '@/config/setting';
import { RsaEncry } from '@/utils/common/util';
import { setToken } from '@/utils/token-util';
import { SsoUtil } from '@/utils/common/sso-util';
import { cleanPageTabs } from '@/utils/page-tab-util';
import Vertify1 from './images/vertify1.png';
import Vertify2 from './images/vertify2.png';
import Vertify3 from './images/vertify3.png';
import Vertify4 from './images/vertify4.png';
import Vertify5 from './images/vertify5.png';

const props = defineProps({
  visible: Boolean,
  image: {
    type: String,
    default: undefined
  },
  position: {
    type: Object,
    default: undefined
  },
  mask: {
    type: Boolean,
    default: false
  },
  maskClosable: {
    type: Boolean,
    default: false
  },
  themeColor: {
    type: String,
    default: undefined
  },
  bgColor: {
    type: String,
    default: undefined
  },
  boxShadow: {
    type: Boolean,
    default: true
  },
  boxShadowColor: {
    type: String,
    default: undefined
  },
  boxShadowBlur: {
    type: Number,
    default: 6
  },
  maxTries: {
    type: Number,
    default: 5
  },
  verifyParams: {
    type: Object,
    default: {}
  },
  verifyMethod: {
    type: String,
    default: 'post'
  },
  verifyAction: {
    type: String,
    default: undefined
  },
  validate: Function,
  form: Object,
  ssoClientId: String,
  ssoCallback: String,
  goHome: Function
});

const emits = defineEmits(['update:visible', 'done']);
// 弹框加载
const loading = ref(false);

// 参数
const params = reactive({
  loading: true,
  background: background,
  ctx: {
    image: null,
    block: null
  },
  elements: {
    slider: null,
    block: null
  },
  coordinate: {
    x: 0,
    y: 0,
    offset: 6
  },
  size: {
    width: 374,
    height: 200
  },
  block: {
    size: 42,
    radius: 8,
    PI: Math.PI,
    real: 0
  },
  drag: {
    moving: false,
    originX: 0,
    originY: 0,
    offset: 0
  },
  time: {
    start: null,
    end: null
  },
  check: {
    tries: props.maxTries ?? 5,
    num: 0,
    correct: false,
    show: false,
    tip: null,
    being: false,
    value: null
  },
  _background: null
});

// ref
const contentRef = ref();
const sliderRef = ref();
const sliderBtnRef = ref();
const imageRef = ref();
const blockRef = ref();
const resultRef = ref();

// 常用的正则规则
const regExp = ref({
  mobile: /^1[3456789]\d{9}$/,
  url: /^((https|http|ftp|rtsp|mms)?:\/\/)(([0-9A-Za-z_!~*'().&=+$%-]+: )?[0-9A-Za-z_!~*'().&=+$%-]+@)?(([0-9]{1,3}.){3}[0-9]{1,3}|([0-9A-Za-z_!~*'()-]+.)*([0-9A-Za-z][0-9A-Za-z-]{0,61})?[0-9A-Za-z].[A-Za-z]{2,6})(:[0-9]{1,4})?((\/?)|(\/[0-9A-Za-z_!~*'().;?:@&=+$,%#-]+)+\/?)$/,
  password: /^[A-Za-z0-9~!@#$%^&*()_+=\-.,]{6,32}$/,
  username: /^[a-zA-Z]{1}([a-zA-Z0-9]|[_]){3,15}$/,
  email: /^[A-Za-z0-9\u4e00-\u9fa5]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$/
});

const dragFlag = ref(false);

// 后台图形数据
const vertifyData = ref({});

const vertifySrc = ref(null);

onMounted(() => {
  getVertifyData(true);
});

// 获取后端验证码图形
const getVertifyData = (isInit = false) => {
  getVertifySrc();
  VertifyApi.getDragCaptcha().then(res => {
    vertifyData.value = res.data;
    params._background = 'data:image/jpeg;base64,' + res.data.srcImage;
    if (isInit) {
      init();
    } else {
      resetDrag();
      redrawPicture();
    }
  });
};

// 把背景图+滑块图一次性重画（刷新时用）
const redrawPicture = () => {
  // 1. 先清空两块画布
  params.ctx.image?.clearRect(0, 0, params.size.width, params.size.height);
  params.ctx.block?.clearRect(0, 0, params.size.width, params.size.height);

  // 2. 重新拉两张图（已经存好的 base64）
  const bgImg = new Image();
  const blockImg = new Image();
  bgImg.src = params._background;
  blockImg.src = 'data:image/jpeg;base64,' + vertifyData.value.cutImage;

  // 3. 背景图画上去
  bgImg.onload = () => {
    params.ctx.image.drawImage(bgImg, 0, 0, params.size.width, params.size.height);
  };

  // 4. 滑块图画上去
  blockImg.onload = () => {
    params.ctx.block.drawImage(blockImg, 0, 0, 50, 50);
    blockRef.value.style.top = vertifyData.value.locationY + 'px';
  };
};

const getVertifySrc = () => {
  const num = Math.floor(Math.random() * 5) + 1;
  switch (num) {
    case 1: vertifySrc.value = Vertify1; break;
    case 2: vertifySrc.value = Vertify2; break;
    case 3: vertifySrc.value = Vertify3; break;
    case 4: vertifySrc.value = Vertify4; break;
    case 5: vertifySrc.value = Vertify5; break;
    default: vertifySrc.value = Vertify1;
  }
};

const init = () => {
  initModal();
};

// 初始化数据
const initModal = () => {
  params.elements = {
    slider: sliderBtnRef.value,
    block: blockRef.value
  };
  params.block.real = params.block.size + params.block.radius * 2 + 2;
  setCheckData();
  initCaptcha();
  $tools.on(params.elements.slider, 'pointerdown', dragStart);
  $tools.on(params.elements.slider, 'touchstart', dragStart);
  $tools.on(params.elements.slider, 'pointermove', dragMoving);
  $tools.on(params.elements.slider, 'touchmove', dragMoving);
  watchMouse();
};

const initCaptcha = () => {
  const image = imageRef.value;
  const block = blockRef.value;
  const imageCtx = image ? image.getContext('2d', { willReadFrequently: true }) : null;
  const blockCtx = block ? block.getContext('2d', { willReadFrequently: true }) : null;
  params.ctx = { image: imageCtx, block: blockCtx };
  if (regExp.value.url.test(params._background)) image2Base64(initImageElem);
  else initImageElem();
};

// base64编码
const image2Base64 = callback => {
  const elem = new Image();
  const canvas = document.createElement('canvas');
  const ctx = canvas.getContext('2d', { willReadFrequently: true });
  elem.crossOrigin = '';
  elem.src = params._background;
  elem.onload = () => {
    canvas.width = params.size.width;
    canvas.height = params.size.height;
    ctx.drawImage(elem, 0, 0, params.size.width, params.size.height);
    params._background = canvas.toDataURL();
    callback && callback();
  };
};

// 更改弹框状态
const updateVisible = value => {
  emits('update:visible', value);
};

const setCheckData = () => {
  params.check = {
    tries: props.maxTries ?? 5,
    num: 0,
    being: false,
    value: null,
    correct: false,
    tip: '拖动滑块将悬浮图像正确拼合',
    show: false
  };
};

// 初始化图例
const initImageElem = () => {
  redrawPicture();
  params.loading = false;
};

// 销毁事件
onBeforeUnmount(() => {
  clearEvent();
});

// 清除事件
const clearEvent = () => {
  $tools.off(params.elements.slider, 'pointerdown', dragStart);
  $tools.off(params.elements.slider, 'touchstart', dragStart);
  $tools.off(params.elements.slider, 'pointermove', dragMoving);
  $tools.off(params.elements.slider, 'touchmove', dragMoving);
  document.removeEventListener('mousedown', dragMousedown);
  document.removeEventListener('mousemove', dragMousemove);
  document.removeEventListener('mouseup', dragMouseup);
};

const getBoundingClientRect = (elem, specific = null) => {
  const rect = elem.getBoundingClientRect();
  if (specific && rect[specific]) return rect[specific];
  return rect;
};

const watchMouse = () => {
  document.addEventListener('mousedown', dragMousedown);
  document.addEventListener('mousemove', dragMousemove);

  document.addEventListener('mouseup', dragMouseup);
};

const dragMousedown = e => {
  if (params.drag.moving) {
    dragFlag.value = true;
    dragStart(e);
  }
};
const dragMousemove = e => {
  if (params.drag.moving && dragFlag.value) {
    dragMoving(e);
  }
};
const dragMouseup = e => {
  if (dragFlag.value) {
    params.check.being = false;
    dragFlag.value = false;
    dragEnd(e);
  }
};

const dragStart = evt => {
  if (params.check.being) return 
  const x = evt.clientX || evt.touches[0].clientX;
  const sliderRect = getBoundingClientRect(sliderRef.value);
  const sliderBtnRect = getBoundingClientRect(sliderBtnRef.value);
  params.drag.originX = Math.round(sliderRect.left * 10) / 10;
  params.drag.originY = Math.round(sliderRect.top * 10) / 10;
  params.drag.offset = Math.round((x - sliderBtnRect.left) * 10) / 10;
  params.drag.moving = true;
  params.time.start = Date.now();
};

const dragMoving = evt => {
  if (!params.drag.moving || params.check.being) return;
  const x = evt.clientX || evt.touches[0].clientX;
  const moveX = Math.round((x - params.drag.originX - params.drag.offset) * 10) / 10;
  if (moveX < 0 || moveX + 54 >= params.size.width) {
    return false;
  }
  params.elements.slider.style.left = `${moveX}px`;
  params.elements.block.style.left = `${moveX}px`;
  params.check.value = moveX;
};

const dragEnd = () => {
  if (!params.drag.moving) return;
  params.time.end = Date.now();
  checkVerificationCode();
};

// 判断是否正确
const checkVerificationCode = async () => {
  const coordinateX = Math.round(params.check.value + params.coordinate.offset);
  if (params.check.being) return;
  params.check.being = true;
  let data = {
    dragVerKey: vertifyData.value.key,
    dragVerCode: coordinateX
  };
  submit(data);
};

/* 提交 */
const submit = data => {
  props.validate().then(() => {
    loading.value = true;
    let formData = JSON.parse(JSON.stringify(props.form));

    formData = Object.assign(formData, data);

    // 是否需要加密
    if (IS_NEED_RSA) {
      // rsa加密密码
      formData.password = RsaEncry(formData.password);
    }

    // 如果开启了单点登录，则本系统就是单点登录服务端，调用获取loginCode接口
    if (SSO_FLAG) {
      LoginApi.getLoginCode(formData)
        .then(response => {
          SsoUtil.activateByLoginCode(props.ssoClientId ?? SSO_CLIENT_ID, props.ssoCallback ?? '', response?.data);
          params.check.being = false;
          clearEvent();
          closeModal('success');
        })
        .catch(e => {
          getVertifyData();
          loading.value = false;
        })
        .finally(() => {});
    }

    // 没开启单点登录，正常走登录接口逻辑
    else {
      LoginApi.login(formData)
        .then(response => {
          // 没开启单点登录
          message.success('登录成功');
          setToken(response?.data?.token, true);
          cleanPageTabs();
          params.check.being = false;
          clearEvent();
          closeModal('success');
          props.goHome();
        })
        .catch(e => {
          getVertifyData();
          loading.value = false;
        })
        .finally(() => {});
    }
  });
};

const dragReset = () => {
  params.elements.slider.style.left = 0;
  params.elements.block.style.left = 0;
  params.drag.originX = 0;
  params.drag.originY = 0;
};

// 把拖拽相关所有状态一次性归位
const resetDrag = () => {
  // 1. 滑块/图块位置归零
  dragReset()

  // 2. 状态标志全部复位
  params.drag.moving = false
  params.check.being = false
  params.check.correct = false
  params.check.value = null
  params.time.start = null
  params.time.end = null
  dragFlag.value = false
}

// 关闭弹框
const closeModal = (type, data) => {
  if (type == 'frequently') {
    message.warning(`已连续错误达 ${params.check.num} 次，请稍候再试`);
  } else {
    updateVisible(false);
    emits('done');
  }
};
</script>

<style scoped lang="less">
@import url('./style/index.less');
</style>
