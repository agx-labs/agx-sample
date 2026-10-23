import { describe, expect, it } from 'vitest';
import { canEdit, canExecuteOnce, createTaskForm, cronError, durationOf, editorLanguageOf, executionSummary, executionTypeOf, jsonError, taskPayload } from './task-model';

describe('任务前端契约', () => {
  it('提交脚本时保留正文和原始参数，全量任务不提交旧 Cron', () => {
    const form = createTaskForm({
      taskId: '1234567890123456789', schedulerJobId: 'job-1', taskName: '  测试任务  ',
      scheduleType: 'full', executionType: 'python3',
      executionDefinition: 'print("x")\n  print("y")\n', taskParams: '{\n  "name": "demo"\n}', taskCron: '0 0 * * * ?'
    });
    expect(taskPayload(form)).toMatchObject({
      taskId: '1234567890123456789', schedulerJobId: 'job-1', taskName: '测试任务',
      executionType: 'python3', executionDefinition: 'print("x")\n  print("y")\n',
      taskParams: '{\n  "name": "demo"\n}', taskCron: ''
    });
    expect(form.taskCron).toBe('0 0 * * * ?');
  });

  it('校验任务参数 JSON 并截取列表执行定义', () => {
    expect(jsonError('{"name":"demo"}')).toBe('');
    expect(jsonError('name=demo')).toBe('请输入合法的 JSON');
    expect(executionSummary('echo  hello\nworld', 10)).toBe('echo hello...');
    expect(editorLanguageOf('python3')).toBe('python');
    expect(editorLanguageOf('groovy')).toBe('java');
  });

  it('增量任务校验 Cron 字段数，旧任务按 Bean 展示', () => {
    expect(cronError('0 0/5 * * * ?')).toBe('');
    expect(cronError('0 0 * * *')).toContain('6 或 7');
    expect(executionTypeOf({ executionDefinition: 'taskHandler' })).toBe('bean');
    expect(canEdit({ status: 1 })).toBe(false);
    expect(canEdit({ status: 2 })).toBe(true);
    expect(canExecuteOnce({ status: 1 })).toBe(true);
    expect(canExecuteOnce({ status: 2 })).toBe(false);
  });

  it('执行耗时只使用有效时间区间', () => {
    expect(durationOf({ startTime: '2026-10-21 10:00:00', endTime: '2026-10-21 10:01:05' })).toBe('1 分 5 秒');
    expect(durationOf({ startTime: '2026-10-21 10:00:00', endTime: '2026-10-21 09:00:00' })).toBe('—');
  });
});
