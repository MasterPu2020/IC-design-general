// -------------------------------------------------------
// title: Verilog IEEE 2001 Standard
// author: Clark @https://github.com/MasterPu2020
// copyright: 备注原作者的条件下自由转载
// features: 不常见的语法
// version: 1.1
// version update: 2023/9/10
// -------------------------------------------------------

module verilog_ieee(
    input clk, nrst,
    input a, b, c, d,
    output wire out
);

// 数据类型
wire [31:0] wire_num;
real real_num;
reg [31:0] reg_num;
integer int_num;
time time_num;
parameter para_num = 0;
localparam locpara_num = 0;
// 其他不常用的类型
// memory, large, medium, small, scalared, tri, triand, trior, trireg, vectored, wand, wor

// 动态数据分割
assign wire_num = reg_num[reg_num+:8]; // [base : base + width - 1] 
assign wire_num = reg_num[reg_num-:8]; // [base : base - width + 1]
assign wire_num = reg_num[-1:-8]; // 
reg [0:31] reversed_reg_num; // 生成的截取方向与定义时的方向相关
assign wire_num = reversed_reg_num[reversed_reg_num+:8]; // [base + width - 1 : base]
assign wire_num = reversed_reg_num[reversed_reg_num-:8]; // [base - width + 1 : base]
assign wire_num = reversed_reg_num[8:0]; // 最高位向低位截取9位
// 两个相反的向量赋值时值会颠倒传递

// 4值变量的赋值细节(注意, Verilog中只能用assign对wire类型赋值)
assign wire_num = 'bx; // in system verilog is 'x, 自动补齐高位x
assign wire_num = 'hz; // 自动补齐高位z, 与上面的类似
assign wire_num = 'b0x; // 000...000x
assign wire_num = 'b0x111; // 000...000x111
assign wire_num = 'shf; // s表示有符号数，这里等于0xF, 等价于wire_num = -1
assign wire_num = 'sh ffff_ffff; // 允许的分离书写格式

initial begin
    // 允许的浮点数赋值
    real_num = 2394.26331;
    real_num = 1.2E12; // (the exponent symbol can be e or E)
    real_num = 1.30e-2; 
    real_num = 0.1e-0;
    real_num = 23E10;
    real_num = 29E-2;
    real_num = 236.123_763_e-12; // (underscores are ignored)
end

// verilog中没有char类
reg [8*14:1] stringvar;
initial begin
    stringvar = "Hello world";
    $display("%s is stored as %h", stringvar,stringvar);
    stringvar = {stringvar,"!!!"};
    $display("%s is stored as %h", stringvar,stringvar);
    $display("\\, \n, \t, \", \123, \0x111, %%"); // 特别的字符, \123是八进制表示的字符的ASIC码, 0x是16进制
end

// 编译指令
`define compile "compiler directives"
// `include "./file.sv"
`ifdef compile
`else
`endif
`default_nettype none // 开启向量对齐赋值

// 属性, attribute, 用于综合指示, 或者仿真指示
(* fsm_state = 1, dont_syn = "false" *) reg [3:0] state;

// 除always和assign外的block

initial begin

    force wire_num = 1; // 类似于电笔, 强制赋值
    release wire_num;

    // 系统函数与任务 System tasks and functions
    
    // 常见
    $write();
    $display();
    $stop();
    $monitor();
    $strobe(); // 非阻塞语句执行完毕后打印
    $finish();

    // 时间
    $time();  // 64位
    $stime(); // 32位
    $realtime(); // float类型
    $timeformat(); // 设置时间格式
    $printtimescale();

    // 浮点数与整数，比特类型的转换
    $bitstoreal();
    $realtobits(); 
    $rtoi();
    $itor(); 

    // 传入参数
    $test$plusargs(); // 获取运行控制台输入args名称
    $value$plusargs(); // 获取运行控制台输入args的值, 格式按 "a=10"

    // 随机数生成
    $random(); // 用于取余限制范围
    // 均匀分布   $dist_uniform(seed, start, end);	start、end 为数据的起始、结尾
    // 正态分布   $dist_normal (seed, mean, std_dev);	mean 为期望值，std_dev 为标准差
    // 泊松分布   $dist_poisson(seed, mean);	mean 为期望 (等于标准差)
    // 指数分布   $dist_exponential(seed , mean);	mean 为单位时间内事件发生的次数
    // 卡方分布   $dist_chi_square(seed, free_deg);	free_deg 为自由度
    //  t  分布   $dist_t(seed, free_deg);	free_deg 为自由度
    // 埃尔朗分布 $dist_erlang(seed, k_stage, mean);	k_stage 为阶数，mean 为期望
    
    // 读写文件操作
    // $dumpfile("路径"); 打开VCD
    // $dumpvars(level,start_module); 要记录的信号, level=0表示记录所有
    // $dumpflush; VCD保存
    // $dumpoff; 停止记录
    // $dumpon; 开始记录
    // $dumplimit(); 限制VCD文件大小(以字节为单位）
    // $dumpall; 记录指定的信号值
    // 文件访问：$fopen, $fclose, $ferror
    // 文件写入：$fdisplay, $fwrite, $fstrobe, $fmonitor
    // 字符串写入：$sformat, $swrite
    // 文件读取：$fgetc, $fgets, $fscanf, $fread
    // 文件定位：$fseek, $ftell, $feof, $frewind
    // 存储器加载：$readmemh, $readmemb
    
    // 标准延迟文件
    // $sdf_annotate ('sdf_file', module_instance,'sdf_configfile','sdf_logfile','mtm_spec','scale_factors','scale_type']);
    // sdf_file: SDF 文件名字，包含路径信息。
    // module_instance: 例化的设计模块名字，一般为 testbench 中所例化的数字设计模块名称，注意和 SDF 文件内容中的声明保持层次的一致。
    // log_file: 编译时关于 SDF 的日志，方便查阅。
    // mtm_spec: 指定使用的延迟类型，选项包括 MAXIMUM、MINIMUM、TYPICAL，分别表示使用 SDF 文件中标注的最大值、最小值或典型值。
    // (来源: www.runoob.com)

    // Verilog的initial块中也允许使用敏感信号
    @(posedge clk);

    // 并发
    fork
        
        // 运算优先级
        // “” {} {{}}
        // ! ~ 
        // **
        // * / %
        // + -
        // << >> 
        // < <= > >=
        // == != === !==
        // &
        // ^ ^~
        // |
        // &&
        // ||
        // ?:

        // 特殊运算用法
        reg_num = & reg_num; // 按位依次逻辑运算, 这类运算优先级最高

    join
