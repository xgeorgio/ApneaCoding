# run in IDLE with:
#    exec(open('filename').read())

import rp2

@rp2.asm_pio()
def gate_and_2bit():       # AND(x,y) logic gate
    wrap_target()
    pull()                 # read bit 0
    mov(x, osr)
    pull()                 # read bit 1
    mov(y, osr)    
    jmp(x_not_y,"and0")    # x<>y => and:0
    jmp("output")          # x==y => and:x
    label("and0")
    set(x, 0)         
    label("output")
    mov(isr, x)
    push()
    wrap()


@rp2.asm_pio()
def gate_or_2bit():        # OR(x,y) logic gate
    wrap_target()
    pull()                 # read bit 0
    mov(x, osr)
    pull()                 # read bit 1
    mov(y, osr)    
    jmp(x_not_y,"or1")     # x<>y => or:1
    jmp("output")          # x==y => or:x
    label("or1")
    set(x, 1)
    label("output")
    mov(isr, x)
    push()
    wrap()


@rp2.asm_pio()
def gate_not_1bit():       # NOT(x) logic gate
    wrap_target()
    pull()                 # read bit 0
    mov(x, osr)
    jmp(not_x,"x_zero")    # x==0 => not:1
    set(x, 0)              # x==1 => not:0
    jmp("output")
    label("x_zero")
    set(x, 1)
    label("output")
    mov(isr, x)
    push()
    wrap()


@rp2.asm_pio()
def gate_xor_2bit():       # XOR(x,y) logic gate
    wrap_target()
    pull()                 # read bit 0
    mov(x, osr)
    pull()                 # read bit 1
    mov(y, osr)    
    jmp(x_not_y,"xor1")    # x<>y => xor:1
    set(x, 0)              # x==y => xor:0
    jmp("output")
    label("xor1")
    set(x, 1)
    label("output")
    mov(isr, x)
    push()
    wrap()


@rp2.asm_pio()
def gate_nand_2bit():      # NAND(x,y) logic gate
    wrap_target()
    pull()                 # read bit 0
    mov(x, osr)
    pull()                 # read bit 1
    mov(y, osr)    
    jmp(x_not_y,"nand1")   # x<>y => nand:1
    jmp(not_x,"nand1")     # x==y==0 => nand:1
    set(x, 0)              # x==y==1 => nand:0
    jmp("output")
    label("nand1")
    set(x, 1)         
    label("output")
    mov(isr, x)
    push()
    wrap()


@rp2.asm_pio()
def gate_nor_2bit():       # NOR(x,y) logic gate
    wrap_target()
    pull()                 # read bit 0
    mov(x, osr)
    pull()                 # read bit 1
    mov(y, osr)    
    jmp(x_not_y,"nor0")    # x<>y => nor:0
    jmp(not_x,"nor1")      # x==y==0 => nor:1
    set(x, 0)              # x==y==1 => nor:0
    jmp("output")
    label("nor0")
    set(x, 0)
    jmp("output")
    label("nor1")
    set(x, 1)
    label("output")
    mov(isr, x)
    push()
    wrap()


@rp2.asm_pio()
def gate_halfadd_2bit():   # HALFADD(x,y) logic gate
    wrap_target()
    pull()                 # read bit 0
    mov(x, osr)
    pull()                 # read bit 1
    mov(y, osr)        
    jmp(x_not_y,"xdiffy")  # x<>y => ...
    jmp(not_x,"output")    # x==y==0 => S=0,C=0
    set(x, 0)              # x==y==1 => S=0,C=1
    jmp("output")
    label("xdiffy")    
    set(x, 1)
    set(y, 0)
    label("output")    
    mov(isr, x)            # output bit 0: S
    push()
    mov(isr, y)            # output bit 1: C
    push()    
    wrap()


@rp2.asm_pio()
def gate_and_or_2bit():    # AND(x,y) / OR(x,y) logic gates
    wrap_target()          # mode select: 0=OR, 1=AND
    pull()                 # read bit 0
    mov(x, osr)
    pull()                 # read bit 1
    mov(y, osr)    
    jmp(x_not_y,"xdiffy")  # x<>y => and/or:(read mode)
    pull()                 # mode not needed, just clear input
    jmp("output")          # x==y => and/or:x
    label("xdiffy")
    pull()                 # x<>y,mode => and/or:mode=(0,1)
    mov(x, osr)
    label("output")
    mov(isr, x)
    push()
    wrap()


@rp2.asm_pio()
def gate_and_or_not_2bit():    # AND(x,y) / OR(x,y) / NOT(res) logic gates
    wrap_target()          # mode1 select: 0=OR, 1=AND / mode2 select: 1=NOT(res)
    pull()                 # read bit 0
    mov(x, osr)
    pull()                 # read bit 1
    mov(y, osr)    
    jmp(x_not_y,"xdiffy")  # x<>y => and/or:(read mode)
    pull()                 # mode not needed, just clear input
    jmp("output1")          # x==y => and/or:x
    label("xdiffy")
    pull()                 # x<>y,mode => and/or:mode=(0,1)
    mov(x, osr)    
    label("output1")       # check NOT flag
    pull()
    mov(y, osr)
    jmp(not_y,"output")    # NOT flag=0 => normal output    
    jmp(not_x, "x_zero")   # NOT flag=1 => invert output
    set(x, 0)
    jmp("output")
    label("x_zero")
    set(x, 1)    
    label("output")    
    mov(isr, x)
    push()
    wrap()


#sm = rp2.StateMachine(0, gate_and_2bit, freq=-1)
#sm = rp2.StateMachine(0, gate_or_2bit, freq=-1)
#sm = rp2.StateMachine(0, gate_not_1bit, freq=-1)
#sm = rp2.StateMachine(0, gate_xor_2bit, freq=-1)
#sm = rp2.StateMachine(0, gate_nand_2bit, freq=-1)
#sm = rp2.StateMachine(0, gate_nor_2bit, freq=-1)
#sm = rp2.StateMachine(0, gate_halfadd_2bit, freq=-1)
#sm = rp2.StateMachine(0, gate_and_or_2bit, freq=-1)
sm = rp2.StateMachine(0, gate_and_or_not_2bit, freq=-1)

sm.active(1)

for a in range(2):
    for b in range(2):
        sm.put(a)
        sm.put(b)
        
        #res=sm.get()
        #print("%d.AND.%d -> %d" % (a,b,res))
        #print("%d.OR.%d -> %d" % (a,b,res))
        #print("NOT.%d -> %d" % (a,res))
        #print("%d.XOR.%d -> %d" % (a,b,res))
        #print("%d.NAND.%d -> %d" % (a,b,res))
        #print("%d.NOR.%d -> %d" % (a,b,res))

        #resC=sm.get()
        #print("%d.HALFADD.%d -> (C,S)=(%d,%d)" % (a,b,resC,res))
        
        # mode select: 0=OR, 1=AND
        #mstr="sAND"; md=0
        #mstr="sOR";  md=1
        #sm.put(md)
        #res=sm.get()
        #print("%d.%s(m:%d).%d -> %d" % (a,mstr,md,b,res))

        # mode1 select: 0=OR, 1=AND / mode2 select: 1=NOT(res)
        #mstr="sAND"; md=0; mnot=1
        mstr="sOR";  md=1; mnot=1
        sm.put(md)
        sm.put(mnot)
        res=sm.get()
        print("%d.%s(m:%d,NOT:%d).%d -> %d" % (a,mstr,md,mnot,b,res))
 
sm.active(0)

