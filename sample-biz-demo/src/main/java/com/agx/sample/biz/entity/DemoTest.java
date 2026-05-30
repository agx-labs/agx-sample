package com.agx.sample.biz.entity;

import cn.stylefeng.roses.kernel.db.api.pojo.entity.BaseEntity;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;

/**
 * 演示实体
 * <p></p>
 *
 * @author gengchen
 * @since 2026/5/25
 */
@EqualsAndHashCode(callSuper = true)
@TableName
@Data
@Accessors(chain = true)
public class DemoTest extends BaseEntity {

    /**
     * id
     */
    @TableId(type = IdType.ASSIGN_ID)
    private Long id;

    /**
     * 状态
     */
    private Integer status;
}