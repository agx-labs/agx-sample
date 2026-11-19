CREATE TABLE task_config (
    task_id NUMBER(20,0) NOT NULL,
    task_code NVARCHAR2(100),
    task_name NVARCHAR2(255) NOT NULL,
    description NVARCHAR2(1000),
    schedule_type NVARCHAR2(20) NOT NULL,
    scheduler_job_id NVARCHAR2(100),
    execution_type NVARCHAR2(50) NOT NULL,
    execution_definition NCLOB,
    task_params NCLOB,
    task_cron NVARCHAR2(100),
    status NUMBER(4,0) DEFAULT 1,
    create_time DATE DEFAULT CURRENT_TIMESTAMP,
    update_time DATE DEFAULT CURRENT_TIMESTAMP,
    create_user NUMBER(20,0),
    update_user NUMBER(20,0),
    CONSTRAINT pk_task_config PRIMARY KEY (task_id)
);
COMMENT ON TABLE task_config IS '任务配置表';
COMMENT ON COLUMN task_config.execution_type IS '执行类型';
COMMENT ON COLUMN task_config.execution_definition IS 'Bean 处理器名称或脚本正文';
COMMENT ON COLUMN task_config.task_params IS '执行参数';

CREATE TABLE task_instance (
    task_inst_id NUMBER(20,0) NOT NULL,
    task_id NUMBER(20,0) NOT NULL,
    task_code NVARCHAR2(100),
    task_name NVARCHAR2(255),
    scheduler_job_id NVARCHAR2(100),
    scheduler_log_id NVARCHAR2(100),
    trigger_type NVARCHAR2(50),
    execution_type NVARCHAR2(50),
    execution_definition NCLOB,
    task_params NCLOB,
    start_time DATE,
    end_time DATE,
    handle_result NVARCHAR2(100),
    handle_msg NCLOB,
    create_time DATE DEFAULT CURRENT_TIMESTAMP,
    update_time DATE DEFAULT CURRENT_TIMESTAMP,
    create_user NUMBER(20,0),
    update_user NUMBER(20,0),
    CONSTRAINT pk_task_instance PRIMARY KEY (task_inst_id)
);
COMMENT ON TABLE task_instance IS '任务实例表';
COMMENT ON COLUMN task_instance.execution_type IS '执行类型快照';
COMMENT ON COLUMN task_instance.execution_definition IS '执行定义快照';
COMMENT ON COLUMN task_instance.task_params IS '执行参数快照';

INSERT INTO sys_menu (
    menu_id, menu_parent_id, menu_pids, menu_name, menu_code, app_id, menu_sort,
    status_flag, menu_type, antdv_router, antdv_component, antdv_icon,
    antdv_active_url, antdv_visible, version_flag, del_flag,
    create_time, create_user, update_time, update_user
) VALUES (

        2060763497145757697, -1, '[-1],', '增强服务', 'zengqiangfuwu',
        1671406745336016898, 105.00, 1, 10, '/system/enhance', NULL,
        'icon-menu-yingyongguanli', NULL, 'Y', 3, 'N',
        TO_DATE('2026-05-30 16:41:20', 'YYYY-MM-DD HH24:MI:SS'), 1339550467939639299,
        TO_DATE('2026-10-24 09:52:50', 'YYYY-MM-DD HH24:MI:SS'), 1339550467939639299
    );

INSERT INTO sys_menu (
    menu_id, menu_parent_id, menu_pids, menu_name, menu_code, app_id, menu_sort,
    status_flag, menu_type, antdv_router, antdv_component, antdv_icon,
    antdv_active_url, antdv_visible, version_flag, del_flag,
    create_time, create_user, update_time, update_user
) VALUES (

        2113931679060545537, 2060763497145757697,
        '[-1],[2060763497145757697],', '任务管理', 'renwuguanli',
        1671406745336016898, 10501.00, 1, 10, '/system/enhance/task', NULL,
        'icon-default', NULL, 'Y', 0, 'N',
        TO_DATE('2026-10-24 09:52:42', 'YYYY-MM-DD HH24:MI:SS'), 1339550467939639299,
        TO_DATE('2026-10-24 09:52:50', 'YYYY-MM-DD HH24:MI:SS'), 1339550467939639299
    );

INSERT INTO sys_menu (
    menu_id, menu_parent_id, menu_pids, menu_name, menu_code, app_id, menu_sort,
    status_flag, menu_type, antdv_router, antdv_component, antdv_icon,
    antdv_active_url, antdv_visible, version_flag, del_flag,
    create_time, create_user, update_time, update_user
) VALUES (

        2112566848493363202, 2113931679060545537,
        '[-1],[2060763497145757697],[2113931679060545537],', '任务配置', 'renwupeizhi',
        1671406745336016898, 1050101.00, 1, 10,
        '/system/enhance/task/task-config', '/system/enhance/task/task-config/index',
        'icon-default', '', 'Y', 2, 'N',
        TO_DATE('2026-10-20 15:29:21', 'YYYY-MM-DD HH24:MI:SS'), 1339550467939639299,
        TO_DATE('2026-10-24 09:52:50', 'YYYY-MM-DD HH24:MI:SS'), 1339550467939639299
    );

INSERT INTO sys_menu (
    menu_id, menu_parent_id, menu_pids, menu_name, menu_code, app_id, menu_sort,
    status_flag, menu_type, antdv_router, antdv_component, antdv_icon,
    antdv_active_url, antdv_visible, version_flag, del_flag,
    create_time, create_user, update_time, update_user
) VALUES (

        2113293464660037634, 2113931679060545537,
        '[-1],[2060763497145757697],[2113931679060545537],', '任务实例', 'renwushili',
        1671406745336016898, 1050102.00, 1, 10,
        '/system/enhance/task/task-instance', '/system/enhance/task/task-instance/index',
        'icon-default', NULL, 'Y', 0, 'N',
        TO_DATE('2026-10-22 15:36:40', 'YYYY-MM-DD HH24:MI:SS'), 1339550467939639299,
        TO_DATE('2026-10-24 09:52:50', 'YYYY-MM-DD HH24:MI:SS'), 1339550467939639299
    );

COMMIT;
