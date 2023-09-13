// -------------------------------------------------------
// title: 常见的笔试题
// author: Clark @https://github.com/MasterPu2020
// copyright: 备注原作者的条件下自由转载
// version: 1.0
// version update: 2023/9/11
// -------------------------------------------------------

module template (
    input clk, nrst,
    output reg result
);

    always @(posedge clk, negedge nrst) 
        if (~ nrst)begin
            
        end
        else begin
            
        end

endmodule

// 统计1024连续8bit输入直方图，实时输出当前出现最多的数字
module counter (
    input clk, nrst, write,
    input [7:0] data,
    output reg [7:0] data_most
);

    reg [7:0] ram [1023:0];
    reg [7:0] present_data;
    reg [9:0] last_appear_most, present_appear, write_addr, lookup_addr;

    always @(posedge clk, negedge nrst) // FIFO style write
        if (~nrst) begin
            write_addr <= 0;
        end
        else if (write) begin
            write_addr <= write_addr + 1;
            ram[write_addr] <= data;
        end
    
    always @(posedge clk, negedge nrst) // running counting
        if (~nrst) begin
            last_appear_most <= 0;
            present_appear <= 0;
            data_most <= 0;
            present_data <= 0;
            lookup_addr <= 0;
        end
        else begin
            if (present_data == ram[lookup_addr])
                present_appear <= present_appear + 1;
            if (lookup_addr == 1023) begin
                lookup_addr <= 0;
                present_data <= present_data + 1;
                if (present_appear > last_appear_most)
                    last_appear_most <= present_appear;
                    data_most <= present_data;
            end
            else begin
                lookup_addr <= lookup_addr + 1;
            end
        end

endmodule

// booth乘法器
module booth_multipiler (
    input clk, nrst,
    input [7:0] multiplicant, multipiler,
    output reg [14:0] result
);
    
endmodule

// 二分频
module clk_div2 (
    input clk, nrst,
    output reg clk2);
    
    always @(posedge clk, negedge nrst)
        if (~ nrst)
            clk2 <= 0;
        else
            clk2 = ~ clk2;
endmodule

// 计数器分频, 奇偶通用
module clk_cnt_div #(parameter N = 7) (
    input clk, nrst,
    output reg clk_out);

    localparam HALF = N/2;
    reg [$clog2(N)-1:0] cnt;

    always @(posedge clk, negedge nrst) 
        if (~ nrst)begin
            cnt <= 0;
            clk_out <= 0;
        end
        else begin
            if (cnt != N) 
                cnt <= cnt + 1;
            else 
                cnt <= 0;
            if (cnt == HALF) 
                clk_out <= ~clk_out;
            else if (cnt == 0) 
                clk_out <= ~clk_out;
        end
endmodule

// 奇数均分频
module clk_odd_div #(parameter N = 7)(
    input clk, nrst,
    output clk_out);

    localparam HALF = N/2;
    reg [$clog2(HALF)-1:0] cnt_rise, cnt_fall;
    reg clk_rise, clk_fall;

    always @(posedge clk, negedge nrst) 
        if (~ nrst) begin
            cnt_rise <= 0;
        end
        else if (cnt_rise != HALF)
            cnt_rise <= cnt_rise + 1;
        else begin
            cnt_rise <= 0;
            clk_rise <= ~clk_rise;
        end

    always @(negedge clk, negedge nrst) 
        if (~ nrst) begin
            cnt_fall <= 0;
            clk_fall <= 0;
        end
        else if (cnt_fall != HALF)
            cnt_fall <= cnt_fall + 1;
        else begin
            cnt_fall <= 0;
            clk_fall <= ~clk_fall;
        end

    assign clk_out = clk_rise | clk_fall;
endmodule

// M / N 分频电路: 必须是小数 (M个周期产生N个脉冲)
module m_div_n_clk #(parameter M = 7, N = 3)(
    input clk_in, nrst,
    output reg clk_out);

    localparam 
        SLOW_FREQ_DIV = $rtoi(M * 1.0 / N),
        FAST_FREQ_DIV = SLOW_FREQ_DIV + 1,
        // CNT_CYCLE1 + CNT_CYCLE2 = N 
        // 且 SLOW_FREQ_DIV * CNT_CYCLE1 + FAST_FREQ_DIV * CNT_CYCLE2 = M
        CNT_CYCLE1 = $rtoi((M - SLOW_FREQ_DIV * N) * 1.0 / (FAST_FREQ_DIV - SLOW_FREQ_DIV)),
        CNT_CYCLE2 = N - CNT_CYCLE1,
        HALF = SLOW_FREQ_DIV * CNT_CYCLE1;

    reg [$clog2(M)-1:0] m_cnt;
    reg [$clog2(SLOW_FREQ_DIV)-1:0] div_cnt1;
    reg [$clog2(FAST_FREQ_DIV)-1:0] div_cnt2;

    // M个周期进行计数
    always @(posedge clk_in, negedge nrst) 
        if (~ nrst)
            m_cnt <= 0;
        else begin
            if (m_cnt != M)
                m_cnt <= m_cnt + 1;
            else
                m_cnt <= 0;
        end

    // 2个奇偶通用分频计数器，分阶段启用
    always @(posedge clk_in, negedge nrst) 
        if (~ nrst)begin
            div_cnt1 <= 0;
            div_cnt2 <= 0;
            clk_out <= 0;
        end
        else begin
            if (m_cnt < HALF) begin
                div_cnt2 <= 0;
                if (div_cnt1 != CNT_CYCLE1) 
                    div_cnt1 <= div_cnt1 + 1;
                else 
                    div_cnt1 <= 0;
                if (div_cnt1 == CNT_CYCLE1/2) 
                    clk_out <= ~clk_out;
                else if (div_cnt1 == 0) 
                    clk_out <= ~clk_out;
            end
            else begin
                div_cnt1 <= 0;
                if (div_cnt2 != CNT_CYCLE2) 
                    div_cnt2 <= div_cnt2 + 1;
                else 
                    div_cnt2 <= 0;
                if (div_cnt2 == CNT_CYCLE2/2) 
                    clk_out <= ~clk_out;
                else if (div_cnt2 == 0) 
                    clk_out <= ~clk_out;
            end
        end
endmodule
