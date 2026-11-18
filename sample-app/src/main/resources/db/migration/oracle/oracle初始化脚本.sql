CREATE TABLE sys_app (
  app_id NUMBER(20,0) NOT NULL,
  app_name NVARCHAR2(100) NOT NULL,
  app_code NVARCHAR2(100) NOT NULL,
  app_icon NUMBER(20,0),
  status_flag NUMBER(4,0) NOT NULL,
  app_sort NUMBER,
  remark NVARCHAR2(255),
  expand_field CLOB,
  version_flag NUMBER(20,0),
  del_flag NCHAR(1) DEFAULT 'N' NOT NULL,
  create_time DATE,
  create_user NUMBER(20,0),
  update_time DATE,
  update_user NUMBER(20,0),
  PRIMARY KEY (app_id)
);
CREATE UNIQUE INDEX APP_CODE_UNIQUE
  ON sys_app (app_code);
COMMENT ON COLUMN sys_app.app_id IS '主键id';
COMMENT ON COLUMN sys_app.app_name IS '应用名称';
COMMENT ON COLUMN sys_app.app_code IS '编码';
COMMENT ON COLUMN sys_app.app_icon IS '应用图标，存fileId，上传的图片';
COMMENT ON COLUMN sys_app.status_flag IS '状态：1-启用，2-禁用';
COMMENT ON COLUMN sys_app.app_sort IS '排序';
COMMENT ON COLUMN sys_app.remark IS '备注';
COMMENT ON COLUMN sys_app.expand_field IS '拓展字段';
COMMENT ON COLUMN sys_app.version_flag IS '乐观锁';
COMMENT ON COLUMN sys_app.del_flag IS '删除标记：Y-已删除，N-未删除';
COMMENT ON COLUMN sys_app.create_time IS '创建时间';
COMMENT ON COLUMN sys_app.create_user IS '创建人';
COMMENT ON COLUMN sys_app.update_time IS '更新时间';
COMMENT ON COLUMN sys_app.update_user IS '更新人';
COMMENT ON TABLE sys_app IS '系统应用';

CREATE TABLE sys_area (
  area_id NUMBER(20,0) NOT NULL,
  area_code NVARCHAR2(255) NOT NULL,
  area_name NVARCHAR2(255) NOT NULL,
  parent_id NVARCHAR2(255) NOT NULL,
  area_level NUMBER(11,0),
  area_sort NUMBER,
  del_flag NCHAR(1),
  area_pids NVARCHAR2(255),
  create_time DATE,
  create_user NUMBER(20,0),
  update_time DATE,
  update_user NUMBER(20,0),
   PRIMARY KEY (area_id)
);
CREATE INDEX area_code
  ON sys_area (area_code);
CREATE INDEX area_name
  ON sys_area (area_name);
CREATE INDEX parent_id
  ON sys_area (parent_id);
COMMENT ON COLUMN sys_area.area_id IS '区域id';
COMMENT ON COLUMN sys_area.area_code IS '区域编码';
COMMENT ON COLUMN sys_area.area_name IS '区域全称';
COMMENT ON COLUMN sys_area.parent_id IS '上级区域编码';
COMMENT ON COLUMN sys_area.area_level IS '区域级别';
COMMENT ON COLUMN sys_area.area_sort IS '排序码';
COMMENT ON COLUMN sys_area.del_flag IS '是否删除';
COMMENT ON COLUMN sys_area.area_pids IS '所有的上级区域编码,用逗号分隔';
COMMENT ON TABLE sys_area IS '行政区域表';

CREATE TABLE sys_click_count (
  click_count_id NUMBER(20,0) NOT NULL,
  business_type NVARCHAR2(100),
  business_key_id NUMBER(20,0),
  click_count NUMBER(20,0),
  create_time DATE,
  create_user NUMBER(20,0),
  update_time DATE,
  update_user NUMBER(20,0),
   PRIMARY KEY (click_count_id)
);
COMMENT ON COLUMN sys_click_count.click_count_id IS '主键id';
COMMENT ON COLUMN sys_click_count.business_type IS '业务的分类标识';
COMMENT ON COLUMN sys_click_count.business_key_id IS '业务的主键id';
COMMENT ON COLUMN sys_click_count.click_count IS '点击次数';
COMMENT ON COLUMN sys_click_count.create_time IS '创建时间';
COMMENT ON COLUMN sys_click_count.create_user IS '创建人';
COMMENT ON COLUMN sys_click_count.update_time IS '修改时间';
COMMENT ON COLUMN sys_click_count.update_user IS '修改人';
COMMENT ON TABLE sys_click_count IS '用户点击数量统计';

CREATE TABLE sys_click_status (
  click_status_id NUMBER(20,0) NOT NULL,
  user_id NUMBER(20,0),
  business_key_id NUMBER(20,0),
  business_type NVARCHAR2(100),
  create_time DATE,
  create_user NUMBER(20,0),
  update_time DATE,
  update_user NUMBER(20,0),
   PRIMARY KEY (click_status_id)
);
COMMENT ON COLUMN sys_click_status.click_status_id IS '主键id';
COMMENT ON COLUMN sys_click_status.user_id IS '用户id';
COMMENT ON COLUMN sys_click_status.business_key_id IS '业务的主键id';
COMMENT ON COLUMN sys_click_status.business_type IS '业务的分类标识';
COMMENT ON COLUMN sys_click_status.create_time IS '创建时间';
COMMENT ON COLUMN sys_click_status.create_user IS '创建人';
COMMENT ON COLUMN sys_click_status.update_time IS '修改时间';
COMMENT ON COLUMN sys_click_status.update_user IS '修改人';
COMMENT ON TABLE sys_click_status IS '用户点击状态';

CREATE TABLE sys_config (
  config_id NUMBER(20,0) NOT NULL,
  config_name NVARCHAR2(255) NOT NULL,
  config_code NVARCHAR2(100),
  config_value NCLOB NOT NULL,
  sys_flag NCHAR(1),
  remark NVARCHAR2(255),
  status_flag NUMBER(4,0),
  group_code NVARCHAR2(255),
  del_flag NCHAR(1) DEFAULT 'N' NOT NULL,
  create_time DATE,
  create_user NUMBER(20,0),
  update_time DATE,
  update_user NUMBER(20,0),
   PRIMARY KEY (config_id)
);
CREATE UNIQUE INDEX code_unique
  ON sys_config (config_code);
COMMENT ON COLUMN sys_config.config_id IS '主键';
COMMENT ON COLUMN sys_config.config_name IS '名称';
COMMENT ON COLUMN sys_config.config_code IS '属性编码';
COMMENT ON COLUMN sys_config.config_value IS '属性值';
COMMENT ON COLUMN sys_config.sys_flag IS '是否是系统参数：Y-是，N-否';
COMMENT ON COLUMN sys_config.remark IS '备注';
COMMENT ON COLUMN sys_config.status_flag IS '状态：1-正常，2-停用';
COMMENT ON COLUMN sys_config.group_code IS '常量所属分类的编码，来自于“常量的分类”字典';
COMMENT ON COLUMN sys_config.del_flag IS '是否删除：Y-被删除，N-未删除';
COMMENT ON COLUMN sys_config.create_time IS '创建时间';
COMMENT ON COLUMN sys_config.create_user IS '创建人';
COMMENT ON COLUMN sys_config.update_time IS '修改时间';
COMMENT ON COLUMN sys_config.update_user IS '修改人';
COMMENT ON TABLE sys_config IS '参数配置';

CREATE TABLE sys_database_info (
  db_id NUMBER(20,0) NOT NULL,
  db_name NVARCHAR2(255) NOT NULL,
  jdbc_driver NVARCHAR2(255) NOT NULL,
  jdbc_url NVARCHAR2(255) NOT NULL,
  username NVARCHAR2(255) NOT NULL,
  password NVARCHAR2(255) NOT NULL,
  schema_name NVARCHAR2(255),
  status_flag NUMBER(4,0),
  error_description NVARCHAR2(500),
  remarks NVARCHAR2(255),
  del_flag NCHAR(1) DEFAULT 'N' NOT NULL,
  create_time DATE,
  create_user NUMBER(20,0),
  update_time DATE,
  update_user NUMBER(20,0),
   PRIMARY KEY (db_id)
);
COMMENT ON COLUMN sys_database_info.db_id IS '主键';
COMMENT ON COLUMN sys_database_info.db_name IS '数据库名称（英文名称）';
COMMENT ON COLUMN sys_database_info.jdbc_driver IS 'jdbc的驱动类型';
COMMENT ON COLUMN sys_database_info.jdbc_url IS 'jdbc的url';
COMMENT ON COLUMN sys_database_info.username IS '数据库连接的账号';
COMMENT ON COLUMN sys_database_info.password IS '数据库连接密码';
COMMENT ON COLUMN sys_database_info.schema_name IS '数据库的schema名称，每种数据库的schema意义都不同';
COMMENT ON COLUMN sys_database_info.status_flag IS '数据源状态：1-正常，2-无法连接';
COMMENT ON COLUMN sys_database_info.error_description IS '连接失败原因';
COMMENT ON COLUMN sys_database_info.remarks IS '备注，摘要';
COMMENT ON COLUMN sys_database_info.del_flag IS '是否删除，Y-被删除，N-未删除';
COMMENT ON COLUMN sys_database_info.create_time IS '创建时间';
COMMENT ON COLUMN sys_database_info.create_user IS '创建人';
COMMENT ON COLUMN sys_database_info.update_time IS '修改时间';
COMMENT ON COLUMN sys_database_info.update_user IS '修改人';
COMMENT ON TABLE sys_database_info IS '多数据源信息';

CREATE TABLE sys_dict (
  dict_id NUMBER(20,0) NOT NULL,
  dict_type_id NUMBER(20,0) NOT NULL,
  dict_code NVARCHAR2(255) NOT NULL,
  dict_name NVARCHAR2(255) NOT NULL,
  dict_name_pinyin NVARCHAR2(255),
  dict_encode NVARCHAR2(255),
  dict_short_name NVARCHAR2(255),
  dict_short_code NVARCHAR2(255),
  dict_parent_id NUMBER(20,0) NOT NULL,
  dict_pids NVARCHAR2(1000) NOT NULL,
  status_flag NUMBER(4,0) NOT NULL,
  dict_sort NUMBER,
  version_flag NUMBER(20,0),
  del_flag NCHAR(1) DEFAULT 'N' NOT NULL,
  create_time DATE,
  create_user NUMBER(20,0),
  update_time DATE,
  update_user NUMBER(20,0),
   PRIMARY KEY (dict_id)
);
COMMENT ON COLUMN sys_dict.dict_id IS '字典id';
COMMENT ON COLUMN sys_dict.dict_type_id IS '字典类型的id';
COMMENT ON COLUMN sys_dict.dict_code IS '字典编码';
COMMENT ON COLUMN sys_dict.dict_name IS '字典名称';
COMMENT ON COLUMN sys_dict.dict_name_pinyin IS '字典名称首字母';
COMMENT ON COLUMN sys_dict.dict_encode IS '字典编码';
COMMENT ON COLUMN sys_dict.dict_short_name IS '字典简称';
COMMENT ON COLUMN sys_dict.dict_short_code IS '字典简称的编码';
COMMENT ON COLUMN sys_dict.dict_parent_id IS '上级字典的id(如果没有上级字典id，则为-1)';
COMMENT ON COLUMN sys_dict.dict_pids IS '父id集合';
COMMENT ON COLUMN sys_dict.status_flag IS '状态：(1-启用,2-禁用),参考 StatusEnum';
COMMENT ON COLUMN sys_dict.dict_sort IS '排序，带小数点';
COMMENT ON COLUMN sys_dict.version_flag IS '乐观锁';
COMMENT ON COLUMN sys_dict.del_flag IS '删除标记：Y-已删除，N-未删除';
COMMENT ON COLUMN sys_dict.create_time IS '创建时间';
COMMENT ON COLUMN sys_dict.create_user IS '创建人';
COMMENT ON COLUMN sys_dict.update_time IS '更新时间';
COMMENT ON COLUMN sys_dict.update_user IS '更新人';
COMMENT ON TABLE sys_dict IS '字典';

CREATE TABLE sys_dict_type (
  dict_type_id NUMBER(20,0) NOT NULL,
  dict_type_class NUMBER(11,0),
  dict_type_bus_code NVARCHAR2(255),
  dict_type_code NVARCHAR2(255),
  dict_type_name NVARCHAR2(255),
  dict_type_name_pinyin NVARCHAR2(255),
  dict_type_desc NVARCHAR2(255),
  status_flag NUMBER(4,0),
  dict_type_sort NUMBER,
  version_flag NUMBER(20,0),
  del_flag NCHAR(1) DEFAULT 'N' NOT NULL,
  create_time DATE,
  create_user NUMBER(20,0),
  update_time DATE,
  update_user NUMBER(20,0),
   PRIMARY KEY (dict_type_id)
);
COMMENT ON COLUMN sys_dict_type.dict_type_id IS '字典类型id';
COMMENT ON COLUMN sys_dict_type.dict_type_class IS '字典类型： 1-业务类型，2-系统类型，参考 DictTypeClassEnum';
COMMENT ON COLUMN sys_dict_type.dict_type_bus_code IS '字典类型业务编码';
COMMENT ON COLUMN sys_dict_type.dict_type_code IS '字典类型编码';
COMMENT ON COLUMN sys_dict_type.dict_type_name IS '字典类型名称';
COMMENT ON COLUMN sys_dict_type.dict_type_name_pinyin IS '字典类型名称首字母拼音';
COMMENT ON COLUMN sys_dict_type.dict_type_desc IS '字典类型描述';
COMMENT ON COLUMN sys_dict_type.status_flag IS '字典类型的状态：1-启用，2-禁用，参考 StatusEnum';
COMMENT ON COLUMN sys_dict_type.dict_type_sort IS '排序，带小数点';
COMMENT ON COLUMN sys_dict_type.version_flag IS '乐观锁';
COMMENT ON COLUMN sys_dict_type.del_flag IS '删除标记：Y-已删除，N-未删除';
COMMENT ON COLUMN sys_dict_type.create_time IS '创建时间';
COMMENT ON COLUMN sys_dict_type.create_user IS '创建人';
COMMENT ON COLUMN sys_dict_type.update_time IS '更新时间';
COMMENT ON COLUMN sys_dict_type.update_user IS '更新人';
COMMENT ON TABLE sys_dict_type IS '字典类型';

CREATE TABLE sys_file_business (
  file_business_id NUMBER(20,0) NOT NULL,
  business_code NVARCHAR2(255),
  business_id NUMBER(20,0),
  file_id NUMBER(20,0),
  download_count NUMBER(11,0),
  create_time DATE,
  create_user NUMBER(20,0),
  update_time DATE,
  update_user NUMBER(20,0),
   PRIMARY KEY (file_business_id)
);
COMMENT ON COLUMN sys_file_business.file_business_id IS '主键id';
COMMENT ON COLUMN sys_file_business.business_code IS '业务的编码，业务自定义';
COMMENT ON COLUMN sys_file_business.business_id IS '业务主键id';
COMMENT ON COLUMN sys_file_business.file_id IS '关联文件表的id';
COMMENT ON COLUMN sys_file_business.download_count IS '下载次数';
COMMENT ON COLUMN sys_file_business.create_time IS '创建时间';
COMMENT ON COLUMN sys_file_business.create_user IS '创建人';
COMMENT ON COLUMN sys_file_business.update_time IS '修改时间';
COMMENT ON COLUMN sys_file_business.update_user IS '修改人';
COMMENT ON TABLE sys_file_business IS '业务关联的文件';

CREATE TABLE sys_file_info (
  file_id NUMBER(20,0) NOT NULL,
  file_code NUMBER(20,0) NOT NULL,
  file_version NUMBER(11,0) NOT NULL,
  file_status NCHAR(1) NOT NULL,
  file_location NUMBER(4,0) NOT NULL,
  file_bucket NVARCHAR2(255) NOT NULL,
  file_origin_name NVARCHAR2(255) NOT NULL,
  file_suffix NVARCHAR2(255),
  file_size_kb NUMBER(20,0),
  file_size_info NVARCHAR2(255),
  file_object_name NVARCHAR2(255),
  file_path NVARCHAR2(255),
  secret_flag NCHAR(1),
  del_flag NCHAR(1) DEFAULT 'N' NOT NULL,
  create_time DATE,
  create_user NUMBER(20,0),
  update_time DATE,
  update_user NUMBER(20,0),
   PRIMARY KEY (file_id)
);
COMMENT ON COLUMN sys_file_info.file_id IS '文件主键id';
COMMENT ON COLUMN sys_file_info.file_code IS '文件编码，本号升级的依据，解决一个文件多个版本问题，多次上传文件编码不变';
COMMENT ON COLUMN sys_file_info.file_version IS '文件版本，从1开始';
COMMENT ON COLUMN sys_file_info.file_status IS '当前状态：0-历史版,1-最新版';
COMMENT ON COLUMN sys_file_info.file_location IS '文件存储位置：1-阿里云，2-腾讯云，3-minio，4-本地';
COMMENT ON COLUMN sys_file_info.file_bucket IS '文件仓库（文件夹）';
COMMENT ON COLUMN sys_file_info.file_origin_name IS '文件名称（上传时候的文件全名）';
COMMENT ON COLUMN sys_file_info.file_suffix IS '文件后缀，例如.txt';
COMMENT ON COLUMN sys_file_info.file_size_kb IS '文件大小kb为单位';
COMMENT ON COLUMN sys_file_info.file_size_info IS '文件大小信息，计算后的';
COMMENT ON COLUMN sys_file_info.file_object_name IS '存储到bucket中的名称，主键id+.后缀';
COMMENT ON COLUMN sys_file_info.file_path IS '存储路径';
COMMENT ON COLUMN sys_file_info.secret_flag IS '是否为机密文件，Y-是机密，N-不是机密';
COMMENT ON COLUMN sys_file_info.del_flag IS '是否删除：Y-被删除，N-未删除';
COMMENT ON COLUMN sys_file_info.create_time IS '创建时间';
COMMENT ON COLUMN sys_file_info.create_user IS '创建人';
COMMENT ON COLUMN sys_file_info.update_time IS '修改时间';
COMMENT ON COLUMN sys_file_info.update_user IS '修改人';
COMMENT ON TABLE sys_file_info IS '文件信息';

CREATE TABLE sys_file_storage (
  file_id NUMBER(20,0) NOT NULL,
  file_bytes BLOB,
   PRIMARY KEY (file_id)
);
COMMENT ON COLUMN sys_file_storage.file_id IS '文件主键id，关联file_info表的主键';
COMMENT ON COLUMN sys_file_storage.file_bytes IS '具体文件的字节信息';
COMMENT ON TABLE sys_file_storage IS '文件存储信息';

CREATE TABLE sys_group (
  group_id NUMBER(20,0) NOT NULL,
  group_biz_code NVARCHAR2(255),
  group_name NVARCHAR2(255),
  business_id NUMBER(20,0),
  user_id NUMBER(20,0),
  create_time DATE,
  create_user NUMBER(20,0),
  update_time DATE,
  update_user NUMBER(20,0),
   PRIMARY KEY (group_id)
);
COMMENT ON COLUMN sys_group.group_id IS '分组id';
COMMENT ON COLUMN sys_group.group_biz_code IS '所属业务类别，例如：PROJECT';
COMMENT ON COLUMN sys_group.group_name IS '分组名称';
COMMENT ON COLUMN sys_group.business_id IS '业务主键id';
COMMENT ON COLUMN sys_group.user_id IS '所属用户id';
COMMENT ON COLUMN sys_group.create_time IS '创建时间';
COMMENT ON COLUMN sys_group.create_user IS '创建人';
COMMENT ON COLUMN sys_group.update_time IS '更新时间';
COMMENT ON COLUMN sys_group.update_user IS '更新人';
COMMENT ON TABLE sys_group IS '业务分组';

CREATE TABLE sys_hr_org_approver (
  org_approver_id NUMBER(20,0) NOT NULL,
  org_approver_type NUMBER(4,0),
  org_id NUMBER(20,0),
  user_id NUMBER(20,0),
  create_time DATE,
  create_user NUMBER(20,0),
  update_time DATE,
  update_user NUMBER(20,0),
   PRIMARY KEY (org_approver_id)
);
COMMENT ON COLUMN sys_hr_org_approver.org_approver_id IS '主键id';
COMMENT ON COLUMN sys_hr_org_approver.org_approver_type IS '组织审批类型：1-负责人，2-部长，3-体系负责人，4-部门助理，5-资产助理（专员），6-考勤专员，7-HRBP，8-门禁员，9-办公账号员，10-转岗须知员';
COMMENT ON COLUMN sys_hr_org_approver.org_id IS '组织机构id';
COMMENT ON COLUMN sys_hr_org_approver.user_id IS '用户id';
COMMENT ON COLUMN sys_hr_org_approver.create_time IS '创建时间';
COMMENT ON COLUMN sys_hr_org_approver.create_user IS '创建人';
COMMENT ON COLUMN sys_hr_org_approver.update_time IS '更新时间';
COMMENT ON COLUMN sys_hr_org_approver.update_user IS '更新人';
COMMENT ON TABLE sys_hr_org_approver IS '组织机构审批人';

