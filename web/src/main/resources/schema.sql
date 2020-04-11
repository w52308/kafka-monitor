CREATE TABLE IF NOT EXISTS sys_admin (
    id INTEGER  PRIMARY key AUTOINCREMENT  ,--'主键'
    sys_role_id bigint(20) NOT NULL,--'角色id(sys_role表的主键)'
    username varchar(64)  NOT NULL ,--'管理员的登陆用户名'
    password varchar(128)  NOT NULL,--'管理员的登陆密码'
    name varchar(64)  NOT NULL ,--'管理员姓名'
    gender int NOT NULL ,--'性别(1: 男性, 0:女性)'
    phone_number varchar(64)  NOT NULL,--'手机号码'
    email varchar(128)  NOT NULL,--'邮件地址'
    remark varchar(256)  NOT NULL,--'备注'
    create_time timestamp default (strftime('%Y-%m-%d %H:%M:%f','now'))--'记录创建时间'
    );
CREATE TABLE IF NOT EXISTS sys_role (
    id INTEGER  PRIMARY key AUTOINCREMENT,--'主键'
    name varchar(64)  NOT NULL ,--'角色名称'
    super_admin int NOT NULL ,--'是否是超级管理员(1:是, 0:否)'
    remark varchar(256)  NOT NULL ,--'角色说明'
    create_time timestamp default (strftime('%Y-%m-%d %H:%M:%f','now'))--'记录创建时间'
    );
CREATE TABLE IF NOT EXISTS sys_page (
    id INTEGER  PRIMARY key AUTOINCREMENT,--'主键'
    name varchar(64)  NOT NULL,--'页面名称'
    url varchar(256)  NOT NULL  ,--'页面地址'
    is_menu int NOT NULL  ,--'页面是否出现在菜单栏'
    is_default int NOT NULL  ,--'是否是默认页(只允许有一个默认页，如果设置多个，以第一个为准)'
    is_blank int NOT NULL  ,--'是否新开窗口打开页面'
    icon_class varchar(64)  NOT NULL ,--'html中的图标样式'
    parent_id bigint(20) NOT NULL ,--'父级id(即本表的主键id)'
    order_num bigint(128) NOT NULL ,--'顺序号(值越小, 排名越靠前)'
    remark varchar(256)  NOT NULL  ,--'备注'
    create_time timestamp default (strftime('%Y-%m-%d %H:%M:%f','now'))--'记录创建时间'
    );
CREATE TABLE IF NOT EXISTS sys_permission (
    id INTEGER  PRIMARY key AUTOINCREMENT ,-- '主键'
    sys_role_id bigint(20) NOT NULL  ,--'sys_role的主键id'
    sys_page_id bigint(20) NOT NULL  ,--'sys_page的主键id'
    can_insert int NOT NULL  ,--'是否能新增(true:能, false:不能)'
    can_delete int NOT NULL  ,--'是否能删除(true:能, false:不能)'
    can_update int NOT NULL  ,--'是否能修改(true:能, false:不能)'
    can_select int NOT NULL  ,--'是否能读取(true:能, false:不能)'
    create_time timestamp default (strftime('%Y-%m-%d %H:%M:%f','now'))--'记录创建时间'
    );
CREATE TABLE IF NOT EXISTS sys_lag (
    id INTEGER  PRIMARY key AUTOINCREMENT ,--'主键'
    consumer_name varchar(256)  NOT NULL  ,--'消费者名称'
    topic_name varchar(256)  NOT NULL  ,--'消费者订阅的主题名称'
    offset bigint(10) NOT NULL  ,--'当前消费的偏移量位置'
    lag bigint(10) NOT NULL  ,--'消息堆积数量'
    create_time timestamp default (strftime('%Y-%m-%d %H:%M:%f','now')) --'记录创建时间'
    );
CREATE TABLE IF NOT EXISTS sys_log_size (
    id INTEGER  PRIMARY key AUTOINCREMENT   ,--'主键'
    topic_name varchar(256)  NOT NULL  ,--'主题名称'
    log_size bigint(20) NOT NULL  ,--'主题对应的信息数量'
    create_time timestamp default (strftime('%Y-%m-%d %H:%M:%f','now')) --'记录创建时间'
    );
