import dayjs from 'dayjs';

// 与 agx-d-task 的任务枚举保持一致，未知值保留原文，避免误标为其他类型。
export const executionTypes = [
  { value: 'bean', label: 'Bean', color: 'blue' },
  { value: 'shell', label: 'Shell', color: 'cyan' },
  { value: 'powershell', label: 'PowerShell', color: 'geekblue' },
  { value: 'python2', label: 'Python 2', color: 'gold' },
  { value: 'python3', label: 'Python 3', color: 'green' },
  { value: 'nodejs', label: 'NodeJs', color: 'orange' },
  { value: 'groovy', label: 'Groovy', color: 'purple' }
];
export const scheduleTypes = [
  { value: 'full', label: '全量', color: 'default' },
  { value: 'inc', label: '增量', color: 'cyan' }
];
export const taskStatuses = [
  { value: 1, label: '启用', color: 'success' },
  { value: 2, label: '停用', color: 'default' }
];
export const handleResults = [
  { value: 'running', label: '运行中', color: 'processing' },
  { value: 'success', label: '成功', color: 'success' },
  { value: 'fail', label: '失败', color: 'error' }
];
export const triggerTypes = [
  { value: 'auto', label: '自动', color: 'blue' },
  { value: 'manual', label: '手动', color: 'orange' },
  { value: 'retry', label: '重试', color: 'purple' }
];

export const optionOf = (options, value) =>
  options.find((item) => String(item.value) === String(value)) || { label: value || '未提供', color: 'default' };
export const executionTypeOf = (task) => task?.executionType || 'bean';
export const isEnabled = (task) => Number(task?.status) === 1;
export const canEdit = (task) => Number(task?.status) === 2;
export const canExecuteOnce = (task) => Number(task?.status) === 1;
export const editorLanguageOf = (executionType) => ({
  shell: 'shell',
  powershell: 'powershell',
  python2: 'python',
  python3: 'python',
  nodejs: 'javascript',
  groovy: 'groovy'
}[executionType] || 'plaintext');

export function executionSummary(value, limit = 24) {
  const summary = String(value || '').replace(/\s+/g, ' ').trim();
  return summary.length > limit ? `${summary.slice(0, limit)}...` : summary || '-';
}

export function createTaskForm(data = {}) {
  return {
    taskId: data.taskId,
    schedulerJobId: data.schedulerJobId,
    taskName: data.taskName ?? '',
    taskCode: data.taskCode ?? '',
    scheduleType: data.scheduleType ?? 'full',
    executionType: data.executionType || 'bean',
    executionDefinition: data.executionDefinition ?? '',
    taskCron: data.taskCron ?? '',
    taskParams: data.taskParams ?? '',
    description: data.description ?? ''
  };
}

export function taskPayload(form) {
  const payload = createTaskForm(form);
  payload.taskName = payload.taskName.trim();
  payload.taskCode = payload.taskCode.trim();
  payload.taskCron = payload.scheduleType === 'inc' ? payload.taskCron.trim() : '';
  if (payload.executionType === 'bean') payload.executionDefinition = payload.executionDefinition.trim();
  // 脚本正文和 JSON 参数按编辑器原文提交，保留用户的换行与缩进。
  return payload;
}

export function jsonError(value) {
  if (!value?.trim()) return '';
  try {
    JSON.parse(value);
    return '';
  } catch {
    return '请输入合法的 JSON';
  }
}

export function cronError(value) {
  if (!value?.trim()) return '请输入增量任务的 Cron 表达式';
  const fields = value.trim().split(/\s+/);
  if (fields.length < 6 || fields.length > 7) return 'Cron 需要 6 或 7 个字段（从秒开始）';
  if (!fields.every((field) => /^[\dA-Za-z*?,/\-#]+$/.test(field))) return 'Cron 包含不支持的字符';
  return '';
}

export function formatParams(value) {
  if (!value) return '未设置';
  try {
    return JSON.stringify(JSON.parse(value), null, 2);
  } catch {
    return value;
  }
}

export function durationOf(record) {
  if (!record.startTime) return '—';
  if (!record.endTime) return record.handleResult === 'running' ? '执行中' : '—';
  const start = dayjs(record.startTime);
  const end = dayjs(record.endTime);
  if (!start.isValid() || !end.isValid() || end.isBefore(start)) return '—';
  const seconds = end.diff(start, 'second');
  if (seconds < 60) return `${seconds} 秒`;
  if (seconds < 3600) return `${Math.floor(seconds / 60)} 分 ${seconds % 60} 秒`;
  return `${Math.floor(seconds / 3600)} 时 ${Math.floor((seconds % 3600) / 60)} 分`;
}
