INITIAL:
	lui   sp,  0x10             # 初始化栈指针sp = 0x00010000
	lui   s1, 0xFFFFF
	addi  t0, zero, 5   #2000
	nop
	nop
	nop
	slli  t0, t0, 7
	nop
	nop
	nop
    sw   t0, 0x24(s1)           # 设置分频系数
    nop
	nop
	nop
    	
PHASE_1:
	lw   t0, 0x20(s1)           # 读取计时器
	nop
	nop
	nop
	sw   t0, 0x00(s1)           # 显示到数码管
	nop
	nop
	nop
	lw   s0, 0x70(s1)	    	# 读取拨码开关
	nop
	nop
	nop
	andi s3, s0, 0x3            # read SW[1:0] into s3
	nop
	nop
	nop
	addi s2, x0, 1            
	nop
	nop
	nop  
	beq  s2, s3, PHASE_2        # SW[1:0] == 01 ? -> PHASE_2
	nop
	nop
	nop
	jal  x0, PHASE_1            # 否则重复执行PHASE_1
	
PHASE_2:	
	lw   t0, 0x20(s1)           # 以计时器最新值作为种子
	nop
	nop
	nop
	sw   t0, 0x00(s1)           # 数码管显示种子值
	nop
	nop
	nop
	
SW_10:	
	lw   s0, 0x70(s1)	    	# 读取拨码开关
	nop
	nop
	nop
	andi s3, s0, 0x3            # read SW[1:0] into s3
	nop
	nop
	nop
	addi s2, x0, 2       
	nop
	nop
	nop
	beq  s2, s3, PHASE_3        # SW[1:0] == 10 ? -> PHASE_3
	nop
	nop
	nop
	jal  x0, SW_10		    	# 否则重复判断SW[1:0] == 10 ?
	
PHASE_3:
	add s8, x0, t0              # 以s8为LFSR，导入种子t0
	nop
	nop
	nop
	
LFSR:
	andi t0, s8, 1              # t0 = s8[0]
	nop
	nop
	nop
	srli t1, s8, 1
	nop
	nop
	nop
	andi t1, t1, 1              # t1 = s8[1]
	nop
	nop
	nop
	srli t2, s8, 21  
	nop
	nop
	nop
	andi t2, t2, 1       	    # t2 = s8[21]
	nop
	nop
	nop
	srli t3, s8, 31  
	nop
	nop
	nop
	andi t3, t3, 1 	     	    # t3 = s8[31]
	nop
	nop
	nop
	
	xor  t4, t0, t1
	nop
	nop
	nop
	xor  t4, t4, t2
	nop
	nop
	nop
	xor  t4, t4, t3             # t4 = t0 ^ t1 ^ t2 ^ t3
	nop
	nop
	nop
	
	slli s8, s8, 1
	nop
	nop
	nop
	or   s8, s8, t4             # 组合为新随机数s8
	nop
	nop
	nop
	sw   s8, 0x00(s1)	    	# 数码管显示随机数
	nop
	nop
	nop
	
	lw   s0, 0x70(s1)	    	# 读取拨码开关
	nop
	nop
	nop
	andi s3, s0, 0x3            # read SW[1:0] into s3
	nop
	nop
	nop
	addi s2, x0, 3           
	nop
	nop
	nop
	beq  s2, s3, PHASE_4        # SW[1:0] == 11 ? -> PHASE_4
	nop
	nop
	nop
	jal  x0, LFSR	            # 否则重复生成随机数
	
PHASE_4: 
	# 将s8中的8个4bit数提取到内存栈中
	addi sp, sp, -32    
	nop
	nop
	nop
	addi t0, sp, 0              # t0 = 栈数组基地址   
	nop
	nop
	nop
	addi t1, s8, 0            
	nop
	nop
	nop
	andi t2, t1, 0xF            # 提取最低4位
	nop
	nop
	nop
	sw t2, 0(t0)                # 存储到栈[0]
	nop
	nop
	nop
	srli t1, t1, 4              # 右移4位
	nop
	nop
	nop
	andi t2, t1, 0xF
	nop
	nop
	nop
	sw t2, 4(t0)                # 栈[1]
	nop
	nop
	nop
	srli t1, t1, 4
	nop
	nop
	nop
	andi t2, t1, 0xF
	nop
	nop
	nop
	sw t2, 8(t0)                # 栈[2]
	nop
	nop
	nop
	srli t1, t1, 4
	nop
	nop
	nop
	andi t2, t1, 0xF
	nop
	nop
	nop
	sw t2, 12(t0)               # 栈[3]
	nop
	nop
	nop
	srli t1, t1, 4
	nop
	nop
	nop
	andi t2, t1, 0xF
	nop
	nop
	nop
	sw t2, 16(t0)               # 栈[4]
	nop
	nop
	nop
	srli t1, t1, 4
	nop
	nop
	nop
	andi t2, t1, 0xF
	nop
	nop
	nop
	sw t2, 20(t0)               # 栈[5]
	nop
	nop
	nop
	srli t1, t1, 4
	nop
	nop
	nop
	andi t2, t1, 0xF
	nop
	nop
	nop
	sw t2, 24(t0)               # 栈[6]
	nop
	nop
	nop
	srli t1, t1, 4
	nop
	nop
	nop
	andi t2, t1, 0xF
	nop
	nop
	nop
	sw t2, 28(t0)               # 栈[7]
	nop
	nop
	nop

	# 冒泡排序（升序）
	addi t1, x0, 7              # 外循环次数i
	nop
	nop
	nop
