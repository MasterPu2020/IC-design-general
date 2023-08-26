// -------------------------------------------------------
// title: 异步FIFO
// author: Clark @https://github.com/MasterPu2020
// copyright: 备注原作者的条件下自由转载
// features: 随机访问, 双向任意时钟, 单周期读写, System Verilog编写
// version: 1.0
// version update: 2023/8/26
// -------------------------------------------------------

`define FAST2SLOW // 若非快时钟域到慢时钟域的设计, 注释该行
`define SLOW2FAST_DEPTH 8 // 若是慢时钟域到快时钟域的设计, 在这里自定义FIFO深度

module asynchronous_fifo #(
        parameter 
        DATA_SIZE = 32, // 定义FIFO数据宽度
        BURST_LENGTH = 50, // 单次突发访问的最大数据量
        W_CLK_FEQ = 100_000_000, // Hz 定义写时钟频率
        R_CLK_FEQ = 50_000_000, // Hz 定义读时钟频率
        W_IDLE_CYC = 0, // 定义写空闲周期
        R_IDLE_CYC = 0  // 定义读空闲周期
    )(
        input  w_clk, r_clk, nrst,
        input  w_en, r_en,
        output full, empty,
        input  wire [DATA_SIZE-1:0] w_data,
        output wire [DATA_SIZE-1:0] r_data
    );

    timeprecision 10ps; timeunit 1ns;

    // 根据需求计算FIFO深度
    `ifdef FAST2SLOW
        parameter DATA_DEPTH = int'(BURST_LENGTH - (W_IDLE_CYC + 1) * (1.0 / W_CLK_FEQ) * (1.0 / (W_IDLE_CYC + 1) * (1.0 / R_CLK_FEQ))),
    `else
        DATA_DEPTH = `SLOW2FAST_DEPTH,
    `endif
    ADDR_SIZE = $clog2(DATA_DEPTH);

    logic [ADDR_SIZE-1:0] w_addr, r_addr; // 读写地址
    wire  [ADDR_SIZE-1:0] w_addr_gary, r_addr_gary; // 读写地址格雷码
    logic [ADDR_SIZE-1:0] w_addr_sync0, w_addr_sync1, r_addr_sync0, r_addr_sync1; // 两级同步D-type
    
    logic [DATA_SIZE-1:0] memory [DATA_DEPTH:0]; // 寄存器堆

    // 读写地址数据交换的异步处理
    always_ff @(posedge w_clk, negedge nrst) begin : sync_write2read
        if (~nrst) begin
            w_addr_sync0 <= #1 0;
            w_addr_sync1 <= #1 0;
        end
        else begin
            w_addr_sync0 <= #1 r_addr_gary;
            w_addr_sync1 <= #1 w_addr_sync0;
        end
    end

    always_ff @(posedge r_clk, negedge nrst) begin : sync_read2write
        if (~nrst) begin
            r_addr_sync0 <= #1 0;
            r_addr_sync1 <= #1 0;
        end
        else begin
            r_addr_sync0 <= #1 w_addr_gary;
            r_addr_sync1 <= #1 r_addr_sync0;
        end
    end

    // 读FIFO
    assign r_addr_gary = (r_addr >> 1) ^ r_addr; // 格雷编码
    assign empty = w_addr_sync1 == r_addr_gary;
    assign r_data = memory[r_addr];
    always_ff @(posedge r_clk, negedge nrst) begin : read_fifo
        if (~nrst)
            r_addr <= #1 0;
        else if (r_en & ~empty)
            r_addr <= #1 r_addr + 1;
    end

    // 写FIFO
    assign w_addr_gary = (w_addr >> 1) ^ w_addr; // 格雷编码
    assign full = r_addr_sync1 == w_addr_gary;
    always_ff @(posedge w_clk, negedge nrst) begin : write_fifo
        if (~nrst) 
            w_addr <= #1 0;
        else if (w_en & ~full) begin
            w_addr <= #1 w_addr + 1;
            memory[w_addr] <= #1 w_data;
        end
    end
endmodule

`define Stimulus // 启用激励模块, 简易debugging, 综合时请注释该行

`ifdef Stimulus
module stim_fifo;
    timeprecision 10ps; timeunit 1ns;
    logic w_clk, r_clk, nrst;
    logic w_en, r_en;
    logic full, empty;
    logic [31:0] w_data;
    logic [31:0] r_data;
    parameter
        DATA_SIZE = 32, // 定义FIFO数据宽度
        BURST_LENGTH = 50, // 单次突发访问的最大数据量
        W_CLK_FEQ = 100_000_000, // Hz 定义写时钟频率
        R_CLK_FEQ = 50_000_000, // Hz 定义读时钟频率
        W_IDLE_CYC = 0, // 定义写空闲周期
        R_IDLE_CYC = 0; // 定义读空闲周期

    asynchronous_fifo #( 
        DATA_SIZE,
        BURST_LENGTH,
        W_CLK_FEQ,
        R_CLK_FEQ,
        W_IDLE_CYC,
        R_IDLE_CYC
    ) asynchronous_fifo (.*);
    
    initial begin : initiation
        w_clk = 0;
        r_clk = 0;
        nrst = 1;
        w_en = 1;
        r_en = 1;
        w_data = 0;
        fork
            forever #(1000_000_000/W_CLK_FEQ) w_clk = ~w_clk;
            forever #(1000_000_000/R_CLK_FEQ) r_clk = ~r_clk;
        join
    end

    initial begin // 进行一次Burst传输
        repeat (BURST_LENGTH) begin
            @(negedge w_clk) w_data = w_data + 1;
            repeat (W_IDLE_CYC) @(negedge w_clk);
        end
        $finish(2);
    end

endmodule
`endif