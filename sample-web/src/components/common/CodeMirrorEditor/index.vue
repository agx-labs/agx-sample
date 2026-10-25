<template>
  <Teleport to="body" :disabled="!fullscreen">
    <div class="code-mirror-editor" :class="{ 'is-fullscreen': fullscreen }">
      <div class="code-mirror-editor-header">
        <span>{{ label || language }}</span>
        <a-space :size="2" class="editor-header-actions">
          <span>{{ lineCount }} 行</span>
          <a-tooltip v-if="showFormat" :title="`格式化 ${label || language}`">
            <a-button
              type="text"
              size="small"
              :loading="formatting"
              :aria-label="`格式化 ${label || language}`"
              @click="formatDocument"
            >
              <align-left-outlined />
            </a-button>
          </a-tooltip>
          <a-button
            v-if="allowFullscreen"
            type="text"
            size="small"
            :aria-label="fullscreen ? '退出全屏' : '全屏编辑'"
            :title="fullscreen ? '退出全屏' : '全屏编辑'"
            @click="toggleFullscreen"
          >
            <fullscreen-exit-outlined v-if="fullscreen" />
            <fullscreen-outlined v-else />
          </a-button>
        </a-space>
      </div>
      <div ref="editorElement" class="code-mirror-editor-content" :style="{ height }"></div>
    </div>
  </Teleport>
</template>

<script setup>
import { nextTick, onBeforeUnmount, onMounted, ref, watch } from 'vue';
import { message } from 'ant-design-vue';
import { AlignLeftOutlined, FullscreenExitOutlined, FullscreenOutlined } from '@ant-design/icons-vue';
import { basicSetup } from 'codemirror';
import { Compartment, EditorState } from '@codemirror/state';
import { EditorView, placeholder as editorPlaceholder } from '@codemirror/view';
import { indentRange, StreamLanguage } from '@codemirror/language';
import { json } from '@codemirror/lang-json';
import { javascript } from '@codemirror/lang-javascript';
import { java } from '@codemirror/lang-java';
import { python } from '@codemirror/lang-python';
import { shell } from '@codemirror/legacy-modes/mode/shell';
import { powerShell } from '@codemirror/legacy-modes/mode/powershell';
import { groovy } from '@codemirror/legacy-modes/mode/groovy';

const props = defineProps({
  modelValue: { type: String, default: '' },
  language: { type: String, default: 'plaintext' },
  label: { type: String, default: '' },
  height: { type: String, default: '240px' },
  placeholder: { type: String, default: '' },
  showFormat: Boolean,
  allowFullscreen: Boolean
});
const emit = defineEmits(['update:modelValue', 'blur']);
const editorElement = ref(null);
const lineCount = ref(1);
const fullscreen = ref(false);
const formatting = ref(false);
const toggleFullscreen = () => { fullscreen.value = !fullscreen.value; };
const languageConfig = new Compartment();
const placeholderConfig = new Compartment();
let editor;
const languageExtension = () => {
  const languages = { json, javascript, java, python, shell: () => StreamLanguage.define(shell), powershell: () => StreamLanguage.define(powerShell), groovy: () => StreamLanguage.define(groovy) };
  return [languages[props.language]?.() || [], props.language === 'json' ? EditorView.lineWrapping : []];
};
const formatDocument = async () => {
  if (!editor || formatting.value) return;
  const source = editor.state.doc.toString();
  if (!source.trim()) return;
  formatting.value = true;
  try {
    if (props.language === 'json') {
      const value = JSON.stringify(JSON.parse(source), null, 2);
      editor.dispatch({ changes: { from: 0, to: editor.state.doc.length, insert: value } });
      return;
    }
    if (props.language === 'javascript') {
      const [prettierModule, babelModule, estreeModule] = await Promise.all([
        import('prettier/standalone'),
        import('prettier/plugins/babel'),
        import('prettier/plugins/estree')
      ]);
      const value = await prettierModule.default.format(source, {
        parser: 'babel',
        plugins: [babelModule.default, estreeModule.default]
      });
      editor.dispatch({ changes: { from: 0, to: editor.state.doc.length, insert: value } });
      return;
    }
    editor.dispatch({ changes: indentRange(editor.state, 0, editor.state.doc.length) });
  } catch {
    message.warning(props.language === 'json' ? 'JSON 格式有误，请修正后再格式化' : '格式化失败，请检查脚本语法');
  } finally {
    formatting.value = false;
  }
};
onMounted(() => {
  editor = new EditorView({
    parent: editorElement.value,
    state: EditorState.create({
      doc: props.modelValue,
      extensions: [
        basicSetup,
        languageConfig.of(languageExtension()),
        placeholderConfig.of(editorPlaceholder(props.placeholder)),
        EditorView.theme({
          '&': { height: '100%', fontSize: '13px' },
          '.cm-scroller': { overflow: 'auto', fontFamily: 'Consolas, monospace', lineHeight: '22px' }
        }),
        EditorView.updateListener.of((update) => {
          if (!update.docChanged) return;
          lineCount.value = update.state.doc.lines;
          const value = update.state.doc.toString();
          if (value !== props.modelValue) emit('update:modelValue', value);
        }),
        EditorView.domEventHandlers({ blur: () => { emit('blur'); } })
      ]
    })
  });
  lineCount.value = editor.state.doc.lines;
});
watch(() => props.modelValue, (value) => {
  if (!editor || value === editor.state.doc.toString()) return;
  editor.dispatch({ changes: { from: 0, to: editor.state.doc.length, insert: value || '' } });
});
watch(() => props.language, () => {
  editor?.dispatch({ effects: languageConfig.reconfigure(languageExtension()) });
});
watch(() => props.placeholder, (value) => {
  editor?.dispatch({ effects: placeholderConfig.reconfigure(editorPlaceholder(value)) });
});
watch(fullscreen, async () => {
  await nextTick();
  editor?.requestMeasure();
});
onBeforeUnmount(() => editor?.destroy());
</script>
<style scoped lang="less">
.code-mirror-editor {
  overflow: hidden;
  border: 1px solid #d9d9d9;
  border-radius: 2px;
  transition: border-color 0.3s, box-shadow 0.3s;

  &:focus-within {
    border-color: #40a9ff;
    box-shadow: 0 0 0 2px rgb(24 144 255 / 20%);
  }
}

.code-mirror-editor-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 34px;
  padding: 0 11px;
  border-bottom: 1px solid #f0f0f0;
  color: #8c8c8c;
  background: #fafafa;
  font-size: 12px;
}

.code-mirror-editor-content {
  width: 100%;
}

.editor-header-actions :deep(.ant-btn) {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 20px;
  min-width: 20px;
  height: 20px;
  padding: 0;
  line-height: 1;
}

.editor-header-actions :deep(.ant-space-item) { display: inline-flex; align-items: center; }

.code-mirror-editor.is-fullscreen {
  position: fixed;
  inset: 12px;
  z-index: 1200;
  display: flex;
  flex-direction: column;
  background: #fff;
  box-shadow: 0 6px 24px rgb(0 0 0 / 24%);

  .code-mirror-editor-content {
    flex: 1;
    min-height: 0;
    height: auto !important;
  }
}
</style>
