BEGIN;

CREATE TABLE public.task_config (
    task_id bigint NOT NULL,
    task_code varchar(100),
    task_name varchar(255) NOT NULL,
    description varchar(1000),
    schedule_type varchar(20) NOT NULL,
    scheduler_job_id varchar(100),
    execution_type varchar(50) NOT NULL,
    execution_definition text,
    task_params text,
    task_cron varchar(100),
    status smallint DEFAULT 1,
    create_time timestamp(6) DEFAULT CURRENT_TIMESTAMP,
    update_time timestamp(6) DEFAULT CURRENT_TIMESTAMP,
    create_user bigint,
    update_user bigint,
    CONSTRAINT pk_task_config PRIMARY KEY (task_id)
);
COMMENT ON TABLE public.task_config IS '任务配置表';
COMMENT ON COLUMN public.task_config.execution_type IS '执行类型';
COMMENT ON COLUMN public.task_config.execution_definition IS 'Bean 处理器名称或脚本正文';
COMMENT ON COLUMN public.task_config.task_params IS '执行参数';

CREATE TABLE public.task_instance (
    task_inst_id bigint NOT NULL,
    task_id bigint NOT NULL,
    task_code varchar(100),
    task_name varchar(255),
    scheduler_job_id varchar(100),
    scheduler_log_id varchar(100),
    trigger_type varchar(50),
    execution_type varchar(50),
    execution_definition text,
    task_params text,
    start_time timestamp(6),
    end_time timestamp(6),
    handle_result varchar(100),
    handle_msg text,
    create_time timestamp(6) DEFAULT CURRENT_TIMESTAMP,
    update_time timestamp(6) DEFAULT CURRENT_TIMESTAMP,
    create_user bigint,
    update_user bigint,
    CONSTRAINT pk_task_instance PRIMARY KEY (task_inst_id)
);
COMMENT ON TABLE public.task_instance IS '任务实例表';
COMMENT ON COLUMN public.task_instance.execution_type IS '执行类型快照';
COMMENT ON COLUMN public.task_instance.execution_definition IS '执行定义快照';
COMMENT ON COLUMN public.task_instance.task_params IS '执行参数快照';

INSERT INTO public.sys_menu (
    menu_id, menu_parent_id, menu_pids, menu_name, menu_code, app_id, menu_sort,
    status_flag, menu_type, antdv_router, antdv_component, antdv_icon,
    antdv_active_url, antdv_visible, version_flag, del_flag,
    create_time, create_user, update_time, update_user
) VALUES
    (
        2060763497145757697, -1, '[-1],', '增强服务', 'zengqiangfuwu',
        1671406745336016898, 105.00, 1, 10, '/system/enhance', NULL,
        'icon-menu-yingyongguanli', NULL, 'Y', 3, 'N',
        '2026-05-30 16:41:20', 1339550467939639299,
        '2026-10-24 09:52:50', 1339550467939639299
    ),
    (
        2113931679060545537, 2060763497145757697,
        '[-1],[2060763497145757697],', '任务管理', 'renwuguanli',
        1671406745336016898, 10501.00, 1, 10, '/system/enhance/task', NULL,
        'icon-default', NULL, 'Y', 0, 'N',
        '2026-10-24 09:52:42', 1339550467939639299,
        '2026-10-24 09:52:50', 1339550467939639299
    ),
    (
        2112566848493363202, 2113931679060545537,
        '[-1],[2060763497145757697],[2113931679060545537],', '任务配置', 'renwupeizhi',
        1671406745336016898, 1050101.00, 1, 10,
        '/system/enhance/task/task-config', '/system/enhance/task/task-config/index',
        'icon-default', '', 'Y', 2, 'N',
        '2026-10-20 15:29:21', 1339550467939639299,
        '2026-10-24 09:52:50', 1339550467939639299
    ),
    (
        2113293464660037634, 2113931679060545537,
        '[-1],[2060763497145757697],[2113931679060545537],', '任务实例', 'renwushili',
        1671406745336016898, 1050102.00, 1, 10,
        '/system/enhance/task/task-instance', '/system/enhance/task/task-instance/index',
        'icon-default', NULL, 'Y', 0, 'N',
        '2026-10-22 15:36:40', 1339550467939639299,
        '2026-10-24 09:52:50', 1339550467939639299
    );

COMMIT;
