-- 基于 ORACLE 8.1.4 初始化脚本补齐 Roses 基础框架增量结构。
-- 仅适用于尚未执行这些增量变更的 ORACLE 数据库；按顺序执行一次。

-- 旧初始化脚本未包含用户收藏表。
CREATE TABLE sys_user_favorite (
    favorite_id NUMBER(20,0) PRIMARY KEY,
    fav_type NVARCHAR2(100) NOT NULL,
    user_id NUMBER(20,0) NOT NULL,
    business_id NUMBER(20,0) NOT NULL,
    fav_time DATE,
    create_time DATE,
    create_user NUMBER(20,0),
    update_time DATE,
    update_user NUMBER(20,0)
);
COMMENT ON TABLE sys_user_favorite IS '用户收藏信息';

-- 应用设计菜单与文件路径。
ALTER TABLE sys_menu ADD app_design_view_id NUMBER(20,0);
COMMENT ON COLUMN sys_menu.app_design_view_id IS '应用设计对应业务的视图id';
UPDATE sys_config
SET config_name = 'Linux本地文件保存路径',
    config_code = 'SYS_LOCAL_FILE_SAVE_PATH_LINUX',
    config_value = '/opt/gunsFilePath',
    group_code = 'file_config'
WHERE config_id = 4;

-- 国密配置与安全策略菜单权限。
INSERT INTO sys_dict (
    dict_id, dict_type_id, dict_code, dict_name, dict_name_pinyin,
    dict_parent_id, dict_pids, status_flag, dict_sort, version_flag,
    del_flag, create_time, create_user
) VALUES (
    1805439083285716994, 1353547215422132226, 'GUO_MI_SM', '国密秘钥', 'gmmy',
    -1, '[-1],', 1, 100.00, 1, 'N', TO_DATE('2024-06-25 11:13:16', 'YYYY-MM-DD HH24:MI:SS'), 1339550467939639299
);

INSERT INTO sys_config (
    config_id, config_name, config_code, config_value, sys_flag,
    remark, status_flag, group_code, del_flag, create_time, create_user
) VALUES (1805439191234519042, 'SM2私钥', 'GUOMI_SM2_PRIVATE_KEY', '1', 'Y',
     '请自行生成并替换', 1, 'GUO_MI_SM', 'N', TO_DATE('2024-06-25 11:13:41', 'YYYY-MM-DD HH24:MI:SS'), 1339550467939639299);
INSERT INTO sys_config (
    config_id, config_name, config_code, config_value, sys_flag,
    remark, status_flag, group_code, del_flag, create_time, create_user
) VALUES (1805439245798219777, 'SM2公钥', 'GUOMI_SM2_PUBLIC_KEY', '1', 'Y',
     '请自行生成并替换', 1, 'GUO_MI_SM', 'N', TO_DATE('2024-06-25 11:13:54', 'YYYY-MM-DD HH24:MI:SS'), 1339550467939639299);
INSERT INTO sys_config (
    config_id, config_name, config_code, config_value, sys_flag,
    remark, status_flag, group_code, del_flag, create_time, create_user
) VALUES (1805788664473255937, 'SM4对称加密秘钥', 'GUOMI_SM4_KEY', '1', 'Y',
     '请自行生成并替换', 1, 'GUO_MI_SM', 'N', TO_DATE('2024-06-25 11:13:54', 'YYYY-MM-DD HH24:MI:SS'), 1339550467939639299);

INSERT INTO sys_menu_options (
    menu_option_id, app_id, menu_id, option_name, option_code, create_time, create_user
) VALUES (1811042155548205058, 1671406745336016898, 1710533513796653058,
     '维护黑白名单', 'BLACK_WHITE_LIST_UPDATE', TO_DATE('2024-07-10 22:17:52', 'YYYY-MM-DD HH24:MI:SS'), 1339550467939639299);
INSERT INTO sys_menu_options (
    menu_option_id, app_id, menu_id, option_name, option_code, create_time, create_user
) VALUES (1811282123950862338, 1671406745336016898, 1710533513796653058,
     '密码策略配置', 'PASSWORD_STRATEGY_CONFIG', TO_DATE('2024-07-11 14:11:25', 'YYYY-MM-DD HH24:MI:SS'), 1339550467939639299);
INSERT INTO sys_menu_options (
    menu_option_id, app_id, menu_id, option_name, option_code, create_time, create_user
) VALUES (1811330833279811585, 1671406745336016898, 1673525659931275265,
     '安全日志', 'SECURITY_LOG', TO_DATE('2024-07-11 17:24:58', 'YYYY-MM-DD HH24:MI:SS'), 1339550467939639299);

