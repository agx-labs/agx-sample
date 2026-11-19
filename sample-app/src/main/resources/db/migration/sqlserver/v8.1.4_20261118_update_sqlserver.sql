-- 基于现有 SQL Server 初始化脚本补齐可直接迁移的 Roses 增量结构。
-- 该初始化脚本使用旧版表模型（如 hr_organization、sys_menu_button、sys_role.role_type_code）。
-- 与新版 MySQL 模型不兼容的菜单权限及角色数据不在此脚本中强行转换。
BEGIN TRANSACTION;

CREATE TABLE dbo.sys_user_favorite (
    favorite_id bigint NOT NULL PRIMARY KEY,
    fav_type nvarchar(100) NOT NULL,
    user_id bigint NOT NULL,
    business_id bigint NOT NULL,
    fav_time datetime2(0),
    create_time datetime2(0),
    create_user bigint,
    update_time datetime2(0),
    update_user bigint
);

ALTER TABLE dbo.sys_menu ADD app_design_view_id bigint;
UPDATE dbo.sys_config
SET config_name = N'Linux本地文件保存路径',
    config_code = N'SYS_LOCAL_FILE_SAVE_PATH_LINUX',
    config_value = N'/opt/gunsFilePath',
    group_code = N'file_config'
WHERE config_id = 4;

ALTER TABLE dbo.sys_login_log ADD account nvarchar(255);
CREATE TABLE dbo.sys_log_security (
    security_log_id bigint NOT NULL PRIMARY KEY,
    request_url nvarchar(2000),
    request_params nvarchar(max),
    server_ip nvarchar(255),
    client_ip nvarchar(255),
    http_method nvarchar(255),
    client_browser nvarchar(255),
    client_os nvarchar(255),
    log_content nvarchar(max),
    create_time datetime2(0),
    create_user bigint,
    update_time datetime2(0),
    update_user bigint
);

ALTER TABLE dbo.sys_user ADD freeze_deadline_time datetime2(0);
ALTER TABLE dbo.sys_user ADD hidden_flag nchar(1) DEFAULT N'N';
ALTER TABLE dbo.sys_file_info ADD file_md5 nvarchar(100);
ALTER TABLE dbo.hr_organization ADD level_code nvarchar(100);

CREATE TABLE dbo.sys_hr_organization_level (
    org_level_id bigint NOT NULL PRIMARY KEY,
    level_number int NOT NULL,
    level_name nvarchar(100) NOT NULL,
    level_code nvarchar(100) NOT NULL,
    level_color nvarchar(100),
    del_flag nchar(1) NOT NULL DEFAULT N'N',
    create_time datetime2(0),
    create_user bigint,
    update_time datetime2(0),
    update_user bigint,
    tenant_id bigint
);

CREATE TABLE dbo.sys_role_category (
    id bigint NOT NULL PRIMARY KEY,
    category_parent_id bigint NOT NULL,
    category_pids nvarchar(1000) NOT NULL,
    role_category_name nvarchar(100) NOT NULL,
    category_type smallint NOT NULL DEFAULT 1,
    company_id bigint,
    fld_sort decimal(10, 2),
    del_flag nchar(1) NOT NULL DEFAULT N'N',
    create_time datetime2(0),
    create_user bigint,
    update_time datetime2(0),
    update_user bigint,
    tenant_id bigint
);
INSERT INTO dbo.sys_role_category (
    id, category_parent_id, category_pids, role_category_name,
    category_type, fld_sort, del_flag, create_time, create_user
) VALUES (
    1881997026537611265, -1, N'[-1],', N'默认业务分类',
    15, 100.00, N'N', '2025-01-22 17:26:26', 1339550467939639299
);
ALTER TABLE dbo.sys_role ADD role_category_id bigint;

ALTER TABLE dbo.sys_role_data_scope ADD data_scope_type smallint NOT NULL DEFAULT 20;
ALTER TABLE dbo.sys_role_data_scope ADD org_level_code nvarchar(100);
ALTER TABLE dbo.sys_role_data_scope ADD define_org_list nvarchar(max);
ALTER TABLE dbo.sys_role_data_scope ADD define_org_id bigint;
UPDATE dbo.sys_role_data_scope
SET data_scope_type = 40,
    define_org_list = N'[' + CONVERT(nvarchar(20), organization_id) + N']'
WHERE organization_id IS NOT NULL;

ALTER TABLE dbo.sys_config ADD fld_sort decimal(10, 2) DEFAULT 1000;
UPDATE dbo.sys_config
SET group_code = N'DRUID_CONFIG',
    fld_sort = config_id - 33 + 201
WHERE config_id BETWEEN 33 AND 43;
UPDATE dbo.sys_config
SET fld_sort = CASE config_id
    WHEN 1356246056131649538 THEN 5
    WHEN 6 THEN 10
    WHEN 1350666094452482049 THEN 20
    WHEN 23 THEN 30
    WHEN 1402549781675610125 THEN 40
    WHEN 1402549781675610400 THEN 50
    WHEN 1402549781675610405 THEN 112
    WHEN 30 THEN 113
END
WHERE config_id IN (
    1356246056131649538, 6, 1350666094452482049, 23,
    1402549781675610125, 1402549781675610400, 1402549781675610405, 30
);
UPDATE dbo.sys_config
SET config_name = N'图片文字验证码开关',
    remark = N'如若开启，请同时将前端/src/config/settings.js中的CAPTCHA_FLAG改为true'
WHERE config_id = 23;
UPDATE dbo.sys_config
SET remark = N'如若开启，请同时将前端/src/config/settings.js中的DRAW_CAPTCHA_FLAG改为true'
WHERE config_id = 1402549781675610125;
DELETE FROM dbo.sys_config WHERE config_id IN (22, 1402549781675610505);

COMMIT TRANSACTION;
