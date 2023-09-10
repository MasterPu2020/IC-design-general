// -------------------------------------------------------
// title: System Verilog Verification
// author: Clark @https://github.com/MasterPu2020
// copyright: 备注原作者的条件下自由转载
// features: SV中用于验证相关的语法
// version: 1.0
// version update: 2023/9/10
// -------------------------------------------------------

typedef parent; // 前置声明
class parent #(parameter type bit_array = bit);

    bit array[]; // 动态数组，动态调用
    bit queue[$]; // 队列，堆栈
    bit [7:0] rom [bit[7:0]]; // 关联数组，节省内存

    function new(bit_array value); // 没有返回值
        this.array = value;
    endfunction : new

    static int all_the_same; // 所有继承的该变量值相同

    typedef struct { // 自定义数据类型
        integer number;
        string str;
    } struct_name;

    struct_name struct_item = '{1, "hi!"};

    function automatic string test(string input_str);
        while (1) begin
            input_str = {input_str, this.struct_item.str};
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
        // 虚函数用于规划子类功能
    endfunction;

endclass : parent

class child extends parent; // 类的继承

    // 随机与约束 

    rand bit random;
    int array = '{0,1,2,3,4,5,6,7,8,9,10};

    constraint c {
        random dist {0:=30, [1:3]:/90, [4:10]:=10};
        (this.struct_item.str != "hi!") -> random inside {array}; // 蕴含条件
        solve array before random; // 生成约束
        random >= 0;

    }

endclass : child

module system_verilog_ieee;
    logic clk, nrst;
    logic a, b, c, d;
    logic out;

endmodule // testbench