end

specify // 来源: www.runoob.com
    specparam ab2out = 2.5 :   3 : 3.5; // min: typical: max
    specparam cd2out = 3.0 : 3.5 :   4;
    //12 个参数: 分别对应0->1, 1->0, 0->z, z->1, 1->z, z->0, 0->x, x->1, 1->x, x->0, x->z, z->x
    (a *> out) = ab2out, 2, 2, 2, 2, 2; // 全连接
    (b => out) = ab2out, 2, 2, 2, 2, 2; // 点对点
    (c, d => out) = cd2out; // 允许组合
    (c, d *> out) = cd2out; // 允许组合

    // 条件路径
    if (a)               (a => out)    = 2.5;
    if (~a)              (a => out)    = 1.5;
    if (b & c)           (b => out)    = 2.5;
    if (!(b & c))        (b => out)    = 1.5;
    if ({c, d} == 2'b01) (c, d *> out) = 3.5;
    ifnone               (c, d *> out) = 3;

    //在 clk 上升沿，从 clk 到 out 的路径上升延迟为 1，下降延迟为 2, 条件为out = a
    (posedge clk => (out +: a)) = (1,2);
   
    //在 clk 下降沿，从 clk 到 out 的路径上升延迟为 1，下降延迟为 2, 条件为out = ~a
    (negedge clk => (out -: a)) = (1,2);
   
    //clk 任意变化时，从 clk 到 out 的路径上升延迟为 1，下降延迟为 2, 无条件
    (negedge clk => (out : a)) = (1,2);

    // 时序设计, 系统函数输入为敏感检测

    // Tcq + Tcomb + Tsu <= Tclk + Tskew 
    // Tcq: 寄存器 clock 端到 Q 端的延迟
    // Tcomb: data path 中的组合逻辑延迟
    // Tsu: 建立时间
    // Tclk: 时钟周期
    // Tskew: 时钟偏移

    $removal(negedge nrst, posedge clk, 1); // 复位信号的去除时间
    $recovery(posedge nrst, posedge clk, 1); // 复位信号的恢复时间
    
    $setup(d, posedge clk, 2);
    $hold(posedge clk, d, 3);
    $setuphold(posedge clk, d, 2, 3); // 等价于上面两条
    $skew(posedge clk, out, 4); // clk to out skew大于4则会报错

    $width(posedge clk, 10);  // 信号宽度检查
    $period(posedge clk, 20); // 信号周期检查

endspecify

generate
    for (genvar i = 0; i < 10; i = i + 1) begin 
        // Verilog不支持++符号, begin end在generate for语句中是强制要求的
        assign wire_num[i] = 0;
    end
endgenerate

task task0 (input a, output b);
    b = #1 a;
endtask

function [31:0] func (input a, b, c); // 单一返回值, 至少需要一个输入, 不含延迟
    func = {a,b,c};
endfunction

// 关于阻塞赋值与非阻塞, 建议理解为blocking与none blocking, 即块内赋值与块外赋值。一个是块内顺序赋值, 另一个是块结束后并发赋值。

// 除系统函数外，还可以用c语言编写自定义函数并调用执行。

endmodule

