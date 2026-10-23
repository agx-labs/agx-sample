INSERT INTO `sys_menu` (`menu_id`, `menu_parent_id`, `menu_pids`, `menu_name`, `menu_code`, `app_id`, `menu_sort`,
                        `status_flag`, `menu_type`, `antdv_router`, `antdv_component`, `antdv_icon`, `antdv_visible`,
                        `version_flag`, `del_flag`, `create_time`)
SELECT 1981000000000000001,
       -1,
       '[-1],',
       '任务实例',
       'TASK_INSTANCE',
       1671406745336016898,
       105.00,
       1,
       10,
       '/system/enhance/task/task-instance',
       'system/enhance/task/task-instance/index',
       'icon-menu-rizhichakan',
       'Y',
       1,
       'N',
       NOW() WHERE NOT EXISTS (
  SELECT 1 FROM `sys_menu`
  WHERE `app_id` = 1671406745336016898 AND `menu_code` = 'TASK_INSTANCE' AND `del_flag` = 'N'
);
