
# MergeSort.s
#
# Merge sorts a string
#
# s0: the address of the string
# s1: the divisor for finding the mid point
# s2: the address of the temp string
# t0: the left index
# t1: the right index
# t2: the mid index
# s2: temporary string
# t3: temporary array counter

.data
string:         .asciiz  "abc"
newline:        .asciiz  "\n"

.text
.globl  main
                 
# Initialize
main:
        la      $s0, string         # address pointer for string
        li      $s1, 2              # divisor

        li      $v0, 9              # prepare to allocate heap space
        li      $a0, 8              # choose a size of 8
        syscall                     # allocate the heap space
        move    $s2, $v0        
        move    $t9, $s2


        move    $t0, $s0            # get address of string
        sw      $t0, ($t9)          # 

        li      $t0, 0              # left index
        li      $t1, 2              # right index
        move    $a2, $t0            # set left argument to be left index
        move    $a3, $t1            # set right argument to be right index

        li      $v0, 4              # print the string
        la      $a0, string
        syscall
        li      $v0, 4
        la      $a0, newline
        syscall

        jal     mergesort           
        nop
        b       done

# Base merge sort method
mergesort:
        subi    $sp,$sp,4           # move stack pointer on by 4
        sw      $ra,($sp)           # push return address onto stack
        
        blt     $a2, $a3, helper    # if left < right branch to helper
        nop
epilog:
        lw      $ra,($sp)           # store current stack pointer in return address
        addiu   $sp, $sp, 4         # move stack pointer back by four
        jr      $ra                 # jump to return address
        
helper:
        move    $t0, $a2            # set left index
        move    $t1, $a3            # set right index
        addu    $t2, $a2, $a3       # left + right
        divu    $t2, $t2, $s1       # mid = (left + right) / 2

        subi    $sp, $sp, 4         # move the stack pointer on by 4
        sw      $t0,($sp)           # store the left index on the stack
        subi    $sp, $sp, 4         # move the stack pointer on by 4
        sw      $t1,($sp)           # store the right index on the stack
        subi    $sp, $sp, 4         # move the stack pointer on by 4
        sw      $t2,($sp)           # store the mid index on the stack
        
        move    $a2, $t0            # set left argument to be left
        move    $a3, $t2            # set right argument to be mid

        jal     mergesort
        nop
        
        lw      $t2,($sp)           # store the current index as the mid index
        addiu   $sp, $sp, 4         # point at the next address
        lw      $t1,($sp)           # store the current index as the right index
        addiu   $sp, $sp, 4         # point at the next address
        lw      $t0,($sp)           # store the current index as the left index
        addiu   $sp, $sp, 4         # point at the next address

        subi    $sp, $sp, 12        # point at the next address

        addiu   $a2, $t2, 1         # set left argument to be mid + 1
        move    $a3, $t1            # set right argument to be right

        jal     mergesort
        nop

        
        lw      $t2,($sp)           # store the current index as the mid index
        addiu   $sp, $sp, 4         # point at the next address
        lw      $t1,($sp)           # store the current index as the right index
        addiu   $sp, $sp, 4         # point at the next address
        lw      $t0,($sp)           # store the current index as the left index
        addiu   $sp, $sp, 4         # point at the next address

        move    $a2, $t0            # set left argument to be left
        move    $a3, $t1            # set right argument to be right
        jal     merge
        nop
      
        j       epilog              # jump back to epilog of caller

# t3: counter for temp string
# t4: left counter
# t5: right counter
# t6: char1 in $s0
# t7: char2 in $s0
# t8: char in temp string ($s2)
merge:
        subi    $sp,$sp,4           # move stack pointer on by 4
        sw      $ra,($sp)           # push return address onto stack

        move    $t3, $0             # start temporary string counter at 0
        move    $t4, $a2            # setup a left count
        move    $t5, $t2            # setup a right count
        addiu   $t5, $t5, 1         # setup a right count

while:
        ble     $t4, $t2, rcheck    # if lcount <= mid check the right count
        nop

