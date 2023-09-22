# 数字IC设计应聘笔试相关边缘知识点

---

Author: Clark Pu

Copyright: 装载需声明作者与该项目的GitHub链接

Notification: 本库中的知识需要一定的数字IC知识储备，不适合初学者阅读学习

---

### 项目文件

**Verilog & SV语法**

- [Verilog IEEE](./verilog_ieee.v)
- [System Verilog](./system_verilog_ieee.sv)

**电路代码**

- [异步FIFO](./asynchronous_fifo.sv): 跨时钟域处理
- [异步时钟选择器](./clk_mux.sv): 二级DFF处理
- [异步复位, 同步释放](./synchronous_reset.sv): 常规ASIC复位设计
- [常见功能性电路](./common.v): 常见的功能电路设计

**知识点收集**

- [小考卷](./电路小考卷.txt)
- [小考卷答案](./小考卷答案.txt)

### 知识点（建议直接看小考卷）

**基本电路**

- 分频: 二，奇偶，小数分频
- 计数器：环形计数器(启动电路设计)，二进制计数器
- 串并转换: 状态机，计数器也行
- 按键消抖电路: 参考Clark其他项目的按钮模块
- 纯组合逻辑实现: 会有些难度高的案例，需要学习这些案例的处理方法(乘法器，除法器，log2，CRC等)

**接口通信协议, 均可以用状态机解决**

- USB通信协议: 串口双工异步，双设备
- UART协议: 串口双工异步，双设备
- IIC(I2C)协议: 串口单工同步，多主多从
- SPI: 串口双工同步，单主多从
- AMBA协议: AMB AHB AXI AHB-Lite 片上总线
- PCIe: 板上接口协议
- TCP/IP: 网络接口协议

**计算机结构**

- CPU电路：各种流水线Hazard, 分支预测, 数据前递, 多核内存, 算法优化, 兼容等等问题
- Linux操作系统原理
