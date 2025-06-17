10867113209000: system.Shader.CUs01.ScheduleStage: schList[5]: Adding: SIMD[0] WV[1]: 140: flat_load_dword v1, v[2:3]
10867113209000: system.Shader.CUs01.ScheduleStage: schList[5]: Added: SIMD[0] WV[1]: 140: flat_load_dword v1, v[2:3]
10867113209000: system.Shader.CUs01.ScheduleStage: schList[2]: WV[81] operands ready for: 161: v_addc_co_u32 v3, vcc_lo, v3, 0, vcc_lo, vcc
10867113209000: system.Shader.CUs01.ScheduleStage: schList[2]: WV[81] RFBUSY->RFREADY
10867113209000: system.Shader.CUs01.ScheduleStage: schList[3]: WV[121] operands ready for: 174: v_add_co_u32 v2, vcc_lo, v1, s12
10867113209000: system.Shader.CUs01.ScheduleStage: schList[3]: WV[121] RFBUSY->RFREADY
10867113209000: system.Shader.CUs01.ScheduleStage: schList[5]: WV[1] operands ready for: 140: flat_load_dword v1, v[2:3]
10867113209000: system.Shader.CUs01.ScheduleStage: schList[5]: WV[1] RFBUSY->RFREADY
10867113209000: system.Shader.CUs01.ScheduleStage: dispatchList[2]: fillDispatchList: EMPTY->EXREADY
10867113209000: system.Shader.CUs01.ScheduleStage: dispatchList[3]: fillDispatchList: EMPTY->EXREADY
10867113209000: system.Shader.CUs01.GlobalMemPipeline: Checking for 1 tokens
10867113209000: system.Shader.CUs01.GlobalMemPipeline: Acquiring 1 token(s)
10867113209000: system.Shader.CUs01.ScheduleStage: dispatchList[5]: fillDispatchList: EMPTY->EXREADY
10867113209000: system.Shader.CUs01.ScheduleStage: dispatchList[6]: arbVrfLds: EXREADY->SKIP
10867113209000: system.Shader.CUs01.ScheduleStage: dispatchList[2]: SIMD[2] WV[81]: 161: v_addc_co_u32 v3, vcc_lo, v3, 0, vcc_lo, vcc    Reserving ExeRes[ 2 ]
10867113209000: system.Shader.CUs01.ScheduleStage: dispatchList[3]: SIMD[3] WV[121]: 174: v_add_co_u32 v2, vcc_lo, v1, s12    Reserving ExeRes[ 3 ]
10867113209000: system.Shader.CUs01.ScheduleStage: dispatchList[5]: SIMD[0] WV[1]: 140: flat_load_dword v1, v[2:3]    Reserving ExeRes[ 6 5 ]


10867113210000: system.Shader.CUs01.ExecStage: Dispatch List:
0: EMPTY
1: EMPTY
2: EXREADY SIMD[2] WV[81]: 161: v_addc_co_u32 v3, vcc_lo, v3, 0, vcc_lo, vcc
3: EXREADY SIMD[3] WV[121]: 174: v_add_co_u32 v2, vcc_lo, v1, s12
4: EMPTY
5: EXREADY SIMD[0] WV[1]: 140: flat_load_dword v1, v[2:3]
6: SKIP SIMD[0] WV[1]: 140: flat_load_dword v1, v[2:3]
7: EMPTY

