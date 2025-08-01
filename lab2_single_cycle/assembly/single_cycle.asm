INITIAL:
	lui   sp,  0x10             # 初始化栈指针sp = 0x00010000
	lui  s1, 0xFFFFF
	addi  t0, zero, 2000
	slli  t0, t0, 7
    sw   t0, 0x24(s1)           # 设置分频系数
    	
PHASE_1:
	lw   t0, 0x20(s1)           # 读取计时器
	sw   t0, 0x00(s1)           # 显示到数码管
	lw   s0, 0x70(s1)	    	# 读取拨码开关
	andi s3, s0, 0x3            # read SW[1:0] into s3
	addi s2, x0, 1              
	beq  s2, s3, PHASE_2        # SW[1:0] == 01 ? -> PHASE_2
	jal  x0, PHASE_1            # 否则重复执行PHASE_1
	
PHASE_2:	
	lw   t0, 0x20(s1)           # 以计时器最新值作为种子
	sw   t0, 0x00(s1)           # 数码管显示种子值
	
SW_10:	
	lw   s0, 0x70(s1)	    	# 读取拨码开关
	andi s3, s0, 0x3            # read SW[1:0] into s3
	addi s2, x0, 2       
	beq  s2, s3, PHASE_3        # SW[1:0] == 10 ? -> PHASE_3
	jal  x0, SW_10		    	# 否则重复判断SW[1:0] == 10 ?
	
PHASE_3:
	add s8, x0, t0              # 以s8为LFSR，导入种子t0
	
LFSR:
	andi t0, s8, 1              # t0 = s8[0]
	srli t1, s8, 1
	andi t1, t1, 1              # t1 = s8[1]
	srli t2, s8, 21  
	andi t2, t2, 1       	    # t2 = s8[21]
	srli t3, s8, 31  
	andi t3, t3, 1 	     	    # t3 = s8[31]
	
	xor  t4, t0, t1
	xor  t4, t4, t2
	xor  t4, t4, t3             # t4 = t0 ^ t1 ^ t2 ^ t3
	
	slli s8, s8, 1
	or   s8, s8, t4             # 组合为新随机数s8
	sw   s8, 0x00(s1)	    	# 数码管显示随机数
	
	lw   s0, 0x70(s1)	    	# 读取拨码开关
	andi s3, s0, 0x3            # read SW[1:0] into s3
	addi s2, x0, 3           
	beq  s2, s3, PHASE_4        # SW[1:0] == 11 ? -> PHASE_4
	jal  x0, LFSR	            # 否则重复生成随机数
	
PHASE_4: 
	# 将s8中的8个4bit数提取到内存栈中
	addi sp, sp, -32    
	addi t0, sp, 0              # t0 = 栈数组基地址   
	addi t1, s8, 0            
	andi t2, t1, 0xF            # 提取最低4位
	sw t2, 0(t0)                # 存储到栈[0]
	srli t1, t1, 4              # 右移4位
	andi t2, t1, 0xF
	sw t2, 4(t0)                # 栈[1]
	srli t1, t1, 4
	andi t2, t1, 0xF
	sw t2, 8(t0)                # 栈[2]
	srli t1, t1, 4
	andi t2, t1, 0xF
	sw t2, 12(t0)               # 栈[3]
	srli t1, t1, 4
	andi t2, t1, 0xF
	sw t2, 16(t0)               # 栈[4]
	srli t1, t1, 4
	andi t2, t1, 0xF
	sw t2, 20(t0)               # 栈[5]
	srli t1, t1, 4
	andi t2, t1, 0xF
	sw t2, 24(t0)               # 栈[6]
	srli t1, t1, 4
	andi t2, t1, 0xF
	sw t2, 28(t0)               # 栈[7]

	# 冒泡排序（升序）
	addi t1, x0, 7              # 外循环次数i
outer_loop:
	addi t2, x0, 0              # 内循环索引j
	addi t3, x0, 0              # 是否交换标志（0表示无交换）
    
inner_loop:
	# 计算当前元素地址
	slli t4, t2, 2              # t4 = 索引×4
	add t5, t0, t4              # t5 = 当前元素地址
	lw t4, 0(t5)                # 当前元素
	lw t6, 4(t5)                # 下一元素
	
	blt t6, t4, no_swap         # 比较当前元素和下一元素，若顺序正确则跳过
	sw t6, 0(t5)                # 交换元素
	sw t4, 4(t5)             
	addi t3, x0, 1              # 设置交换标志
    
no_swap:
	addi t2, t2, 1              # j++
	blt t2, t1, inner_loop      # 若j < i则继续内循环
	beq t3, x0, sort_done       # 若无交换则排序完成
	
	addi t1, t1, -1             # i--
	blt  x0, t1, outer_loop     # 若i > 0则继续外循环

sort_done:
	# 将排序结果打包回s8
	lw t1, 0(t0)                # 加载第一个数
	lw t2, 4(t0)             
	slli t2, t2, 4              # 左移4位
	or t1, t1, t2               # 组合

	lw t3, 8(t0)
	slli t3, t3, 8
	or t1, t1, t3

	lw t4, 12(t0)
	slli t4, t4, 12
	or t1, t1, t4

	lw t5, 16(t0)
	slli t5, t5, 16
	or t1, t1, t5

	lw t6, 20(t0)
	slli t6, t6, 20
	or t1, t1, t6

	lw a0, 24(t0)
	slli a0, a0, 24
	or t1, t1, a0

	lw a1, 28(t0)
	slli a1, a1, 28
	or s8, t1, a1               # 存入s8

	addi sp, sp, 32             # 释放栈空间

	addi t1, x0, 1
	sw   t1, 0x60(s1)           # 排序完成，点亮LED[0]	

SW_00:   
	lw   s0, 0x70(s1)	   
	andi s3, s0, 0x3           
	addi s2, x0, 0          
	beq  s2, s3, END         	# SW[1:0] == 00 ? -> END
	jal  x0, SW_00
    
END:
	sw   x0, 0x60(s1)           # 排序完成，点亮LED[0]	
	sw   s8, 0x00(s1)           # 数码管显示排序后整数
	
END_LOOP:
	j    END_LOOP
	ret