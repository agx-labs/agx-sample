-- 基于 kingbase 8.1.4 初始化脚本补齐 Roses 基础框架增量结构。
-- 仅适用于尚未执行这些增量变更的 kingbase 数据库；在同一事务中执行一次。
BEGIN;

-- 旧初始化脚本未包含用户收藏表。
CREATE TABLE public.sys_user_favorite (
    favorite_id bigint PRIMARY KEY,
    fav_type varchar(100) NOT NULL,
    user_id bigint NOT NULL,
    business_id bigint NOT NULL,
    fav_time timestamp(6),
    create_time timestamp(6),
    create_user bigint,
    update_time timestamp(6),
    update_user bigint
);
COMMENT ON TABLE public.sys_user_favorite IS '用户收藏信息';

-- 应用设计菜单与文件路径。
ALTER TABLE public.sys_menu ADD COLUMN app_design_view_id bigint;
COMMENT ON COLUMN public.sys_menu.app_design_view_id IS '应用设计对应业务的视图id';
UPDATE public.sys_config
SET config_name = 'Linux本地文件保存路径',
    config_code = 'SYS_LOCAL_FILE_SAVE_PATH_LINUX',
    config_value = '/opt/gunsFilePath',
    group_code = 'file_config'
WHERE config_id = 4;

-- 国密配置与安全策略菜单权限。
INSERT INTO public.sys_dict (
    dict_id, dict_type_id, dict_code, dict_name, dict_name_pinyin,
    dict_parent_id, dict_pids, status_flag, dict_sort, version_flag,
    del_flag, create_time, create_user
) VALUES (
    1805439083285716994, 1353547215422132226, 'GUO_MI_SM', '国密秘钥', 'gmmy',
    -1, '[-1],', 1, 100.00, 1, 'N', '2024-06-25 11:13:16', 1339550467939639299
);

INSERT INTO public.sys_config (
    config_id, config_name, config_code, config_value, sys_flag,
    remark, status_flag, group_code, del_flag, create_time, create_user
) VALUES
    (1805439191234519042, 'SM2私钥', 'GUOMI_SM2_PRIVATE_KEY', '1', 'Y',
     '请自行生成并替换', 1, 'GUO_MI_SM', 'N', '2024-06-25 11:13:41', 1339550467939639299),
    (1805439245798219777, 'SM2公钥', 'GUOMI_SM2_PUBLIC_KEY', '1', 'Y',
     '请自行生成并替换', 1, 'GUO_MI_SM', 'N', '2024-06-25 11:13:54', 1339550467939639299),
    (1805788664473255937, 'SM4对称加密秘钥', 'GUOMI_SM4_KEY', '1', 'Y',
     '请自行生成并替换', 1, 'GUO_MI_SM', 'N', '2024-06-25 11:13:54', 1339550467939639299);

INSERT INTO public.sys_menu_options (
    menu_option_id, app_id, menu_id, option_name, option_code, create_time, create_user
) VALUES
    (1811042155548205058, 1671406745336016898, 1710533513796653058,
     '维护黑白名单', 'BLACK_WHITE_LIST_UPDATE', '2024-07-10 22:17:52', 1339550467939639299),
    (1811282123950862338, 1671406745336016898, 1710533513796653058,
     '密码策略配置', 'PASSWORD_STRATEGY_CONFIG', '2024-07-11 14:11:25', 1339550467939639299),
    (1811330833279811585, 1671406745336016898, 1673525659931275265,
     '安全日志', 'SECURITY_LOG', '2024-07-11 17:24:58', 1339550467939639299);

-- 登录和安全日志。
ALTER TABLE public.sys_login_log ADD COLUMN account varchar(255);
COMMENT ON COLUMN public.sys_login_log.account IS '登录账号';

CREATE TABLE public.sys_log_security (
    security_log_id bigint PRIMARY KEY,
    request_url varchar(2000),
    request_params text,
    server_ip varchar(255),
    client_ip varchar(255),
    http_method varchar(255),
    client_browser varchar(255),
    client_os varchar(255),
    log_content text,
    create_time timestamp(6),
    create_user bigint,
    update_time timestamp(6),
    update_user bigint
);
COMMENT ON TABLE public.sys_log_security IS '安全日志';

ALTER TABLE public.sys_user ADD COLUMN freeze_deadline_time timestamp(6);
COMMENT ON COLUMN public.sys_user.freeze_deadline_time IS '临时冻结截止时间';
COMMENT ON COLUMN public.sys_user.status_flag IS '状态：1-正常，2-冻结，3-临时冻结';

-- kingbase 初始化脚本的资源描述字段已是 text，无须重复修改。
INSERT INTO public.sys_config (
    config_id, config_name, config_code, config_value, sys_flag,
    remark, status_flag, group_code, del_flag, create_time, create_user
) VALUES (
    1829152372339773442, '文件存储类型', 'SYS_FILE_SAVE_TYPE', '11', 'Y',
    E'10-本地，存储到默认路径\n11-本地，存储到指定路径下\n20-存储到MinIO\n30-存储到阿里云\n40-存储到腾讯云\n50-存储到青云',
    1, 'file_config', 'N', '2024-08-29 21:41:24', 1821938198325960706
);

ALTER TABLE public.sys_file_info ADD COLUMN file_md5 varchar(100);
COMMENT ON COLUMN public.sys_file_info.file_md5 IS '文件 MD5 值';

