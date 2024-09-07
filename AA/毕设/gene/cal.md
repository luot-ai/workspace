* 5.2
  * 表1：性能之比
    * 所有的卷积层：Our实际Gops/TC实际Gops
      * Our实际Gops=峰值 * U，两个值都是估值，峰值固定，U是某值上下浮动
        * 峰值=(72ops/11cycles)*800MHz=5.2352Gop/s
        * U=11/33
      * TC实际Gops=操作量/时间
        * 操作量：由表可算，每一层=OH×OW×OC×IC×(9+9)，这里OH和OW就是表里的IH和IW
        * 时间：TC文章里的周期数/1GHz
    * 所有的池化层：
      * 直接按这个算：各pooling层input长宽都设为PI
        * 加速比等于= 8 × （6×PI×PI/4）/（33×PI×PI/16) =  8 × 24 / 33，6倍左右吧
          * 里头的8是主频之比，33可以进行一个小幅度波动
    * 卷积：cva6_acc vs cva6_our
      * 33+21 / 33
    * 池化：
      * (64/8) / (33/16)≈3.87
        * 64=27x2+8+2
  * 表2：能效之比
    * 公式：U×峰值Gops/(U×动power+静power)
      * 卷积层
        * TC：U=实际/峰值 实际见上 峰值=0.225 动power=5.086 静power=0.714
        * Our：U是估计出来的11/33 33浮动一下 峰值=5.235  动power=37.2 静power=4.8
      * 池化层（这里的峰值是TC和Our相对的）
        * TC： U=1/6 峰值=1
        * Our：U= 4/33(33上下浮动)  峰值=8
* 5.1
  * Our Vs Base 加速比，主频一致

    * Our的实际值：72ops/33cycles
      * 33=25+8，25可以上下浮动
    * Base的实际值：72ops/(243+36+76=355cycles)
      * 243=[(25+2)×3]×3，25可以上下浮动
      * Base的峰值：72/76 * 800 = 0.758
  * 池化

    * 直接按这个算：各pooling层input长宽都设为PI
      * 加速比等于  =  （68×PI×PI/8）/（33×PI×PI/16) =  约为4.12
        * 68=27x2+8+6
* 5.3
  * Base FPGA(来源于Survey，XCVU9P Xilinx Virtex UltraScale+ FPGA)：
    * Fmax：112MHz.......
    * power = 静态power 3080mW + 动态power 1995mW
    * 46K Registers，55K LUTs， 18DSPs
    * Gops：72/76 * 112 = 0.106
    * Effi：0.106/5.075=0.021，看ICCAD 这个数值还挺合理的
  * Base ASIC（来源于VIRTU，22nm FDX）
    * 主频：800MHz
    * power 4.8mW + 动态power 37.2mW
    * 0.257mm2
    * Gops：72/76 * 800 = 0.758
    * Effi: 0.758/42mW=18.05