寄存器：可索引2048个?物理寄存器组 每组64lane 32bit位宽
每个WF会映射到一个startIndex，从这里开始map上他的arch寄存器号
由于是vload，所以是64个线程，每个都用它的64bit地址（来自于寄存器pair v[2:3]）去地址中取一个32bit数到v1中
10867113210000: system.Shader.CUs01.ExecStage: Exec[5]: SIMD[0] WV[1]: flat_load_dword v1, v[2:3]
10867113210000: system.Shader.CUs01.ExecStage: dispatchList[5] EXREADY->EMPTY
10867113210000: system.Shader.CUs01.wavefronts00: CU1: WF[0][0]: wave[1] Executing inst: flat_load_dword v1, v[2:3] (pc: 0x7fd1b6c06264; seqNum: 140)
10867113210000: global: Read v[2]
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[2][0] = 0xb6c18100
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[2][1] = 0xb6c18104
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[2][2] = 0xb6c18108
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[2][3] = 0xb6c1810c
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[2][4] = 0xb6c18110
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[2][5] = 0xb6c18114
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[2][6] = 0xb6c18118
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[2][7] = 0xb6c1811c
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[2][8] = 0xb6c18120
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[2][9] = 0xb6c18124
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[2][10] = 0xb6c18128
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[2][11] = 0xb6c1812c
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[2][12] = 0xb6c18130
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[2][13] = 0xb6c18134
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[2][14] = 0xb6c18138
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[2][15] = 0xb6c1813c
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[2][16] = 0xb6c18140
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[2][17] = 0xb6c18144
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[2][18] = 0xb6c18148
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[2][19] = 0xb6c1814c
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[2][20] = 0xb6c18150
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[2][21] = 0xb6c18154
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[2][22] = 0xb6c18158
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[2][23] = 0xb6c1815c
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[2][24] = 0xb6c18160
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[2][25] = 0xb6c18164
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[2][26] = 0xb6c18168
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[2][27] = 0xb6c1816c
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[2][28] = 0xb6c18170
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[2][29] = 0xb6c18174
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[2][30] = 0xb6c18178
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[2][31] = 0xb6c1817c
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[2][32] = 0xb6c18180
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[2][33] = 0xb6c18184
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[2][34] = 0xb6c18188
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[2][35] = 0xb6c1818c
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[2][36] = 0xb6c18190
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[2][37] = 0xb6c18194
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[2][38] = 0xb6c18198
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[2][39] = 0xb6c1819c
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[2][40] = 0xb6c181a0
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[2][41] = 0xb6c181a4
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[2][42] = 0xb6c181a8
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[2][43] = 0xb6c181ac
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[2][44] = 0xb6c181b0
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[2][45] = 0xb6c181b4
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[2][46] = 0xb6c181b8
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[2][47] = 0xb6c181bc
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[2][48] = 0xb6c181c0
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[2][49] = 0xb6c181c4
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[2][50] = 0xb6c181c8
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[2][51] = 0xb6c181cc
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[2][52] = 0xb6c181d0
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[2][53] = 0xb6c181d4
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[2][54] = 0xb6c181d8
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[2][55] = 0xb6c181dc
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[2][56] = 0xb6c181e0
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[2][57] = 0xb6c181e4
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[2][58] = 0xb6c181e8
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[2][59] = 0xb6c181ec
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[2][60] = 0xb6c181f0
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[2][61] = 0xb6c181f4
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[2][62] = 0xb6c181f8
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[2][63] = 0xb6c181fc
10867113210000: global: Read v[3]
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[3][0] = 0x7fd1
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[3][1] = 0x7fd1
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[3][2] = 0x7fd1
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[3][3] = 0x7fd1
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[3][4] = 0x7fd1
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[3][5] = 0x7fd1
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[3][6] = 0x7fd1
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[3][7] = 0x7fd1
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[3][8] = 0x7fd1
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[3][9] = 0x7fd1
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[3][10] = 0x7fd1
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[3][11] = 0x7fd1
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[3][12] = 0x7fd1
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[3][13] = 0x7fd1
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[3][14] = 0x7fd1
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[3][15] = 0x7fd1
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[3][16] = 0x7fd1
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[3][17] = 0x7fd1
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[3][18] = 0x7fd1
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[3][19] = 0x7fd1
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[3][20] = 0x7fd1
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[3][21] = 0x7fd1
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[3][22] = 0x7fd1
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[3][23] = 0x7fd1
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[3][24] = 0x7fd1
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[3][25] = 0x7fd1
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[3][26] = 0x7fd1
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[3][27] = 0x7fd1
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[3][28] = 0x7fd1
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[3][29] = 0x7fd1
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[3][30] = 0x7fd1
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[3][31] = 0x7fd1
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[3][32] = 0x7fd1
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[3][33] = 0x7fd1
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[3][34] = 0x7fd1
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[3][35] = 0x7fd1
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[3][36] = 0x7fd1
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[3][37] = 0x7fd1
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[3][38] = 0x7fd1
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[3][39] = 0x7fd1
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[3][40] = 0x7fd1
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[3][41] = 0x7fd1
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[3][42] = 0x7fd1
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[3][43] = 0x7fd1
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[3][44] = 0x7fd1
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[3][45] = 0x7fd1
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[3][46] = 0x7fd1
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[3][47] = 0x7fd1
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[3][48] = 0x7fd1
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[3][49] = 0x7fd1
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[3][50] = 0x7fd1
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[3][51] = 0x7fd1
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[3][52] = 0x7fd1
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[3][53] = 0x7fd1
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[3][54] = 0x7fd1
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[3][55] = 0x7fd1
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[3][56] = 0x7fd1
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[3][57] = 0x7fd1
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[3][58] = 0x7fd1
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[3][59] = 0x7fd1
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[3][60] = 0x7fd1
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[3][61] = 0x7fd1
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[3][62] = 0x7fd1
10867113210000: system.Shader.CUs01.vector_register_file0: WF[0][0]: WV[1] v[3][63] = 0x7fd1
10867113210000: system.Shader.CUs01.wavefronts00: CU1: WF[0][0]: wave[1] (pc: 0x7fd1b6c0626c)
10867113210000: system.Shader.CUs01.ExecStage: dispatchList[6] SKIP->EMPTY