CREATE TABLE sys_hr_organization (
  org_id NUMBER(20,0) NOT NULL,
  org_parent_id NUMBER(20,0) NOT NULL,
  org_pids NVARCHAR2(500) NOT NULL,
  org_name NVARCHAR2(100) NOT NULL,
  org_short_name NVARCHAR2(100),
  org_code NVARCHAR2(50) NOT NULL,
  org_sort NUMBER NOT NULL,
  status_flag NUMBER(4,0) NOT NULL,
  org_type NUMBER(4,0),
  tax_no NVARCHAR2(30),
  remark NVARCHAR2(255),
  org_level NUMBER(11,0),
  master_org_id NVARCHAR2(100),
  master_org_parent_id NVARCHAR2(100),
  expand_field CLOB,
  version_flag NUMBER(20,0),
  del_flag NCHAR(1) DEFAULT 'N' NOT NULL,
  create_time DATE,
  create_user NUMBER(20,0),
  update_time DATE,
  update_user NUMBER(20,0),
  tenant_id NUMBER(20,0),
   PRIMARY KEY (org_id)
);
COMMENT ON COLUMN sys_hr_organization.org_id IS '主键';
COMMENT ON COLUMN sys_hr_organization.org_parent_id IS '父id，一级节点父id是-1';
COMMENT ON COLUMN sys_hr_organization.org_pids IS '父ids';
COMMENT ON COLUMN sys_hr_organization.org_name IS '组织名称';
COMMENT ON COLUMN sys_hr_organization.org_short_name IS '组织机构简称';
COMMENT ON COLUMN sys_hr_organization.org_code IS '组织编码';
COMMENT ON COLUMN sys_hr_organization.org_sort IS '排序';
COMMENT ON COLUMN sys_hr_organization.status_flag IS '状态：1-启用，2-禁用';
COMMENT ON COLUMN sys_hr_organization.org_type IS '组织机构类型：1-公司，2-部门';
COMMENT ON COLUMN sys_hr_organization.tax_no IS '税号';
COMMENT ON COLUMN sys_hr_organization.remark IS '描述';
COMMENT ON COLUMN sys_hr_organization.org_level IS '组织机构层级';
COMMENT ON COLUMN sys_hr_organization.master_org_id IS '对接外部主数据的机构id';
COMMENT ON COLUMN sys_hr_organization.master_org_parent_id IS '对接外部主数据的父级机构id';
COMMENT ON COLUMN sys_hr_organization.expand_field IS '拓展字段';
COMMENT ON COLUMN sys_hr_organization.version_flag IS '乐观锁';
COMMENT ON COLUMN sys_hr_organization.del_flag IS '删除标记：Y-已删除，N-未删除';
COMMENT ON COLUMN sys_hr_organization.create_time IS '创建时间';
COMMENT ON COLUMN sys_hr_organization.create_user IS '创建人';
COMMENT ON COLUMN sys_hr_organization.update_time IS '更新时间';
COMMENT ON COLUMN sys_hr_organization.update_user IS '更新人';
COMMENT ON COLUMN sys_hr_organization.tenant_id IS '租户号';
COMMENT ON TABLE sys_hr_organization IS '组织机构信息';

CREATE TABLE sys_hr_position (
  position_id NUMBER(20,0) NOT NULL,
  position_name NVARCHAR2(100) NOT NULL,
  position_code NVARCHAR2(100) NOT NULL,
  position_sort NUMBER NOT NULL,
  status_flag NUMBER(4,0) NOT NULL,
  remark NVARCHAR2(255),
  expand_field CLOB,
  version_flag NUMBER(20,0),
  del_flag NCHAR(1) DEFAULT 'N' NOT NULL,
  create_time DATE,
  create_user NUMBER(20,0),
  update_time DATE,
  update_user NUMBER(20,0),
  tenant_id NUMBER(20,0),
   PRIMARY KEY (position_id)
);
COMMENT ON COLUMN sys_hr_position.position_id IS '主键';
COMMENT ON COLUMN sys_hr_position.position_name IS '职位名称';
COMMENT ON COLUMN sys_hr_position.position_code IS '职位编码';
COMMENT ON COLUMN sys_hr_position.position_sort IS '排序';
COMMENT ON COLUMN sys_hr_position.status_flag IS '状态：1-启用，2-禁用';
COMMENT ON COLUMN sys_hr_position.remark IS '备注';
COMMENT ON COLUMN sys_hr_position.expand_field IS '拓展字段';
COMMENT ON COLUMN sys_hr_position.version_flag IS '乐观锁';
COMMENT ON COLUMN sys_hr_position.del_flag IS '删除标记：Y-已删除，N-未删除';
COMMENT ON COLUMN sys_hr_position.create_time IS '创建时间';
COMMENT ON COLUMN sys_hr_position.create_user IS '创建人';
COMMENT ON COLUMN sys_hr_position.update_time IS '更新时间';
COMMENT ON COLUMN sys_hr_position.update_user IS '更新人';
COMMENT ON COLUMN sys_hr_position.tenant_id IS '租户号';
COMMENT ON TABLE sys_hr_position IS '职位信息';

CREATE TABLE sys_log_api (
  log_id NUMBER(20,0) NOT NULL,
  log_content NVARCHAR2(255),
  app_name NVARCHAR2(255),
  request_url NVARCHAR2(255),
  request_params NCLOB,
  request_result NCLOB,
  server_ip NVARCHAR2(255),
  client_ip NVARCHAR2(255),
  user_id NUMBER(20,0),
  http_method NVARCHAR2(255),
  client_browser NVARCHAR2(255),
  client_os NVARCHAR2(255),
  create_time DATE,
  create_user NUMBER(20,0),
  update_time DATE,
  update_user NUMBER(20,0),
   PRIMARY KEY (log_id)
);
COMMENT ON COLUMN sys_log_api.log_id IS '主键';
COMMENT ON COLUMN sys_log_api.log_content IS '日志记录的内容';
COMMENT ON COLUMN sys_log_api.app_name IS '服务名称，一般为spring.application.name';
COMMENT ON COLUMN sys_log_api.request_url IS '当前用户请求的url';
COMMENT ON COLUMN sys_log_api.request_params IS 'http或方法的请求参数体';
COMMENT ON COLUMN sys_log_api.request_result IS 'http或方法的请求结果';
COMMENT ON COLUMN sys_log_api.server_ip IS '当前服务器的ip';
COMMENT ON COLUMN sys_log_api.client_ip IS '客户端的ip';
COMMENT ON COLUMN sys_log_api.user_id IS '用户id';
COMMENT ON COLUMN sys_log_api.http_method IS '请求http方法';
COMMENT ON COLUMN sys_log_api.client_browser IS '客户浏览器标识';
COMMENT ON COLUMN sys_log_api.client_os IS '客户操作系统';
COMMENT ON COLUMN sys_log_api.create_time IS '创建时间';
COMMENT ON COLUMN sys_log_api.create_user IS '创建人';
COMMENT ON COLUMN sys_log_api.update_time IS '修改时间';
COMMENT ON COLUMN sys_log_api.update_user IS '修改人';
COMMENT ON TABLE sys_log_api IS 'API接口日志记录';

CREATE TABLE sys_log_business (
  business_log_id NUMBER(20,0) NOT NULL,
  log_type_code NVARCHAR2(255),
  log_title NVARCHAR2(255),
  request_url NVARCHAR2(255),
  http_method NVARCHAR2(255),
  client_ip NVARCHAR2(255),
  user_id NUMBER(20,0),
  create_time DATE,
  create_user NUMBER(20,0),
  update_time DATE,
  update_user NUMBER(20,0),
   PRIMARY KEY (business_log_id)
);
COMMENT ON COLUMN sys_log_business.business_log_id IS '主键';
COMMENT ON COLUMN sys_log_business.log_type_code IS '日志的业务分类的编码';
COMMENT ON COLUMN sys_log_business.log_title IS '日志的标题，摘要信息';
COMMENT ON COLUMN sys_log_business.request_url IS '当前用户请求的url';
COMMENT ON COLUMN sys_log_business.http_method IS '请求http方法';
COMMENT ON COLUMN sys_log_business.client_ip IS '客户端的ip';
COMMENT ON COLUMN sys_log_business.user_id IS '业务操作的用户id';
COMMENT ON COLUMN sys_log_business.create_time IS '创建时间';
COMMENT ON COLUMN sys_log_business.create_user IS '创建人';
COMMENT ON COLUMN sys_log_business.update_time IS '修改时间';
COMMENT ON COLUMN sys_log_business.update_user IS '修改人';
COMMENT ON TABLE sys_log_business IS '业务日志记录';

CREATE TABLE sys_log_business_content (
  content_id NUMBER(20,0) NOT NULL,
  business_log_id NUMBER(20,0),
  log_content NCLOB,
  create_time DATE,
  create_user NUMBER(20,0),
  update_time DATE,
  update_user NUMBER(20,0),
   PRIMARY KEY (content_id)
);
COMMENT ON COLUMN sys_log_business_content.content_id IS '主键';
COMMENT ON COLUMN sys_log_business_content.business_log_id IS '对应主表主键id';
COMMENT ON COLUMN sys_log_business_content.log_content IS '日志记录的内容';
COMMENT ON COLUMN sys_log_business_content.create_time IS '创建时间';
COMMENT ON COLUMN sys_log_business_content.create_user IS '创建人';
COMMENT ON COLUMN sys_log_business_content.update_time IS '修改时间';
COMMENT ON COLUMN sys_log_business_content.update_user IS '修改人';
COMMENT ON TABLE sys_log_business_content IS '业务日志记录';

CREATE TABLE sys_login_log (
  llg_id NUMBER(20,0) NOT NULL,
  llg_name NVARCHAR2(255),
  llg_succeed NVARCHAR2(255),
  llg_message NCLOB,
  llg_ip_address NVARCHAR2(255),
  user_id NUMBER(20,0),
  create_time DATE,
   PRIMARY KEY (llg_id)
);
COMMENT ON COLUMN sys_login_log.llg_id IS '主键';
COMMENT ON COLUMN sys_login_log.llg_name IS '日志名称';
COMMENT ON COLUMN sys_login_log.llg_succeed IS '是否执行成功';
COMMENT ON COLUMN sys_login_log.llg_message IS '具体消息';
COMMENT ON COLUMN sys_login_log.llg_ip_address IS '登录ip';
COMMENT ON COLUMN sys_login_log.user_id IS '用户id';
COMMENT ON COLUMN sys_login_log.create_time IS '创建时间';
COMMENT ON TABLE sys_login_log IS '登录记录';

CREATE TABLE sys_menu (
  menu_id NUMBER(20,0) NOT NULL,
  menu_parent_id NUMBER(20,0) NOT NULL,
  menu_pids NVARCHAR2(1000) NOT NULL,
  menu_name NVARCHAR2(100) NOT NULL,
  menu_code NVARCHAR2(50) NOT NULL,
  app_id NUMBER(20,0) NOT NULL,
  menu_sort NUMBER NOT NULL,
  status_flag NUMBER(4,0) NOT NULL,
  remark NVARCHAR2(255),
  menu_type NUMBER(4,0),
  antdv_router NVARCHAR2(255),
  antdv_component NVARCHAR2(255),
  antdv_icon NVARCHAR2(255),
  antdv_link_url NVARCHAR2(255),
  antdv_active_url NVARCHAR2(255),
  antdv_visible NCHAR(1),
  expand_field CLOB,
  version_flag NUMBER(20,0),
  del_flag NCHAR(1) DEFAULT 'N' NOT NULL,
  create_time DATE,
  create_user NUMBER(20,0),
  update_time DATE,
  update_user NUMBER(20,0),
   PRIMARY KEY (menu_id)
);
COMMENT ON COLUMN sys_menu.menu_id IS '主键';
COMMENT ON COLUMN sys_menu.menu_parent_id IS '父id，顶级节点的父id是-1';
COMMENT ON COLUMN sys_menu.menu_pids IS '父id集合，中括号包住，逗号分隔';
COMMENT ON COLUMN sys_menu.menu_name IS '菜单的名称';
COMMENT ON COLUMN sys_menu.menu_code IS '菜单的编码';
COMMENT ON COLUMN sys_menu.app_id IS '所属应用id';
COMMENT ON COLUMN sys_menu.menu_sort IS '排序';
COMMENT ON COLUMN sys_menu.status_flag IS '状态：1-启用，2-禁用';
COMMENT ON COLUMN sys_menu.remark IS '备注';
COMMENT ON COLUMN sys_menu.menu_type IS '菜单类型：10-后台菜单，20-纯前台路由界面，30-内部链接，40-外部链接';
COMMENT ON COLUMN sys_menu.antdv_router IS '路由地址，浏览器显示的URL，例如/menu';
COMMENT ON COLUMN sys_menu.antdv_component IS '前端组件名';
COMMENT ON COLUMN sys_menu.antdv_icon IS '图标编码';
COMMENT ON COLUMN sys_menu.antdv_link_url IS '外部链接地址';
COMMENT ON COLUMN sys_menu.antdv_active_url IS '用于非菜单显示页面的重定向url设置';
COMMENT ON COLUMN sys_menu.antdv_visible IS '是否可见(分离版用)：Y-是，N-否';
COMMENT ON COLUMN sys_menu.expand_field IS '拓展字段';
COMMENT ON COLUMN sys_menu.version_flag IS '乐观锁';
COMMENT ON COLUMN sys_menu.del_flag IS '删除标记：Y-已删除，N-未删除';
COMMENT ON COLUMN sys_menu.create_time IS '创建时间';
COMMENT ON COLUMN sys_menu.create_user IS '创建人';
COMMENT ON COLUMN sys_menu.update_time IS '更新时间';
COMMENT ON COLUMN sys_menu.update_user IS '更新人';
COMMENT ON TABLE sys_menu IS '系统菜单';

CREATE TABLE sys_menu_options (
  menu_option_id NUMBER(20,0) NOT NULL,
  app_id NUMBER(20,0),
  menu_id NUMBER(20,0) NOT NULL,
  option_name NVARCHAR2(100) NOT NULL,
  option_code NVARCHAR2(100) NOT NULL,
  create_time DATE,
  create_user NUMBER(20,0),
  update_time DATE,
  update_user NUMBER(20,0),
   PRIMARY KEY (menu_option_id)
);
COMMENT ON COLUMN sys_menu_options.menu_option_id IS '主键';
COMMENT ON COLUMN sys_menu_options.app_id IS '冗余字段，菜单所属的应用id';
COMMENT ON COLUMN sys_menu_options.menu_id IS '菜单id';
COMMENT ON COLUMN sys_menu_options.option_name IS '功能或操作的名称';
COMMENT ON COLUMN sys_menu_options.option_code IS '功能或操作的编码';
COMMENT ON COLUMN sys_menu_options.create_time IS '创建时间';
COMMENT ON COLUMN sys_menu_options.create_user IS '创建人';
COMMENT ON COLUMN sys_menu_options.update_time IS '修改时间';
COMMENT ON COLUMN sys_menu_options.update_user IS '修改人';
COMMENT ON TABLE sys_menu_options IS '菜单下的功能操作';

CREATE TABLE sys_message (
  message_id NUMBER(20,0) NOT NULL,
  receive_user_id NUMBER(20,0),
  send_user_id NUMBER(20,0),
  message_title NVARCHAR2(255),
  message_content NVARCHAR2(512),
  message_type NVARCHAR2(255),
  message_url NVARCHAR2(500),
  priority_level NVARCHAR2(50),
  message_send_time DATE,
  business_id NUMBER(20,0),
  business_type NVARCHAR2(255),
  read_flag NUMBER(4,0),
  del_flag NCHAR(1) DEFAULT 'N' NOT NULL,
  create_user NUMBER(20,0),
  create_time DATE,
  update_user NUMBER(20,0),
  update_time DATE,
   PRIMARY KEY (message_id)
);
COMMENT ON COLUMN sys_message.message_id IS '主键';
COMMENT ON COLUMN sys_message.receive_user_id IS '接收用户id';
COMMENT ON COLUMN sys_message.send_user_id IS '发送用户id';
COMMENT ON COLUMN sys_message.message_title IS '消息标题';
COMMENT ON COLUMN sys_message.message_content IS '消息内容';
COMMENT ON COLUMN sys_message.message_type IS '消息类型';
COMMENT ON COLUMN sys_message.message_url IS '消息跳转的URL';
COMMENT ON COLUMN sys_message.priority_level IS '优先级';
COMMENT ON COLUMN sys_message.message_send_time IS '消息发送时间';
COMMENT ON COLUMN sys_message.business_id IS '业务id';
COMMENT ON COLUMN sys_message.business_type IS '业务类型(根据业务id和业务类型可以确定业务数据)';
COMMENT ON COLUMN sys_message.read_flag IS '阅读状态：0-未读，1-已读';
COMMENT ON COLUMN sys_message.del_flag IS '是否删除：Y-被删除，N-未删除';
COMMENT ON COLUMN sys_message.create_user IS '创建人';
COMMENT ON COLUMN sys_message.create_time IS '创建时间';
COMMENT ON COLUMN sys_message.update_user IS '修改人';
COMMENT ON COLUMN sys_message.update_time IS '修改时间';
COMMENT ON TABLE sys_message IS '系统消息';

CREATE TABLE sys_notice (
  notice_id NUMBER(20,0) NOT NULL,
  notice_title NVARCHAR2(255),
  notice_summary NVARCHAR2(255),
  notice_content NVARCHAR2(512),
  priority_level NVARCHAR2(255),
  notice_begin_time DATE,
  notice_end_time DATE,
  notice_scope NCLOB,
  del_flag NCHAR(1) DEFAULT 'N' NOT NULL,
  create_user NUMBER(20,0),
  create_time DATE,
  update_user NUMBER(20,0),
  update_time DATE,
   PRIMARY KEY (notice_id)
);
COMMENT ON COLUMN sys_notice.notice_id IS '主键';
COMMENT ON COLUMN sys_notice.notice_title IS '通知标题';
COMMENT ON COLUMN sys_notice.notice_summary IS '通知摘要';
COMMENT ON COLUMN sys_notice.notice_content IS '通知内容';
COMMENT ON COLUMN sys_notice.priority_level IS '优先级';
COMMENT ON COLUMN sys_notice.notice_begin_time IS '开始时间';
COMMENT ON COLUMN sys_notice.notice_end_time IS '结束时间';
COMMENT ON COLUMN sys_notice.notice_scope IS '通知范围（用户id字符串）';
COMMENT ON COLUMN sys_notice.del_flag IS '是否删除：Y-被删除，N-未删除';
COMMENT ON COLUMN sys_notice.create_user IS '创建人';
COMMENT ON COLUMN sys_notice.create_time IS '创建时间';
COMMENT ON COLUMN sys_notice.update_user IS '修改人';
COMMENT ON COLUMN sys_notice.update_time IS '修改时间';
COMMENT ON TABLE sys_notice IS '通知管理';

CREATE TABLE sys_portal_user_app (
  app_link_id NUMBER(20,0) NOT NULL,
  user_id NUMBER(20,0),
  app_id NUMBER(20,0),
  menu_id NUMBER(20,0),
  create_time DATE,
  create_user NUMBER(20,0),
  update_time DATE,
  update_user NUMBER(20,0),
   PRIMARY KEY (app_link_id)
);
COMMENT ON COLUMN sys_portal_user_app.app_link_id IS '主键id';
COMMENT ON COLUMN sys_portal_user_app.user_id IS '所属用户id';
COMMENT ON COLUMN sys_portal_user_app.app_id IS '冗余字段，菜单所属的应用id';
COMMENT ON COLUMN sys_portal_user_app.menu_id IS '关联的菜单id';
COMMENT ON COLUMN sys_portal_user_app.create_time IS '创建时间';
COMMENT ON COLUMN sys_portal_user_app.create_user IS '创建人';
COMMENT ON COLUMN sys_portal_user_app.update_time IS '修改时间';
COMMENT ON COLUMN sys_portal_user_app.update_user IS '修改人';
COMMENT ON TABLE sys_portal_user_app IS '用户常用功能';

CREATE TABLE sys_resource (
  resource_id NUMBER(20,0) NOT NULL,
  app_code NVARCHAR2(100),
  resource_code NVARCHAR2(300) NOT NULL,
  resource_name NVARCHAR2(300) NOT NULL,
  project_code NVARCHAR2(64),
  class_name NVARCHAR2(100),
  method_name NVARCHAR2(100),
  modular_code NVARCHAR2(100),
  modular_name NVARCHAR2(100),
  ip_address NVARCHAR2(255),
  view_flag NCHAR(1),
  url NVARCHAR2(300),
  http_method NVARCHAR2(10),
  resource_biz_type NUMBER(4,0),
  required_login_flag NCHAR(1),
  required_permission_flag NCHAR(1),
  permission_code NVARCHAR2(255),
  validate_groups NCLOB,
  param_field_descriptions NCLOB,
  response_field_descriptions NCLOB,
  create_user NUMBER(20,0),
  create_time DATE,
  update_user NUMBER(20,0),
  update_time DATE,
   PRIMARY KEY (resource_id)
);
CREATE INDEX RESOURCE_CODE_URL
  ON sys_resource (resource_code, url);
