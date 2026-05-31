<template>
  <common-modal
    :width="1200"
    :maskClosable="false"
    :visible="props.visible"
    :confirm-loading="loading"
    :forceRender="true"
    title="分配角色"
    :body-style="{ padding: '8px 24px', height: '75vh', overflowY: 'auto' }"
    @update:visible="updateVisible"
    @ok="save"
    maxable
    :footer="null"
    @close="updateVisible(false)"
  >
    <a-form ref="formRef" :model="form">
      <a-form-item label="用户姓名" style="width: 100%">
        <span style="font-size: 16px">{{ props.data.realName }}</span>
      </a-form-item>
      <div class="role-select">
        <div class="role-select-h">
          <a-tabs v-model:activeKey="activeKey" class="devops-tabs" @change="tabChange">
            <a-tab-pane :key="10" tab="系统角色"> </a-tab-pane>
            <a-tab-pane :key="15" tab="业务角色"> </a-tab-pane>
            <a-tab-pane :key="20" tab="公司角色"> </a-tab-pane>
          </a-tabs>
        </div>
        <div class="role-select-b">
          <a-form-item label="角色信息" style="width: 100%; padding: 16px" v-if="activeKey == 10">
            <a-checkbox-group v-model:value="form.roleIdList">
              <a-checkbox :value="roItem.roleId" name="type" v-for="roItem in roleList" :key="roItem.roleId" class="chexkout">
                <span v-if="roItem.roleType == 10" class="system-role"> {{ roItem.roleName }} <span>（系统角色）</span> </span>
                <span v-else-if="roItem.roleType == 15" class="system-role"> {{ roItem.roleName }} <span>（业务角色）</span> </span>
                <span v-else>
                  {{ roItem.roleName }}
                </span>
              </a-checkbox>
            </a-checkbox-group>
            <div>
              <a-button type="primary" class="border-radius" @click="save">确定</a-button>
            </div>
          </a-form-item>
          <div class="role-select-box" v-if="activeKey != 10">
            <guns-split-layout width="252px" :allowCollapse="false">
              <div class="company-tree">
                <a-directory-tree
                  :show-icon="false"
                  v-model:selectedKeys="currentSelectKeys"
                  @select="companySelect"
                  :tree-data="companyList"
                  :fieldNames="{ children: 'children', title: 'companyName', key: 'orgId', value: 'orgId' }"
                ></a-directory-tree>
              </div>
              <template #content>
                <div class="role-select-content">
                  <div class="role-select-item">
                    <div class="role-select-item-top">{{ activeKey == 15 ? '业务角色' : '公司角色' }}</div>
                    <div class="role-select-item-search">
                      <a-input v-model:value="leftSearchText" placeholder="请输入关键词（回车搜索）" allow-clear>
                        <template #prefix>
                          <icon-font iconClass="icon-opt-search"></icon-font>
                        </template>
                      </a-input>
                    </div>
                    <div class="role-select-item-bottom">
                      <a-directory-tree
                        :show-icon="false"
                        checkable
                        checkStrictly
                        @check="checkTree"
                        v-model:checkedKeys="checkedKeyss"
                        :tree-data="LeftTreeData"
                        :fieldNames="{ children: 'children', title: 'roleTreeNodeName', key: 'roleTreeNodeId', value: 'roleTreeNodeId' }"
                      ></a-directory-tree>
                    </div>
                  </div>
                  <div class="role-select-item">
                    <div class="role-select-item-top">已选择</div>
                    <div class="role-select-item-search">
                      <a-input v-model:value="rightSearchText" placeholder="请输入关键词（回车搜索）" allow-clear>
                        <template #prefix>
                          <icon-font iconClass="icon-opt-search"></icon-font>
                        </template>
                      </a-input>
                    </div>
                    <div class="role-select-item-bottom">
                      <div class="bottom-list">
                        <!-- 空数据 -->
                        <a-empty :image="Empty.PRESENTED_IMAGE_SIMPLE" v-if="selectList && selectList.length == 0" />
                        <!-- 已选列表 -->
                        <div v-else>
                          <div
                            class="list"
                            v-for="(item, index) in selectList?.filter(item => item.roleTreeNodeName.includes(rightSearchText))"
                            :key="item.roleTreeNodeId"
                          >
                            <div class="selected-name">{{ index + 1 }}. {{ item.roleTreeNodeName }}</div>
                            <div class="selected-del">
                              <icon-font iconClass="icon-opt-shanchu" title="删除" color="#000" @click="deleteClick(item)"></icon-font>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </template>
            </guns-split-layout>
          </div>
        </div>
      </div>
    </a-form>
  </common-modal>