FLAT:可能 LDS/GDS/SCRATCH
FLATGlobal
FLATSCRATCH
之后会调用指令的exec：计算地址calcAddr->然后发送请求issueRequestHelper


计算地址会根据不同的地址分区排开
上面的trace就是读操作数，对应着下面第一种情况

模式	地址计算逻辑

_isFlat || FlatGlobal && _saddr == 0x7f	64-bit VGPR 地址 + offset
FlatGlobal  && _saddr != 0x7f	        64-bit SGPR + 32-bit VGPR offset + offset
FlatScratch && _saddr != 0x7f	        flat_scratch_base + sgpr + offset + vgpr
FlatScratch && _saddr == 0x7f	        flat_scratch_base + vgpr + offset

    struct InFmt_FLAT {
        unsigned int    OFFSET : 13;
        unsigned int       SVE : 1;
        unsigned int       SEG : 2;
        unsigned int       GLC : 1;
        unsigned int       SLC : 1;
        unsigned int        OP : 7;
        unsigned int    pad_25 : 1;
        unsigned int  ENCODING : 6;
    };

    struct InFmt_FLAT_1 {
        unsigned int      ADDR : 8;
        unsigned int      DATA : 8;
        unsigned int     SADDR : 7;
        unsigned int        NV : 1;
        unsigned int      VDST : 8;
    };

读出来的操作数还是一个64lane的64bit数，+offset得到最终地址，用来调度
resolveFlatSegment函数
    _ldsApe：is_lds：staticInstruction()->executed_as = enums::SC_GROUP;
        映射到这里的话，地址要转换一下addr[lane] = addr[lane] -wavefront()->computeUnit->shader->ldsApe().base;
        wavefront()->execUnitId =  wavefront()->flatLmUnitId;
        gpuDynInst->computeUnit()->localMemoryPipe.issueRequest(gpuDynInst);
    _scratchApe：is_scratch：staticInstruction()->executed_as = enums::SC_PRIVATE;
        线程私有[生命周期等与线程本身]，编译器自动分配，VGPR不够时作为一个后备（应该是vgpr_cache）
        wavefront()->execUnitId = wavefront()->flatLmUnitId;
        gpuDynInst->computeUnit()->globalMemoryPipe.issueRequest(gpuDynInst);这里好奇怪
    _gpuVmApe：is_gpu_vm：不支持
    staticInstruction()->executed_as = enums::SC_PRIVATE;
        wavefront()->execUnitId =  wavefront()->flatGmUnitId;
        gpuDynInst->computeUnit()->globalMemoryPipe.issueRequest(gpuDynInst);

同一拍：：GlobalMemPipeline::issueRequest(GPUDynInstPtr gpuDynInst)
    wf->outstandingReqs++;
    wf->validateRequestCounters();

    gpuDynInst->setAccessTime(curTick());
    gpuDynInst->profileRoundTripTime(curTick(), InstMemoryHop::Initiate);
    gmIssuedRequests.push(gpuDynInst);

下一拍：：GlobalMemPipeline::exec()
调用指令的initiateAcc->
initMemRead(根据flat执行分区)->
initMemReqHelper
循环地对64个lane做一件事情
执行逻辑：若lane对应的掩码位为真，则封装req packet，然后gpuDynInst->computeUnit()->sendRequest(gpuDynInst, lane, pkt);
10867113211000: system.Shader.CUs01.GlobalMemPipeline: initiateAcc for flat_load_dword v1, v[2:3] seqNum 140
10867113211000: global: CU1: WF[0][0]: mempacket status bitvector=1111111111111111111111111111111111111111111111111111111111111111
里头会调用std::vector<DTLBPort> tlbPort.sendTimingReq
VegaTLBCoalescer::CpuSidePort::recvTimingReq(PacketPtr pkt)
    这里会把地址翻译合并
    下面是合并的逻辑：
        以packet到达coalescer的tick(curTick)为基准
        Tick tick_index = sender_state->issueTime / coalescer->coalescingWindow;落在同一个窗口的共用一个索引
        同一个索引下，还会根据不同的page页或读写类型再细分多个槽
        接着遍历对应索引下的所有槽，尝试看看能否合并（在同一个page并且读写类型相同），可以的话push
        如果都不行就自己创一个
    下一周期调度coalescer->probeTLBEvent