COMMENT ON COLUMN sys_resource.resource_id IS '资源id';
COMMENT ON COLUMN sys_resource.app_code IS '应用编码';
COMMENT ON COLUMN sys_resource.resource_code IS '资源编码';
COMMENT ON COLUMN sys_resource.resource_name IS '资源名称';
COMMENT ON COLUMN sys_resource.project_code IS '项目编码，一般为spring.application.name';
COMMENT ON COLUMN sys_resource.class_name IS '类名称';
COMMENT ON COLUMN sys_resource.method_name IS '方法名称';
COMMENT ON COLUMN sys_resource.modular_code IS '资源模块编码，一般为控制器类名排除Controller';
COMMENT ON COLUMN sys_resource.modular_name IS '资源模块名称，一般为控制器名称';
COMMENT ON COLUMN sys_resource.ip_address IS '资源初始化的服务器ip地址';
COMMENT ON COLUMN sys_resource.view_flag IS '是否是视图类型：Y-是，N-否
如果是视图类型，url需要以 ''/view'' 开头，
视图类型的接口会渲染出html界面，而不是json数据，
视图层一般会在前后端不分离项目出现';
COMMENT ON COLUMN sys_resource.url IS '资源url';
COMMENT ON COLUMN sys_resource.http_method IS 'http请求方法';
COMMENT ON COLUMN sys_resource.resource_biz_type IS '资源的业务类型：1-业务类，2-系统类';
COMMENT ON COLUMN sys_resource.required_login_flag IS '是否需要登录：Y-是，N-否';
COMMENT ON COLUMN sys_resource.required_permission_flag IS '是否需要鉴权：Y-是，N-否';
COMMENT ON COLUMN sys_resource.permission_code IS '需要鉴权的菜单或者功能编码';
COMMENT ON COLUMN sys_resource.validate_groups IS '需要进行参数校验的分组';
COMMENT ON COLUMN sys_resource.param_field_descriptions IS '接口参数的字段描述';
COMMENT ON COLUMN sys_resource.response_field_descriptions IS '接口返回结果的字段描述';
COMMENT ON COLUMN sys_resource.create_user IS '创建人';
COMMENT ON COLUMN sys_resource.create_time IS '创建时间';
COMMENT ON COLUMN sys_resource.update_user IS '更新人';
COMMENT ON COLUMN sys_resource.update_time IS '更新时间';
COMMENT ON TABLE sys_resource IS '资源';

CREATE TABLE sys_role (
  role_id NUMBER(20,0) NOT NULL,
  role_name NVARCHAR2(100) NOT NULL,
  role_code NVARCHAR2(100) NOT NULL,
  role_sort NUMBER NOT NULL,
  data_scope_type NUMBER(4,0) NOT NULL,
  status_flag NUMBER(4,0) NOT NULL,
  remark NVARCHAR2(255),
  role_system_flag NCHAR(1) NOT NULL,
  expand_field CLOB,
  version_flag NUMBER(20,0),
  del_flag NCHAR(1) DEFAULT 'N' NOT NULL,
  create_time DATE,
  create_user NUMBER(20,0),
  update_time DATE,
  update_user NUMBER(20,0),
  tenant_id NUMBER(20,0),
   PRIMARY KEY (role_id)
);
COMMENT ON COLUMN sys_role.role_id IS '主键id';
COMMENT ON COLUMN sys_role.role_name IS '角色名称';
COMMENT ON COLUMN sys_role.role_code IS '角色编码';
COMMENT ON COLUMN sys_role.role_sort IS '序号';
COMMENT ON COLUMN sys_role.data_scope_type IS '数据范围类型：10-仅本人数据，20-本部门数据，30-本部门及以下数据，40-指定部门数据，50-全部数据';
COMMENT ON COLUMN sys_role.status_flag IS '状态：1-启用，2-禁用';
COMMENT ON COLUMN sys_role.remark IS '备注';
COMMENT ON COLUMN sys_role.role_system_flag IS '是否是系统角色：Y-是，N-否。系统角色不能删除';
COMMENT ON COLUMN sys_role.expand_field IS '拓展字段';
COMMENT ON COLUMN sys_role.version_flag IS '乐观锁';
COMMENT ON COLUMN sys_role.del_flag IS '删除标记：Y-已删除，N-未删除';
COMMENT ON COLUMN sys_role.create_time IS '创建时间';
COMMENT ON COLUMN sys_role.create_user IS '创建人';
COMMENT ON COLUMN sys_role.update_time IS '更新时间';
COMMENT ON COLUMN sys_role.update_user IS '更新人';
COMMENT ON COLUMN sys_role.tenant_id IS '租户号';
COMMENT ON TABLE sys_role IS '系统角色';

CREATE TABLE sys_role_data_scope (
  role_data_scope_id NUMBER(20,0) NOT NULL,
  role_id NUMBER(20,0) NOT NULL,
  organization_id NUMBER(20,0) NOT NULL,
  create_time DATE,
  create_user NUMBER(20,0),
  update_time DATE,
  update_user NUMBER(20,0),
   PRIMARY KEY (role_data_scope_id)
);
COMMENT ON COLUMN sys_role_data_scope.role_data_scope_id IS '主键';
COMMENT ON COLUMN sys_role_data_scope.role_id IS '角色id';
COMMENT ON COLUMN sys_role_data_scope.organization_id IS '机构id';
COMMENT ON COLUMN sys_role_data_scope.create_time IS '创建时间';
COMMENT ON COLUMN sys_role_data_scope.create_user IS '创建人';
COMMENT ON COLUMN sys_role_data_scope.update_time IS '修改时间';
COMMENT ON COLUMN sys_role_data_scope.update_user IS '修改人';
COMMENT ON TABLE sys_role_data_scope IS '角色数据范围';

CREATE TABLE sys_role_limit (
  role_limit_id NUMBER(20,0) NOT NULL,
  role_id NUMBER(20,0) NOT NULL,
  limit_type NUMBER(4,0) NOT NULL,
  business_id NUMBER(20,0) NOT NULL,
  create_time DATE,
  create_user NUMBER(20,0),
  update_time DATE,
  update_user NUMBER(20,0),
   PRIMARY KEY (role_limit_id)
);
COMMENT ON COLUMN sys_role_limit.role_limit_id IS '主键';
COMMENT ON COLUMN sys_role_limit.role_id IS '角色id';
COMMENT ON COLUMN sys_role_limit.limit_type IS '角色限制类型：1-角色可分配的菜单，2-角色可分配的功能';
COMMENT ON COLUMN sys_role_limit.business_id IS '业务id，为菜单id或菜单功能id';
COMMENT ON COLUMN sys_role_limit.create_time IS '创建时间';
COMMENT ON COLUMN sys_role_limit.create_user IS '创建人';
COMMENT ON COLUMN sys_role_limit.update_time IS '修改时间';
COMMENT ON COLUMN sys_role_limit.update_user IS '修改人';
COMMENT ON TABLE sys_role_limit IS '角色权限限制';

CREATE TABLE sys_role_menu (
  role_menu_id NUMBER(20,0) NOT NULL,
  role_id NUMBER(20,0) NOT NULL,
  app_id NUMBER(20,0),
  menu_id NUMBER(20,0) NOT NULL,
  create_time DATE,
  create_user NUMBER(20,0),
  update_time DATE,
  update_user NUMBER(20,0),
   PRIMARY KEY (role_menu_id)
);
COMMENT ON COLUMN sys_role_menu.role_menu_id IS '主键';
COMMENT ON COLUMN sys_role_menu.role_id IS '角色id';
COMMENT ON COLUMN sys_role_menu.app_id IS '冗余字段，菜单所属的应用id';
COMMENT ON COLUMN sys_role_menu.menu_id IS '菜单id';
COMMENT ON COLUMN sys_role_menu.create_time IS '创建时间';
COMMENT ON COLUMN sys_role_menu.create_user IS '创建人';
COMMENT ON COLUMN sys_role_menu.update_time IS '修改时间';
COMMENT ON COLUMN sys_role_menu.update_user IS '修改人';
COMMENT ON TABLE sys_role_menu IS '角色菜单关联';

CREATE TABLE sys_role_menu_options (
  role_menu_option_id NUMBER(20,0) NOT NULL,
  role_id NUMBER(20,0) NOT NULL,
  app_id NUMBER(20,0),
  menu_id NUMBER(20,0),
  menu_option_id NUMBER(20,0) NOT NULL,
  create_time DATE,
  create_user NUMBER(20,0),
  update_time DATE,
  update_user NUMBER(20,0),
   PRIMARY KEY (role_menu_option_id)
);
COMMENT ON COLUMN sys_role_menu_options.role_menu_option_id IS '主键';
COMMENT ON COLUMN sys_role_menu_options.role_id IS '角色id';
COMMENT ON COLUMN sys_role_menu_options.app_id IS '冗余字段，菜单所属的应用id';
COMMENT ON COLUMN sys_role_menu_options.menu_id IS '冗余字段，功能所属的菜单id';
COMMENT ON COLUMN sys_role_menu_options.menu_option_id IS '菜单功能id，关联sys_menu_options主键id';
COMMENT ON COLUMN sys_role_menu_options.create_time IS '创建时间';
COMMENT ON COLUMN sys_role_menu_options.create_user IS '创建人';
COMMENT ON COLUMN sys_role_menu_options.update_time IS '修改时间';
COMMENT ON COLUMN sys_role_menu_options.update_user IS '修改人';
COMMENT ON TABLE sys_role_menu_options IS '角色和菜单下的功能关联';

CREATE TABLE sys_sms (
  sms_id NUMBER(20,0) NOT NULL,
  phone_number NVARCHAR2(11),
  validate_code NVARCHAR2(100),
  template_code NVARCHAR2(255),
  biz_id NVARCHAR2(20),
  status_flag NUMBER(4,0),
  source NUMBER(11,0),
  invalid_time DATE,
  create_time DATE,
  create_user NUMBER(20,0),
  update_time DATE,
  update_user NUMBER(20,0),
   PRIMARY KEY (sms_id)
);
COMMENT ON COLUMN sys_sms.sms_id IS '主键';
COMMENT ON COLUMN sys_sms.phone_number IS '手机号';
COMMENT ON COLUMN sys_sms.validate_code IS '短信验证码';
COMMENT ON COLUMN sys_sms.template_code IS '短信模板编号';
COMMENT ON COLUMN sys_sms.biz_id IS '业务id';
COMMENT ON COLUMN sys_sms.status_flag IS '发送状态：1-未发送，2-发送成功，3-发送失败，4-失效';
COMMENT ON COLUMN sys_sms.source IS '来源：1-app，2-pc，3-其他';
COMMENT ON COLUMN sys_sms.invalid_time IS '短信失效截止时间';
COMMENT ON COLUMN sys_sms.create_time IS '创建时间';
COMMENT ON COLUMN sys_sms.create_user IS '创建人';
COMMENT ON COLUMN sys_sms.update_time IS '修改时间';
COMMENT ON COLUMN sys_sms.update_user IS '修改人';
COMMENT ON TABLE sys_sms IS '短信发送记录';

CREATE TABLE sys_table_width (
  table_width_id NUMBER(20,0) NOT NULL,
  field_business_code NVARCHAR2(100) NOT NULL,
  field_type NUMBER(11,0) NOT NULL,
  user_id NUMBER(20,0),
  table_width_json NCLOB,
  create_time DATE,
  create_user NUMBER(20,0),
  update_time DATE,
  update_user NUMBER(20,0),
   PRIMARY KEY (table_width_id)
);
COMMENT ON COLUMN sys_table_width.table_width_id IS '主键id';
COMMENT ON COLUMN sys_table_width.field_business_code IS '业务标识的编码，例如：PROJECT_TABLE';
COMMENT ON COLUMN sys_table_width.field_type IS '宽度记录的类型：1-全体员工，2-个人独有';
COMMENT ON COLUMN sys_table_width.user_id IS '所属用户id';
COMMENT ON COLUMN sys_table_width.table_width_json IS '自定义列是否显示、宽度、顺序和列的锁定，一段json';
COMMENT ON COLUMN sys_table_width.create_time IS '创建时间';
COMMENT ON COLUMN sys_table_width.create_user IS '创建人';
COMMENT ON COLUMN sys_table_width.update_time IS '修改时间';
COMMENT ON COLUMN sys_table_width.update_user IS '修改人';
COMMENT ON TABLE sys_table_width IS '业务中表的宽度';

CREATE TABLE sys_theme (
  theme_id NUMBER(20,0) NOT NULL,
  theme_name NVARCHAR2(50) NOT NULL,
  theme_value NCLOB NOT NULL,
  template_id NUMBER(20,0) NOT NULL,
  status_flag NCHAR(1) NOT NULL,
  create_time DATE,
  create_user NUMBER(20,0),
  update_time DATE,
  update_user NUMBER(20,0),
   PRIMARY KEY (theme_id)
);
COMMENT ON COLUMN sys_theme.theme_id IS '主键';
COMMENT ON COLUMN sys_theme.theme_name IS '主题名称';
COMMENT ON COLUMN sys_theme.theme_value IS '主题属性，json格式';
COMMENT ON COLUMN sys_theme.template_id IS '主题模板id';
COMMENT ON COLUMN sys_theme.status_flag IS '是否启用：Y-启用，N-禁用';
COMMENT ON COLUMN sys_theme.create_time IS '创建时间';
COMMENT ON COLUMN sys_theme.create_user IS '创建人';
COMMENT ON COLUMN sys_theme.update_time IS '修改时间';
COMMENT ON COLUMN sys_theme.update_user IS '修改人';
COMMENT ON TABLE sys_theme IS '系统主题';

CREATE TABLE sys_theme_template (
  template_id NUMBER(20,0) NOT NULL,
  template_name NVARCHAR2(50) NOT NULL,
  template_code NVARCHAR2(40) NOT NULL,
  template_type NUMBER(4,0) NOT NULL,
  status_flag NCHAR(1) NOT NULL,
  create_time DATE,
  create_user NUMBER(20,0),
  update_time DATE,
  update_user NUMBER(20,0),
   PRIMARY KEY (template_id)
);
COMMENT ON COLUMN sys_theme_template.template_id IS '主键';
COMMENT ON COLUMN sys_theme_template.template_name IS '主题名称';
COMMENT ON COLUMN sys_theme_template.template_code IS '主题编码';
COMMENT ON COLUMN sys_theme_template.template_type IS '主题类型：1-系统类型，2-业务类型';
COMMENT ON COLUMN sys_theme_template.status_flag IS '启用状态：Y-启用，N-禁用';
COMMENT ON COLUMN sys_theme_template.create_time IS '创建时间';
COMMENT ON COLUMN sys_theme_template.create_user IS '创建人';
COMMENT ON COLUMN sys_theme_template.update_time IS '修改时间';
COMMENT ON COLUMN sys_theme_template.update_user IS '修改人';
COMMENT ON TABLE sys_theme_template IS '系统主题-模板';

CREATE TABLE sys_theme_template_field (
  field_id NUMBER(20,0) NOT NULL,
  field_name NVARCHAR2(50) NOT NULL,
  field_code NVARCHAR2(50) NOT NULL,
  field_type NVARCHAR2(100) NOT NULL,
  field_required NCHAR(1),
  field_length NUMBER(11,0),
  field_description NCLOB,
  create_time DATE,
  create_user NUMBER(20,0),
  update_time DATE,
  update_user NUMBER(20,0),
   PRIMARY KEY (field_id)
);
COMMENT ON COLUMN sys_theme_template_field.field_id IS '主键';
COMMENT ON COLUMN sys_theme_template_field.field_name IS '属性名称';
COMMENT ON COLUMN sys_theme_template_field.field_code IS '属性编码';
COMMENT ON COLUMN sys_theme_template_field.field_type IS '属性展示类型（字典维护），例如：图片，文本等类型';
COMMENT ON COLUMN sys_theme_template_field.field_required IS '是否必填：Y-必填，N-非必填';
COMMENT ON COLUMN sys_theme_template_field.field_length IS '属性值长度';
COMMENT ON COLUMN sys_theme_template_field.field_description IS '属性描述';
COMMENT ON COLUMN sys_theme_template_field.create_time IS '创建时间';
COMMENT ON COLUMN sys_theme_template_field.create_user IS '创建人';
COMMENT ON COLUMN sys_theme_template_field.update_time IS '修改时间';
COMMENT ON COLUMN sys_theme_template_field.update_user IS '修改人';
COMMENT ON TABLE sys_theme_template_field IS '系统主题-模板属性';

CREATE TABLE sys_theme_template_rel (
  relation_id NUMBER(20,0) NOT NULL,
  template_id NUMBER(20,0) NOT NULL,
  field_code NVARCHAR2(50) NOT NULL,
  create_time DATE,
  create_user NUMBER(20,0),
  update_time DATE,
  update_user NUMBER(20,0),
   PRIMARY KEY (relation_id)
);
COMMENT ON COLUMN sys_theme_template_rel.relation_id IS '主键';
COMMENT ON COLUMN sys_theme_template_rel.template_id IS '模板主键id';
COMMENT ON COLUMN sys_theme_template_rel.field_code IS '属性编码';
COMMENT ON COLUMN sys_theme_template_rel.create_time IS '创建时间';
COMMENT ON COLUMN sys_theme_template_rel.create_user IS '创建人';
COMMENT ON COLUMN sys_theme_template_rel.update_time IS '修改时间';
COMMENT ON COLUMN sys_theme_template_rel.update_user IS '修改人';
COMMENT ON TABLE sys_theme_template_rel IS '系统主题-模板配置关联关系';

CREATE TABLE sys_timers (
  timer_id NUMBER(20,0) NOT NULL,
  timer_name NVARCHAR2(255),
  action_class NVARCHAR2(255),
  cron NVARCHAR2(255),
  params NCLOB,
  job_status NUMBER(11,0),
  remark NVARCHAR2(255),
  del_flag NCHAR(1) DEFAULT 'N' NOT NULL,
  create_time DATE,
  create_user NUMBER(20,0),
  update_time DATE,
  update_user NUMBER(20,0),
  PRIMARY KEY (timer_id)
);
COMMENT ON COLUMN sys_timers.timer_id IS '定时器id';
COMMENT ON COLUMN sys_timers.timer_name IS '任务名称';
COMMENT ON COLUMN sys_timers.action_class IS '执行任务的class的类名（实现了TimerAction接口的类的全称）';
COMMENT ON COLUMN sys_timers.cron IS '定时任务表达式';
COMMENT ON COLUMN sys_timers.params IS '参数';
COMMENT ON COLUMN sys_timers.job_status IS '状态：1-运行，2-停止';
COMMENT ON COLUMN sys_timers.remark IS '备注信息';
COMMENT ON COLUMN sys_timers.del_flag IS '是否删除：Y-被删除，N-未删除';
COMMENT ON COLUMN sys_timers.create_time IS '创建时间';
COMMENT ON COLUMN sys_timers.create_user IS '创建人';
COMMENT ON COLUMN sys_timers.update_time IS '修改时间';
COMMENT ON COLUMN sys_timers.update_user IS '修改人';
COMMENT ON TABLE sys_timers IS '定时任务';

