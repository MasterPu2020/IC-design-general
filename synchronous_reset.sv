// -------------------------------------------------------
// title: 异步复位, 同步释放
// author: Clark @https://github.com/MasterPu2020
// copyright: 备注原作者的条件下自由转载
// features: 常规ASIC复位设计
// version: 1.0
// version update: 2023/8/27
// -------------------------------------------------------

module synchronous_reset(
    input clk,
    input clr,
    output sys_rst
);

    logic nrst_sync0, nrst_sync1;

    always @(posedge clk, posedge clr)
        if(clr)begin
            nrst_sync0 <= 1;
            nrst_sync1 <= 1;
        end
        else begin
            nrst_sync0 <= 0;
            nrst_sync1 <= nrst_sync0;
        end

    assign sys_rst = nrst_sync1;

endmodule
