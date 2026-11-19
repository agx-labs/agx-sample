CREATE TABLE `task_config`
(
    `task_id`              BIGINT       NOT NULL COMMENT '任务ID',
    `task_code`            VARCHAR(100)  DEFAULT NULL COMMENT '任务编码',
    `task_name`            VARCHAR(255) NOT NULL COMMENT '任务名称',
    `description`          VARCHAR(1000) DEFAULT NULL COMMENT '描述',
    `schedule_type`        VARCHAR(20)  NOT NULL COMMENT '抽取方式 full-全量 inc-增量',
    `scheduler_job_id`     VARCHAR(100)  DEFAULT NULL COMMENT '调度器任务ID',
    `execution_type`       VARCHAR(50)  NOT NULL COMMENT '执行类型',
    `execution_definition` LONGTEXT      DEFAULT NULL COMMENT 'Bean 处理器名称或脚本正文',
    `task_params`          TEXT COMMENT '执行参数',
    `task_cron`            VARCHAR(100)  DEFAULT NULL COMMENT 'Cron表达式',
    `status`               TINYINT       DEFAULT 1 COMMENT '状态',
    `create_time`          DATETIME      DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time`          DATETIME      DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `create_user`          BIGINT        DEFAULT NULL COMMENT '创建人',
    `update_user`          BIGINT        DEFAULT NULL COMMENT '更新人',
    PRIMARY KEY (`task_id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '任务配置表';


CREATE TABLE `task_instance`
(
    `task_inst_id`         BIGINT NOT NULL COMMENT '实例ID',
    `task_id`              BIGINT NOT NULL COMMENT '任务ID',
    `task_code`            VARCHAR(100) DEFAULT NULL COMMENT '任务编码',
    `task_name`            VARCHAR(255) DEFAULT NULL COMMENT '任务名称',
    `scheduler_job_id`     VARCHAR(100) DEFAULT NULL COMMENT '调度器任务ID',
    `scheduler_log_id`     VARCHAR(100) DEFAULT NULL COMMENT '调度器日志ID',
    `trigger_type`         VARCHAR(50)  DEFAULT NULL COMMENT '触发类型',
    `execution_type`       VARCHAR(50)  DEFAULT NULL COMMENT '执行类型快照',
    `execution_definition` LONGTEXT     DEFAULT NULL COMMENT '执行定义快照',
    `task_params`          TEXT COMMENT '执行参数快照',
    `start_time`           DATETIME     DEFAULT NULL COMMENT '开始时间',
    `end_time`             DATETIME     DEFAULT NULL COMMENT '结束时间',
    `handle_result`        VARCHAR(100) DEFAULT NULL COMMENT '处理结果',
    `handle_msg`           TEXT COMMENT '处理消息',
    `create_time`          DATETIME     DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time`          DATETIME     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `create_user`          BIGINT       DEFAULT NULL COMMENT '创建人',
    `update_user`          BIGINT       DEFAULT NULL COMMENT '更新人',
    PRIMARY KEY (`task_inst_id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '任务实例表';

INSERT INTO `sys_menu` (`menu_id`, `menu_parent_id`, `menu_pids`, `menu_name`, `menu_code`, `app_id`, `menu_sort`,
                        `status_flag`, `remark`, `menu_type`, `antdv_router`, `antdv_component`, `antdv_icon`,
                        `antdv_link_url`, `antdv_active_url`, `antdv_visible`, `app_design_business_id`,
                        `app_design_view_id`, `expand_field`, `version_flag`, `del_flag`, `create_time`, `create_user`,
                        `update_time`, `update_user`)
VALUES (2060763497145757697, -1, '[-1],', '增强服务', 'zengqiangfuwu', 1671406745336016898, 105.00, 1, NULL, 10,
        '/system/enhance', NULL, 'icon-menu-yingyongguanli', NULL, NULL, 'Y', NULL, NULL, NULL, 3, 'N',
        '2026-05-30 16:41:20', 1339550467939639299, '2026-10-24 09:52:50', 1339550467939639299);
INSERT INTO `sys_menu` (`menu_id`, `menu_parent_id`, `menu_pids`, `menu_name`, `menu_code`, `app_id`, `menu_sort`,
                        `status_flag`, `remark`, `menu_type`, `antdv_router`, `antdv_component`, `antdv_icon`,
                        `antdv_link_url`, `antdv_active_url`, `antdv_visible`, `app_design_business_id`,
                        `app_design_view_id`, `expand_field`, `version_flag`, `del_flag`, `create_time`, `create_user`,
                        `update_time`, `update_user`)
VALUES (2112566848493363202, 2113931679060545537, '[-1],[2060763497145757697],[2113931679060545537],', '任务配置',
        'renwupeizhi', 1671406745336016898, 1050101.00, 1, NULL, 10, '/system/enhance/task/task-config',
        '/system/enhance/task/task-config/index', 'icon-default', NULL, '', 'Y', NULL, NULL, NULL, 2, 'N',
        '2026-10-20 15:29:21', 1339550467939639299, '2026-10-24 09:52:50', 1339550467939639299);
INSERT INTO `sys_menu` (`menu_id`, `menu_parent_id`, `menu_pids`, `menu_name`, `menu_code`, `app_id`, `menu_sort`,
                        `status_flag`, `remark`, `menu_type`, `antdv_router`, `antdv_component`, `antdv_icon`,
                        `antdv_link_url`, `antdv_active_url`, `antdv_visible`, `app_design_business_id`,
                        `app_design_view_id`, `expand_field`, `version_flag`, `del_flag`, `create_time`, `create_user`,
                        `update_time`, `update_user`)
VALUES (2113293464660037634, 2113931679060545537, '[-1],[2060763497145757697],[2113931679060545537],', '任务实例',
        'renwushili', 1671406745336016898, 1050102.00, 1, NULL, 10, '/system/enhance/task/task-instance',
        '/system/enhance/task/task-instance/index', 'icon-default', NULL, NULL, 'Y', NULL, NULL, NULL, 0, 'N',
        '2026-10-22 15:36:40', 1339550467939639299, '2026-10-24 09:52:50', 1339550467939639299);
INSERT INTO `sys_menu` (`menu_id`, `menu_parent_id`, `menu_pids`, `menu_name`, `menu_code`, `app_id`, `menu_sort`,
                        `status_flag`, `remark`, `menu_type`, `antdv_router`, `antdv_component`, `antdv_icon`,
                        `antdv_link_url`, `antdv_active_url`, `antdv_visible`, `app_design_business_id`,
                        `app_design_view_id`, `expand_field`, `version_flag`, `del_flag`, `create_time`, `create_user`,
                        `update_time`, `update_user`)
VALUES (2113931679060545537, 2060763497145757697, '[-1],[2060763497145757697],', '任务管理', 'renwuguanli',
        1671406745336016898, 10501.00, 1, NULL, 10, '/system/enhance/task', NULL, 'icon-default', NULL, NULL, 'Y', NULL,
        NULL, NULL, 0, 'N', '2026-10-24 09:52:42', 1339550467939639299, '2026-10-24 09:52:50', 1339550467939639299);

