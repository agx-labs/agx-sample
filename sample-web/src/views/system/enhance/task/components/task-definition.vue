<template>
  <div class="task-definition">
    <div class="task-section-heading">
      <strong>{{ snapshot ? '执行定义快照' : '执行定义' }}</strong>
      <a-tag :color="optionOf(executionTypes, executionTypeOf(data)).color">{{ optionOf(executionTypes, executionTypeOf(data)).label }}</a-tag>
    </div>
    <p v-if="snapshot" class="task-muted">记录本次执行使用的定义与参数。</p>
    <a-descriptions v-if="executionTypeOf(data) === 'bean'" class="task-descriptions" bordered size="small" :column="1">
      <a-descriptions-item label="Bean 处理器">{{ data.executionDefinition || '未提供' }}</a-descriptions-item>
    </a-descriptions>
    <pre v-else class="task-code">{{ data.executionDefinition || '未提供执行定义' }}</pre>
    <div class="task-section-heading"><strong>{{ snapshot ? '执行参数快照' : '任务参数' }}</strong></div>
    <pre class="task-code task-code-light">{{ formatParams(data.taskParams) }}</pre>
  </div>
</template>

<script setup>
import { executionTypeOf, executionTypes, formatParams, optionOf } from '../task-model';
defineProps({ data: { type: Object, required: true }, snapshot: Boolean });
</script>