-- 登录和安全日志。
ALTER TABLE sys_login_log ADD account NVARCHAR2(255);
COMMENT ON COLUMN sys_login_log.account IS '登录账号';

CREATE TABLE sys_log_security (
    security_log_id NUMBER(20,0) PRIMARY KEY,
    request_url NVARCHAR2(2000),
    request_params NCLOB,
    server_ip NVARCHAR2(255),
    client_ip NVARCHAR2(255),
    http_method NVARCHAR2(255),
    client_browser NVARCHAR2(255),
    client_os NVARCHAR2(255),
    log_content NCLOB,
    create_time DATE,
    create_user NUMBER(20,0),
    update_time DATE,
    update_user NUMBER(20,0)
);
COMMENT ON TABLE sys_log_security IS '安全日志';

ALTER TABLE sys_user ADD freeze_deadline_time DATE;
COMMENT ON COLUMN sys_user.freeze_deadline_time IS '临时冻结截止时间';
COMMENT ON COLUMN sys_user.status_flag IS '状态：1-正常，2-冻结，3-临时冻结';

-- 初始化脚本的资源描述字段已是大字段，无须重复修改。
INSERT INTO sys_config (
    config_id, config_name, config_code, config_value, sys_flag,
    remark, status_flag, group_code, del_flag, create_time, create_user
) VALUES (
    1829152372339773442, '文件存储类型', 'SYS_FILE_SAVE_TYPE', '11', 'Y',
    '10-本地，存储到默认路径' || CHR(10) || '11-本地，存储到指定路径下' || CHR(10) || '20-存储到MinIO' || CHR(10) || '30-存储到阿里云' || CHR(10) || '40-存储到腾讯云' || CHR(10) || '50-存储到青云',
    1, 'file_config', 'N', TO_DATE('2024-08-29 21:41:24', 'YYYY-MM-DD HH24:MI:SS'), 1821938198325960706
);

ALTER TABLE sys_file_info ADD file_md5 NVARCHAR2(100);
COMMENT ON COLUMN sys_file_info.file_md5 IS '文件 MD5 值';

ALTER TABLE sys_user ADD hidden_flag NCHAR(1) DEFAULT 'N';
COMMENT ON COLUMN sys_user.hidden_flag IS '是否隐藏：Y-隐藏，N-不隐藏';

-- 机构层级与角色分类。
ALTER TABLE sys_hr_organization ADD level_code NVARCHAR2(100);
COMMENT ON COLUMN sys_hr_organization.level_code IS '机构层级编码';

CREATE TABLE sys_hr_organization_level (
    org_level_id NUMBER(20,0) PRIMARY KEY,
    level_number NUMBER(10,0) NOT NULL,
    level_name NVARCHAR2(100) NOT NULL,
    level_code NVARCHAR2(100) NOT NULL,
    level_color NVARCHAR2(100),
    del_flag NCHAR(1) NOT NULL DEFAULT 'N',
    create_time DATE,
    create_user NUMBER(20,0),
    update_time DATE,
    update_user NUMBER(20,0),
    tenant_id NUMBER(20,0)
);
COMMENT ON TABLE sys_hr_organization_level IS '组织机构层级';

CREATE TABLE sys_role_category (
    id NUMBER(20,0) PRIMARY KEY,
    category_parent_id NUMBER(20,0) NOT NULL,
    category_pids NVARCHAR2(1000) NOT NULL,
    role_category_name NVARCHAR2(100) NOT NULL,
    category_type NUMBER(4,0) NOT NULL DEFAULT 1,
    company_id NUMBER(20,0),
    fld_sort NUMBER(10,2),
    del_flag NCHAR(1) NOT NULL DEFAULT 'N',
    create_time DATE,
    create_user NUMBER(20,0),
    update_time DATE,
    update_user NUMBER(20,0),
    tenant_id NUMBER(20,0)
);
COMMENT ON TABLE sys_role_category IS '角色分类';

INSERT INTO sys_role_category (
    id, category_parent_id, category_pids, role_category_name,
    category_type, fld_sort, del_flag, create_time, create_user
) VALUES (
    1881997026537611265, -1, '[-1],', '默认业务分类',
    15, 100.00, 'N', TO_DATE('2025-01-22 17:26:26', 'YYYY-MM-DD HH24:MI:SS'), 1339550467939639299
);

