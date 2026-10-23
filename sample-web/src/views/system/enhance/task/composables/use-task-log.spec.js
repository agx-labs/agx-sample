import { afterEach, describe, expect, it, vi } from 'vitest';
import { mount } from '@vue/test-utils';
import { h, nextTick, ref } from 'vue';
import { useTaskLog } from './use-task-log';

function mountLog(visible, id, fetchLog) {
  let state;
  const wrapper = mount({
    setup() {
      state = useTaskLog(() => visible.value, () => id.value, fetchLog);
      return () => h('div');
    }
  });
  return { wrapper, state };
}

const flush = async () => { await Promise.resolve(); await Promise.resolve(); await nextTick(); };

describe('执行日志读取', () => {
  afterEach(() => vi.useRealTimers());

  it('按行号串行追加，结束后停止自动读取', async () => {
    vi.useFakeTimers();
    const fetchLog = vi.fn()
      .mockResolvedValueOnce({ logContent: '第一行\n', toLineNum: 1, end: false })
      .mockResolvedValueOnce({ logContent: '第二行\n', toLineNum: 2, end: true });
    const { wrapper, state } = mountLog(ref(true), ref('88'), fetchLog);
    await flush();
    expect(fetchLog).toHaveBeenCalledWith({ taskInstId: '88', fromLineNum: 1 });
    expect(state.nextLine.value).toBe(2);
    await vi.advanceTimersByTimeAsync(3000);
    await flush();
    expect(fetchLog).toHaveBeenLastCalledWith({ taskInstId: '88', fromLineNum: 2 });
    expect(state.content.value).toBe('第一行\n第二行\n');
    expect(state.ended.value).toBe(true);
    await vi.advanceTimersByTimeAsync(3000);
    expect(fetchLog).toHaveBeenCalledTimes(2);
    wrapper.unmount();
  });

  it('关闭弹窗后忽略旧请求', async () => {
    let complete;
    const fetchLog = vi.fn(() => new Promise((resolve) => { complete = resolve; }));
    const visible = ref(true);
    const { wrapper, state } = mountLog(visible, ref('99'), fetchLog);
    visible.value = false;
    await nextTick();
    complete({ logContent: '过期日志', toLineNum: 1, end: true });
    await flush();
    expect(state.content.value).toBe('');
    expect(state.loading.value).toBe(false);
    wrapper.unmount();
  });
});