10867113211000: system.l1_coalescer01: mustStallCUPort: downstream = 0, max = 64
10867113211000: system.l1_coalescer01-port0: receiving pkt w/ req_cnt 1
10867113211000: system.l1_coalescer01-port0: coalescerFIFO[10867113211000] now has 1 coalesced reqs after push
10867113211000: system.Shader.CUs01: CU1: WF[0][0]: Translation for addr 0x7fd1b6c18100 from instruction flat_load_dword v1, v[2:3] sent!

10867113211000: system.l1_coalescer01: mustStallCUPort: downstream = 0, max = 64
10867113211000: system.l1_coalescer01-port0: receiving pkt w/ req_cnt 1
10867113211000: system.l1_coalescer01-port0: Coalesced req 0 w/ tick_index 10867113211000 has 2 reqs
10867113211000: system.Shader.CUs01: CU1: WF[0][0]: Translation for addr 0x7fd1b6c18104 from instruction flat_load_dword v1, v[2:3] sent!
10867113211000: system.l1_coalescer01: mustStallCUPort: downstream = 0, max = 64
下面的省略了，总之就是64个lane的tlb请求被合并了

下一周期：：VegaTLBCoalescer::processProbeTLBEvent()
10867113212000: system.l1_coalescer01: triggered VegaTLBCoalescer processProbeTLBEvent
10867113212000: system.l1_coalescer01: coalescedReq_cnt is 1 for tick_index 10867113211000
memSidePort[0]->sendTimingReq(first_packet)
GpuTLB::CpuSidePort::recvTimingReq(PacketPtr pkt)
tlb->issueTLBLookup(pkt);
10867113212000: system.l1_tlb01: Translation req. for virt. page addr 0x7fd1b6c18000
10867113212000: system.l1_tlb01: TLB Lookup for vaddr 0x7fd1b6c18100.
schedule(tlb_event, curTick() + cyclesToTicks(Cycles(hitLatency)));一级tlb hit延迟是1周期
10867113212000: system.l1_tlb01: schedule translationReturnEvent @ curTick 10867113213000
10867113212000: system.l1_coalescer01: system.l1_coalescer01 sending pkt w/ req_cnt 64
10867113212000: system.l1_coalescer01: Successfully sent TLB request for page 0x7fd1b6c18000

