import { onActivated, onDeactivated, onScopeDispose, ref, watch } from 'vue';

/** 串行读取增量日志，关闭、切换实例及组件卸载时使在途请求失效。 */
export function useTaskLog(visible, instanceId, fetchLog, shouldAutoLoad = () => true) {
  const content = ref('');
  const loading = ref(false);
  const error = ref('');
  const ended = ref(false);
  const automatic = ref(shouldAutoLoad());
  const nextLine = ref(1);
  let generation = 0;
  let timer;
  let suspended = false;
  const clearTimer = () => { clearTimeout(timer); timer = undefined; };
  const stop = () => { generation++; clearTimer(); loading.value = false; };
  const canLoad = () => visible() && instanceId() && !suspended;
  const schedule = () => {
    clearTimer();
    if (canLoad() && automatic.value && !ended.value && !error.value) timer = setTimeout(() => load(), 3000);
  };
  const load = async (reset = false) => {
    if (!canLoad() || loading.value) return;
    clearTimer();
    if (reset) {
      content.value = '';
      nextLine.value = 1;
      ended.value = false;
    }
    if (ended.value) return;
    const version = generation;
    const line = nextLine.value;
    loading.value = true;
    error.value = '';
    try {
      const result = await fetchLog({ taskInstId: instanceId(), fromLineNum: line });
      if (version !== generation || !canLoad()) return;
      if (!result) throw new Error('未获取到日志数据');
      const lastLine = Number(result.toLineNum);
      if (Number.isInteger(lastLine) && lastLine >= line) {
        content.value += result.logContent || '';
        nextLine.value = lastLine + 1;
      }
      ended.value = result.end === true;
    } catch (cause) {
      if (version !== generation) return;
      error.value = cause?.message || '日志加载失败，请重试';
      automatic.value = false;
    } finally {
      if (version === generation) {
        loading.value = false;
        schedule();
      }
    }
  };
  watch([visible, instanceId], () => {
    stop();
    content.value = '';
    nextLine.value = 1;
    ended.value = false;
    error.value = '';
    automatic.value = shouldAutoLoad();
    if (canLoad()) load();
  }, { immediate: true });
  watch(automatic, (value) => {
    if (value && !loading.value) load();
    else if (!value) clearTimer();
  });
  onDeactivated(() => { suspended = true; stop(); });
  onActivated(() => {
    if (!suspended) return;
    suspended = false;
    if (automatic.value) load();
  });
  onScopeDispose(stop);
  return { content, loading, error, ended, automatic, nextLine, load };
}
