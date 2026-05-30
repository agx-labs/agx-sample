package com.agx.sample.api.pojo.request;

import cn.stylefeng.roses.kernel.rule.pojo.request.BaseRequest;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;
import org.springframework.web.multipart.MultipartFile;

/**
 * 演示请求对象
 * <p></p>
 *
 * @author gengchen
 * @since 2026/5/25
 */
@Data
@EqualsAndHashCode(callSuper = true)
@Accessors(chain = true)
public class DemoTestRequest extends BaseRequest {

    /**
     * 文件
     */
    private MultipartFile file;

    /**
     * id
     */
    @NotNull(message = "缺少唯一标识", groups = {delete.class, edit.class})
    private Long id;

    /**
     * 状态
     */
    private Integer status;
}