ALTER TABLE public.sys_user ADD COLUMN hidden_flag char(1) DEFAULT 'N';
COMMENT ON COLUMN public.sys_user.hidden_flag IS '是否隐藏：Y-隐藏，N-不隐藏';

-- 机构层级与角色分类。
ALTER TABLE public.sys_hr_organization ADD COLUMN level_code varchar(100);
COMMENT ON COLUMN public.sys_hr_organization.level_code IS '机构层级编码';

CREATE TABLE public.sys_hr_organization_level (
    org_level_id bigint PRIMARY KEY,
    level_number integer NOT NULL,
    level_name varchar(100) NOT NULL,
    level_code varchar(100) NOT NULL,
    level_color varchar(100),
    del_flag char(1) NOT NULL DEFAULT 'N',
    create_time timestamp(6),
    create_user bigint,
    update_time timestamp(6),
    update_user bigint,
    tenant_id bigint
);
COMMENT ON TABLE public.sys_hr_organization_level IS '组织机构层级';

CREATE TABLE public.sys_role_category (
    id bigint PRIMARY KEY,
    category_parent_id bigint NOT NULL,
    category_pids varchar(1000) NOT NULL,
    role_category_name varchar(100) NOT NULL,
    category_type smallint NOT NULL DEFAULT 1,
    company_id bigint,
    fld_sort numeric(10, 2),
    del_flag char(1) NOT NULL DEFAULT 'N',
    create_time timestamp(6),
    create_user bigint,
    update_time timestamp(6),
    update_user bigint,
    tenant_id bigint
);
COMMENT ON TABLE public.sys_role_category IS '角色分类';

INSERT INTO public.sys_role_category (
    id, category_parent_id, category_pids, role_category_name,
    category_type, fld_sort, del_flag, create_time, create_user
) VALUES (
    1881997026537611265, -1, '[-1],', '默认业务分类',
    15, 100.00, 'N', '2025-01-22 17:26:26', 1339550467939639299
);

ALTER TABLE public.sys_role ADD COLUMN role_category_id bigint;
COMMENT ON COLUMN public.sys_role.role_category_id IS '业务角色或公司角色所属分类';
UPDATE public.sys_role
SET role_category_id = 1881997026537611265
WHERE role_type = 15 AND role_category_id IS NULL;

-- 将旧版指定机构记录转为机构集合，再移除旧字段，保留原有授权范围。
ALTER TABLE public.sys_role_data_scope
    ADD COLUMN data_scope_type smallint NOT NULL DEFAULT 20,
    ADD COLUMN org_level_code varchar(100),
    ADD COLUMN define_org_list text,
    ADD COLUMN define_org_id bigint;
UPDATE public.sys_role_data_scope
SET data_scope_type = 40,
    define_org_list = json_build_array(organization_id)::text
WHERE organization_id IS NOT NULL;
ALTER TABLE public.sys_role_data_scope DROP COLUMN organization_id;
COMMENT ON COLUMN public.sys_role_data_scope.data_scope_type IS '数据范围类型：10、20、30、31、32、40、41、50';
COMMENT ON COLUMN public.sys_role_data_scope.define_org_list IS '指定机构标识集合，JSON 数组';

DELETE FROM public.sys_role_data_scope
WHERE role_id = 1671420545250439170 AND data_scope_type = 50;
INSERT INTO public.sys_role_data_scope (
    role_data_scope_id, role_id, data_scope_type, create_time, create_user
) VALUES (
    1920774896534970369, 1671420545250439170, 50,
    '2025-05-09 17:36:36', 1339550467939639299
);

-- 系统配置排序与无效配置清理。
ALTER TABLE public.sys_config ADD COLUMN fld_sort numeric(10, 2) DEFAULT 1000;
COMMENT ON COLUMN public.sys_config.fld_sort IS '配置排序';

INSERT INTO public.sys_dict (
    dict_id, dict_type_id, dict_code, dict_name, dict_name_pinyin,
    dict_parent_id, dict_pids, status_flag, dict_sort, version_flag,
    del_flag, create_time, create_user
) VALUES (
    1984089168132517889, 1353547215422132226, 'DRUID_CONFIG', 'Druid配置', 'Druidpz',
    -1, '[-1],', 1, 110.00, 0, 'N', '2025-10-31 10:44:55', 1339550467939639299
);

UPDATE public.sys_config
SET group_code = 'DRUID_CONFIG',
    fld_sort = CASE config_id
        WHEN 33 THEN 201 WHEN 34 THEN 202 WHEN 35 THEN 203
        WHEN 36 THEN 204 WHEN 37 THEN 205 WHEN 38 THEN 206
        WHEN 39 THEN 207 WHEN 40 THEN 208 WHEN 41 THEN 209
        WHEN 42 THEN 210 WHEN 43 THEN 211
    END
WHERE config_id BETWEEN 33 AND 43;

UPDATE public.sys_config
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
UPDATE public.sys_config
SET config_name = '图片文字验证码开关',
    remark = '如若开启，请同时将前端/src/config/settings.js中的CAPTCHA_FLAG改为true'
WHERE config_id = 23;
UPDATE public.sys_config
SET remark = '如若开启，请同时将前端/src/config/settings.js中的DRAW_CAPTCHA_FLAG改为true'
WHERE config_id = 1402549781675610125;

DELETE FROM public.sys_config
WHERE config_id IN (22, 1402549781675610505);

COMMIT;
