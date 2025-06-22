import rp2
from utime import ticks_us, ticks_diff

@rp2.asm_pio()
def add_uint32():
    wrap_target()
    pull()
    mov(x, invert(osr))
    pull()
    mov(y, osr)    
    jmp("test")
    label("incr")
    jmp(x_dec,"test")
    label("test")
    jmp(y_dec,"incr")
    mov(isr, invert(x))
    push()
    wrap()


sm = rp2.StateMachine(0, add_uint32, freq=-1)

sm.active(1)

now = ticks_us()
a=9
b=19000
res=a+b
elapsed = ticks_diff(ticks_us(), now)
print("MCU: %u + %u = %u (time = %u ms)" % (a,b,res,elapsed))
now = ticks_us()
sm.put(a)
sm.put(b)
res=sm.get()
elapsed = ticks_diff(ticks_us(), now)
print("PIO: %u + %u = %u (time = %u ms)\n" % (a,b,res,elapsed))

now = ticks_us()
a=16
b=19003
res=a+b
elapsed = ticks_diff(ticks_us(), now)
print("MCU: %u + %u = %u (time = %u ms)" % (a,b,res,elapsed))
now = ticks_us()
sm.put(a)
sm.put(b)
res=sm.get()
elapsed = ticks_diff(ticks_us(), now)
print("PIO: %u + %u = %u (time = %u ms)" % (a,b,res,elapsed))

sm.active(0)

# Results:
# MCU: 9 + 19000 = 19009 (time = 108 ms)
# PIO: 9 + 19000 = 19009 (time = 401 ms)
#
# MCU: 16 + 19003 = 19019 (time = 32 ms)
# PIO: 16 + 19003 = 19019 (time = 365 ms)


