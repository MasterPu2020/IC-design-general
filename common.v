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

// 二分频
module div2 (
    input clk, nrst,
    output reg clk2
);
    
    always @(posedge clk, negedge nrst)
        if (~ nrst)
            clk2 <= 0;
        else
            clk2 = ~ clk2;

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

//
module template1 (
    input clk, nrst,
    output reg result
);

    always @(posedge clk, negedge nrst) 
        if (~ nrst)begin

        end
        else begin
            
        end

endmodule