outer_loop:
	addi t2, x0, 0              # 内循环索引j
	nop
	nop
	nop
	addi t3, x0, 0              # 是否交换标志（0表示无交换）
	nop
	nop
	nop
    
inner_loop:
	# 计算当前元素地址
	slli t4, t2, 2              # t4 = 索引×4
	nop
	nop
	nop
	add t5, t0, t4              # t5 = 当前元素地址
	nop
	nop
	nop
	lw t4, 0(t5)                # 当前元素
	nop
	nop
	nop
	lw t6, 4(t5)                # 下一元素
	nop
	nop
	nop
	
	blt t6, t4, no_swap         # 比较当前元素和下一元素，若顺序正确则跳过
	nop
	nop
	nop
	sw t6, 0(t5)                # 交换元素
	nop
	nop
	nop
	sw t4, 4(t5)             
	nop
	nop
	nop
	addi t3, x0, 1              # 设置交换标志
	nop
	nop
	nop
    
no_swap:
	addi t2, t2, 1              # j++
	nop
	nop
	nop
	blt t2, t1, inner_loop      # 若j < i则继续内循环
	nop
	nop
	nop
	beq t3, x0, sort_done       # 若无交换则排序完成
	nop
	nop
	nop
	
	addi t1, t1, -1             # i--
	nop
	nop
	nop
	blt  x0, t1, outer_loop     # 若i > 0则继续外循环
	nop
	nop
	nop

sort_done:
	# 将排序结果打包回s8
	lw t1, 0(t0)                # 加载第一个数
	nop
	nop
	nop
	lw t2, 4(t0)             
	nop
	nop
	nop
	slli t2, t2, 4              # 左移4位
	nop
	nop
	nop
	or t1, t1, t2               # 组合
	nop
	nop
	nop

	lw t3, 8(t0)
	nop
	nop
	nop
	slli t3, t3, 8
	nop
	nop
	nop
	or t1, t1, t3
	nop
	nop
	nop

	lw t4, 12(t0)
	nop
	nop
	nop
	slli t4, t4, 12
	nop
	nop
	nop
	or t1, t1, t4
	nop
	nop
	nop

	lw t5, 16(t0)
	nop
	nop
	nop
	slli t5, t5, 16
	nop
	nop
	nop
	or t1, t1, t5
	nop
	nop
	nop

	lw t6, 20(t0)
	nop
	nop
	nop
	slli t6, t6, 20
	nop
	nop
	nop
	or t1, t1, t6
	nop
	nop
	nop

	lw a0, 24(t0)
	nop
	nop
	nop
	slli a0, a0, 24
	nop
	nop
	nop
	or t1, t1, a0
	nop
	nop
	nop

	lw a1, 28(t0)
	nop
	nop
	nop
	slli a1, a1, 28
	nop
	nop
	nop
	or s8, t1, a1               # 存入s8
	nop
	nop
	nop

	addi sp, sp, 32             # 释放栈空间
	nop
	nop
	nop

	addi t1, x0, 1
	nop
	nop
	nop
	sw   t1, 0x60(s1)           # 排序完成，点亮LED[0]
	nop
	nop
	nop	

SW_00:   
	lw   s0, 0x70(s1)	   
	nop
	nop
	nop
	andi s3, s0, 0x3          
	nop
	nop
	nop 
	addi s2, x0, 0       
	nop
	nop
	nop   
	beq  s2, s3, END         	# SW[1:0] == 00 ? -> END
	nop
	nop
	nop
	jal  x0, SW_00
	nop
	nop
	nop
    
END:
	sw   x0, 0x60(s1)           # 熄灭LED[0]	
	nop
	nop
	nop
	sw   s8, 0x00(s1)           # 数码管显示排序后整数
	
END_LOOP:
	j    END_LOOP
	ret