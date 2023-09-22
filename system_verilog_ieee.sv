// -------------------------------------------------------
// title: System Verilog Verification
// author: Clark @https://github.com/MasterPu2020
// copyright: 备注原作者的条件下自由转载
// features: SV中用于验证相关的语法
// version: 1.0
// version update: 2023/9/10
// -------------------------------------------------------

typedef parent; // 前置声明
class parent #(parameter type bit_array = bit); // 定义传入数据类型

    bit array[]; // 动态数组，动态调用
    bit queue[$]; // 队列，堆栈
    bit [7:0] rom [bit[7:0]]; // 关联数组，节省内存

    function new(bit_array value); // 没有返回值
        this.array = value;
    endfunction : new

    static int all_the_same; // 所有继承的该变量值相同

    typedef struct { // 自定义数据类型与结构体
        integer number;
        string str;
    } struct_name;

    struct_name struct_item = '{1, "hi!"};

    function automatic string test(string input_str);
        while (1) begin
            input_str = {input_str, this.struct_item.str};
            if (1) // 更多的关键词
                continue;
            else
                break;
        end
        return input_str;

    endfunction : test

    function automatic void stack;

        this.array = new[5]; // 灵活调用动态数组
        this.queue.insert(0,10);
        this.queue.push_back(10);
        this.queue.pop_front();
        this.queue.delete(0);
        this.queue = {}; // clear
        
    endfunction

    virtual function void print();
        // 虚函数用会调用子类的方法
    endfunction;

endclass : parent

class child extends parent; // 类的继承

    // 随机与约束 

    rand bit random;
    int array = '{0,1,2,3,4,5,6,7,8,9,10}; // 快速整数结构体，重载父类array
    bit array1[];

    constraint c0 {
        random dist {0:=30, [1:3]:/90, [4:10]:=10}; // 加权概率
        (this.struct_item.str != "hi!") -> random inside {array}; // 蕴含条件与inside方法
        solve array before random; // 顺序约束
        if (this.struct_item.str == "hi!")
            random >= 0;
        else
            random inside {array};

        this.struct_item.str == "hi!" ? random >= 0 : random inside {array};
        
        foreach(array1[i]){ // foreach用法与数组约束
            array1[i] inside {[1:3]};
            array1.sum() < 1024; // 数组函数
            array1.size() inside {[1:8]}; // 数组函数
        }

    }

endclass : child


module system_verilog_ieee;

    timeunit 1ns; timeprecision 10ps;

    logic clk, nrst;
    logic a, b, c, d;
    logic out;

    sequence new_s1;
        @(posedge clk) a ^ b |-> a ##1 (b == 2) [->2:5] ##1 c > 0 ##[0:4] (d == 5);
    endsequence

    property new_property;
        // 符号解释:
        // 打拍信号与表达式的@()敏感列表绑定
        // ##n 第n拍后
        // [=n:m] 非连续出现n~m次
        // [*n:m] 非连续出现n~m次后,或关系
        // -> 最后一拍为1
        // [n:m] 数列n~m
        // |-> 立刻assertion
        // |=> 1拍后assertion
        new_s1; // 封装时序
    endproperty

    `define expression0 (a && b == c & d && $stable(c))
    property new_property1;
        @(posedge clk) `expression0 |-> ## [1:2] $rose(a) ##1 $fell(b);
    endproperty

    label : assert property (new_property1); // 并发且时刻运行

    initial begin
        fork
            // 多线程问题：线程会在本时刻的所有非阻塞语句完成后并发执行，注意列出线程之间的先后关系
        join_none
    end

endmodule // testbench