mergecont:
        bleu     $t4, $t2, else3     # if lcount <= mid
        nop
while2:
        bgt     $t5, $a3, mergecont2
        nop
        move    $t7, $s0            # get address of string
        add     $t7, $t7, $t5       # get address of rcount index of string
        lbu     $t7, ($t7)          # store that char
        move    $t8, $s2            # get address of temp string
        add     $t8, $t8, $t3       # get address of certain char in temp string
        sb      $t7, ($t8)          # store char1 in temp string at specified position
        addiu   $t3, $t3, 1         # increment temp string counter
        addiu   $t5, $t5, 1         # increment right counter
        b       while2

mergecont2:
        move    $t3, $0             # set temporary string counter to 0
        move    $t9, $t1
        sub     $t9, $a3, $a2
        addiu   $t9, $t9, 1
while3:
        bgeu    $t3, $t9, mergecont3 # if bcount >= $t9
        nop
        move    $t8, $s2            # get address of temp string
        add     $t8, $t8, $t3       # get address of certain char in temp string
        lbu     $t8, ($t8)          # store that char

        move    $t6, $s0            # get address of string
        add     $t6, $t6, $a2       # get address of left index of string
        add     $t6, $t6, $t3       # add temp counter to address
        sb      $t8, ($t6)          # store temp string char at specified position in string
        addiu   $t3, $t3, 1
        b       while3

mergecont3:
        lw      $ra,($sp)           # store current stack pointer in return address
        addiu   $sp, $sp, 4         # move stack pointer back by four
        jr      $ra                 # jump to return address

rcheck:
        bgt     $t5, $a3, mergecont # if rcount > right index branch to else
        nop
        move    $t6, $s0            # get address of string
        add     $t6, $t6, $t4       # get address of lcount index of string
        lbu     $t6, ($t6)          # store that char
        move    $t7, $s0            # get address of string
        add     $t7, $t7, $t5       # get address of rcount index of string
        lbu     $t7, ($t7)          # store that char
        move    $t8, $s2            # get address of temp string
        add     $t8, $t8, $t3       # get address of certain char in temp string
        bgt     $t6, $t7, else2     # if string[lcount] > string[rcount]
        nop
        sb      $t6, ($t8)          # store char1 in temp string at specified position
        addiu   $t3, $t3, 1         # increment temp string counter
        addiu   $t4, $t4, 1         # increment left counter
        b       while


else2:
        sb      $t7, ($t8)          # store char1 in temp string at specified position
        addiu   $t3, $t3, 1         # increment temp string counter
        addiu   $t5, $t5, 1         # increment right counter
        b       while

else3:
        bgt     $t4, $t2, mergecont2# if lcount > mid continue with merge
        nop
        move    $t6, $s0            # get address of string
        add     $t6, $t6, $t4       # get address of lcount index of string
        lbu     $t6, ($t6)          # store that char
        move    $t8, $s2            # get address of temp string
        add     $t8, $t8, $t3       # get address of certain char in temp string
        sb      $t6, ($t8)          # store char1 in temp string at specified position
        addiu   $t3, $t3, 1         # increment temp string counter
        addiu   $t4, $t4, 1         # increment left counter
        b       else3


print:
        subi    $sp,$sp,4           # move stack pointer on by 4
        sw      $ra,($sp)           # push return address onto stack
        
        li      $v0, 11             # prepare to print a string
        syscall                     # print the string
        
        lw      $ra,($sp)           # store current stack pointer in return address
        addiu   $sp, $sp, 4         # move stack pointer back by four
        jr      $ra                 # jump to return address
        
printint:
        subi    $sp,$sp,4           # move stack pointer on by 4
        sw      $ra,($sp)           # push return address onto stack
        
        li $v0, 1
        syscall
        
        lw      $ra,($sp)           # store current stack pointer in return address
        addiu   $sp, $sp, 4         # move stack pointer back by four
        jr      $ra                 # jump to return address

# finish
done:
        li      $v0, 4              # print the string
        la      $a0, string
        syscall
        li      $v0, 10             # syscall code 10: exit program
        syscall