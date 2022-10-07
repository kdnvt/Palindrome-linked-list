.data

    list: .word 1,0,2,0,2,0,1,0
    list2: .word 1,0,2,0,3,0,1,0
    list3: .word 1,0,2,0,3,0,2,0,1,0
    list4: .word 1,0,2,0,3,0,3,0,1,0
    list5: .word 1,0
    
    heap_base: .word 0x12000000
    heap_end: .word 0x12000000
.text

main:
    
 
    #########

    
    la s4, list  # s4 stores the head of the target list 

    # the process to link the list.
    # list5 don't need this section.
    
    addi t0, s4, 8
    sw t0, 4(s4)
    addi t0, s4, 16
    sw t0, 12(s4)
    addi t0, s4, 24
    sw t0, 20(s4) 
    # addi t0, s4, 32 # for length 5 list
    # sw t0, 28(s4)   # for length 5 list
    
    # end of linking section
    
    add a0, s4, zero
    
    addi a0,zero,100
    jal ra, generate
    
    

    jal ra, isPalindrome
    j print

#################### isPalindrome ###############

isPalindrome:

    add t4, zero, zero  # t4 prev = NULL;
    add t5, a0, zero    # t5 cur = head;
    add t2, a0, zero    # t2 = tail = head;

    lw t0, 4(a0)        # t0 = head->next;
    beq t0, zero, end2
loop1:
    lw t0, 4(t2)        # t0 = tail->next;
    beq t2, zero, end1  # while(tail)
    beq t0, zero, end1  # while(tail->next)

    lw t1, 4(t0)        # t1 = tail->next->next;
    
    lw t3, 4(t5)        # t3 = tmp = cur->next;
    
    add t2, t1, zero    # tail = tail->next->next;

 
    sw t4, 4(t5)        # cur->next = prev;
    add t4, t5, zero    # prev = cur;
    add t5, t3, zero    # cur = tmp;

    
    
    j loop1

end1:

    add a0,zero,zero    # if two list are different
                        # the loop will jump to end
                        # and the a0 will be 0.

    beq t2,zero,loop2
    lw t5, 4(t5)        # cur = cur->next

loop2:
    
    beq t5,zero,end2    # while(cur)
    lw t0, 0(t4)        # t0 = prev->val;
    lw t1, 0(t5)        # t1 = cur->val;
    bne t0,t1, fail     # if(cur->val != prev->val)
    lw t4, 4(t4)        # prev = prev->next;
    lw t5, 4(t5)        # cur = cur->next;
        
    j loop2             #
end2:
    addi a0,zero,1      # if loop terminates normally(cur == NULL).
                        # this line will be executed.
    
fail:

    jr ra
    
################  generate #######
generate:
    # a0 number
    addi sp,sp,-8
    sw s0,0(sp)    
    sw ra,4(sp)
    add s0,zero,a0    
    slli s0,s0,3    # 8bytes per node, 2^3 = 8, s0 is the size of whole momery
    add a0,s0,zero
    jal ra, sbrk
    la t0,heap_base
    lw t0, 0(t0)
    add a0,t0,zero
    addi t0,t0,4        # t0 is the address of "next" of each node
    add t1, t0,s0       # t1 is the boundry
gen_loop:
    
    bgt t0,t1,gen_end
    addi t2,t0,4
    sw t2,0(t0)        # node->next pointing to next node
    sw zero,-4(t0)        # node->val = 0
    addi t0,t0,8    # next node
    
    bgt t0,t1,gen_end
    addi t2,t0,4
    sw t2,0(t0)        # node->next pointing to next node
    sw zero,-4(t0)        # node->val = 0
    addi t0,t0,8    # next node
    
    bgt t0,t1,gen_end
    addi t2,t0,4
    sw t2,0(t0)        # node->next pointing to next node
    sw zero,-4(t0)        # node->val = 0
    addi t0,t0,8    # next node
    
    bgt t0,t1,gen_end
    addi t2,t0,4
    sw t2,0(t0)        # node->next pointing to next node
    sw zero,-4(t0)        # node->val = 0
    addi t0,t0,8    # next node
    
    j gen_loop
gen_end:
    sw zero,-8(t0)    # make final node pointing to null
    
    
    lw s0,0(sp)
    lw ra,4(sp)
    addi sp,sp,8
    jr ra
    
    
################# sbrk ###############
sbrk:
    # a0 incre_size
    la t0,heap_end
    lw t1,0(t0)
    add a0,t1,a0
    sw a0,0(t0)
    add t1,a0,zero
    li a7,214
    ecall
    
    # Todo : consider brk fail
    
    add a0,t1,zero
    
    jr ra
    
    


############# print #############

print:
    li a7,1
    ecall

exit:

