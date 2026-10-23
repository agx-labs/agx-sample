<template>
  <div class="guns-layout">
    <div class="guns-layout-content">
      <div class="guns-layout">
        <div class="guns-layout-content-application">
          <div class="content-mian">
            <div class="content-mian-header">
              <div class="header-content">
                <div class="header-content-left"><a-space :size="16" /></div>
                <div class="header-content-right">
                  <a-space :size="16">
                    <a-button class="border-radius" @click="reset">重置</a-button>
                    <a-button type="primary" class="border-radius" @click="reload"><search-outlined />查询</a-button>
                  </a-space>
                </div>
              </div>
            </div>
            <div class="content-mian-body">
              <div class="table-content">
                <TaskInstanceList ref="listRef" />
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup name="TaskInstance">
import { ref } from 'vue';
import { SearchOutlined } from '@ant-design/icons-vue';
import TaskInstanceList from './components/task-instance-list.vue';
import '../task.less';
defineOptions({ name: 'TaskInstance' });
const listRef = ref(null);
const reload = () => listRef.value?.reload();
const reset = () => listRef.value?.reset();
</script>