l1_tlb接受返回handleTranslationReturn，写入自己的PTE
GpuTLB::translationReturn(Addr virtPageAddr, tlbOutcome outcome,
38: sys.l1_tlb01: Triggered TLBEvent for addr 0x7fd1b6c18000
38: sys.l1_tlb01: Translation Done - TLB Miss for addr 0x7fd1b6c18100
38: sys.l1_tlb01: allocating entry w/ addr 0x7fd1b6c18000 of size 0x1000
38: sys.l1_tlb01: Inserted 0x7fd1b6c18000 -> 0x130a2e000 of size 0x1000 into set 0
38: sys.l1_tlb01: Entry found with vaddr 0x7fd1b6c18000,  doing protection checks while paddr was 0x130a2e000.
38: sys.l1_tlb01: Translated 0x7fd1b6c18100 -> 0x130a2e100.
pkt->makeTimingResponse();
_l1_coalescer01的memside端收到响应
38: sys.l1_coalescer01: Update phys. addr. for 64 coalesced reqs for page 0x7fd1b6c18000
ComputeUnit::DTLBPort::recvTimingResp(PacketPtr pkt)
38: sys.Shader.CUs01-port0: CU1: DTLBPort received 0x7fd1b6c18100->0x130a2e100
38: sys.Shader.CUs01-port0: CU1: WF[0][0]: index 0, addr 0x130a2e100 data scheduled
38: sys.Shader.CUs01-port0: CU1: DTLBPort received 0x7fd1b6c18104->0x130a2e104
38: sys.Shader.CUs01-port0: CU1: WF[0][0]: index 1, addr 0x130a2e104 data scheduled
38: sys.Shader.CUs01-port0: CU1: DTLBPort received 0x7fd1b6c18108->0x130a2e108
38: sys.Shader.CUs01-port0: CU1: WF[0][0]: index 2, addr 0x130a2e108 data scheduled

接下来就是向ruby系统发请求
    // translation is done. Schedule the mem_req_event at the appropriate
    // cycle to send the timing memory request to ruby
    EventFunctionWrapper *mem_req_event =
        computeUnit->memPort[mp_index].createMemReqEvent(new_pkt);

    DPRINTF(GPUPort, "CU%d: WF[%d][%d]: index %d, addr %#x data scheduled\n",
            computeUnit->cu_id, gpuDynInst->simdId,
            gpuDynInst->wfSlotId, mp_index, new_pkt->req->getPaddr());

    computeUnit->schedule(mem_req_event, curTick() +
                          computeUnit->req_tick_latency);






断了！换一个
70: sys.Shader.CUs00.ScoreboardCheckStage: Adding to readyList[5]: SIMD[0] WV[0]: 186: flat_store_dword v[4:5], v1

71: sys.Shader.CUs00.ScheduleStage: schList[5]: Adding: SIMD[0] WV[0]: 186: flat_store_dword v[4:5], v1
71: sys.Shader.CUs00.ScheduleStage: schList[5]: Added: SIMD[0] WV[0]: 186: flat_store_dword v[4:5], v1
71: sys.Shader.CUs00.ScheduleStage: schList[5]: WV[0] operands ready for: 186: flat_store_dword v[4:5], v1
71: sys.Shader.CUs00.ScheduleStage: schList[5]: WV[0] RFBUSY->RFREADY
71: sys.Shader.CUs00.GlobalMemPipeline: Checking for 1 tokens
71: sys.Shader.CUs00.GlobalMemPipeline: Acquiring 1 token(s)
71: sys.Shader.CUs00.ScheduleStage: dispatchList[5]: fillDispatchList: EMPTY->EXREADY
71: sys.Shader.CUs00.ScheduleStage: dispatchList[6]: arbVrfLds: EXREADY->SKIP
71: sys.Shader.CUs00.ScheduleStage: dispatchList[5]: SIMD[0] WV[0]: 186: flat_store_dword v[4:5], v1    Reserving ExeRes[ 6 5 ]

72: sys.Shader.CUs00.ExecStage: Exec[5]: SIMD[0] WV[0]: flat_store_dword v[4:5], v1
72: sys.Shader.CUs00.ExecStage: dispatchList[5] EXREADY->EMPTY
72: sys.Shader.CUs00.wavefronts00: CU0: WF[0][0]: wave[0] Executing inst: flat_store_dword v[4:5], v1 (pc: 0x7fd1b6c06280; seqNum: 186)
72: global: Read v[1]

73: sys.Shader.CUs00.GlobalMemPipeline: initiateAcc for flat_store_dword v[4:5], v1 seqNum 186
73: global: CU0: WF[0][0]: mempacket status bitvector=1111111111111111111111111111111111111111111111111111111111111111
73: sys.l1_coalescer00: mustStallCUPort: downstream = 0, max = 64
73: sys.l1_coalescer00-port0: receiving pkt w/ req_cnt 1
73: sys.l1_coalescer00-port0: coalescerFIFO[10867114573000] now has 1 coalesced reqs after push
73: sys.Shader.CUs00: CU0: WF[0][0]: Translation for addr 0x7fd1b6c1c000 from instruction flat_store_dword v[4:5], v1 sent!
73: sys.l1_coalescer00: mustStallCUPort: downstream = 0, max = 64
73: sys.l1_coalescer00-port0: receiving pkt w/ req_cnt 1
73: sys.l1_coalescer00-port0: Coalesced req 0 w/ tick_index 10867114573000 has 2 reqs

每个线程的port都会来一次
ComputeUnit::DTLBPort::recvTimingResp(PacketPtr pkt)
32: sys.Shader.CUs00-port0: CU0: DTLBPort received 0x7fd1b6c1c0fc->0x3feeda0fc
    EventFunctionWrapper *mem_req_event =
        computeUnit->memPort[mp_index].createMemReqEvent(new_pkt);
    computeUnit->schedule(mem_req_event, curTick() + computeUnit->req_tick_latency);   这里就是调度每一个memport对数据发起请求！
32: sys.Shader.CUs00-port0: CU0: WF[0][0]: index 63, addr 0x3feeda0fc data scheduled：

VegaTLBCoalescer::MemSidePort::recvTimingResp(PacketPtr pkt)
32: sys.l1_coalescer00-port0: recvTimingReq: clscr = 0x55bcbcd34000, numDownstream = 1, max = 64
32: sys.l1_tlb00: Scheduled 0x7fd1b6c1c000 for cleanup
32: sys.l1_tlb00: Deleting return event for 0x7fd1b6c1c000
32: sys.l1_coalescer00: Cleanup - Delete coalescer entry with key 0x7fd1b6c1c000

D

隔了50周期
上面调度的事件现在触发：这里的请求响应端口属于dataPort_coalescer
ComputeUnit::DataPort::processMemReqEvent(PacketPtr pkt)
    (sendTimingReq(pkt))
RubyPort::MemResponsePort::recvTimingReq(PacketPtr pkt)->RequestStatus requestStatus = owner.makeRequest(pkt);

VIPERCoalescer::makeRequest(PacketPtr pkt)
GPUCoalescer::makeRequest(PacketPtr pkt)
UncoalescedTable::insertPacket(PacketPtr pkt)
82: global: Adding 0x3FEEDA0FC seqNum 186 to map. (map 1 vec 1)
GPUCoalescer::makeRequest(PacketPtr pkt)
82: sys.ruby.tcp_cntrl0.coalescer: Put pkt with addr 0x3FEEDA0FC to uncoalescedTable
82: sys.ruby.tcp_cntrl0.coalescer: Scheduled issueEvent for seqNum 186  这里就是调度合并访问
返回true，所以这里的请求端口打印：
    82: sys.Shader.CUs00-port63: CU0: WF[0][0]: gpuDynInst: 186, index 63, addr 0x3feeda0fc data req sent!

82: global: Adding 0x3FEEDA0F8 seqNum 186 to map. (map 1 vec 2)
82: sys.ruby.tcp_cntrl0.coalescer: Put pkt with addr 0x3FEEDA0F8 to uncoalescedTable
82: sys.Shader.CUs00-port62: CU0: WF[0][0]: gpuDynInst: 186, index 62, addr 0x3feeda0f8 data req sent! 
uncoalescedTable是以seqnum为索引,list为值的map 
insertPacket：instMap通过指令序号->映射到一个装有pkt的list中【后续的都往这个list里加】
insertReqType：reqTypeMap：reqTypeMap[seqNum] = type;




然后上面调度的事情本周期开始执行，注意这里只需要调度一次
makeRequest:schedule(issueEvent, curTick());
GPUCoalescer::completeIssue():

遍历for (int instIdx = 0; instIdx < coalescingWindow; ++instIdx)，即一周期最多可coalesced指令
            循环的pkt_list->remove_if(
                [&](PacketPtr pkt) { return coalescePacket(pkt); }
            );
GPUCoalescer::coalescePacket(PacketPtr pkt)
82: sys.ruby.tcp_cntrl0.coalescer: Creating new or aliased request for 0x3FEEDA0C0
82: sys.ruby.tcp_cntrl0.coalescer: adding write inst 186 at line 0x3feeda0c0 to the pending write instruction list
82: sys.ruby.tcp_cntrl0.coalescer: Creating new or aliased request for 0x3FEEDA080
82: sys.ruby.tcp_cntrl0.coalescer: adding write inst 186 at line 0x3feeda080 to the pending write instruction list
82: sys.ruby.tcp_cntrl0.coalescer: Creating new or aliased request for 0x3FEEDA040
82: sys.ruby.tcp_cntrl0.coalescer: adding write inst 186 at line 0x3feeda040 to the pending write instruction list
82: sys.ruby.tcp_cntrl0.coalescer: Creating new or aliased request for 0x3FEEDA000
82: sys.ruby.tcp_cntrl0.coalescer: adding write inst 186 at line 0x3feeda000 to the pending write instruction list
82: sys.ruby.tcp_cntrl0.coalescer: Issued req type ST seqNum 186



    最终结果是
    coalescedTable在4个对应cacheline下各自队列下，加入1个新CoalescedRequest(seqnum,16pkts)
    coalescedReqs新创了1个队列，该队列下面有4个CoalescedRequest，各个creq的cacheline不同且包含16个pkt
        
1：
    lineaddr-> 索引队列
    若有队列，并且有seqnum相同的就加入：insertPacket【seqnum同，cacheline同】
    if (coalescedTable.count(line_addr)) {
        // Search for a previous coalesced request with the same seqNum.
        auto& creqQueue = coalescedTable.at(line_addr);
        auto citer = std::find_if(creqQueue.begin(), creqQueue.end(),
            [&](CoalescedRequest* c) { return c->getSeqNum() == seqNum; }
        );
        if (citer != creqQueue.end()) {
            (*citer)->insertPacket(pkt);
            return true;
        }
    }
2：
    如果没有找到就要创建一下，需要保证当前count没超过2560:(m_outstanding_count < m_max_outstanding_requests)
        CoalescedRequest *creq = new CoalescedRequest(seqNum);
        creq->insertPacket(pkt);
        creq->setRubyType(getRequestType(pkt));
        creq->setIssueTime(curCycle());      

        2.1：去coalescedTable中用cacheline索引，看有无队列
        if (!coalescedTable.count(line_addr)) {
            auto reqList = std::deque<CoalescedRequest*> { creq };
            coalescedTable.insert(std::make_pair(line_addr, reqList));
            if (!coalescedReqs.count(seqNum)) {
                coalescedReqs.insert(std::make_pair(seqNum, reqList)); //新建：seq lineaddr
            } else {
                coalescedReqs.at(seqNum).push_back(creq);//seq同 lineaddr不同
            }
        } else {
            //seq不同 lineaddr同
            coalescedTable.at(line_addr).push_back(creq);
            DPRINTF(GPUCoalescer, "found address 0x%X with new seqNum %d\n",
                    line_addr, seqNum);
        }



回到GPUCoalescer::completeIssue()函数中，在把请求合并之后
    会将coalescedReqs中当前的seqNum对应的多个请求，issueRequest(creq);

82: sys.ruby.tcp_cntrl0.coalescer: Issued req type ST seqNum 186
dataBlock.setData(tmpPkt->getPtr<uint8_t>(),tmpOffset, tmpSize);}   这里是把4B放入dataBlock中(64B)
for (int j = 0; j < tmpSize; j++) {accessMask[tmpOffset + j] = true;}   每个字节对应一个掩码
然后制作一个msg = std::make_shared<RubyRequest>，用的就是一个dataBlock，所以一次写一整个cacheline