</template>

<script setup name="AllocationRole">
import { ref, onMounted, computed } from 'vue';
import { message, Empty } from 'ant-design-vue';
import { UsersApi } from '../api/UsersApi';
import { useUserStore } from '@/store/modules/user';

const props = defineProps({
  visible: Boolean,
  data: Object
});

const emits = defineEmits(['update:visible', 'done']);

const userStore = useUserStore();

// 弹框加载
const loading = ref(false);
// 表单数据
const form = ref({
  roleIdList: [],
  userId: props.data.userId
});
// 角色列表
const roleList = ref([]);

// 公司列表
const companyList = ref([]);

const currentSelectKeys = ref([]);

const activeKey = ref('');

const leftSearchText = ref('');

const rightSearchText = ref('');

// 右侧选中列表
const selectList = ref([]);

const checkedKeyss = ref([]);

const LeftTreeData = ref([]);

// 是否是超管
const superAdminFlag = computed(() => {
  return userStore.info.superAdminFlag;
});

onMounted(() => {
  if (superAdminFlag.value) {
    activeKey.value = 10;
    getRoleList();
    getUserDetail();
  } else {
    activeKey.value = 15;
  }
  getUserOrgList();
});

// 获取用户详情
const getUserDetail = () => {
  UsersApi.detail({ userId: props.data.userId }).then(res => {
    form.value.roleIdList = res.roleIdList ?? [];
  });
};

// 获取角色列表
const getRoleList = async () => {
  roleList.value = await UsersApi.roleList();
};

// 获取左侧机构列表
const getUserOrgList = async () => {
  companyList.value = await UsersApi.getUserOrgList({ userId: props.data.userId });
  getRightData();
};

// 获取右侧数据
const getRightData = () => {
  selectList.value = [];
  checkedKeyss.value = [];
  if (activeKey.value != 10 && companyList.value?.length > 0) {
    if (currentSelectKeys.value.length == 0) currentSelectKeys.value = [companyList.value[0].orgId];
    if (activeKey.value == 15) {
      getCompanyBusinessRoleTree();
    } else if (activeKey.value == 20) {
      getCompanyRoleTree();
    }
  }
};

// 获取用户指定机构下的业务角色树
const getCompanyBusinessRoleTree = () => {
  UsersApi.getCompanyBusinessRoleTree({
    orgId: currentSelectKeys.value[0],
    userId: props.data.userId,
    searhText: leftSearchText.value
  }).then(res => {
    LeftTreeData.value = setTreeData(res.data);
  });
};

// 获取用户指定机构下的公司角色树
const getCompanyRoleTree = () => {
  UsersApi.getCompanyRoleTree({ orgId: currentSelectKeys.value[0], userId: props.data.userId, searhText: leftSearchText.value }).then(
    res => {
      LeftTreeData.value = setTreeData(res.data);
    }
  );
};

const setTreeData = arr => {
  if (arr?.length > 0) {
    arr.forEach(item => {
      if (item.nodeType == 1) {
        item.disabled = true;
      }
      if (item.checkedFlag) {
        selectList.value.push({ ...item, children: undefined });
        checkedKeyss.value.push(item.roleTreeNodeId);
      }
      if (item.children?.length > 0) {
        item.children = setTreeData(item.children);
      }
    });
  }
  return arr;
};

// 更改弹框状态
const updateVisible = value => {
  emits('update:visible', value);
};

// 点击保存
const save = () => {
  loading.value = true;
  UsersApi.bindRoles(form.value)
    .then(result => {
      // 移除加载框
      loading.value = false;

      // 提示添加成功
      message.success(result.message);
    })
    .catch(() => {
      loading.value = false;
    });
};

const tabChange = () => {
  getRightData();
};

// 公司选择
const companySelect = () => {
  getRightData();
};

