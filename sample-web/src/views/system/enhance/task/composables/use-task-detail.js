import { onScopeDispose, ref, watch } from 'vue';

/** 弹窗关闭或切换记录后，忽略上一条记录尚未返回的请求。 */
export function useTaskDetail(visible, recordId, fetchDetail) {
  const detail = ref(null);
  const loading = ref(false);
  const error = ref('');
  let requestId = 0;
  const load = async () => {
    const id = ++requestId;
    detail.value = null;
    error.value = '';
    loading.value = false;
    if (!visible() || !recordId()) return;
    loading.value = true;
    try {
      const result = await fetchDetail(recordId());
      if (id === requestId) {
        if (!result) throw new Error('未找到记录');
        detail.value = result;
      }
    } catch (cause) {
      if (id === requestId) error.value = cause?.message || '详情加载失败，请重试';
    } finally {
      if (id === requestId) loading.value = false;
    }
  };
  watch([visible, recordId], load, { immediate: true });
  onScopeDispose(() => requestId++);
  return { detail, loading, error, load };
}