写指令需要makeWriteCompletePkts(crequest);
    为这个coalesced reqs里的每一个req都
        创一个写完成pkt，设置地址/senderState
        m_writeCompletePktMap[key].push_back(writeCompletePkt);  //seqNum是key
这是因为下游的cache对于一个req会有writeCallback and writeCompleteCallback
82: sys.ruby.tcp_cntrl0.coalescer: makeWriteCompletePkts: instSeqNum 186
82: sys.ruby.tcp_cntrl0.coalescer: makeWriteCompletePkts: instSeqNum 186
82: sys.ruby.tcp_cntrl0.coalescer: makeWriteCompletePkts: instSeqNum 186
82: sys.ruby.tcp_cntrl0.coalescer: makeWriteCompletePkts: instSeqNum 186
82: sys.ruby.tcp_cntrl0.coalescer: makeWriteCompletePkts: instSeqNum 186
82: sys.ruby.tcp_cntrl0.coalescer: makeWriteCompletePkts: instSeqNum 186
82: sys.ruby.tcp_cntrl0.coalescer: makeWriteCompletePkts: instSeqNum 186
82: sys.ruby.tcp_cntrl0.coalescer: makeWriteCompletePkts: instSeqNum 186
82: sys.ruby.tcp_cntrl0.coalescer: makeWriteCompletePkts: instSeqNum 186
82: sys.ruby.tcp_cntrl0.coalescer: makeWriteCompletePkts: instSeqNum 186
82: sys.ruby.tcp_cntrl0.coalescer: makeWriteCompletePkts: instSeqNum 186
82: sys.ruby.tcp_cntrl0.coalescer: makeWriteCompletePkts: instSeqNum 186
82: sys.ruby.tcp_cntrl0.coalescer: makeWriteCompletePkts: instSeqNum 186
82: sys.ruby.tcp_cntrl0.coalescer: makeWriteCompletePkts: instSeqNum 186
82: sys.ruby.tcp_cntrl0.coalescer: makeWriteCompletePkts: instSeqNum 186
82: sys.ruby.tcp_cntrl0.coalescer: makeWriteCompletePkts: instSeqNum 186
_然后是经典的把msg放入cache的m_mandatory_q_ptr里，关键的东西就是latency：
m_mandatory_q_ptr->enqueue(

回到GPUCoalescer::completeIssue()函数中
coalescedReqs.erase(seq_num);：：注意这里仅在这个表中erase，那个table里还没消除
当前的seqNum对应的多个请求发完之后，查一下数
82: sys.ruby.tcp_cntrl0.coalescer: Coalesced 64 pkts for seqNum 186, 0 remaining
然后去uncoalesced表中，如果一个seqnum的请求全发了，移除相应的list


过了两周期[不知道为啥是两周期，根据下面的描述，是把合并器返还给dataport的一周期算进来了]
那边cache块命中之后，写直达【还得看下c源码】
然后是调用coalescer的writeCallback
    coalescer.writeCallback(address, MachineType:L1Cache, cache_entry.DataBlk);
        这个函数会调用hitcallback，然后把creq从 ctable中pop出去
hitcallback：会对creqs里各个req封装一下，如果是写就不用干啥，如果是load就得按字节填充一下数据
84: sys.ruby.tcp_cntrl0.coalescer: Got hitCallback for 0x3FEEDA0C0
84: sys.ruby.tcp_cntrl0.coalescer: Responding to 16 packets for addr 0x3FEEDA0C0
84: sys.ruby.tcp_cntrl0.coalescer: Got hitCallback for 0x3FEEDA080
84: sys.ruby.tcp_cntrl0.coalescer: Responding to 16 packets for addr 0x3FEEDA080
84: sys.ruby.tcp_cntrl0.coalescer: Got hitCallback for 0x3FEEDA040
84: sys.ruby.tcp_cntrl0.coalescer: Responding to 16 packets for addr 0x3FEEDA040
84: sys.ruby.tcp_cntrl0.coalescer: Got hitCallback for 0x3FEEDA000
84: sys.ruby.tcp_cntrl0.coalescer: Responding to 16 packets for addr 0x3FEEDA000

//hitcallback调用completeHitCallback
GPUCoalescer::completeHitCallback(std::vector<PacketPtr> & mylist)然后
        // Send a response in the same cycle. There is no need to delay the
        // response because the response latency is already incurred in the
        // Ruby protocol.
        schedTimingResp(pkt, curTick()); 

然后dataport就会收到coalescer的resp
ComputeUnit::DataPort::recvTimingResp(PacketPtr pkt)
{
    return handleResponse(pkt);
}
84: sys.Shader.CUs00-port0: CU0: WF[0][0]: gpuDynInst: 186, index 0, addr 0x3feeda000 received!
84: sys.Shader.CUs00-port1: CU0: WF[0][0]: gpuDynInst: 186, index 1, addr 0x3feeda004 received!
...64
调度一个proc_memresp事件

50周期后触发
...64
ComputeUnit::DataPort::processMemRespEvent(PacketPtr pkt)
34: sys.Shader.CUs00-port1: CU0: WF[0][0]: Response for addr 0x3feeda004, index 1
34: sys.Shader.CUs00-port0: CU0: WF[0][0]: Response for addr 0x3feeda000, index 0
这里如果是写，那实际上这个函数就不做啥，因为是TCC对TCP做出响应


cache那边收到l2cache返回的写直达完成信号，会调用coalescer.writeCompleteCallback
action(wd_wtDone, "wd", desc="writethrough done") {
    if (use_seq_not_coal) {
      DPRINTF(RubySlicc, "Sequencer does not define writeCompleteCallback!\n");
      assert(false);
    } else {
      peek(responseToTCP_in, ResponseMsg) {
        coalescer.writeCompleteCallback(address, in_msg.instSeqNum);
      }
    }
  }

注意是 VIPERCoalescer::writeCompleteCallback(Addr addr, uint64_t instSeqNum)
分别在24 34 36 39调用4个包
34: sys.ruby.tcp_cntrl0.coalescer: writeCompleteCallback: instSeqNum 186 addr 0x3feeda0c0
这个writeCompleteCallback函数中会调用sendtimingresp，这边请求端口会recvtimingresp->handle
34: sys.Shader.CUs00-port48: CU0: WF[0][0]: gpuDynInst: 186, index 48, addr 0x3feeda0c0 received!

handle中同样schedule一个processMemRespEvent事件
writeResp不做事情
其他的类型：
gpuDynInst->memStatusVector[paddr].pop_back();
gpuDynInst->decrementStatusVector(index);减掉那个lane对应的请求数


if (gpuDynInst->allLanesZero()) 
    这个函数会检查statusVector[lane]，看是否每个lane都完成请求
    91: global: CU0: WF[0][0]: all lanes have no pending requests for 0x7fd1b6c1c000
    如果都完成了就会compute_unit->globalMemoryPipe.handleResponse(gpuDynInst);
        auto mem_req = gmOrderedRespBuffer.find(gpuDynInst->seqNum());
        mem_req->second.second = true;
        将指令在gmOrderedRespBuffer中标为完成，在gm.exec函数中会使用
    91: sys.Shader.CUs00-port0: CU0: WF[0][0]: packet totally complete
if (pkt->isRead())

下一周期，gm.exec:
    从gmOrderedRespBuffer取出指令
    load需要glbMemToVrfBus就绪才可进行
    completeAcc
    load指令：scheduleWriteOperandsFromLoad
        下一周期，寄存器会被标为free
    gmOrderedRespBuffer移除指令