const checkTree = (checkedKeys, { checked, node }) => {
  if (checked) {
    if (!selectList.value.find(item => item.roleTreeNodeId == node.roleTreeNodeId)) {
      selectList.value.push({
        checkedFlag: node.checkedFlag,
        nodeId: node.nodeId,
        nodeParentId: node.nodeParentId,
        nodeType: node.nodeType,
        roleTreeNodeId: node.roleTreeNodeId,
        roleTreeNodeName: node.roleTreeNodeName,
        roleTreeParentNodeId: node.roleTreeParentNodeId,
        roleType: node.roleType
      });
      changeRoleSelect(node, checked);
    }
  } else {
    deleteClick(node);
  }
};

const deleteClick = record => {
  selectList.value.splice(
    selectList.value.findIndex(item => item.roleTreeNodeId === record.roleTreeNodeId),
    1
  );
  checkedKeyss.value = selectList.value?.map(item => item.roleTreeNodeId);
  changeRoleSelect(record, false);
};

// 绑定或取消绑定角色
const changeRoleSelect = (node, checked) => {
  UsersApi.changeRoleSelect({
    checkedFlag: checked,
    orgId: currentSelectKeys.value[0],
    roleId: node.roleTreeNodeId,
    roleType: node.roleType,
    userId: props.data.userId
  }).then(res => {
    message.success(res.message);
  });
};
</script>

<style scoped lang="less">
.chexkout {
  width: 100%;
  margin-bottom: 10px;
}
:deep(.ant-checkbox-wrapper + .ant-checkbox-wrapper) {
  margin-left: 0;
}
:deep(.ant-checkbox-group:nth-child(1)) {
  margin-top: 5px;
}
.system-role {
  font-weight: bold;
}
.ant-form {
  height: 100%;
}
.role-select {
  height: calc(100% - 80px);
  border: 1px solid rgba(197, 207, 209, 0.4);
  border-radius: 8px;
  .role-select-h {
    height: 49px;
    padding: 8px 16px;
    border-bottom: 1px solid rgba(197, 207, 209, 0.4);

    :deep(.ant-tabs-tab) {
      font-size: 16px !important;
    }
    :deep(.ant-tabs-tab.ant-tabs-tab-active .ant-tabs-tab-btn) {
      font-weight: 400 !important;
    }
  }
  .role-select-b {
    height: calc(100% - 49px);
    overflow-y: auto;

    .role-select-box {
      width: 100%;
      height: 100%;
    }
  }
}
@import url('@/styles/commonTree.less');
.company-tree {
  padding: 8px;
  box-sizing: border-box;
  width: 100%;
  height: 100%;
  overflow-y: auto;
  :deep(.ant-tree-switcher) {
    display: none;
  }
}
.role-select-content {
  width: 100%;
  height: 100%;
  border-left: 1px solid rgba(197, 207, 209, 0.4);
  display: flex;

  .role-select-item {
    width: 50%;
    height: 100%;
    &:first-child {
      border-right: 1px solid rgba(197, 207, 209, 0.4);
    }

    .role-select-item-top {
      width: 100%;
      padding: 8px 16px;
      height: 40px;
      line-height: 24px;
      position: relative;
      font-size: 16px;
      background: #f7f7f9;
      color: #43505e;
    }
    .role-select-item-search {
      margin-top: 10px;
      padding: 0 16px;
      height: 36px;
      border-radius: 5px;
      margin-bottom: 16px;
      .ant-input-affix-wrapper {
        height: 100%;
      }
    }
    .role-select-item-bottom {
      padding: 0 16px 16px 16px;
      height: calc(100% - 40px - 62px);

      :deep(.ant-tree-checkbox) {
        margin: 11px 6px 0 0 !important;
      }
      :deep(.ant-tree .ant-tree-treenode-disabled .ant-tree-node-content-wrapper) {
        color: #000 !important;
      }

      .bottom-list {
        width: 100%;
        height: 100%;
        overflow-y: auto;
        position: relative;
        .ant-empty {
          position: absolute;
          left: 50%;
          top: 50%;
          margin-left: -32px;
          margin-top: -42px;
        }
      }
      .list {
        display: flex;
        width: 100%;
        padding: 0 12px;
        height: 100%;
        .selected-name {
          width: 80%;
          padding: 12px 0;
        }
        .selected-del {
          width: 20%;
          cursor: pointer;
          padding: 12px 0;
          display: flex;
          align-items: center;
          justify-content: right;
          &:hover {
            color: red;
          }
        }
      }
    }
  }
}
</style>