CREATE TABLE IF NOT EXISTS sys_kpi(
    id INTEGER  PRIMARY key AUTOINCREMENT   ,--'主键'
    host varchar(256)  NOT NULL  ,--'kpi的主机信息'
    kpi int(10) NOT NULL  ,--'kpi指标名称'
    value double NOT NULL  ,--'kpi值'
    create_time timestamp default (strftime('%Y-%m-%d %H:%M:%f','now'))--'记录创建时间'
    );
CREATE TABLE IF NOT EXISTS sys_mail_config(
    id INTEGER  PRIMARY key AUTOINCREMENT  ,-- '主键'
    host varchar(128)  NOT NULL  ,--'邮箱服务器地址'
    port varchar(32)  NOT NULL  ,--'邮箱服务器端口'
    username varchar(128)  NOT NULL  ,--'邮箱服务器用户名'
    password varchar(128)  NOT NULL  ,--'邮箱服务器密码'
    create_time timestamp default (strftime('%Y-%m-%d %H:%M:%f','now'))-- '记录创建时间'
    );
CREATE TABLE IF NOT EXISTS sys_alert_cluster(
    id INTEGER  PRIMARY key AUTOINCREMENT   ,--'主键'
    type int(10) NOT NULL  ,--'集群主机类型(1. zookeeper, 2: kafka)'
    server varchar(32)  NOT NULL  ,--'服务器地址'
    email varchar(128)  NOT NULL  ,--'警报邮件的发送地址'
    create_time timestamp default (strftime('%Y-%m-%d %H:%M:%f','now')) --'记录创建时间'
    );
CREATE TABLE IF NOT EXISTS sys_alert_consumer(
    id INTEGER  PRIMARY key AUTOINCREMENT   ,--'主键'
    group_id varchar(128)  NOT NULL  ,--'消费组名称'
    topic_name varchar(128)  NOT NULL  ,--'消费组对应的主题名称'
    lag_threshold bigint(20) NOT NULL  ,--'消息积压的数量阀值，超过这个阀值则会触发报警'
    email varchar(128)  NOT NULL  ,--'警报邮件的发送地址'
    create_time timestamp default (strftime('%Y-%m-%d %H:%M:%f','now'))--'记录创建时间'
    );
