import math

theta = 45

current_theta = 0

x = 0.6072529351
y = 0.0

THETA = [45.0, 26.56505118, 14.03624347, 7.125016349, 3.576334375, 1.789910608, 0.8951737102, 0.4476141709, 0.2238105004, 0.1119056771, 0.0559528189, 0.02797645262, 0.01398822714, 0.006994113675, 0.003497056851, 0.001748528427]
#print(x*(2**16), y*(2**16))
for i in range(16):
    if current_theta <= theta:
        current_theta += THETA[i]
        x_new = x - y*float(2**(-i))
        y_new = y + x*float(2**(-i))
    elif current_theta > theta:
        current_theta -= THETA[i]
        x_new = x + y*float(2**(-i))
        y_new = y - x*float(2**(-i))
    x = x_new
    y = y_new
    #print(x*(2**16), y*(2**16))

print("     cos(", end="")
print(theta, end="")
print("):", end="")
print(x)
print("     sin(", end="")
print(theta, end="")
print("):", end="")
print(y)

cos = math.cos(theta/180*math.pi)
sin = math.sin(theta/180*math.pi)

print("real cos(", end="")
print(theta, end="")
print("):", end="")
print(cos)
print("real sin(", end="")
print(theta, end="")
print("):", end="")
print(sin)
