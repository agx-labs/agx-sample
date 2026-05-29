CREATE TABLE `task_config`
(
    `task_id`          BIGINT       NOT NULL COMMENT '任务ID',
    `task_code`        VARCHAR(100)  DEFAULT NULL COMMENT '任务编码',
    `task_name`        VARCHAR(255) NOT NULL COMMENT '任务名称',
    `description`      VARCHAR(1000) DEFAULT NULL COMMENT '描述',
    `schedule_type`    VARCHAR(20)  NOT NULL COMMENT '抽取方式 full-全量 inc-增量',
    `scheduler_job_id` VARCHAR(100)  DEFAULT NULL COMMENT '调度器任务ID',
    `run_mode`         VARCHAR(50)  NOT NULL COMMENT '运行模式',
    `job_handler`      VARCHAR(255)  DEFAULT NULL COMMENT '任务处理器',
    `task_params`      TEXT COMMENT '任务参数',
    `task_cron`        VARCHAR(100)  DEFAULT NULL COMMENT 'Cron表达式',
    `status`           TINYINT       DEFAULT 1 COMMENT '状态',
    `create_time`      DATETIME      DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time`      DATETIME      DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `create_user`      BIGINT        DEFAULT NULL COMMENT '创建人',
    `update_user`      BIGINT        DEFAULT NULL COMMENT '更新人',
    PRIMARY KEY (`task_id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '任务配置表';


CREATE TABLE `task_instance`
(
    `task_inst_id`     BIGINT NOT NULL COMMENT '实例ID',
    `task_id`          BIGINT NOT NULL COMMENT '任务ID',
    `task_code`        VARCHAR(100) DEFAULT NULL COMMENT '任务编码',
    `task_name`        VARCHAR(255) DEFAULT NULL COMMENT '任务名称',
    `scheduler_job_id` VARCHAR(100) DEFAULT NULL COMMENT '调度器任务ID',
    `scheduler_log_id` VARCHAR(100) DEFAULT NULL COMMENT '调度器日志ID',
    `trigger_type`     VARCHAR(50)  DEFAULT NULL COMMENT '触发类型',
    `run_mode`         VARCHAR(50)  DEFAULT NULL COMMENT '运行模式',
    `job_handler`      VARCHAR(255) DEFAULT NULL COMMENT '任务处理器',
    `task_params`      TEXT COMMENT '任务参数',
    `start_time`       DATETIME     DEFAULT NULL COMMENT '开始时间',
    `end_time`         DATETIME     DEFAULT NULL COMMENT '结束时间',
    `handle_result`    VARCHAR(100) DEFAULT NULL COMMENT '处理结果',
    `handle_msg`       TEXT COMMENT '处理消息',
    `create_time`      DATETIME     DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time`      DATETIME     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `create_user`      BIGINT       DEFAULT NULL COMMENT '创建人',
    `update_user`      BIGINT       DEFAULT NULL COMMENT '更新人',
    PRIMARY KEY (`task_inst_id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '任务实例表';