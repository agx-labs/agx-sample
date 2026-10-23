<template>
  <div class="code-mirror-editor">
    <div class="code-mirror-editor-header">
      <span>{{ label || language }}</span>
      <a-space :size="12">
        <span>{{ lineCount }} 行</span>
        <a v-if="showFormat" @click="formatDocument">格式化</a>
      </a-space>
    </div>
    <div ref="editorElement" class="code-mirror-editor-content" :style="{ height }"></div>
  </div>
</template>

<script setup>
import { onBeforeUnmount, onMounted, ref, watch } from 'vue';
import { message } from 'ant-design-vue';
import { basicSetup } from 'codemirror';
import { Compartment, EditorState } from '@codemirror/state';
import { EditorView, placeholder as editorPlaceholder } from '@codemirror/view';
import { StreamLanguage } from '@codemirror/language';
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
  showFormat: Boolean
});
const emit = defineEmits(['update:modelValue', 'blur']);
const editorElement = ref(null);
const lineCount = ref(1);
const languageConfig = new Compartment();
const placeholderConfig = new Compartment();
let editor;
const languageExtension = () => {
  const languages = { json, javascript, java, python, shell: () => StreamLanguage.define(shell), powershell: () => StreamLanguage.define(powerShell), groovy: () => StreamLanguage.define(groovy) };
  return [languages[props.language]?.() || [], props.language === 'json' ? EditorView.lineWrapping : []];
};
const formatDocument = () => {
  if (!editor || props.language !== 'json') return;
  try {
    const value = JSON.stringify(JSON.parse(editor.state.doc.toString()), null, 2);
    editor.dispatch({ changes: { from: 0, to: editor.state.doc.length, insert: value } });
  } catch {
    message.warning('JSON 格式有误，请修正后再格式化');
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
</style>