CREATE TABLE sys_toc_customer (
  customer_id NUMBER(20,0) NOT NULL,
  account NVARCHAR2(50) NOT NULL,
  password NVARCHAR2(100) NOT NULL,
  old_password NVARCHAR2(255),
  old_password_salt NVARCHAR2(255),
  nick_name NVARCHAR2(255) NOT NULL,
  email NVARCHAR2(100),
  telephone NVARCHAR2(30),
  verify_code NVARCHAR2(100),
  verified_flag NCHAR(1),
  avatar NUMBER(20,0),
  avatar_object_name NVARCHAR2(100),
  score NUMBER(11,0),
  status_flag NUMBER(4,0),
  secret_key NVARCHAR2(50),
  member_expire_time DATE,
  last_login_ip NVARCHAR2(100),
  last_login_time DATE,
  create_time DATE,
  create_user NUMBER(20,0),
  update_time DATE,
  update_user NUMBER(20,0),
  PRIMARY KEY (customer_id)
);
COMMENT ON COLUMN sys_toc_customer.customer_id IS '主键id';
COMMENT ON COLUMN sys_toc_customer.account IS '账号';
COMMENT ON COLUMN sys_toc_customer.password IS '密码，BCrypt';
COMMENT ON COLUMN sys_toc_customer.old_password IS '旧密码';
COMMENT ON COLUMN sys_toc_customer.old_password_salt IS '旧的密码盐';
COMMENT ON COLUMN sys_toc_customer.nick_name IS '昵称（显示名称）';
COMMENT ON COLUMN sys_toc_customer.email IS '邮箱';
COMMENT ON COLUMN sys_toc_customer.telephone IS '手机';
COMMENT ON COLUMN sys_toc_customer.verify_code IS '邮箱或手机验证码';
COMMENT ON COLUMN sys_toc_customer.verified_flag IS '是否已经邮箱或手机验证通过：Y-通过，N-未通过';
COMMENT ON COLUMN sys_toc_customer.avatar IS '用户头像（文件表id）';
COMMENT ON COLUMN sys_toc_customer.avatar_object_name IS '用户头像的文件全名';
COMMENT ON COLUMN sys_toc_customer.score IS '用户积分';
COMMENT ON COLUMN sys_toc_customer.status_flag IS '用户状态：1-启用，2-禁用';
COMMENT ON COLUMN sys_toc_customer.secret_key IS '用户秘钥，用在调用会员校验等';
COMMENT ON COLUMN sys_toc_customer.member_expire_time IS '会员截止日期，到期时间';
COMMENT ON COLUMN sys_toc_customer.last_login_ip IS '上次登录ip';
COMMENT ON COLUMN sys_toc_customer.last_login_time IS '上次登录时间';
COMMENT ON COLUMN sys_toc_customer.create_time IS '创建时间';
COMMENT ON COLUMN sys_toc_customer.create_user IS '创建人';
COMMENT ON COLUMN sys_toc_customer.update_time IS '更新时间';
COMMENT ON COLUMN sys_toc_customer.update_user IS '更新人';
COMMENT ON TABLE sys_toc_customer IS 'C端用户表';

CREATE TABLE sys_translation (
  tran_id NUMBER(20,0) NOT NULL,
  tran_code NVARCHAR2(255) NOT NULL,
  tran_name NVARCHAR2(255) NOT NULL,
  tran_language_code NVARCHAR2(255) NOT NULL,
  tran_value NVARCHAR2(255) NOT NULL,
  create_time DATE,
  create_user NUMBER(20,0),
  update_time DATE,
  update_user NUMBER(20,0),
  PRIMARY KEY (tran_id)
);
COMMENT ON COLUMN sys_translation.tran_id IS '主键id';
COMMENT ON COLUMN sys_translation.tran_code IS '编码';
COMMENT ON COLUMN sys_translation.tran_name IS '多语言条例名称';
COMMENT ON COLUMN sys_translation.tran_language_code IS '语种字典';
COMMENT ON COLUMN sys_translation.tran_value IS '翻译的值';
COMMENT ON COLUMN sys_translation.create_time IS '创建时间';
COMMENT ON COLUMN sys_translation.create_user IS '创建人';
COMMENT ON COLUMN sys_translation.update_time IS '更新时间';
COMMENT ON COLUMN sys_translation.update_user IS '更新人';
COMMENT ON TABLE sys_translation IS '多语言';

CREATE TABLE sys_user (
  user_id NUMBER(20,0) NOT NULL,
  real_name NVARCHAR2(100),
  nick_name NVARCHAR2(50),
  account NVARCHAR2(50) NOT NULL,
  password NVARCHAR2(100) NOT NULL,
  password_salt NVARCHAR2(10),
  avatar NUMBER(20,0),
  birthday DATE,
  sex NCHAR(1) NOT NULL,
  email NVARCHAR2(50),
  phone NVARCHAR2(50),
  tel NVARCHAR2(50),
  super_admin_flag NCHAR(1) NOT NULL,
  status_flag NUMBER(4,0) NOT NULL,
  login_count NUMBER(11,0),
  last_login_ip NVARCHAR2(100),
  last_login_time DATE,
  user_sort NUMBER,
  master_user_id NVARCHAR2(100),
  expand_field CLOB,
  version_flag NUMBER(20,0),
  del_flag NCHAR(1) DEFAULT 'N' NOT NULL,
  create_time DATE,
  create_user NUMBER(20,0),
  update_time DATE,
  update_user NUMBER(20,0),
  tenant_id NUMBER(20,0),
  PRIMARY KEY (user_id)
);
COMMENT ON COLUMN sys_user.user_id IS '主键';
COMMENT ON COLUMN sys_user.real_name IS '姓名';
COMMENT ON COLUMN sys_user.nick_name IS '昵称';
COMMENT ON COLUMN sys_user.account IS '账号';
COMMENT ON COLUMN sys_user.password IS '密码，加密方式为MD5';
COMMENT ON COLUMN sys_user.password_salt IS '密码盐';
COMMENT ON COLUMN sys_user.avatar IS '头像，存的为文件id';
COMMENT ON COLUMN sys_user.birthday IS '生日';
COMMENT ON COLUMN sys_user.sex IS '性别：M-男，F-女';
COMMENT ON COLUMN sys_user.email IS '邮箱';
COMMENT ON COLUMN sys_user.phone IS '手机';
COMMENT ON COLUMN sys_user.tel IS '电话';
COMMENT ON COLUMN sys_user.super_admin_flag IS '是否是超级管理员：Y-是，N-否';
COMMENT ON COLUMN sys_user.status_flag IS '状态：1-正常，2-冻结';
COMMENT ON COLUMN sys_user.login_count IS '登录次数';
COMMENT ON COLUMN sys_user.last_login_ip IS '最后登陆IP';
COMMENT ON COLUMN sys_user.last_login_time IS '最后登陆时间';
COMMENT ON COLUMN sys_user.user_sort IS '用户的排序';
COMMENT ON COLUMN sys_user.master_user_id IS '对接外部主数据的用户id';
COMMENT ON COLUMN sys_user.expand_field IS '拓展字段';
COMMENT ON COLUMN sys_user.version_flag IS '乐观锁';
COMMENT ON COLUMN sys_user.del_flag IS '删除标记：Y-已删除，N-未删除';
COMMENT ON COLUMN sys_user.create_time IS '创建时间';
COMMENT ON COLUMN sys_user.create_user IS '创建人';
COMMENT ON COLUMN sys_user.update_time IS '更新时间';
COMMENT ON COLUMN sys_user.update_user IS '更新人';
COMMENT ON COLUMN sys_user.tenant_id IS '租户号';
COMMENT ON TABLE sys_user IS '系统用户';

CREATE TABLE sys_user_data_scope (
  user_data_scope_id NUMBER(20,0) NOT NULL,
  user_id NUMBER(20,0) NOT NULL,
  org_id NUMBER(20,0) NOT NULL,
  create_time DATE,
  create_user NUMBER(20,0),
  update_time DATE,
  update_user NUMBER(20,0),
  PRIMARY KEY (user_data_scope_id)
);
COMMENT ON COLUMN sys_user_data_scope.user_data_scope_id IS '主键';
COMMENT ON COLUMN sys_user_data_scope.user_id IS '用户id';
COMMENT ON COLUMN sys_user_data_scope.org_id IS '机构id';
COMMENT ON COLUMN sys_user_data_scope.create_time IS '创建时间';
COMMENT ON COLUMN sys_user_data_scope.create_user IS '创建人';
COMMENT ON COLUMN sys_user_data_scope.update_time IS '修改时间';
COMMENT ON COLUMN sys_user_data_scope.update_user IS '修改人';
COMMENT ON TABLE sys_user_data_scope IS '用户数据范围';

CREATE TABLE sys_user_group (
  user_group_id NUMBER(20,0) NOT NULL,
  user_group_title NVARCHAR2(100),
  user_group_detail_name NCLOB,
  create_user NUMBER(20,0),
  create_time DATE,
  update_user NUMBER(20,0),
  update_time DATE,
  PRIMARY KEY (user_group_id)
);
COMMENT ON COLUMN sys_user_group.user_group_id IS '用户组id';
COMMENT ON COLUMN sys_user_group.user_group_title IS '用户分组标题简称';
COMMENT ON COLUMN sys_user_group.user_group_detail_name IS '组内选择项的合并';
COMMENT ON COLUMN sys_user_group.create_user IS '创建人';
COMMENT ON COLUMN sys_user_group.create_time IS '创建时间';
COMMENT ON COLUMN sys_user_group.update_user IS '更新人';
COMMENT ON COLUMN sys_user_group.update_time IS '更新时间';
COMMENT ON TABLE sys_user_group IS '用户组';

CREATE TABLE sys_user_group_detail (
  detail_id NUMBER(20,0) NOT NULL,
  user_group_id NUMBER(20,0),
  select_type NUMBER(4,0),
  select_value NUMBER(20,0),
  select_value_name NVARCHAR2(255),
  create_user NUMBER(20,0),
  create_time DATE,
  update_user NUMBER(20,0),
  update_time DATE,
  PRIMARY KEY (detail_id)
);
COMMENT ON COLUMN sys_user_group_detail.detail_id IS '详情id';
COMMENT ON COLUMN sys_user_group_detail.user_group_id IS '所属用户组id';
COMMENT ON COLUMN sys_user_group_detail.select_type IS '授权对象类型：1-用户，2-部门，3-角色，4-职位，5-关系';
COMMENT ON COLUMN sys_user_group_detail.select_value IS '授权对象id值，例如：用户id，部门id';
COMMENT ON COLUMN sys_user_group_detail.select_value_name IS '授权对象名称，例如：张三，研发部，管理员等';
COMMENT ON COLUMN sys_user_group_detail.create_user IS '创建人';
COMMENT ON COLUMN sys_user_group_detail.create_time IS '创建时间';
COMMENT ON COLUMN sys_user_group_detail.update_user IS '更新人';
COMMENT ON COLUMN sys_user_group_detail.update_time IS '更新时间';
COMMENT ON TABLE sys_user_group_detail IS '用户组详情';

CREATE TABLE sys_user_org (
  user_org_id NUMBER(20,0) NOT NULL,
  user_id NUMBER(20,0) NOT NULL,
  master_user_id NVARCHAR2(100),
  org_id NUMBER(20,0) NOT NULL,
  master_org_id NVARCHAR2(100),
  position_id NUMBER(20,0),
  main_flag NCHAR(1) NOT NULL,
  expand_field CLOB,
  create_time DATE,
  create_user NUMBER(20,0),
  update_time DATE,
  update_user NUMBER(20,0),
  PRIMARY KEY (user_org_id)
);
COMMENT ON COLUMN sys_user_org.user_org_id IS '企业员工主键id';
COMMENT ON COLUMN sys_user_org.user_id IS '用户id';
COMMENT ON COLUMN sys_user_org.master_user_id IS '对接外部主数据的用户id';
COMMENT ON COLUMN sys_user_org.org_id IS '所属机构id';
COMMENT ON COLUMN sys_user_org.master_org_id IS '对接外部组织机构id';
COMMENT ON COLUMN sys_user_org.position_id IS '职位id';
COMMENT ON COLUMN sys_user_org.main_flag IS '是否是主部门：Y-是，N-不是';
COMMENT ON COLUMN sys_user_org.expand_field IS '拓展字段';
COMMENT ON COLUMN sys_user_org.create_time IS '添加时间';
COMMENT ON COLUMN sys_user_org.create_user IS '添加人';
COMMENT ON COLUMN sys_user_org.update_time IS '更新时间';
COMMENT ON COLUMN sys_user_org.update_user IS '更新人';
COMMENT ON TABLE sys_user_org IS '用户组织机构关联';

CREATE TABLE sys_user_role (
  user_role_id NUMBER(20,0) NOT NULL,
  user_id NUMBER(20,0) NOT NULL,
  role_id NUMBER(20,0) NOT NULL,
  create_time DATE,
  create_user NUMBER(20,0),
  update_time DATE,
  update_user NUMBER(20,0),
  PRIMARY KEY (user_role_id)
);
COMMENT ON COLUMN sys_user_role.user_role_id IS '主键';
COMMENT ON COLUMN sys_user_role.user_id IS '用户id';
COMMENT ON COLUMN sys_user_role.role_id IS '角色id';
COMMENT ON COLUMN sys_user_role.create_time IS '创建时间';
COMMENT ON COLUMN sys_user_role.create_user IS '创建人';
COMMENT ON COLUMN sys_user_role.update_time IS '修改时间';
COMMENT ON COLUMN sys_user_role.update_user IS '修改人';
COMMENT ON TABLE sys_user_role IS '用户角色关联';

CREATE TABLE sys_user_password_record (
  record_id NUMBER(20,0) NOT NULL,
  user_id NUMBER(20,0) NOT NULL,
  history_password NVARCHAR2(100),
  history_password_salt NVARCHAR2(10),
  update_password_time DATE,
  create_time DATE,
  create_user NUMBER(20,0),
  update_time DATE,
  update_user NUMBER(20,0),
  PRIMARY KEY (record_id)
);
COMMENT ON COLUMN sys_user_password_record.record_id IS '主键';
COMMENT ON COLUMN sys_user_password_record.user_id IS '用户id';
COMMENT ON COLUMN sys_user_password_record.history_password IS '历史密码记录';
COMMENT ON COLUMN sys_user_password_record.history_password_salt IS '历史密码记录盐值';
COMMENT ON COLUMN sys_user_password_record.update_password_time IS '修改密码时间';
COMMENT ON COLUMN sys_user_password_record.create_time IS '创建时间';
COMMENT ON COLUMN sys_user_password_record.create_user IS '创建人';
COMMENT ON COLUMN sys_user_password_record.update_time IS '修改时间';
COMMENT ON COLUMN sys_user_password_record.update_user IS '修改人';
COMMENT ON TABLE sys_user_password_record IS '用户历史密码记录';