CREATE TABLE IF NOT EXISTS sys_alert_topic (
    id INTEGER  PRIMARY key AUTOINCREMENT   ,--'主键'
    topic_name varchar(128)  NOT NULL  ,--'主题名称'
    from_time varchar(32)  NULL DEFAULT NULL  ,--'监听主题的开始时间'
    to_time varchar(32)  NULL DEFAULT NULL  ,--'监听主题的结束时间'
    from_tps int(11) NULL DEFAULT NULL  ,--'主题发送消息的TPS下限'
    to_tps int(11) NULL DEFAULT NULL  ,--'主题发送消息的TPS上限'
    from_mom_tps int(11) NULL DEFAULT NULL  ,--'主题发送消息的TPS变化下限'
    to_mom_tps int(11) NULL DEFAULT NULL  ,--'主题发送消息的TPS变化上限'
    email varchar(128)  NULL DEFAULT NULL  ,--'警报邮件的发送地址'
    create_time timestamp default (strftime('%Y-%m-%d %H:%M:%f','now'))--'记录创建时间'
    );
    INSERT INTO sys_admin(id,
    sys_role_id, username, password, name, gender, phone_number, email, remark, create_time)
    VALUES
    (1, 1, 'admin', 'ebc255e6a0c6711a4366bc99ebafb54f' , '系统管理员', 1, '', 'zhangningkid@163.com', '',
    strftime('%Y-%m-%d %H:%M:%f','now'));
    INSERT INTO sys_role(id, name,
    super_admin, remark, create_time) VALUES (1, '超级管理员', 1, '超级管理员, 拥有最高权限', strftime('%Y-%m-%d %H:%M:%f','now'));
    INSERT INTO sys_page(id, name, url,
    is_menu, is_default, is_blank, icon_class, parent_id, order_num, remark, create_time) VALUES (1,
    '仪表盘', '/dashboard/index', 1, 1, 0, 'layui-icon-engine', 0, 1, '', strftime('%Y-%m-%d %H:%M:%f','now'));
    INSERT INTO sys_page(id, name, url,
    is_menu, is_default, is_blank, icon_class, parent_id, order_num, remark, create_time) VALUES (2,
    '集群', '/cluster/tolist', 1, 0, 0, 'layui-icon-share', 0, 2, '', strftime('%Y-%m-%d %H:%M:%f','now'));
    INSERT INTO sys_page(id, name, url,
    is_menu, is_default, is_blank, icon_class, parent_id, order_num, remark, create_time) VALUES (3,
    '主题', '/topic/tolist', 1, 0, 0, 'layui-icon-dialogue', 0, 3, '', strftime('%Y-%m-%d %H:%M:%f','now'));
    INSERT INTO sys_page(id, name, url,
    is_menu, is_default, is_blank, icon_class, parent_id, order_num, remark, create_time) VALUES (4,
    '消息跟踪', '/record/tolist', 1, 0, 0, 'layui-icon-list', 0, 4, '', strftime('%Y-%m-%d %H:%M:%f','now'));
    INSERT INTO sys_page(id, name, url,
    is_menu, is_default, is_blank, icon_class, parent_id, order_num, remark, create_time) VALUES (5,
    '消费者', '/consumer/tolist', 1, 0, 0, 'layui-icon-group', 0, 5, '', strftime('%Y-%m-%d %H:%M:%f','now'));
    INSERT INTO sys_page(id, name, url,
    is_menu, is_default, is_blank, icon_class, parent_id, order_num, remark, create_time) VALUES (6,
    'ZooKeeper客户端', '/zkCli/tolist', 1, 0, 0, 'layui-icon-util', 0, 6, '', strftime('%Y-%m-%d %H:%M:%f','now'));
    INSERT INTO sys_page(id, name, url,
    is_menu, is_default, is_blank, icon_class, parent_id, order_num, remark, create_time) VALUES (7,
    '性能指标', '', 1, 0, 0, 'layui-icon-console', 0, 7, '', strftime('%Y-%m-%d %H:%M:%f','now'));
    INSERT INTO sys_page(id, name, url,
    is_menu, is_default, is_blank, icon_class, parent_id, order_num, remark, create_time) VALUES (8,
    'ZooKeeper性能', '/zkperformance/tolist', 1, 0, 0, '', 7, 1, '', strftime('%Y-%m-%d %H:%M:%f','now'));
    INSERT INTO sys_page(id, name, url,
    is_menu, is_default, is_blank, icon_class, parent_id, order_num, remark, create_time) VALUES (9,
    'Kafka性能', '/kafkaperformance/tolist', 1, 0, 0, '', 7, 2, '', strftime('%Y-%m-%d %H:%M:%f','now'));
    INSERT INTO sys_page(id, name, url,
    is_menu, is_default, is_blank, icon_class, parent_id, order_num, remark, create_time) VALUES
    (10, '警告设置','', 1, 0, 0, 'layui-icon-notice', 0, 8, '', strftime('%Y-%m-%d %H:%M:%f','now'));
    INSERT INTO sys_page(id, name, url,
    is_menu, is_default, is_blank, icon_class, parent_id, order_num, remark, create_time) VALUES
    (11, '主题TPS设置', '/alerttopic/tolist', 1, 0, 0, '', 10, 1, '', strftime('%Y-%m-%d %H:%M:%f','now'));
    INSERT INTO sys_page(id, name, url,
    is_menu, is_default, is_blank, icon_class, parent_id, order_num, remark, create_time) VALUES
    (12, '消费组设置', '/alertconsumer/tolist', 1, 0, 0, '', 10, 2, '', strftime('%Y-%m-%d %H:%M:%f','now'));
    INSERT INTO sys_page(id, name, url,
    is_menu, is_default, is_blank, icon_class, parent_id, order_num, remark, create_time) VALUES
    (13, '集群主机设置', '/alertcluster/tolist', 1, 0, 0, '', 10, 3, '', strftime('%Y-%m-%d %H:%M:%f','now'));
    INSERT INTO sys_page(id, name, url,
    is_menu, is_default, is_blank, icon_class, parent_id, order_num, remark, create_time) VALUES
    (14, '权限设置', '', 1, 0, 0, 'layui-icon-password', 0, 9, '', strftime('%Y-%m-%d %H:%M:%f','now'));
    INSERT INTO sys_page(id, name, url,
    is_menu, is_default, is_blank, icon_class, parent_id, order_num, remark, create_time) VALUES
    (15, '管理员配置', '/admin/tolist', 1, 0, 0, '', 14, 1, '', strftime('%Y-%m-%d %H:%M:%f','now'));
    INSERT INTO sys_page(id, name, url,
    is_menu, is_default, is_blank, icon_class, parent_id, order_num, remark, create_time) VALUES
    (16, '角色管理', '/role/tolist', 1, 0, 0, '', 14, 2, '', strftime('%Y-%m-%d %H:%M:%f','now'));
    INSERT INTO sys_page(id, name, url,
    is_menu, is_default, is_blank, icon_class, parent_id, order_num, remark, create_time) VALUES
    (17, '权限管理', '/permission/tolist', 1, 0, 0, '', 14, 3, '', strftime('%Y-%m-%d %H:%M:%f','now'));
    INSERT INTO sys_page(id, name, url,
    is_menu, is_default, is_blank, icon_class, parent_id, order_num, remark, create_time) VALUES
    (18, '系统设置', '', 1, 0, 0, 'layui-icon-set', 0, 10, '', strftime('%Y-%m-%d %H:%M:%f','now'));
    INSERT INTO sys_page(id, name, url,
    is_menu, is_default, is_blank, icon_class, parent_id, order_num, remark, create_time) VALUES
    (19, '页面配置', '/page/tolist', 1, 0, 0, '', 18, 1, '', strftime('%Y-%m-%d %H:%M:%f','now'));
    INSERT INTO sys_page(id, name, url,
    is_menu, is_default, is_blank, icon_class, parent_id, order_num, remark, create_time) VALUES
    (20, '邮件发送设置', '/mailconfig/tolist', 1, 0, 0, '', 18, 2, '', strftime('%Y-%m-%d %H:%M:%f','now'));
    INSERT INTO sys_page(id, name, url,
    is_menu, is_default, is_blank, icon_class, parent_id, order_num, remark, create_time) VALUES
    (21, '钉钉机器人设置', '/dingdingconfig/tolist', 1, 0, 0, '', 18, 3, '', strftime('%Y-%m-%d %H:%M:%f','now'));
    INSERT INTO sys_page(id, name, url,
    is_menu, is_default, is_blank, icon_class, parent_id, order_num, remark, create_time) VALUES
    (22, '大屏幕', '/bigscreen/tolist', 1, 0, 1, 'layui-icon-chart-screen', 0, 11, '', strftime('%Y-%m-%d %H:%M:%f','now'));
CREATE UNIQUE INDEX idx_topic_name ON sys_alert_consumer (topic_name);
CREATE UNIQUE INDEX idx_group_id_topic_name ON sys_alert_consumer (group_id,topic_name);
CREATE UNIQUE INDEX idx_type_server ON sys_alert_cluster (type,server);
CREATE INDEX sys_kpi_idx_create_time ON sys_kpi (create_time);
CREATE INDEX idx_kpi ON sys_kpi (kpi);
CREATE INDEX sys_log_size_idx_create_time ON sys_log_size (create_time);
CREATE UNIQUE INDEX idx_topic_name_create_time ON sys_log_size (topic_name,create_time);
CREATE INDEX sys_lag_idx_create_time ON sys_lag (create_time);
CREATE INDEX idx_consumer_name_topic_name ON sys_lag (consumer_name,topic_name);
CREATE INDEX idx_sys_role_id_sys_page_id ON sys_permission (sys_role_id,sys_page_id);
CREATE INDEX idx_url ON sys_page (url);
CREATE UNIQUE INDEX idx_name ON sys_role (name);
CREATE UNIQUE INDEX idx_username ON sys_admin (username);
CREATE INDEX idx_sys_role_id ON sys_admin (sys_role_id);