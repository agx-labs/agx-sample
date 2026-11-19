-- SQL Server Roses 基础表使用 app_code 标识应用，菜单按该结构写入。
BEGIN TRANSACTION;

CREATE TABLE dbo.task_config (
    task_id bigint NOT NULL CONSTRAINT pk_task_config PRIMARY KEY,
    task_code nvarchar(100),
    task_name nvarchar(255) NOT NULL,
    description nvarchar(1000),
    schedule_type nvarchar(20) NOT NULL,
    scheduler_job_id nvarchar(100),
    execution_type nvarchar(50) NOT NULL,
    execution_definition nvarchar(max),
    task_params nvarchar(max),
    task_cron nvarchar(100),
    status tinyint DEFAULT 1,
    create_time datetime2(0) DEFAULT SYSDATETIME(),
    update_time datetime2(0) DEFAULT SYSDATETIME(),
    create_user bigint,
    update_user bigint
);

CREATE TABLE dbo.task_instance (
    task_inst_id bigint NOT NULL CONSTRAINT pk_task_instance PRIMARY KEY,
    task_id bigint NOT NULL,
    task_code nvarchar(100),
    task_name nvarchar(255),
    scheduler_job_id nvarchar(100),
    scheduler_log_id nvarchar(100),
    trigger_type nvarchar(50),
    execution_type nvarchar(50),
    execution_definition nvarchar(max),
    task_params nvarchar(max),
    start_time datetime2(0),
    end_time datetime2(0),
    handle_result nvarchar(100),
    handle_msg nvarchar(max),
    create_time datetime2(0) DEFAULT SYSDATETIME(),
    update_time datetime2(0) DEFAULT SYSDATETIME(),
    create_user bigint,
    update_user bigint
);

INSERT INTO dbo.sys_menu (
    menu_id, menu_parent_id, menu_pids, menu_name, menu_code, app_code,
    menu_sort, status_flag, antdv_router, antdv_component, antdv_icon,
    antdv_active_url, antdv_visible, del_flag,
    create_time, create_user, update_time, update_user
) VALUES (
    2060763497145757697, -1, N'[-1],', N'增强服务', N'zengqiangfuwu', N'systemApp',
    105.00, 1, N'/system/enhance', NULL, N'icon-menu-yingyongguanli',
    NULL, N'Y', N'N',
    '2026-05-30 16:41:20', 1339550467939639299,
    '2026-10-24 09:52:50', 1339550467939639299
);

INSERT INTO dbo.sys_menu (
    menu_id, menu_parent_id, menu_pids, menu_name, menu_code, app_code,
    menu_sort, status_flag, antdv_router, antdv_component, antdv_icon,
    antdv_active_url, antdv_visible, del_flag,
    create_time, create_user, update_time, update_user
) VALUES (
    2113931679060545537, 2060763497145757697,
    N'[-1],[2060763497145757697],', N'任务管理', N'renwuguanli', N'systemApp',
    10501.00, 1, N'/system/enhance/task', NULL, N'icon-default',
    NULL, N'Y', N'N',
    '2026-10-24 09:52:42', 1339550467939639299,
    '2026-10-24 09:52:50', 1339550467939639299
);

INSERT INTO dbo.sys_menu (
    menu_id, menu_parent_id, menu_pids, menu_name, menu_code, app_code,
    menu_sort, status_flag, antdv_router, antdv_component, antdv_icon,
    antdv_active_url, antdv_visible, del_flag,
    create_time, create_user, update_time, update_user
) VALUES (
    2112566848493363202, 2113931679060545537,
    N'[-1],[2060763497145757697],[2113931679060545537],', N'任务配置', N'renwupeizhi', N'systemApp',
    1050101.00, 1, N'/system/enhance/task/task-config', N'/system/enhance/task/task-config/index', N'icon-default',
    N'', N'Y', N'N',
    '2026-10-20 15:29:21', 1339550467939639299,
    '2026-10-24 09:52:50', 1339550467939639299
);

INSERT INTO dbo.sys_menu (
    menu_id, menu_parent_id, menu_pids, menu_name, menu_code, app_code,
    menu_sort, status_flag, antdv_router, antdv_component, antdv_icon,
    antdv_active_url, antdv_visible, del_flag,
    create_time, create_user, update_time, update_user
) VALUES (
    2113293464660037634, 2113931679060545537,
    N'[-1],[2060763497145757697],[2113931679060545537],', N'任务实例', N'renwushili', N'systemApp',
    1050102.00, 1, N'/system/enhance/task/task-instance', N'/system/enhance/task/task-instance/index', N'icon-default',
    NULL, N'Y', N'N',
    '2026-10-22 15:36:40', 1339550467939639299,
    '2026-10-24 09:52:50', 1339550467939639299
);

COMMIT TRANSACTION;