INSERT INTO SYS_APP VALUES ('1671406669800796161', '门户应用', 'portal', '1673705057339625474', '1', '100', '前台门户应用，包含个人信息、常用应用等界面', NULL, '1', 'N', TO_DATE('2023-06-21 14:37:38', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, NULL);
INSERT INTO SYS_APP VALUES ('1671406745336016898', '后台管理', 'system_manager', '1673705057339625478', '1', '200', '系统后台管理应用，包含组织架构维护、权限配置等界面', NULL, '1', 'N', TO_DATE('2023-06-21 14:38:35', 'SYYYY-MM-DD HH24:MI:SS'), NULL, NULL, NULL);

INSERT INTO SYS_CONFIG VALUES ('1', '系统配置是否已经初始化的标识', 'SYS_CONFIG_INIT_FLAG', 'false', 'Y', NULL, '1', 'sys_config', 'N', NULL, NULL, TO_DATE('2023-05-11 11:10:28', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');
INSERT INTO SYS_CONFIG VALUES ('4', 'Linux本地文件保存路径', 'SYS_LOCAL_FILE_SAVE_PATH_LINUX', '/tmp/tempFilePath', 'Y', NULL, '1', 'file_config', 'N', NULL, NULL, TO_DATE('2023-05-11 11:10:28', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');
INSERT INTO SYS_CONFIG VALUES ('5', 'Windows本地文件保存路径', 'SYS_LOCAL_FILE_SAVE_PATH_WINDOWS', 'D:\tempFilePath', 'Y', NULL, '1', 'file_config', 'N', NULL, NULL, TO_DATE('2023-05-11 11:10:28', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');
INSERT INTO SYS_CONFIG VALUES ('6', '不需要过滤的url', 'SYS_NONE_SECURITY_URLS', '/assets/**,/login,/swagger-ui.html,/favicon.ico,/swagger-ui/**,/error,/webSocket/*,/guns-devops/**,', 'Y', NULL, '1', 'sys_config', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_CONFIG VALUES ('8', 'session过期时间', 'SYS_SESSION_EXPIRED_SECONDS', '3600', 'Y', NULL, '1', 'auth_config', 'N', NULL, NULL, TO_DATE('2023-05-11 11:10:28', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');
INSERT INTO SYS_CONFIG VALUES ('9', '账号单端登录限制', 'SYS_SINGLE_ACCOUNT_LOGIN_FLAG', 'false', 'Y', NULL, '1', 'auth_config', 'N', NULL, NULL, TO_DATE('2023-05-11 11:10:28', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');
INSERT INTO SYS_CONFIG VALUES ('12', '系统默认密码', 'SYS_DEFAULT_PASSWORD', '123456', 'Y', NULL, '1', 'auth_config', 'N', NULL, NULL, TO_DATE('2023-05-11 11:10:28', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');
INSERT INTO SYS_CONFIG VALUES ('21', '系统发布版本', 'SYS_RELEASE_VERSION', '20230511', 'Y', NULL, '1', 'sys_config', 'N', NULL, NULL, TO_DATE('2023-05-11 11:10:28', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');
INSERT INTO SYS_CONFIG VALUES ('22', '多租户开关', 'SYS_TENANT_OPEN', 'false', 'Y', NULL, '1', 'sys_config', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_CONFIG VALUES ('23', '验证码开关', 'SYS_CAPTCHA_OPEN', 'false', 'Y', NULL, '1', 'sys_config', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_CONFIG VALUES ('29', '获取文件生成auth url的失效时间', 'SYS_DEFAULT_FILE_TIMEOUT_SECONDS', '3600', 'Y', NULL, '1', 'file_config', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_CONFIG VALUES ('30', '服务默认部署的环境地址', 'SYS_SERVER_DEPLOY_HOST', 'http://localhost:8080', 'Y', '主要用来生成文件的访问URL', '1', 'file_config', 'N', NULL, NULL, TO_DATE('2023-05-11 11:10:28', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');
INSERT INTO SYS_CONFIG VALUES ('32', '用于auth模块权限校验的jwt失效时间', 'SYS_AUTH_JWT_TIMEOUT_SECONDS', '604800', 'Y', NULL, '1', 'auth_config', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_CONFIG VALUES ('33', 'Druid监控界面的url映射', 'SYS_DRUID_URL_MAPPINGS', '/druid/*', 'Y', NULL, '1', 'sys_config', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_CONFIG VALUES ('34', 'Druid控制台账号', 'SYS_DRUID_ACCOUNT', 'admin', 'Y', NULL, '1', 'sys_config', 'N', NULL, NULL, TO_DATE('2023-05-11 11:10:28', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');
INSERT INTO SYS_CONFIG VALUES ('35', 'Druid控制台账号密码', 'SYS_DRUID_PASSWORD', 'qxvgkmsz4r7p8v4061e0', 'Y', '默认是空串，为空会让程序自动创建一个随机密码', '1', 'sys_config', 'N', NULL, NULL, TO_DATE('2023-05-11 11:10:28', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');
INSERT INTO SYS_CONFIG VALUES ('36', 'Druid控制台的监控数据是否可以重置清零', 'SYS_DRUID_RESET_ENABLE', 'false', 'Y', NULL, '1', 'sys_config', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_CONFIG VALUES ('37', 'druid web url统计的拦截范围', 'SYS_DRUID_WEB_STAT_FILTER_URL_PATTERN', '/*', 'Y', NULL, '1', 'sys_config', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_CONFIG VALUES ('38', 'druid web url统计的排除拦截表达式', 'SYS_DRUID_WEB_STAT_FILTER_EXCLUSIONS', '*.js,*.gif,*.jpg,*.png,*.css,*.ico,/druid/*', 'Y', NULL, '1', 'sys_config', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_CONFIG VALUES ('39', 'druid web url统计的session统计开关', 'SYS_DRUID_WEB_STAT_FILTER_SESSION_STAT_ENABLE', 'false', 'Y', NULL, '1', 'sys_config', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_CONFIG VALUES ('40', 'druid web url统计的session名称', 'SYS_DRUID_WEB_STAT_FILTER_PRINCIPAL_SESSION_NAME', 'Authorization', 'Y', NULL, '1', 'sys_config', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_CONFIG VALUES ('41', 'druid web url统计的session最大监控数', 'SYS_DRUID_WEB_STAT_FILTER_SESSION_STAT_MAX_COUNT', '1000', 'Y', NULL, '1', 'sys_config', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_CONFIG VALUES ('42', 'druid web url统计的cookie名称', 'SYS_DRUID_WEB_STAT_FILTER_PRINCIPAL_COOKIE_NAME', 'Authorization', 'Y', NULL, '1', 'sys_config', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_CONFIG VALUES ('43', 'druid web url统计的是否开启监控单个url调用的sql列表', 'SYS_DRUID_WEB_STAT_FILTER_PROFILE_ENABLE', 'true', 'Y', NULL, '1', 'sys_config', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_CONFIG VALUES ('44', '阿里云短信的accessKeyId', 'SYS_ALIYUN_SMS_ACCESS_KEY_ID', '你的accessKeyId', 'Y', NULL, '1', 'sms_config', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_CONFIG VALUES ('45', '阿里云短信的accessKeySecret', 'SYS_ALIYUN_SMS_ACCESS_KEY_SECRET', '你的secret', 'Y', NULL, '1', 'sms_config', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_CONFIG VALUES ('46', '阿里云短信的签名', 'SYS_ALIYUN_SMS_SIGN_NAME', '签名名称', 'Y', NULL, '1', 'sms_config', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_CONFIG VALUES ('47', '短信发送验证码失效时间', 'SYS_SMS_VALIDATE_EXPIRED_SECONDS', '300', 'Y', NULL, '1', 'sms_config', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_CONFIG VALUES ('1350666094452482049', '获取XSS排除过滤的url范围', 'SYS_XSS_URL_EXCLUSIONS', '/sysNotice/add,/sysNotice/edit,/databaseInfo/add,/apiResource/record,/sysTheme/add,/sysTheme/edit,/webSocket/*,/sysTableWidth/setTableWidth', 'Y', NULL, '1', 'sys_config', 'N', TO_DATE('2021-01-17 12:47:46', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', TO_DATE('2021-03-04 22:14:14', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');
INSERT INTO SYS_CONFIG VALUES ('1350666094452482050', '获取XSS过滤的url范围', 'SYS_XSS_URL_INCLUDES', '/*', 'Y', NULL, '1', 'sys_config', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_CONFIG VALUES ('1356246056131649538', 'websocket的ws-url', 'WEB_SOCKET_WS_URL', 'ws://localhost:8000/api/webSocket/{token}', 'Y', NULL, '1', 'sys_config', 'N', TO_DATE('2021-02-01 22:20:32', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', TO_DATE('2023-05-11 11:10:28', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');
INSERT INTO SYS_CONFIG VALUES ('1367118984192843778', '邮件是否启用账号密码验证', 'SYS_EMAIL_ENABLE_AUTH', 'true', 'N', NULL, '1', 'java_mail_config', 'N', TO_DATE('2021-03-03 22:25:40', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', TO_DATE('2021-03-03 22:25:43', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');
INSERT INTO SYS_CONFIG VALUES ('1367119064924807169', '邮箱的账号', 'SYS_EMAIL_ACCOUNT', 'xxx@126.com', 'N', NULL, '1', 'java_mail_config', 'N', TO_DATE('2021-03-03 22:26:00', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', NULL, NULL);
INSERT INTO SYS_CONFIG VALUES ('1367119226749444098', '邮箱的密码或者授权码', 'SYS_EMAIL_PASSWORD', 'xxx', 'N', NULL, '1', 'java_mail_config', 'N', TO_DATE('2021-03-03 22:26:38', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', NULL, NULL);
INSERT INTO SYS_CONFIG VALUES ('1367119286195314689', '邮箱的发送方邮箱', 'SYS_EMAIL_SEND_FROM', 'xxx@126.com', 'Y', NULL, '1', 'java_mail_config', 'N', TO_DATE('2021-03-03 22:26:52', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', NULL, NULL);
INSERT INTO SYS_CONFIG VALUES ('1367119399810621441', '是否开启tls', 'SYS_EMAIL_START_TLS_ENABLE', 'true', 'N', '使用 STARTTLS安全连接，STARTTLS是对纯文本通信协议的扩展。它将纯文本连接升级为加密连接（TLS或SSL）， 而不是使用一个单独的加密通信端口。', '1', 'java_mail_config', 'N', TO_DATE('2021-03-03 22:27:19', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', NULL, NULL);
INSERT INTO SYS_CONFIG VALUES ('1367119457260003329', 'SSL安全连接', 'SYS_EMAIL_TLS_ENABLE', 'true', 'N', NULL, '1', 'java_mail_config', 'N', TO_DATE('2021-03-03 22:27:33', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', TO_DATE('2021-03-03 22:28:33', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');
INSERT INTO SYS_CONFIG VALUES ('1367119505888763905', '指定的端口连接到在使用指定的套接字工厂', 'SYS_EMAIL_SOCKET_FACTORY_PORT', '465', 'Y', NULL, '1', 'java_mail_config', 'N', TO_DATE('2021-03-03 22:27:45', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', NULL, NULL);
INSERT INTO SYS_CONFIG VALUES ('1367119568455196674', 'SMTP超时时长，单位毫秒', 'SYS_EMAIL_SMTP_TIMEOUT', '10000', 'N', NULL, '1', 'java_mail_config', 'N', TO_DATE('2021-03-03 22:28:00', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', NULL, NULL);
INSERT INTO SYS_CONFIG VALUES ('1367119662306942977', 'Socket连接超时值，单位毫秒，缺省值不超时', 'SYS_EMAIL_CONNECTION_TIMEOUT', '10000', 'N', 'Socket连接超时值，单位毫秒，缺省值不超时', '1', 'java_mail_config', 'N', TO_DATE('2021-03-03 22:28:22', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', NULL, NULL);
INSERT INTO SYS_CONFIG VALUES ('1402549781675610114', 'smtp服务器地址', 'SYS_EMAIL_SMTP_HOST', 'smtp.126.com', 'N', NULL, '1', 'java_mail_config', 'N', TO_DATE('2021-06-09 16:55:01', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', NULL, NULL);
INSERT INTO SYS_CONFIG VALUES ('1402549781675610115', 'smtp服务端口', 'SYS_EMAIL_SMTP_PORT', '465', 'Y', NULL, '1', 'java_mail_config', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_CONFIG VALUES ('1402549781675610125', '拖拽验证码开关', 'SYS_DRAG_CAPTCHA_OPEN', 'false', 'Y', NULL, '1', 'sys_config', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_CONFIG VALUES ('1402549781675610200', 'auth认证用的jwt秘钥，用于校验登录token', 'SYS_AUTH_JWT_SECRET', '995zg7hw6uwfcwfd6s8w5ibyl4i5u9', 'Y', NULL, '1', 'auth_config', 'N', NULL, NULL, TO_DATE('2023-05-11 11:10:28', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');
INSERT INTO SYS_CONFIG VALUES ('1402549781675610205', '解析sso传过来的token', 'SYS_AUTH_SSO_JWT_SECRET', 'aabbccdd', 'Y', NULL, '1', 'ca_config', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_CONFIG VALUES ('1402549781675610210', '解析sso加密的数据的秘钥，解密sso单点中jwt中payload的秘钥', 'SYS_AUTH_SSO_DECRYPT_DATA_SECRET', 'EDPpR/BQfEFJiXKgxN8Uno4OnNMGcIJW1F777yySCPA=', 'Y', NULL, '1', 'ca_config', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_CONFIG VALUES ('1402549781675610215', '获取是否开启sso远程会话校验', 'SYS_AUTH_SSO_SESSION_VALIDATE_SWITCH', 'false', 'Y', NULL, '1', 'ca_config', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_CONFIG VALUES ('1402549781675610220', 'sso会话校验，redis的host', 'SYS_AUTH_SSO_SESSION_VALIDATE_REDIS_HOST', 'localhost', 'Y', NULL, '1', 'ca_config', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_CONFIG VALUES ('1402549781675610225', 'sso会话校验，redis的port', 'SYS_AUTH_SSO_SESSION_VALIDATE_REDIS_PORT', '6379', 'Y', NULL, '1', 'ca_config', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_CONFIG VALUES ('1402549781675610230', 'sso会话校验，redis的密码', 'SYS_AUTH_SSO_SESSION_VALIDATE_REDIS_PASSWORD', '123456', 'Y', NULL, '1', 'ca_config', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_CONFIG VALUES ('1402549781675610235', 'sso会话校验，redis的数据库序号', 'SYS_AUTH_SSO_SESSION_VALIDATE_REDIS_DB_INDEX', '2', 'Y', NULL, '1', 'ca_config', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_CONFIG VALUES ('1402549781675610240', 'sso会话校验，redis的缓存前缀', 'SYS_AUTH_SSO_SESSION_VALIDATE_REDIS_CACHE_PREFIX', 'CA:USER:TOKEN:', 'Y', NULL, '1', 'ca_config', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_CONFIG VALUES ('1402549781675610245', 'sso服务器地址', 'SYS_AUTH_SSO_HOST', 'http://localhost:8888', 'Y', NULL, '1', 'ca_config', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_CONFIG VALUES ('1402549781675610300', 'C端用户，注册邮件标题', 'CUSTOMER_REG_EMAIL_TITLE', '用户注册', 'Y', NULL, '1', 'customer_config', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_CONFIG VALUES ('1402549781675610305', '获取注册邮件的内容模板', 'CUSTOMER_REG_EMAIL_CONTENT', '感谢您注册Guns官方论坛，请点击此激活链接激活您的账户：<a href=http://localhost:8080/customer/active?verifyCode={}>http://localhost:8080/customer/active?verifyCode={} </a>', 'Y', NULL, '1', 'customer_config', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_CONFIG VALUES ('1402549781675610310', '获取重置密码的邮件标题', 'CUSTOMER_RESET_PWD_EMAIL_TITLE', '用户校验', 'Y', NULL, '1', 'customer_config', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_CONFIG VALUES ('1402549781675610315', '获取重置密码的邮件内容', 'CUSTOMER_RESET_PWD_EMAIL_CONTENT', '您的验证码是【{}】，此验证码用于修改登录密码，请不要泄露给他人，如果不是您本人操作，请忽略此邮件。', 'Y', NULL, '1', 'customer_config', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_CONFIG VALUES ('1402549781675610320', '存放用户头像的bucket的名称', 'CUSTOMER_FILE_BUCKET', 'customer-bucket', 'Y', NULL, '1', 'customer_config', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_CONFIG VALUES ('1402549781675610325', '存放用户头像的bucket的名称的过期时间', 'CUSTOMER_FILE_BUCKET_EXPIRED_SECONDS', '600', 'Y', NULL, '1', 'customer_config', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_CONFIG VALUES ('1402549781675610330', '获取c端用户缓存的过期时间，用在加快获取速度', 'CUSTOMER_CACHE_EXPIRED_SECONDS', '3600', 'Y', NULL, '1', 'customer_config', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_CONFIG VALUES ('1402549781675610335', '是否开启旧版密码校验', 'CUSTOMER_OPEN_OLD_PASSWORD_VALIDATE', 'false', 'Y', NULL, '1', 'customer_config', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_CONFIG VALUES ('1402549781675610400', '是否开启demo演示', 'SYS_DEMO_ENV_FLAG', 'false', 'Y', NULL, '1', 'sys_config', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_CONFIG VALUES ('1402549781675610405', '默认存储文件的bucket名称', 'SYS_FILE_DEFAULT_BUCKET', 'defaultBucket', 'Y', NULL, '1', 'file_config', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_CONFIG VALUES ('1402549781675610500', 'AES秘钥，用在数据库数据加密', 'SYS_ENCRYPT_SECRET_KEY', 'y7v2gpd9bv3bbi5ojhu9ool4pceimer8', 'Y', NULL, '1', 'security_config', 'N', NULL, NULL, TO_DATE('2023-05-11 11:10:28', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');
INSERT INTO SYS_CONFIG VALUES ('1402549781675610505', '开发模式开关', 'DEVOPS_DEV_SWITCH_STATUS', 'true', 'Y', '在开发模式下，允许devops平台访问某些系统接口', '1', 'sys_config', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_CONFIG VALUES ('1481244035229200386', '全局日志记录，如果开启则所有请求都将记录日志', 'SYS_LOG_GLOBAL_FLAG', 'false', 'Y', NULL, '1', 'file_config', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_CONFIG VALUES ('1581687626275000321', '登录密码是否进行RSA加密校验，false为关闭', 'SYS_AUTH_PASSWORD_RSA_VALIDATE', 'false', 'Y', NULL, '1', 'auth_config', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_CONFIG VALUES ('1697301485767798785', '默认根租户的ID', 'DEFAULT_ROOT_TENANT_ID', '1', 'Y', NULL, '1', 'TENANT_CONFIG', 'N', TO_DATE('2023-09-01 01:33:03', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', NULL, NULL);
INSERT INTO SYS_CONFIG VALUES ('1709186904454336514', '密码策略：口令最小长度', 'SYS_LOGIN_MIN_PASSWORD_LENGTH', '6', 'Y', NULL, '1', 'auth_config', 'N', TO_DATE('2023-10-03 20:41:28', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', NULL, NULL);
INSERT INTO SYS_CONFIG VALUES ('1709189854337699842', '密码策略：最少特殊符号数量', 'SYS_LOGIN_PASSWORD_MIN_SPECIAL_SYMBOL_COUNT', '0', 'Y', NULL, '1', 'auth_config', 'N', TO_DATE('2023-10-03 20:53:11', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', TO_DATE('2023-10-03 21:19:56', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');
INSERT INTO SYS_CONFIG VALUES ('1709196660577406977', '密码策略：最少大写字母数量', 'SYS_LOGIN_PASSWORD_MIN_UPPER_CASE_COUNT', '0', 'Y', NULL, '1', 'auth_config', 'N', TO_DATE('2023-10-03 21:20:14', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', NULL, NULL);
INSERT INTO SYS_CONFIG VALUES ('1709196708086288385', '密码策略：最少小写字母数量', 'SYS_LOGIN_PASSWORD_MIN_LOWER_CASE_COUNT', '0', 'Y', NULL, '1', 'auth_config', 'N', TO_DATE('2023-10-03 21:20:25', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', NULL, NULL);
INSERT INTO SYS_CONFIG VALUES ('1709196753862922241', '密码策略：最少数字符号的数量', 'SYS_LOGIN_PASSWORD_MIN_NUMBER_COUNT', '0', 'Y', NULL, '1', 'auth_config', 'N', TO_DATE('2023-10-03 21:20:36', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', NULL, NULL);
INSERT INTO SYS_CONFIG VALUES ('1709207802066505730', '密码策略：最少多久更新一次密码，单位天', 'SYS_LOGIN_PASSWORD_MIN_UPDATE_DAYS', '180', 'Y', NULL, '1', 'auth_config', 'N', TO_DATE('2023-10-03 22:04:30', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', NULL, NULL);
INSERT INTO SYS_CONFIG VALUES ('1709207873369673730', '密码策略：修改密码时，不能和历史密码重复的次数', 'SYS_LOGIN_PASSWORD_MIN_CANT_REPEAT_TIMES', '0', 'Y', NULL, '1', 'auth_config', 'N', TO_DATE('2023-10-03 22:04:47', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', TO_DATE('2023-10-03 22:05:50', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');

INSERT INTO SYS_DICT VALUES ('1348235720908619802', '1348235720908619811', 'M', '男', 'n', 'male', NULL, NULL, '-1', '[-1],', '1', '110', '1', 'N', NULL, NULL, TO_DATE('2023-07-09 22:19:58', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');
INSERT INTO SYS_DICT VALUES ('1348235720908619803', '1348235720908619811', 'F', '女', 'n', 'female', NULL, NULL, '-1', '[-1],', '1', '120', '1', 'N', NULL, NULL, TO_DATE('2023-07-09 22:19:58', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');
INSERT INTO SYS_DICT VALUES ('1348235720908619804', '1348235720908619812', '1', '启用', 'n', 'male', NULL, NULL, '-1', '[-1],', '1', '1', '1', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_DICT VALUES ('1348235720908619805', '1348235720908619812', '2', '禁用', 'n', 'female', NULL, NULL, '-1', '[-1],', '1', '2', '1', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_DICT VALUES ('1348235720908619806', '1348235720908619812', '3', '冻结', 'n', 'female', NULL, NULL, '-1', '[-1],', '1', '2', '1', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_DICT VALUES ('1350457799368257537', '1350457656690618370', 'low', '低', 'd', NULL, '低', NULL, '-1', '[-1],', '1', '1', '1', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_DICT VALUES ('1350457870780477442', '1350457656690618370', 'middle', '中', 'z', NULL, '中', NULL, '-1', '[-1],', '1', '2', '1', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_DICT VALUES ('1350457950417727489', '1350457656690618370', 'high', '高', 'g', NULL, '高', NULL, '-1', '[-1],', '1', '3', '1', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_DICT VALUES ('1353547360691851266', '1353547215422132226', 'sys_config', '系统配置', 'xtpz', NULL, NULL, NULL, '-1', '[-1],', '1', '1', '1', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_DICT VALUES ('1353547405457657857', '1353547215422132226', 'file_config', '文件配置', 'wjpz', NULL, NULL, NULL, '-1', '[-1],', '1', '2', '1', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_DICT VALUES ('1353547460558229506', '1353547215422132226', 'auth_config', '鉴权配置', 'jqpz', NULL, NULL, NULL, '-1', '[-1],', '1', '3', '1', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_DICT VALUES ('1353547539293704194', '1353547215422132226', 'sms_config', '短信配置', 'dxpz', NULL, NULL, NULL, '-1', '[-1],', '1', '4', '1', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_DICT VALUES ('1353998066804658177', '1353997993299480577', 'chinese', '中文', 'zw', NULL, NULL, NULL, '-1', '[-1],', '1', '1', '1', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_DICT VALUES ('1353998106784763906', '1353997993299480577', 'english', 'english', 'yw', NULL, NULL, NULL, '-1', '[-1],', '1', '2', '1', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_DICT VALUES ('1354040749627662337', '1354040335406587906', 'role_system', '系统角色', 'xtjs', NULL, NULL, NULL, '-1', '[-1],', '1', '1', '1', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_DICT VALUES ('1354040819219554305', '1354040335406587906', 'role_c', 'C端角色', 'Cdjs', NULL, NULL, NULL, '-1', '[-1],', '1', '2', '1', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_DICT VALUES ('1354041049981771778', '1354040335406587906', 'role_b', 'B端角色', 'Bdjs', NULL, NULL, NULL, '-1', '[-1],', '1', '3', '1', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_DICT VALUES ('1365251792270045186', '1365251549365317633', 'Y', '是', 's', NULL, NULL, NULL, '-1', '[-1],', '1', '1', '1', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_DICT VALUES ('1365251827812577282', '1365251549365317633', 'N', '否', 'f', NULL, NULL, NULL, '-1', '[-1],', '1', '2', '1', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_DICT VALUES ('1365252384094728193', '1365252142779641858', 'com.mysql.cj.jdbc.Driver', 'com.mysql.cj.jdbc.Driver', 'com.mysql.cj.jdbc.Driver', NULL, NULL, NULL, '-1', '[-1],', '1', '1', '1', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_DICT VALUES ('1402549554864427010', '1353547215422132226', 'java_mail_config', 'java邮件配置', 'javayjpz', NULL, NULL, NULL, '-1', '[-1],', '1', '50', '1', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_DICT VALUES ('1402549554864427020', '1353547215422132226', 'customer_config', 'C端用户配置', 'cdyhpz', NULL, NULL, NULL, '-1', '[-1],', '1', '60', '1', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_DICT VALUES ('1526221204984197121', '1353547215422132226', 'ca_config', '单点配置', 'ddpz', NULL, NULL, NULL, '-1', '[-1],', '1', '70', '1', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_DICT VALUES ('1569699572911206401', '1569699391469809666', '1', '负责人', 'fzr', NULL, NULL, NULL, '-1', '[-1],', '1', '10', '1', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_DICT VALUES ('1569699624215932930', '1569699391469809666', '2', '部长', 'bz', NULL, NULL, NULL, '-1', '[-1],', '1', '20', '1', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_DICT VALUES ('1569699732391227394', '1569699391469809666', '3', '体系负责人', 'txfzr', NULL, NULL, NULL, '-1', '[-1],', '1', '30', '1', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_DICT VALUES ('1569699780906741762', '1569699391469809666', '4', '部门助理', 'bmzl', NULL, NULL, NULL, '-1', '[-1],', '1', '40', '1', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_DICT VALUES ('1569699833889189889', '1569699391469809666', '5', '资产助理', 'zczl', NULL, NULL, NULL, '-1', '[-1],', '1', '50', '1', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_DICT VALUES ('1569699872430649345', '1569699391469809666', '6', '考勤专员', 'kqzy', NULL, NULL, NULL, '-1', '[-1],', '1', '60', '1', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_DICT VALUES ('1569699912133931009', '1569699391469809666', '7', 'HRBP', 'HRBP', NULL, NULL, NULL, '-1', '[-1],', '1', '70', '1', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_DICT VALUES ('1569699950046244865', '1569699391469809666', '8', '门禁员', 'mjy', NULL, NULL, NULL, '-1', '[-1],', '1', '80', '1', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_DICT VALUES ('1569700054404722690', '1569699391469809666', '9', '办公账号员', 'bgzhy', NULL, NULL, NULL, '-1', '[-1],', '1', '90', '1', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_DICT VALUES ('1569700365244592129', '1569699391469809666', '10', '转岗须知员', 'zgxzy', NULL, NULL, NULL, '-1', '[-1],', '1', '100', '1', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_DICT VALUES ('1574327462970531842', '1574327405802168321', '1', '所有人', 'syr', NULL, NULL, NULL, '-1', '[-1],', '1', '10', '1', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_DICT VALUES ('1574327499536474114', '1574327405802168321', '2', '当前登录人', 'dqdlr', NULL, NULL, NULL, '-1', '[-1],', '1', '20', '1', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_DICT VALUES ('1574327582113931266', '1574327405802168321', '3', '申请人', 'sqr', NULL, NULL, NULL, '-1', '[-1],', '1', '30', '1', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_DICT VALUES ('1574327869830602753', '1574327405802168321', '4', '当前登录人部门', 'dqdlrbm', NULL, NULL, NULL, '-1', '[-1],', '1', '40', '1', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_DICT VALUES ('1574327924788568065', '1574327405802168321', '5', '当前申请人部门', 'dqsqrbm', NULL, NULL, NULL, '-1', '[-1],', '1', '50', '1', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_DICT VALUES ('1697301378511056897', '1353547215422132226', 'TENANT_CONFIG', '租户配置', 'zhpz', NULL, NULL, NULL, '-1', '[-1],', '1', '80', '1', 'N', TO_DATE('2023-09-01 01:32:38', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', TO_DATE('2023-09-01 01:32:46', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');
INSERT INTO SYS_DICT VALUES ('1717480173877596162', '1717480072987807746', '1', '启用', 'qy', NULL, NULL, NULL, '-1', '[-1],', '1', '100.00', '0', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_DICT VALUES ('1717480204684759041', '1717480072987807746', '2', '禁用', 'jy', NULL, NULL, NULL, '-1', '[-1],', '1', '101.00', '0', 'N', NULL, NULL, NULL, NULL);

INSERT INTO SYS_DICT_TYPE VALUES ('1348235720908619811', '1', 'base', 'sex', '性别', 'xb', NULL, '1', '1', '1', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_DICT_TYPE VALUES ('1348235720908619812', '2', 'system', 'user_status', '用户状态', 'yhzt', NULL, '1', '2', '1', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_DICT_TYPE VALUES ('1350457656690618370', '1', 'notice', 'priority_level', '优先级', 'yxj', NULL, '1', '5', '1', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_DICT_TYPE VALUES ('1353547215422132226', '2', NULL, 'config_group', '系统配置分组', 'xtpzfz', '系统配置分组', '1', '6', '1', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_DICT_TYPE VALUES ('1353997993299480577', '2', NULL, 'languages', '语种', 'yz', 'i18n 多语言', '1', '7', '1', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_DICT_TYPE VALUES ('1354040335406587906', '2', NULL, 'role_type', '角色类型', 'jslx', NULL, '1', '8', '1', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_DICT_TYPE VALUES ('1365251549365317633', '1', NULL, 'yn', 'yn', 'yn', NULL, '1', '7', '1', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_DICT_TYPE VALUES ('1365252142779641858', '1', NULL, 'jdbc_type', 'jdbc_type', 'jdbc_type', NULL, '1', '8', '1', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_DICT_TYPE VALUES ('1569699391469809666', '1', NULL, 'org_approver_type', '审批人类型', 'sprlx', '组织机构审批人类型', '1', '10', '1', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_DICT_TYPE VALUES ('1574327405802168321', '1', NULL, 'select_relation', '选择关系', 'xzgx', '适用于通用选择器中的选择关系的列举', '1', '20', '1', 'N', NULL, NULL, NULL, NULL);
INSERT INTO SYS_DICT_TYPE VALUES ('1717480072987807746', '1', NULL, 'COMMON_STATUS_FLAG', '通用状态', 'tyzt', NULL, '1', '101.00', '1', 'N', NULL, NULL, NULL, NULL);

INSERT INTO SYS_FILE_INFO VALUES ('10000', '1479745704687820802', '1', '1', '5', 'defaultBucket', 'defaultAvatar.png', 'png', '8', '7.61 KB', '10000.png', NULL, 'N', 'N', TO_DATE('2022-01-08 17:24:03', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', NULL, NULL);
INSERT INTO SYS_FILE_INFO VALUES ('1479753047148322818', '1479753047165100034', '1', '1', '5', 'defaultBucket', 'logo.png', 'png', '9', '8.86 KB', '1479753047148322818.png', NULL, 'N', 'N', TO_DATE('2022-01-08 17:53:14', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', NULL, NULL);
INSERT INTO SYS_FILE_INFO VALUES ('1673705057339625474', '1673705057339625476', '1', '1', '5', 'defaultBucket', 'icon-app-portal.png', 'png', '10', '9.5 KB', '1673705057339625474.png', NULL, 'N', 'N', TO_DATE('2023-06-27 22:49:16', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', NULL, NULL);
INSERT INTO SYS_FILE_INFO VALUES ('1673705057339625478', '1673705057339625479', '1', '1', '5', 'defaultBucket', 'icon-app-backend.png', 'png', '8', '8.43 KB', '1673705057339625478.png', NULL, 'N', 'N', TO_DATE('2023-06-27 22:49:16', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', NULL, NULL);
INSERT INTO SYS_FILE_INFO VALUES ('1678667508563898369', '1678667508563898370', '1', '1', '5', 'defaultBucket', 'bg-login.jpg', 'jpg', '249', '248.61 KB', '1678667508563898369.jpg', NULL, 'N', 'N', TO_DATE('2023-07-11 15:28:17', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', NULL, NULL);
INSERT INTO SYS_FILE_INFO VALUES ('1704330515919671298', '1704330515919671299', '1', '1', '5', 'defaultBucket', '登录背景.png', 'png', '104', '104.04 KB', '1704330515919671298.png', NULL, 'N', 'N', TO_DATE('2023-09-20 11:03:55', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', NULL, NULL);


INSERT INTO SYS_HR_ORGANIZATION VALUES ('1671418869810540546', '-1', '[-1],', '北京公司', '总公司', '10000000', '10', '1', '1', NULL, NULL, NULL, NULL, NULL, NULL, '1', 'N', TO_DATE('2023-06-21 15:35:09', 'SYYYY-MM-DD HH24:MI:SS'), '-1', TO_DATE('2023-06-28 21:51:04', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', '1');
INSERT INTO SYS_HR_ORGANIZATION VALUES ('1671419146928205826', '1671418869810540546', '[-1],[1671418869810540546],', '信息中心', '信息中心', '10010000', '101', '1', '2', NULL, NULL, NULL, NULL, NULL, NULL, '3', 'N', TO_DATE('2023-06-21 15:35:09', 'SYYYY-MM-DD HH24:MI:SS'), '-1', TO_DATE('2023-06-28 23:18:55', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', '1');
INSERT INTO SYS_HR_ORGANIZATION VALUES ('1671419297969287170', '1671418869810540546', '[-1],[1671418869810540546],', '发展规划部', '发展规划部', '10020000', '102', '1', '2', NULL, NULL, NULL, NULL, NULL, NULL, '1', 'N', TO_DATE('2023-06-21 15:35:09', 'SYYYY-MM-DD HH24:MI:SS'), '-1', TO_DATE('2023-07-11 13:55:14', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', '1');
INSERT INTO SYS_HR_ORGANIZATION VALUES ('1671419436767195137', '1671418869810540546', '[-1],[1671418869810540546],', '法律部', '法律部', '10030000', '103', '1', '2', NULL, NULL, NULL, NULL, NULL, NULL, '1', 'N', TO_DATE('2023-06-21 15:35:09', 'SYYYY-MM-DD HH24:MI:SS'), '-1', TO_DATE('2023-07-11 13:55:19', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', '1');
INSERT INTO SYS_HR_ORGANIZATION VALUES ('1671419890196623362', '1671418869810540546', '[-1],[1671418869810540546],', '北京西城区公司', '北京西城区能源管理公司', '10040000', '104', '1', '1', NULL, NULL, NULL, NULL, NULL, NULL, '2', 'N', TO_DATE('2023-06-21 15:35:09', 'SYYYY-MM-DD HH24:MI:SS'), '-1', TO_DATE('2023-06-29 11:44:26', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', '1');
INSERT INTO SYS_HR_ORGANIZATION VALUES ('1671420255612776449', '1671419890196623362', '[-1],[1671418869810540546],[1671419890196623362],', '能源管理部', '能源部', '10040001', '1040', '2', '2', NULL, NULL, NULL, NULL, NULL, NULL, '2', 'N', TO_DATE('2023-06-21 15:35:09', 'SYYYY-MM-DD HH24:MI:SS'), '-1', TO_DATE('2023-06-29 11:44:26', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', '1');
INSERT INTO SYS_HR_ORGANIZATION VALUES ('1674672546647220226', '-1', '[-1],', '南京公司', NULL, '20000000', '20', '1', '1', NULL, NULL, NULL, NULL, NULL, NULL, '1', 'N', TO_DATE('2023-06-30 14:53:44', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', TO_DATE('2023-07-11 14:03:25', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', '1');
INSERT INTO SYS_HR_ORGANIZATION VALUES ('1674675494710255617', '1674672546647220226', '[-1],[1674672546647220226],', '综合管理部', NULL, '20000001', '201', '1', '2', NULL, NULL, NULL, NULL, NULL, NULL, '1', 'N', TO_DATE('2023-06-30 15:05:27', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', TO_DATE('2023-07-11 13:55:54', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', '1');

INSERT INTO SYS_HR_POSITION VALUES ('1671418731163627522', '员工', 'yg', '1000', '1', NULL, NULL, '1', 'N', TO_DATE('2023-06-21 15:28:21', 'SYYYY-MM-DD HH24:MI:SS'), '-1', NULL, NULL, '1');
INSERT INTO SYS_HR_POSITION VALUES ('1671418794157879297', '部门负责人', 'bmfzr', '200', '1', NULL, NULL, '1', 'N', TO_DATE('2023-06-29 10:20:54', 'SYYYY-MM-DD HH24:MI:SS'), NULL, TO_DATE('2023-06-29 10:21:19', 'SYYYY-MM-DD HH24:MI:SS'), '1673708058896797697', '1');
INSERT INTO SYS_HR_POSITION VALUES ('1671418831935975426', '总经理', 'zjl', '100', '1', NULL, NULL, '1', 'N', TO_DATE('2023-06-21 15:28:21', 'SYYYY-MM-DD HH24:MI:SS'), '-1', TO_DATE('2023-06-29 10:21:10', 'SYYYY-MM-DD HH24:MI:SS'), '1673708058896797697', '1');

INSERT INTO SYS_MENU VALUES ('1671406619464953857', '-1', '[-1],', '门户主页', 'PORTAL_INDEX', '1671406669800796161', '101', '1', NULL, '20', '/index', '/index/index', 'icon-menu-zhuye', NULL, NULL, 'Y', NULL, '1', 'N', TO_DATE('2023-06-21 14:39:24', 'SYYYY-MM-DD HH24:MI:SS'), NULL, TO_DATE('2023-07-07 17:09:26', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');
INSERT INTO SYS_MENU VALUES ('1671407186899759106', '-1', '[-1],', '个人信息', 'PERSONAL_INFO', '1671406669800796161', '102', '1', NULL, '20', '/index/personal', '/index/personal', 'icon-menu-gerenxinxi', NULL, NULL, 'Y', NULL, '1', 'N', TO_DATE('2023-06-21 14:40:04', 'SYYYY-MM-DD HH24:MI:SS'), NULL, TO_DATE('2023-07-07 17:09:26', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');
INSERT INTO SYS_MENU VALUES ('1671407312775016450', '-1', '[-1],', '组织架构', 'ORG_INDEX', '1671406745336016898', '101', '1', NULL, '10', '/system/structure', NULL, 'icon-menu-zuzhijiagou', NULL, NULL, 'Y', NULL, '1', 'N', TO_DATE('2023-06-21 14:42:07', 'SYYYY-MM-DD HH24:MI:SS'), NULL, TO_DATE('2023-07-07 17:09:32', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');
INSERT INTO SYS_MENU VALUES ('1671407539607171073', '1671407312775016450', '[-1],[1671407312775016450],', '人员', 'ORG_USER', '1671406745336016898', '10101', '1', NULL, '10', '/system/structure/user', '/system/structure/user/index', 'icon-menu-renyuan', NULL, NULL, 'Y', NULL, '1', 'N', TO_DATE('2023-06-21 14:42:07', 'SYYYY-MM-DD HH24:MI:SS'), NULL, TO_DATE('2023-07-07 17:09:32', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');
INSERT INTO SYS_MENU VALUES ('1671407615163363330', '1671407312775016450', '[-1],[1671407312775016450],', '机构', 'ORG_LIST', '1671406745336016898', '10102', '1', NULL, '10', '/system/structure/organization', '/system/structure/organization/index', 'icon-menu-jigou', NULL, NULL, 'Y', NULL, '1', 'N', TO_DATE('2023-06-21 14:42:07', 'SYYYY-MM-DD HH24:MI:SS'), NULL, TO_DATE('2023-07-07 17:09:32', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');
INSERT INTO SYS_MENU VALUES ('1671407652933070850', '1671407312775016450', '[-1],[1671407312775016450],', '职位', 'ORG_POSITION', '1671406745336016898', '10103', '1', NULL, '10', '/system/structure/position', '/system/structure/position/index', 'icon-menu-zhiwei', NULL, NULL, 'Y', NULL, '1', 'N', TO_DATE('2023-06-21 14:42:07', 'SYYYY-MM-DD HH24:MI:SS'), NULL, TO_DATE('2023-07-07 17:09:32', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');
INSERT INTO SYS_MENU VALUES ('1671407791416406018', '-1', '[-1],', '权限控制', 'AUTH_CONTROL', '1671406745336016898', '102', '1', NULL, '10', '/system/auth', NULL, 'icon-menu-quanxiankongzhi', NULL, NULL, 'Y', NULL, '1', 'N', TO_DATE('2023-06-21 14:42:07', 'SYYYY-MM-DD HH24:MI:SS'), NULL, TO_DATE('2023-07-07 17:09:32', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');
INSERT INTO SYS_MENU VALUES ('1671407892205531137', '1671407791416406018', '[-1],[1671407791416406018],', '应用', 'AUTH_APP', '1671406745336016898', '10201', '1', NULL, '10', '/system/auth/app', '/system/auth/app/index', 'icon-menu-yingyong', NULL, NULL, 'Y', NULL, '1', 'N', TO_DATE('2023-06-21 14:42:07', 'SYYYY-MM-DD HH24:MI:SS'), NULL, TO_DATE('2023-07-07 17:09:32', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');
INSERT INTO SYS_MENU VALUES ('1671407967690420226', '1671407791416406018', '[-1],[1671407791416406018],', '角色', 'AUTH_ROLE', '1671406745336016898', '10202', '1', NULL, '10', '/system/auth/role', '/system/auth/role/index', 'icon-menu-juese', NULL, NULL, 'Y', NULL, '1', 'N', TO_DATE('2023-06-21 14:42:07', 'SYYYY-MM-DD HH24:MI:SS'), NULL, TO_DATE('2023-07-07 17:09:32', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');
INSERT INTO SYS_MENU VALUES ('1671408081100206081', '1671407791416406018', '[-1],[1671407791416406018],', '权限', 'AUTH_PERMISSION', '1671406745336016898', '10203', '1', NULL, '10', '/system/auth/permission', '/system/auth/permission/index', 'icon-menu-quanxian', NULL, NULL, 'Y', NULL, '1', 'N', TO_DATE('2023-06-21 14:42:07', 'SYYYY-MM-DD HH24:MI:SS'), NULL, TO_DATE('2023-07-07 17:09:32', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');
INSERT INTO SYS_MENU VALUES ('1671408144094457858', '1671407791416406018', '[-1],[1671407791416406018],', '菜单', 'AUTH_MENU', '1671406745336016898', '10204', '1', NULL, '10', '/system/auth/menu', '/system/auth/menu/index', 'icon-menu-caidan', NULL, NULL, 'Y', NULL, '1', 'N', TO_DATE('2023-06-21 14:42:07', 'SYYYY-MM-DD HH24:MI:SS'), NULL, TO_DATE('2023-07-07 17:09:32', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');
INSERT INTO SYS_MENU VALUES ('1671408194501603329', '1671407791416406018', '[-1],[1671407791416406018],', '资源', 'AUTH_RESOURCE', '1671406745336016898', '10205', '1', NULL, '10', '/system/auth/resource', '/system/auth/resource/index', 'icon-menu-ziyuan', NULL, NULL, 'Y', NULL, '1', 'N', TO_DATE('2023-06-21 14:42:07', 'SYYYY-MM-DD HH24:MI:SS'), NULL, TO_DATE('2023-07-07 17:09:32', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');
INSERT INTO SYS_MENU VALUES ('1673524613037191169', '-1', '[-1],', '后台配置', 'BACKEND_CONFIG', '1671406745336016898', '103', '1', NULL, '10', '/backend/config', '/backend/config', 'icon-menu-peizhi', NULL, NULL, 'Y', NULL, '1', 'N', TO_DATE('2023-06-27 11:15:17', 'SYYYY-MM-DD HH24:MI:SS'), NULL, TO_DATE('2023-07-07 17:09:32', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');
INSERT INTO SYS_MENU VALUES ('1673524865274245118', '1673524613037191169', '[-1],[1673524613037191169],', '系统配置', 'SYS_CONFIG', '1671406745336016898', '10301', '1', NULL, '10', '/system/backend/sys_config', '/system/backend/sys-config/index', 'icon-menu-peizhi', NULL, NULL, 'Y', NULL, '1', 'N', TO_DATE('2023-06-27 11:15:17', 'SYYYY-MM-DD HH24:MI:SS'), NULL, TO_DATE('2023-07-07 17:09:32', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');
INSERT INTO SYS_MENU VALUES ('1673524865274245121', '1673524613037191169', '[-1],[1673524613037191169],', '字典', 'DICT', '1671406745336016898', '10302', '1', NULL, '10', '/system/backend/dict', '/system/backend/dict/index', 'icon-menu-zidian', NULL, NULL, 'Y', NULL, '1', 'N', TO_DATE('2023-06-27 11:15:17', 'SYYYY-MM-DD HH24:MI:SS'), NULL, TO_DATE('2023-07-07 17:09:32', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');
INSERT INTO SYS_MENU VALUES ('1673524941069512706', '1673524613037191169', '[-1],[1673524613037191169],', '在线用户', 'ONLINE_USER', '1671406745336016898', '10303', '1', NULL, '10', '/system/backend/online', '/system/backend/online/index', 'icon-menu-zaixianyonghu', NULL, NULL, 'Y', NULL, '1', 'N', TO_DATE('2023-06-27 11:15:17', 'SYYYY-MM-DD HH24:MI:SS'), NULL, TO_DATE('2023-07-07 17:09:32', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');
INSERT INTO SYS_MENU VALUES ('1673524966277279745', '1673524613037191169', '[-1],[1673524613037191169],', '定时任务', 'TIMER', '1671406745336016898', '10304', '1', NULL, '10', '/system/backend/timer', '/system/backend/timer/index', 'icon-menu-dingshirenwu', NULL, NULL, 'Y', NULL, '1', 'N', TO_DATE('2023-06-27 11:15:17', 'SYYYY-MM-DD HH24:MI:SS'), NULL, TO_DATE('2023-07-07 17:09:32', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');
INSERT INTO SYS_MENU VALUES ('1673525004151844865', '1673524613037191169', '[-1],[1673524613037191169],', '文件管理', 'FILE_MANAGER', '1671406745336016898', '10305', '1', NULL, '10', '/system/backend/file', '/system/backend/file/index', 'icon-menu-wenjianguanli', NULL, NULL, 'Y', NULL, '1', 'N', TO_DATE('2023-06-27 11:15:17', 'SYYYY-MM-DD HH24:MI:SS'), NULL, TO_DATE('2023-07-07 17:09:32', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');
INSERT INTO SYS_MENU VALUES ('1673525357136080898', '1673524613037191169', '[-1],[1673524613037191169],', '多数据源', 'MULTI_DS', '1671406745336016898', '10306', '1', NULL, '10', '/system/backend/datasource', '/system/backend/datasource/index', 'icon-menu-duoshujuyuan', NULL, NULL, 'Y', NULL, '1', 'N', TO_DATE('2023-06-27 11:15:17', 'SYYYY-MM-DD HH24:MI:SS'), NULL, TO_DATE('2023-07-07 17:09:32', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');
INSERT INTO SYS_MENU VALUES ('1673525659931275265', '1673524613037191169', '[-1],[1673524613037191169],', '日志查看', 'LOG_MANAGER', '1671406745336016898', '10307', '1', NULL, '10', '/system/backend/log', NULL, 'icon-menu-rizhi', NULL, NULL, 'Y', NULL, '1', 'N', TO_DATE('2023-06-27 11:15:17', 'SYYYY-MM-DD HH24:MI:SS'), NULL, TO_DATE('2023-07-07 17:09:32', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');
INSERT INTO SYS_MENU VALUES ('1673525723072327682', '1673525659931275265', '[-1],[1673524613037191169],[1673525659931275265],', '登录日志', 'LOG_LOGIN', '1671406745336016898', '1030701', '1', NULL, '10', '/system/backend/log/loginlog', '/system/backend/log/login-log/index', 'icon-menu-denglurizhi', NULL, NULL, 'Y', NULL, '1', 'N', TO_DATE('2023-06-27 11:15:17', 'SYYYY-MM-DD HH24:MI:SS'), NULL, TO_DATE('2023-07-07 17:09:32', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');
INSERT INTO SYS_MENU VALUES ('1673525798674657282', '1673525659931275265', '[-1],[1673524613037191169],[1673525659931275265],', 'API日志', 'OPERATE_LOG', '1671406745336016898', '1030702', '1', NULL, '10', '/system/backend/log/operatelog', '/system/backend/log/operate-log/index', 'icon-menu-caozuorizhi', NULL, NULL, 'Y', NULL, '1', 'N', TO_DATE('2023-06-27 11:15:17', 'SYYYY-MM-DD HH24:MI:SS'), NULL, TO_DATE('2023-07-07 17:09:32', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');
INSERT INTO SYS_MENU VALUES ('1673525912344489985', '1673524613037191169', '[-1],[1673524613037191169],', '监控管理', 'MONITOR', '1671406745336016898', '10308', '1', NULL, '10', '/system/backend/monitor', NULL, 'icon-menu-jiankong', NULL, NULL, 'Y', NULL, '1', 'N', TO_DATE('2023-06-27 11:15:17', 'SYYYY-MM-DD HH24:MI:SS'), NULL, TO_DATE('2023-07-07 17:09:32', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');
INSERT INTO SYS_MENU VALUES ('1673526227621933057', '1673525912344489985', '[-1],[1673524613037191169],[1673525912344489985],', 'SQL监控', 'SQL_MONITOR', '1671406745336016898', '1030801', '1', NULL, '40', 'http://localhost:8080/druid', 'http://localhost:8080/druid', 'icon-menu-sqljiankong', NULL, NULL, 'Y', NULL, '1', 'N', TO_DATE('2023-06-27 11:15:17', 'SYYYY-MM-DD HH24:MI:SS'), NULL, TO_DATE('2023-07-07 17:09:32', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');
INSERT INTO SYS_MENU VALUES ('1673526479934484481', '1673525912344489985', '[-1],[1673524613037191169],[1673525912344489985],', '服务器信息', 'SERVER_MONITOR', '1671406745336016898', '1030802', '1', NULL, '10', '/system/backend/monitor/server', '/system/backend/monitor/server', 'icon-menu-fuwuqixinxi', NULL, NULL, 'Y', NULL, '1', 'N', TO_DATE('2023-06-27 11:15:17', 'SYYYY-MM-DD HH24:MI:SS'), NULL, TO_DATE('2023-07-07 17:09:32', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');
INSERT INTO SYS_MENU VALUES ('1673526656565014530', '1673524613037191169', '[-1],[1673524613037191169],', '主题配置', 'THEME', '1671406745336016898', '10309', '1', NULL, '10', '/system/backend/theme', NULL, 'icon-menu-zhuti', NULL, NULL, 'Y', NULL, '1', 'N', TO_DATE('2023-06-27 11:15:17', 'SYYYY-MM-DD HH24:MI:SS'), NULL, TO_DATE('2023-07-07 17:09:32', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');
INSERT INTO SYS_MENU VALUES ('1673526946869571585', '1673526656565014530', '[-1],[1673524613037191169],[1673526656565014530],', '主题管理', 'THEME_MANAGER', '1671406745336016898', '1030901', '1', NULL, '10', '/system/backend/theme/manager', '/system/backend/theme/manager/index', 'icon-menu-zhutiguanli', NULL, NULL, 'Y', NULL, '1', 'N', TO_DATE('2023-06-27 11:15:17', 'SYYYY-MM-DD HH24:MI:SS'), NULL, TO_DATE('2023-07-07 17:09:32', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');
INSERT INTO SYS_MENU VALUES ('1673527098267168769', '1673526656565014530', '[-1],[1673524613037191169],[1673526656565014530],', '主题模板', 'THEME_TEMPLATE', '1671406745336016898', '1030902', '1', NULL, '10', '/system/backend/theme/template', '/system/backend/theme/template/index', 'icon-menu-zhutimuban', NULL, NULL, 'Y', NULL, '1', 'N', TO_DATE('2023-06-27 11:15:17', 'SYYYY-MM-DD HH24:MI:SS'), NULL, TO_DATE('2023-07-07 17:09:32', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');
INSERT INTO SYS_MENU VALUES ('1673527401095917570', '1673526656565014530', '[-1],[1673524613037191169],[1673526656565014530],', '主题属性', 'THEME_ATTR', '1671406745336016898', '1030903', '1', NULL, '10', '/system/backend/theme/attr', '/system/backend/theme/attr/index', 'icon-menu-zhutishuxing', NULL, NULL, 'Y', NULL, '1', 'N', TO_DATE('2023-06-27 11:15:17', 'SYYYY-MM-DD HH24:MI:SS'), NULL, TO_DATE('2023-07-07 17:09:32', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');
INSERT INTO SYS_MENU VALUES ('1684222436082364417', '1673525659931275265', '[-1],[1673524613037191169],[1673525659931275265],', '业务日志', 'YEWU_RIZHI', '1671406745336016898', '100', '1', NULL, '10', '/system/backend/log/business', '/system/backend/log/business-log/index', 'icon-menu-yewurizhi', NULL, NULL, 'Y', NULL, '0', 'N', TO_DATE('2023-07-26 23:21:35', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', NULL, NULL);
INSERT INTO SYS_MENU VALUES ('1710533513796653058', '1673524613037191169', '[-1],[1673524613037191169],', '安全策略', 'anquancelve', '1671406745336016898', '10310.00', '1', NULL, '10', '/backend/security', '/system/backend/security/index', 'icon-update-password', NULL, NULL, 'Y', NULL, '1', 'N', NULL, NULL, NULL, NULL);

INSERT INTO SYS_MENU_OPTIONS VALUES ('1671416717948006401', '1671406745336016898', '1671407539607171073', '新增人员', 'ADD_USER', TO_DATE('2023-06-21 15:17:48', 'SYYYY-MM-DD HH24:MI:SS'), NULL, TO_DATE('2023-07-07 15:09:31', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');
INSERT INTO SYS_MENU_OPTIONS VALUES ('1671416755763851265', '1671406745336016898', '1671407539607171073', '修改人员', 'EDIT_USER', TO_DATE('2023-06-21 15:17:48', 'SYYYY-MM-DD HH24:MI:SS'), NULL, TO_DATE('2023-07-07 15:09:34', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');
INSERT INTO SYS_MENU_OPTIONS VALUES ('1675495204221640706', '1671406745336016898', '1671407615163363330', '新增机构', 'ADD_ORG', TO_DATE('2023-07-02 21:22:41', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', TO_DATE('2023-07-07 15:10:13', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');
INSERT INTO SYS_MENU_OPTIONS VALUES ('1677199976008040449', '1671406669800796161', '1671406619464953857', '公司概况统计', 'COMPANY_STAT_INFO', TO_DATE('2023-07-07 14:16:50', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', TO_DATE('2023-07-07 14:16:57', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');
INSERT INTO SYS_MENU_OPTIONS VALUES ('1677205540070064129', '1671406745336016898', '1671407539607171073', '删除人员', 'DELETE_USER', TO_DATE('2023-07-07 14:38:56', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', TO_DATE('2023-07-07 15:09:37', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');
INSERT INTO SYS_MENU_OPTIONS VALUES ('1677205784526684162', '1671406745336016898', '1671407539607171073', '分配角色', 'ASSIGN_USER_ROLE', TO_DATE('2023-07-07 14:39:55', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', TO_DATE('2023-07-07 15:09:40', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');
INSERT INTO SYS_MENU_OPTIONS VALUES ('1677205870040154114', '1671406745336016898', '1671407539607171073', '重置密码', 'RESET_PASSWORD', TO_DATE('2023-07-07 14:40:15', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', TO_DATE('2023-07-07 15:09:43', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');
INSERT INTO SYS_MENU_OPTIONS VALUES ('1677205994816503809', '1671406745336016898', '1671407539607171073', '修改状态', 'UPDATE_USER_STATUS', TO_DATE('2023-07-07 14:40:45', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', TO_DATE('2023-07-07 15:09:46', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');
INSERT INTO SYS_MENU_OPTIONS VALUES ('1677212372381564929', '1671406745336016898', '1671407652933070850', '新增职位', 'ADD_POSITION', TO_DATE('2023-07-07 15:06:05', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', NULL, NULL);
INSERT INTO SYS_MENU_OPTIONS VALUES ('1677212407240425474', '1671406745336016898', '1671407652933070850', '修改职位', 'EDIT_POSITION', TO_DATE('2023-07-07 15:06:14', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', NULL, NULL);
INSERT INTO SYS_MENU_OPTIONS VALUES ('1677212448021643265', '1671406745336016898', '1671407652933070850', '删除职位', 'DELETE_POSITION', TO_DATE('2023-07-07 15:06:23', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', NULL, NULL);
INSERT INTO SYS_MENU_OPTIONS VALUES ('1677213466805501954', '1671406745336016898', '1671407615163363330', '修改机构', 'EDIT_ORG', TO_DATE('2023-07-07 15:10:26', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', NULL, NULL);
INSERT INTO SYS_MENU_OPTIONS VALUES ('1677213504298385410', '1671406745336016898', '1671407615163363330', '删除机构', 'DELETE_ORG', TO_DATE('2023-07-07 15:10:35', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', TO_DATE('2023-07-07 15:11:52', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');
INSERT INTO SYS_MENU_OPTIONS VALUES ('1677213572741038081', '1671406745336016898', '1671407615163363330', '设置审批人', 'ASSIGN_APPROVER', TO_DATE('2023-07-07 15:10:52', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', NULL, NULL);
INSERT INTO SYS_MENU_OPTIONS VALUES ('1677216034650685442', '1671406745336016898', '1671407892205531137', '新增应用', 'ADD_APP', TO_DATE('2023-07-07 15:20:38', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', NULL, NULL);
INSERT INTO SYS_MENU_OPTIONS VALUES ('1677216100685807617', '1671406745336016898', '1671407892205531137', '修改应用', 'EDIT_APP', TO_DATE('2023-07-07 15:20:54', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', NULL, NULL);
INSERT INTO SYS_MENU_OPTIONS VALUES ('1677216141127286786', '1671406745336016898', '1671407892205531137', '删除应用', 'DELETE_APP', TO_DATE('2023-07-07 15:21:04', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', NULL, NULL);
INSERT INTO SYS_MENU_OPTIONS VALUES ('1677223921938694145', '1671406745336016898', '1671407892205531137', '更新应用状态', 'UPDATE_APP_STATUS', TO_DATE('2023-07-07 15:51:59', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', NULL, NULL);
INSERT INTO SYS_MENU_OPTIONS VALUES ('1677228381343678466', '1671406745336016898', '1671407967690420226', '新增角色', 'ADD_ROLE', TO_DATE('2023-07-07 16:09:42', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', NULL, NULL);
INSERT INTO SYS_MENU_OPTIONS VALUES ('1677228480924844033', '1671406745336016898', '1671407967690420226', '删除角色', 'DELETE_ROLE', TO_DATE('2023-07-07 16:10:06', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', NULL, NULL);
INSERT INTO SYS_MENU_OPTIONS VALUES ('1677228556107743233', '1671406745336016898', '1671407967690420226', '修改角色', 'EDIT_ROLE', TO_DATE('2023-07-07 16:10:24', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', NULL, NULL);
INSERT INTO SYS_MENU_OPTIONS VALUES ('1677229379281846273', '1671406745336016898', '1671408081100206081', '修改权限', 'CHANGE_ROLE_PERMISSION', TO_DATE('2023-07-07 16:13:40', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', NULL, NULL);
INSERT INTO SYS_MENU_OPTIONS VALUES ('1678056521171140609', '1671406745336016898', '1673524865274245121', '新增字典', 'ADD_DICT', TO_DATE('2023-07-09 23:00:26', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', NULL, NULL);
INSERT INTO SYS_MENU_OPTIONS VALUES ('1678056564691238914', '1671406745336016898', '1673524865274245121', '修改字典', 'EDIT_DICT', TO_DATE('2023-07-09 23:00:36', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', NULL, NULL);
INSERT INTO SYS_MENU_OPTIONS VALUES ('1678056611675832321', '1671406745336016898', '1673524865274245121', '删除字典', 'DELETE_DICT', TO_DATE('2023-07-09 23:00:48', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', NULL, NULL);
INSERT INTO SYS_MENU_OPTIONS VALUES ('1680610475986931714', '1671406745336016898', '1671408081100206081', '修改数据权限', 'CHANGE_ROLE_DATA_SCOPE', TO_DATE('2023-07-17 00:08:56', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', NULL, NULL);
INSERT INTO SYS_MENU_OPTIONS VALUES ('1711189530448498690', '1671406745336016898', '1671408081100206081', '修改权限的权限范围', 'CHANGE_ROLE_BIND_LIMIT', NULL, NULL, NULL, NULL);

INSERT INTO SYS_PORTAL_USER_APP VALUES ('1678674927629168641', '1339550467939639299', '1671406669800796161', '1671407186899759106', TO_DATE('2023-07-11 15:57:46', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', NULL, NULL);
INSERT INTO SYS_PORTAL_USER_APP VALUES ('1678674927629168642', '1339550467939639299', '1671406745336016898', '1671407539607171073', TO_DATE('2023-07-11 15:57:46', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', NULL, NULL);
INSERT INTO SYS_PORTAL_USER_APP VALUES ('1678674927629168643', '1339550467939639299', '1671406745336016898', '1671408081100206081', TO_DATE('2023-07-11 15:57:46', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', NULL, NULL);
INSERT INTO SYS_PORTAL_USER_APP VALUES ('1678674927629168644', '1339550467939639299', '1671406745336016898', '1671408144094457858', TO_DATE('2023-07-11 15:57:46', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', NULL, NULL);
INSERT INTO SYS_PORTAL_USER_APP VALUES ('1678674927629168645', '1339550467939639299', '1671406745336016898', '1673524865274245121', TO_DATE('2023-07-11 15:57:46', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', NULL, NULL);
INSERT INTO SYS_PORTAL_USER_APP VALUES ('1678674927629168646', '1339550467939639299', '1671406745336016898', '1671407615163363330', TO_DATE('2023-07-11 15:57:46', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', NULL, NULL);
INSERT INTO SYS_PORTAL_USER_APP VALUES ('1678716885718315009', '1678652551806959618', '1671406669800796161', '1671407186899759106', TO_DATE('2023-07-11 18:44:29', 'SYYYY-MM-DD HH24:MI:SS'), '1678652551806959618', NULL, NULL);

INSERT INTO SYS_ROLE VALUES ('1671420545250439170', '后台管理员', 'backendAdmin', '10', '50', '1', NULL, 'Y', NULL, '1', 'N', TO_DATE('2023-06-21 15:47:12', 'SYYYY-MM-DD HH24:MI:SS'), '-1', NULL, NULL, '1');
INSERT INTO SYS_ROLE VALUES ('1671420608181776386', '普通人员', 'employee', '20', '50', '1', NULL, 'Y', NULL, '1', 'N', TO_DATE('2023-06-21 15:47:12', 'SYYYY-MM-DD HH24:MI:SS'), '-1', NULL, NULL, '1');

INSERT INTO SYS_ROLE_MENU VALUES ('1678716210741555201', '1671420608181776386', '1671406669800796161', '1671406619464953857', TO_DATE('2023-07-11 18:41:48', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', NULL, NULL);
INSERT INTO SYS_ROLE_MENU VALUES ('1678716210745749505', '1671420608181776386', '1671406669800796161', '1671407186899759106', TO_DATE('2023-07-11 18:41:48', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', NULL, NULL);
INSERT INTO SYS_ROLE_MENU VALUES ('1705156505331109890', '1671420545250439170', '1671406669800796161', '1671406619464953857', TO_DATE('2023-09-22 17:46:06', 'SYYYY-MM-DD HH24:MI:SS'), '-1', NULL, NULL);
INSERT INTO SYS_ROLE_MENU VALUES ('1705156505331109891', '1671420545250439170', '1671406669800796161', '1671407186899759106', TO_DATE('2023-09-22 17:46:06', 'SYYYY-MM-DD HH24:MI:SS'), '-1', NULL, NULL);
INSERT INTO SYS_ROLE_MENU VALUES ('1705156505331109892', '1671420545250439170', '1671406745336016898', '1671407312775016450', TO_DATE('2023-09-22 17:46:06', 'SYYYY-MM-DD HH24:MI:SS'), '-1', NULL, NULL);
INSERT INTO SYS_ROLE_MENU VALUES ('1705156505331109893', '1671420545250439170', '1671406745336016898', '1671407539607171073', TO_DATE('2023-09-22 17:46:06', 'SYYYY-MM-DD HH24:MI:SS'), '-1', NULL, NULL);
INSERT INTO SYS_ROLE_MENU VALUES ('1705156505398218754', '1671420545250439170', '1671406745336016898', '1671407615163363330', TO_DATE('2023-09-22 17:46:06', 'SYYYY-MM-DD HH24:MI:SS'), '-1', NULL, NULL);
INSERT INTO SYS_ROLE_MENU VALUES ('1705156505398218755', '1671420545250439170', '1671406745336016898', '1671407652933070850', TO_DATE('2023-09-22 17:46:06', 'SYYYY-MM-DD HH24:MI:SS'), '-1', NULL, NULL);
INSERT INTO SYS_ROLE_MENU VALUES ('1705156505398218756', '1671420545250439170', '1671406745336016898', '1671407791416406018', TO_DATE('2023-09-22 17:46:06', 'SYYYY-MM-DD HH24:MI:SS'), '-1', NULL, NULL);
INSERT INTO SYS_ROLE_MENU VALUES ('1705156505398218757', '1671420545250439170', '1671406745336016898', '1671407892205531137', TO_DATE('2023-09-22 17:46:06', 'SYYYY-MM-DD HH24:MI:SS'), '-1', NULL, NULL);
INSERT INTO SYS_ROLE_MENU VALUES ('1705156505398218758', '1671420545250439170', '1671406745336016898', '1671407967690420226', TO_DATE('2023-09-22 17:46:06', 'SYYYY-MM-DD HH24:MI:SS'), '-1', NULL, NULL);
INSERT INTO SYS_ROLE_MENU VALUES ('1705156505398218759', '1671420545250439170', '1671406745336016898', '1671408081100206081', TO_DATE('2023-09-22 17:46:06', 'SYYYY-MM-DD HH24:MI:SS'), '-1', NULL, NULL);
INSERT INTO SYS_ROLE_MENU VALUES ('1705156505398218760', '1671420545250439170', '1671406745336016898', '1671408144094457858', TO_DATE('2023-09-22 17:46:06', 'SYYYY-MM-DD HH24:MI:SS'), '-1', NULL, NULL);
INSERT INTO SYS_ROLE_MENU VALUES ('1705156505398218761', '1671420545250439170', '1671406745336016898', '1671408194501603329', TO_DATE('2023-09-22 17:46:06', 'SYYYY-MM-DD HH24:MI:SS'), '-1', NULL, NULL);
INSERT INTO SYS_ROLE_MENU VALUES ('1705156505398218762', '1671420545250439170', '1671406745336016898', '1673524613037191169', TO_DATE('2023-09-22 17:46:06', 'SYYYY-MM-DD HH24:MI:SS'), '-1', NULL, NULL);
INSERT INTO SYS_ROLE_MENU VALUES ('1705156505398218763', '1671420545250439170', '1671406745336016898', '1673524865274245118', TO_DATE('2023-09-22 17:46:06', 'SYYYY-MM-DD HH24:MI:SS'), '-1', NULL, NULL);
INSERT INTO SYS_ROLE_MENU VALUES ('1705156505398218764', '1671420545250439170', '1671406745336016898', '1673524865274245121', TO_DATE('2023-09-22 17:46:06', 'SYYYY-MM-DD HH24:MI:SS'), '-1', NULL, NULL);
INSERT INTO SYS_ROLE_MENU VALUES ('1705156505398218765', '1671420545250439170', '1671406745336016898', '1673524941069512706', TO_DATE('2023-09-22 17:46:06', 'SYYYY-MM-DD HH24:MI:SS'), '-1', NULL, NULL);
INSERT INTO SYS_ROLE_MENU VALUES ('1705156505398218766', '1671420545250439170', '1671406745336016898', '1673524966277279745', TO_DATE('2023-09-22 17:46:06', 'SYYYY-MM-DD HH24:MI:SS'), '-1', NULL, NULL);
INSERT INTO SYS_ROLE_MENU VALUES ('1705156505398218767', '1671420545250439170', '1671406745336016898', '1673525004151844865', TO_DATE('2023-09-22 17:46:06', 'SYYYY-MM-DD HH24:MI:SS'), '-1', NULL, NULL);
INSERT INTO SYS_ROLE_MENU VALUES ('1705156505398218768', '1671420545250439170', '1671406745336016898', '1673525357136080898', TO_DATE('2023-09-22 17:46:06', 'SYYYY-MM-DD HH24:MI:SS'), '-1', NULL, NULL);
INSERT INTO SYS_ROLE_MENU VALUES ('1705156505398218769', '1671420545250439170', '1671406745336016898', '1673525659931275265', TO_DATE('2023-09-22 17:46:06', 'SYYYY-MM-DD HH24:MI:SS'), '-1', NULL, NULL);
INSERT INTO SYS_ROLE_MENU VALUES ('1705156505398218770', '1671420545250439170', '1671406745336016898', '1673525723072327682', TO_DATE('2023-09-22 17:46:06', 'SYYYY-MM-DD HH24:MI:SS'), '-1', NULL, NULL);
INSERT INTO SYS_ROLE_MENU VALUES ('1705156505398218771', '1671420545250439170', '1671406745336016898', '1673525798674657282', TO_DATE('2023-09-22 17:46:06', 'SYYYY-MM-DD HH24:MI:SS'), '-1', NULL, NULL);
INSERT INTO SYS_ROLE_MENU VALUES ('1705156505398218772', '1671420545250439170', '1671406745336016898', '1673525912344489985', TO_DATE('2023-09-22 17:46:06', 'SYYYY-MM-DD HH24:MI:SS'), '-1', NULL, NULL);
INSERT INTO SYS_ROLE_MENU VALUES ('1705156505398218773', '1671420545250439170', '1671406745336016898', '1673526227621933057', TO_DATE('2023-09-22 17:46:06', 'SYYYY-MM-DD HH24:MI:SS'), '-1', NULL, NULL);
INSERT INTO SYS_ROLE_MENU VALUES ('1705156505398218774', '1671420545250439170', '1671406745336016898', '1673526479934484481', TO_DATE('2023-09-22 17:46:06', 'SYYYY-MM-DD HH24:MI:SS'), '-1', NULL, NULL);
INSERT INTO SYS_ROLE_MENU VALUES ('1705156505398218775', '1671420545250439170', '1671406745336016898', '1673526656565014530', TO_DATE('2023-09-22 17:46:06', 'SYYYY-MM-DD HH24:MI:SS'), '-1', NULL, NULL);
INSERT INTO SYS_ROLE_MENU VALUES ('1705156505398218776', '1671420545250439170', '1671406745336016898', '1673526946869571585', TO_DATE('2023-09-22 17:46:06', 'SYYYY-MM-DD HH24:MI:SS'), '-1', NULL, NULL);
INSERT INTO SYS_ROLE_MENU VALUES ('1705156505398218777', '1671420545250439170', '1671406745336016898', '1673527098267168769', TO_DATE('2023-09-22 17:46:06', 'SYYYY-MM-DD HH24:MI:SS'), '-1', NULL, NULL);
INSERT INTO SYS_ROLE_MENU VALUES ('1705156505398218778', '1671420545250439170', '1671406745336016898', '1673527401095917570', TO_DATE('2023-09-22 17:46:06', 'SYYYY-MM-DD HH24:MI:SS'), '-1', NULL, NULL);
INSERT INTO SYS_ROLE_MENU VALUES ('1705156505398218779', '1671420545250439170', '1671406745336016898', '1684222436082364417', TO_DATE('2023-09-22 17:46:06', 'SYYYY-MM-DD HH24:MI:SS'), '-1', NULL, NULL);

INSERT INTO SYS_ROLE_MENU_OPTIONS VALUES ('1671417849311211521', '1339550467939639303', '1671406745336016898', '1671407539607171073', '1671416717948006401', TO_DATE('2023-06-21 15:20:43', 'SYYYY-MM-DD HH24:MI:SS'), '-1', NULL, NULL);
INSERT INTO SYS_ROLE_MENU_OPTIONS VALUES ('1671417849311211522', '1339550467939639303', '1671406745336016898', '1671407539607171073', '1671416755763851265', TO_DATE('2023-06-21 15:20:43', 'SYYYY-MM-DD HH24:MI:SS'), '-1', NULL, NULL);
INSERT INTO SYS_ROLE_MENU_OPTIONS VALUES ('1678716210938687489', '1671420608181776386', '1671406669800796161', '1671406619464953857', '1677199976008040449', TO_DATE('2023-07-11 18:41:48', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', NULL, NULL);
INSERT INTO SYS_ROLE_MENU_OPTIONS VALUES ('1705156505465327618', '1671420545250439170', '1671406745336016898', '1671407539607171073', '1671416717948006401', TO_DATE('2023-09-22 17:46:06', 'SYYYY-MM-DD HH24:MI:SS'), '-1', NULL, NULL);
INSERT INTO SYS_ROLE_MENU_OPTIONS VALUES ('1705156505465327619', '1671420545250439170', '1671406745336016898', '1671407539607171073', '1671416755763851265', TO_DATE('2023-09-22 17:46:06', 'SYYYY-MM-DD HH24:MI:SS'), '-1', NULL, NULL);
INSERT INTO SYS_ROLE_MENU_OPTIONS VALUES ('1705156505465327620', '1671420545250439170', '1671406745336016898', '1671407615163363330', '1675495204221640706', TO_DATE('2023-09-22 17:46:06', 'SYYYY-MM-DD HH24:MI:SS'), '-1', NULL, NULL);
INSERT INTO SYS_ROLE_MENU_OPTIONS VALUES ('1705156505465327621', '1671420545250439170', '1671406669800796161', '1671406619464953857', '1677199976008040449', TO_DATE('2023-09-22 17:46:06', 'SYYYY-MM-DD HH24:MI:SS'), '-1', NULL, NULL);
INSERT INTO SYS_ROLE_MENU_OPTIONS VALUES ('1705156505465327622', '1671420545250439170', '1671406745336016898', '1671407539607171073', '1677205540070064129', TO_DATE('2023-09-22 17:46:06', 'SYYYY-MM-DD HH24:MI:SS'), '-1', NULL, NULL);
INSERT INTO SYS_ROLE_MENU_OPTIONS VALUES ('1705156505465327623', '1671420545250439170', '1671406745336016898', '1671407539607171073', '1677205784526684162', TO_DATE('2023-09-22 17:46:06', 'SYYYY-MM-DD HH24:MI:SS'), '-1', NULL, NULL);
INSERT INTO SYS_ROLE_MENU_OPTIONS VALUES ('1705156505465327624', '1671420545250439170', '1671406745336016898', '1671407539607171073', '1677205870040154114', TO_DATE('2023-09-22 17:46:06', 'SYYYY-MM-DD HH24:MI:SS'), '-1', NULL, NULL);
INSERT INTO SYS_ROLE_MENU_OPTIONS VALUES ('1705156505465327625', '1671420545250439170', '1671406745336016898', '1671407539607171073', '1677205994816503809', TO_DATE('2023-09-22 17:46:06', 'SYYYY-MM-DD HH24:MI:SS'), '-1', NULL, NULL);
INSERT INTO SYS_ROLE_MENU_OPTIONS VALUES ('1705156505465327626', '1671420545250439170', '1671406745336016898', '1671407652933070850', '1677212372381564929', TO_DATE('2023-09-22 17:46:06', 'SYYYY-MM-DD HH24:MI:SS'), '-1', NULL, NULL);
INSERT INTO SYS_ROLE_MENU_OPTIONS VALUES ('1705156505465327627', '1671420545250439170', '1671406745336016898', '1671407652933070850', '1677212407240425474', TO_DATE('2023-09-22 17:46:06', 'SYYYY-MM-DD HH24:MI:SS'), '-1', NULL, NULL);
INSERT INTO SYS_ROLE_MENU_OPTIONS VALUES ('1705156505465327628', '1671420545250439170', '1671406745336016898', '1671407652933070850', '1677212448021643265', TO_DATE('2023-09-22 17:46:06', 'SYYYY-MM-DD HH24:MI:SS'), '-1', NULL, NULL);
INSERT INTO SYS_ROLE_MENU_OPTIONS VALUES ('1705156505465327629', '1671420545250439170', '1671406745336016898', '1671407615163363330', '1677213466805501954', TO_DATE('2023-09-22 17:46:06', 'SYYYY-MM-DD HH24:MI:SS'), '-1', NULL, NULL);
INSERT INTO SYS_ROLE_MENU_OPTIONS VALUES ('1705156505465327630', '1671420545250439170', '1671406745336016898', '1671407615163363330', '1677213504298385410', TO_DATE('2023-09-22 17:46:06', 'SYYYY-MM-DD HH24:MI:SS'), '-1', NULL, NULL);
INSERT INTO SYS_ROLE_MENU_OPTIONS VALUES ('1705156505465327631', '1671420545250439170', '1671406745336016898', '1671407615163363330', '1677213572741038081', TO_DATE('2023-09-22 17:46:06', 'SYYYY-MM-DD HH24:MI:SS'), '-1', NULL, NULL);
INSERT INTO SYS_ROLE_MENU_OPTIONS VALUES ('1705156505465327632', '1671420545250439170', '1671406745336016898', '1671407892205531137', '1677216034650685442', TO_DATE('2023-09-22 17:46:06', 'SYYYY-MM-DD HH24:MI:SS'), '-1', NULL, NULL);
INSERT INTO SYS_ROLE_MENU_OPTIONS VALUES ('1705156505465327633', '1671420545250439170', '1671406745336016898', '1671407892205531137', '1677216100685807617', TO_DATE('2023-09-22 17:46:06', 'SYYYY-MM-DD HH24:MI:SS'), '-1', NULL, NULL);
INSERT INTO SYS_ROLE_MENU_OPTIONS VALUES ('1705156505465327634', '1671420545250439170', '1671406745336016898', '1671407892205531137', '1677216141127286786', TO_DATE('2023-09-22 17:46:06', 'SYYYY-MM-DD HH24:MI:SS'), '-1', NULL, NULL);
INSERT INTO SYS_ROLE_MENU_OPTIONS VALUES ('1705156505465327635', '1671420545250439170', '1671406745336016898', '1671407892205531137', '1677223921938694145', TO_DATE('2023-09-22 17:46:06', 'SYYYY-MM-DD HH24:MI:SS'), '-1', NULL, NULL);
INSERT INTO SYS_ROLE_MENU_OPTIONS VALUES ('1705156505465327636', '1671420545250439170', '1671406745336016898', '1671407967690420226', '1677228381343678466', TO_DATE('2023-09-22 17:46:06', 'SYYYY-MM-DD HH24:MI:SS'), '-1', NULL, NULL);
INSERT INTO SYS_ROLE_MENU_OPTIONS VALUES ('1705156505465327637', '1671420545250439170', '1671406745336016898', '1671407967690420226', '1677228480924844033', TO_DATE('2023-09-22 17:46:06', 'SYYYY-MM-DD HH24:MI:SS'), '-1', NULL, NULL);
INSERT INTO SYS_ROLE_MENU_OPTIONS VALUES ('1705156505465327638', '1671420545250439170', '1671406745336016898', '1671407967690420226', '1677228556107743233', TO_DATE('2023-09-22 17:46:06', 'SYYYY-MM-DD HH24:MI:SS'), '-1', NULL, NULL);
INSERT INTO SYS_ROLE_MENU_OPTIONS VALUES ('1705156505465327639', '1671420545250439170', '1671406745336016898', '1671408081100206081', '1677229379281846273', TO_DATE('2023-09-22 17:46:06', 'SYYYY-MM-DD HH24:MI:SS'), '-1', NULL, NULL);
INSERT INTO SYS_ROLE_MENU_OPTIONS VALUES ('1705156505465327640', '1671420545250439170', '1671406745336016898', '1673524865274245121', '1678056521171140609', TO_DATE('2023-09-22 17:46:06', 'SYYYY-MM-DD HH24:MI:SS'), '-1', NULL, NULL);
INSERT INTO SYS_ROLE_MENU_OPTIONS VALUES ('1705156505465327641', '1671420545250439170', '1671406745336016898', '1673524865274245121', '1678056564691238914', TO_DATE('2023-09-22 17:46:06', 'SYYYY-MM-DD HH24:MI:SS'), '-1', NULL, NULL);
INSERT INTO SYS_ROLE_MENU_OPTIONS VALUES ('1705156505465327642', '1671420545250439170', '1671406745336016898', '1673524865274245121', '1678056611675832321', TO_DATE('2023-09-22 17:46:06', 'SYYYY-MM-DD HH24:MI:SS'), '-1', NULL, NULL);
INSERT INTO SYS_ROLE_MENU_OPTIONS VALUES ('1705156505465327643', '1671420545250439170', '1671406745336016898', '1671408081100206081', '1680610475986931714', TO_DATE('2023-09-22 17:46:06', 'SYYYY-MM-DD HH24:MI:SS'), '-1', NULL, NULL);

INSERT INTO SYS_THEME VALUES ('1477272515573542913', 'Guns后台管理系统默认主题', '{"positionSort":1000,"themeId":"1477272515573542913","themeName":"Guns后台管理系统默认主题","templateId":"1477171926286020610","GUNS_MGR_LOGIN_BACKGROUND_IMG":"1704330515919671298","GUNS_MGR_BEI_URL":"https://beian.miit.gov.cn/","GUNS_MGR_LOGO":"1479753047148322818","GUNS_MGR_NAME":"Guns Tech.","GUNS_MGR_FAVICON":"1479753047148322818","GUNS_MGR_FOOTER_TEXT":"stylefeng开源技术 javaguns.com","GUNS_MGR_BEI_NO":"京ICP备001-1","GUNS_SUB_TITLE":"stylefeng开源技术"}', '1477171926286020610', 'Y', TO_DATE('2022-01-01 21:36:29', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', TO_DATE('2023-09-20 10:28:41', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');

INSERT INTO SYS_THEME_TEMPLATE VALUES ('1477171926286020610', 'Guns后台管理系统模板', 'GUNS_PLATFORM', '1', 'Y', TO_DATE('2022-01-01 14:56:46', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', TO_DATE('2022-01-01 15:11:27', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');

INSERT INTO SYS_THEME_TEMPLATE_FIELD VALUES ('1473949204011819009', '平台名称', 'GUNS_MGR_NAME', 'string', 'Y', '10', 'Guns后台管理系统左上角名称', TO_DATE('2021-12-23 17:30:50', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', TO_DATE('2022-01-01 14:30:42', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');
INSERT INTO SYS_THEME_TEMPLATE_FIELD VALUES ('1473949858369380354', '登录页背景图片', 'GUNS_MGR_LOGIN_BACKGROUND_IMG', 'file', 'Y', NULL, 'Guns后台管理系统登录页图片', TO_DATE('2021-12-23 17:33:26', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', TO_DATE('2022-01-01 14:32:14', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');
INSERT INTO SYS_THEME_TEMPLATE_FIELD VALUES ('1473950190365319169', '平台LOGO', 'GUNS_MGR_LOGO', 'file', 'Y', NULL, 'Guns后台管理系统左上角logo', TO_DATE('2021-12-23 17:34:45', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', TO_DATE('2022-01-01 14:46:07', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');
INSERT INTO SYS_THEME_TEMPLATE_FIELD VALUES ('1473950675281387521', '浏览器Icon', 'GUNS_MGR_FAVICON', 'file', 'Y', NULL, 'Guns后台管理系统标签栏图标', TO_DATE('2021-12-23 17:36:40', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', TO_DATE('2022-01-01 14:46:56', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');
INSERT INTO SYS_THEME_TEMPLATE_FIELD VALUES ('1473951200521494529', '页脚文字', 'GUNS_MGR_FOOTER_TEXT', 'string', 'Y', '100', 'Guns后台管理系统页脚文字', TO_DATE('2021-12-23 17:38:46', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', TO_DATE('2022-01-01 14:48:08', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');
INSERT INTO SYS_THEME_TEMPLATE_FIELD VALUES ('1473951616827138050', '备案号', 'GUNS_MGR_BEI_NO', 'string', 'N', '100', 'Guns后台管理系统底部备案号', TO_DATE('2021-12-23 17:40:25', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', TO_DATE('2022-01-01 14:48:46', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');
INSERT INTO SYS_THEME_TEMPLATE_FIELD VALUES ('1477170929413206017', '备案号跳转链接', 'GUNS_MGR_BEI_URL', 'string', 'N', '200', 'Guns后台管理系统备案号跳转到的链接', TO_DATE('2022-01-01 14:52:49', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', TO_DATE('2022-01-01 14:55:28', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');
INSERT INTO SYS_THEME_TEMPLATE_FIELD VALUES ('1713914194342457345', '平台副标题名称', 'GUNS_SUB_TITLE', 'string', 'N', NULL, NULL, NULL, NULL, NULL, NULL);

INSERT INTO SYS_THEME_TEMPLATE_REL VALUES ('1477175606452236290', '1477171926286020610', 'GUNS_MGR_NAME', TO_DATE('2022-01-01 15:11:24', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', NULL, NULL);
INSERT INTO SYS_THEME_TEMPLATE_REL VALUES ('1477175606519345154', '1477171926286020610', 'GUNS_MGR_LOGIN_BACKGROUND_IMG', TO_DATE('2022-01-01 15:11:24', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', NULL, NULL);
INSERT INTO SYS_THEME_TEMPLATE_REL VALUES ('1477175606519345155', '1477171926286020610', 'GUNS_MGR_LOGO', TO_DATE('2022-01-01 15:11:24', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', NULL, NULL);
INSERT INTO SYS_THEME_TEMPLATE_REL VALUES ('1477175606586454017', '1477171926286020610', 'GUNS_MGR_FAVICON', TO_DATE('2022-01-01 15:11:24', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', NULL, NULL);
INSERT INTO SYS_THEME_TEMPLATE_REL VALUES ('1477175606653562881', '1477171926286020610', 'GUNS_MGR_FOOTER_TEXT', TO_DATE('2022-01-01 15:11:24', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', NULL, NULL);
INSERT INTO SYS_THEME_TEMPLATE_REL VALUES ('1477175606720671746', '1477171926286020610', 'GUNS_MGR_BEI_NO', TO_DATE('2022-01-01 15:11:24', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', NULL, NULL);
INSERT INTO SYS_THEME_TEMPLATE_REL VALUES ('1477175606787780610', '1477171926286020610', 'GUNS_MGR_BEI_URL', TO_DATE('2022-01-01 15:11:24', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', NULL, NULL);
INSERT INTO SYS_THEME_TEMPLATE_REL VALUES ('1713921667560493058', '1477171926286020610', 'GUNS_SUB_TITLE', NULL, NULL, NULL, NULL);

INSERT INTO SYS_TIMERS VALUES ('1355878268976271362', '定时刷新服务器状态', 'cn.stylefeng.roses.kernel.monitor.system.holder.SystemHardwareInfoHolder', '0 0/1 * * * ? ', NULL, '1', '每1分钟执行一次，刷新服务器状态', 'N', TO_DATE('2021-01-31 21:59:05', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', TO_DATE('2021-01-31 22:00:23', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299');
INSERT INTO SYS_TIMERS VALUES ('1385068954897223681', '定时检测数据源的链接状态', 'cn.stylefeng.roses.kernel.dsctn.modular.timer.DataSourceStatusCheckTimer', '0/30 * * * * ? ', NULL, '1', NULL, 'N', TO_DATE('2021-04-22 11:12:27', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', NULL, NULL);

INSERT INTO SYS_USER VALUES ('1339550467939639299', '管理员', NULL, 'admin', 'ab94f1a029e3eda398cd054cdc3acfd7', '2dxzcmp9', '10000', TO_DATE('2020-12-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'), 'M', 'sn93@qq.com', '18266668888', NULL, 'Y', '1', '2', '127.0.0.1', TO_DATE('2023-07-11 18:44:49', 'SYYYY-MM-DD HH24:MI:SS'), '1', NULL, NULL, '2', 'N', TO_DATE('2020-12-17 20:40:31', 'SYYYY-MM-DD HH24:MI:SS'), '-1', TO_DATE('2023-05-23 11:34:38', 'SYYYY-MM-DD HH24:MI:SS'), '-1', '1');
INSERT INTO SYS_USER VALUES ('1678652551806959618', '张三', NULL, 'zhangsan', '5e4a4cd54816f15983b793f189fae871', 'ls79ab85', '10000', NULL, 'F', NULL, NULL, NULL, 'N', '1', '2', '127.0.0.1', TO_DATE('2023-07-11 18:44:18', 'SYYYY-MM-DD HH24:MI:SS'), '1000', NULL, NULL, '3', 'N', TO_DATE('2023-07-11 14:28:51', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', TO_DATE('2023-07-11 18:45:04', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', '1');

INSERT INTO SYS_USER_ORG VALUES ('1678717069600796673', '1678652551806959618', NULL, '1674675494710255617', NULL, '1671418731163627522', 'Y', NULL, TO_DATE('2023-07-11 18:45:13', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', NULL, NULL);
INSERT INTO SYS_USER_ORG VALUES ('1678717105206243330', '1339550467939639299', NULL, '1671419146928205826', NULL, '1671418831935975426', 'Y', NULL, TO_DATE('2023-07-11 18:45:22', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', NULL, NULL);

INSERT INTO SYS_USER_ROLE VALUES ('1673899829178261505', '1339550467939639299', '1671420545250439170', TO_DATE('2023-06-28 11:43:13', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', NULL, NULL);
INSERT INTO SYS_USER_ROLE VALUES ('1678716759805308929', '1678652551806959618', '1671420608181776386', TO_DATE('2023-07-11 18:43:59', 'SYYYY-MM-DD HH24:MI:SS'), '1339550467939639299', NULL, NULL);