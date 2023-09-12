# 数字IC设计应聘笔试相关代码

---

Author: Clark Pu

Copyright: 装载需声明作者与该项目的GitHub链接

---

### 常见内容

**Verilog语法**
- [Verilog IEEE 2001 Standard](./verilog_ieee.v)

**跨时钟域与异步处理**

- [异步FIFO](./asynchronous_fifo.sv): 跨时钟域处理
- [异步时钟选择器](./clk_mux.sv): 二级DFF处理
- [异步复位, 同步释放](./synchronous_reset.sv): 常规ASIC复位设计
- Clock gating: 《节能环保》

**基本电路**

- 分频: 时钟分频
- 串并转换: 分频实现
- 按键消抖电路: 参考Clark其他项目的按钮模块
- 状态机电路: Verilog与System Verilog的两种写法, 略

**接口通信协议, 均可以用状态机解决**

- USB通信协议: 串口双工异步，双设备
- UART协议: 串口双工异步，双设备
- IIC(I2C)协议: 串口单工同步，多主多从
- SPI: 串口双工同步，单主多从
- AMBA协议: AMB AHB AXI AHB-Lite 等片上总线

**CPU电路, 一般不会问吧**

各种流水线Hazard, 分支预测, 数据前递, 多核内存, 算法优化, 兼容等等问题

- RISC-V: 参考Clark其他项目

**《想要成为验证高手》**

- 熟读System Verilog IEEE文档: 即是把SV拿来当软件写
