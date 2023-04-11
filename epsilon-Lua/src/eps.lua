eps=1
repeat
  eps=eps/2.0
  eps1=eps+1.0
until eps1==1.0

print('eps=',eps)
print('digits=',-math.floor(math.log10(eps)))