ALTER TABLE sys_role ADD role_type NUMBER(4,0) DEFAULT 10 NOT NULL;
COMMENT ON COLUMN sys_role.role_type IS '角色类型：10-系统角色，15-业务角色，20-公司角色';
ALTER TABLE sys_role ADD role_category_id NUMBER(20,0);
COMMENT ON COLUMN sys_role.role_category_id IS '业务角色或公司角色所属分类';
UPDATE sys_role
SET role_category_id = 1881997026537611265
WHERE role_type = 15 AND role_category_id IS NULL;

-- 将旧版指定机构记录转为机构集合，再移除旧字段，保留原有授权范围。
ALTER TABLE sys_role_data_scope ADD (
    data_scope_type NUMBER(4,0) DEFAULT 20 NOT NULL,
    org_level_code NVARCHAR2(100),
    define_org_list NCLOB,
    define_org_id NUMBER(20,0)
);
UPDATE sys_role_data_scope
SET data_scope_type = 40,
    define_org_list = '[' || TO_CHAR(organization_id) || ']'
WHERE organization_id IS NOT NULL;
ALTER TABLE sys_role_data_scope DROP COLUMN organization_id;
COMMENT ON COLUMN sys_role_data_scope.data_scope_type IS '数据范围类型：10、20、30、31、32、40、41、50';
COMMENT ON COLUMN sys_role_data_scope.define_org_list IS '指定机构标识集合，JSON 数组';

DELETE FROM sys_role_data_scope
WHERE role_id = 1671420545250439170 AND data_scope_type = 50;
INSERT INTO sys_role_data_scope (
    role_data_scope_id, role_id, data_scope_type, create_time, create_user
) VALUES (
    1920774896534970369, 1671420545250439170, 50,
    TO_DATE('2025-05-09 17:36:36', 'YYYY-MM-DD HH24:MI:SS'), 1339550467939639299
);

-- 系统配置排序与无效配置清理。
ALTER TABLE sys_config ADD fld_sort NUMBER(10,2) DEFAULT 1000;
COMMENT ON COLUMN sys_config.fld_sort IS '配置排序';

INSERT INTO sys_dict (
    dict_id, dict_type_id, dict_code, dict_name, dict_name_pinyin,
    dict_parent_id, dict_pids, status_flag, dict_sort, version_flag,
    del_flag, create_time, create_user
) VALUES (
    1984089168132517889, 1353547215422132226, 'DRUID_CONFIG', 'Druid配置', 'Druidpz',
    -1, '[-1],', 1, 110.00, 0, 'N', TO_DATE('2025-10-31 10:44:55', 'YYYY-MM-DD HH24:MI:SS'), 1339550467939639299
);

UPDATE sys_config
SET group_code = 'DRUID_CONFIG',
    fld_sort = CASE config_id
        WHEN 33 THEN 201 WHEN 34 THEN 202 WHEN 35 THEN 203
        WHEN 36 THEN 204 WHEN 37 THEN 205 WHEN 38 THEN 206
        WHEN 39 THEN 207 WHEN 40 THEN 208 WHEN 41 THEN 209
        WHEN 42 THEN 210 WHEN 43 THEN 211
    END
WHERE config_id BETWEEN 33 AND 43;

UPDATE sys_config
SET fld_sort = CASE config_id
    WHEN 1356246056131649538 THEN 5
    WHEN 6 THEN 10
    WHEN 1350666094452482049 THEN 20
    WHEN 23 THEN 30
    WHEN 1402549781675610125 THEN 40
    WHEN 1402549781675610400 THEN 50
    WHEN 1829152372339773442 THEN 111
    WHEN 1402549781675610405 THEN 112
    WHEN 30 THEN 113
END
WHERE config_id IN (
    1356246056131649538, 6, 1350666094452482049, 23,
    1402549781675610125, 1402549781675610400,
    1829152372339773442, 1402549781675610405, 30
);
UPDATE sys_config
SET config_name = '图片文字验证码开关',
    remark = '如若开启，请同时将前端/src/config/settings.js中的CAPTCHA_FLAG改为true'
WHERE config_id = 23;
UPDATE sys_config
SET remark = '如若开启，请同时将前端/src/config/settings.js中的DRAW_CAPTCHA_FLAG改为true'
WHERE config_id = 1402549781675610125;

DELETE FROM sys_config
WHERE config_id IN (22, 1402549781675610505);

COMMIT;
