package com.agx.sample.api.pojo.dto;

import cn.stylefeng.roses.kernel.rule.pojo.response.BaseResponse;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;

/**
 * 演示返回对象
 * <p></p>
 *
 * @author gengchen
 * @since 2026/5/25
 */
@EqualsAndHashCode(callSuper = true)
@Data
@Accessors(chain = true)
public class DemoTestDTO extends BaseResponse {
    /**
     * id
     */
    private Long id;

    /**
     * 状态
     */
    private Integer status;
}
