// -------------------------------------------------------
// title: 异步时钟选择器
// author: Clark @https://github.com/MasterPu2020
// copyright: 备注原作者的条件下自由转载
// features: 两级D-type异步处理
// version: 1.0
// version update: 2023/8/27
// -------------------------------------------------------

module clk_mux(
    input clk0, clk1, sel,
    input nrst,
    output clk
);

    logic clk0_sync0, clk0_sync1, clk1_sync0, clk1_sync1; // D-type 触发器

    // 一级
    always_ff @(posedge clk0, negedge nrst)
        if (nrst)
            clk0_sync0 <= 0;
        else
            clk0_sync0 <= ~clk1_sync1 & ~sel;
    
    always_ff @(posedge clk1, negedge nrst)
        if (nrst)
            clk1_sync0 <= 0;
        else
            clk1_sync0 <= ~clk0_sync1 & sel;

    // 二级
    // 下降沿触发可综合为clk接反相器, 或特殊的触发器cell
    // 根据需求更改以得到想要的综合结果
    always_ff @(negedge clk0, negedge nrst)
        if (nrst)
            clk0_sync1 <= 0;
        else
            clk0_sync1 <= clk0_sync0;

    always_ff @(negedge clk1, negedge nrst)
        if (nrst)
            clk1_sync1 <= 0;
        else
            clk1_sync1 <= clk1_sync0;

    // 输出
    assign clk = (clk0 & clk0_sync1) | (clk1 & clk1_sync1);

endmodule
