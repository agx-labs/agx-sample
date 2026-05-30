package com.agx.sample.api.pojo.bo;

import com.alibaba.excel.annotation.ExcelProperty;
import lombok.Data;

/**
 * 演示Excel导入BO
 * <p></p>
 *
 * @author gengchen
 * @since 2026/5/30 19:49
 */
@Data
public class DemoTestExcelBO {

    @ExcelProperty("ID")
    private String id;

    @ExcelProperty("状态")
    private String status;
}
